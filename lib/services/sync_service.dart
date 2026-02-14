import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:saketo/ffi/fastscan.dart';
import 'package:saketo/main.dart';
import 'package:saketo/nodes/node.dart';
import 'package:saketo/wallet/chain/data_types.dart';

import '../error_handling/result.dart';
import '../rpc/monero_rpc.dart';
import '../wallet/wallet.dart';

class SyncService extends ChangeNotifier {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  ServiceStatus _syncStatus = ServiceStatus.notSyncing;
  int _syncHeight = 0;
  List<Transaction> _transactions = [];
  String _message = "";
  Isolate? _syncIsolate;
  ReceivePort? _receivePort;
  SendPort? _sendPort;
  Timer? _syncedTimer;
  ServiceStatus get syncStatus => _syncStatus;
  int get syncHeight => _syncHeight;
  List<Transaction> get transactions => _transactions;
  String get message => _message;

  Future<void> startSyncing(Wallet theWallet, Node node, String mnemonic) async {
    if (_syncStatus == ServiceStatus.syncing || _syncStatus == ServiceStatus.synced) return; // Already syncing

    _syncHeight = theWallet.lastSyncedHeight > 3197570 ? theWallet.lastSyncedHeight : 3197570;
    theWallet.lastSyncedHeight = _syncHeight;
    notifyListeners();

    _receivePort = ReceivePort();
    _syncIsolate = await Isolate.spawn(_syncTask, IsolateData(_receivePort!.sendPort, theWallet, node, mnemonic));

    _receivePort!.listen((message) {
      if (message is SendPort) {
        _sendPort = message;
      } else if (message is SendMessage) {
        switch (message.messageType) {
          case MessageType.error:
            _syncStatus = ServiceStatus.error;
            _message = message.value as String;
            notifyListeners();
          case MessageType.updateHeight:
            _syncStatus = ServiceStatus.syncing;
            _syncHeight = message.value as int;
            _message = "";
            notifyListeners();
            break;
          case MessageType.updateStatus:
            _syncStatus = message.value as ServiceStatus;
            _message = "";
            notifyListeners();
            break;
          case MessageType.updateData:
            if (message.value != null) {
              final Map<String, dynamic> data = message.value as Map<String, dynamic>;
              print("Received data: $data");
              _syncHeight = data["height"] ?? _syncHeight;
              theWallet.lastSyncedHeight = _syncHeight;
              theWallet.rawInputs = jsonEncode(data["inputs"] ?? []);
              theWallet.rawOutputs = jsonEncode(data["outputs"] ?? []);
              _transactions = List.from(theWallet.transactions);
              objectbox.store.box<Wallet>().put(theWallet);
              notifyListeners();
            }
        }
      }
      });
  }

  void stopSyncing() {
    if (_syncStatus == ServiceStatus.notSyncing || _syncStatus == ServiceStatus.error) return; // Already stopped

    _syncStatus = ServiceStatus.notSyncing;
    notifyListeners();

    _sendPort?.send(SyncAction.stop);
    _syncIsolate?.kill(priority: Isolate.immediate);
    _receivePort?.close();
    _syncIsolate = null;

    _syncedTimer?.cancel();
    _syncedTimer = null;
  }

  void _setSyncedStatus() {
    _syncStatus = ServiceStatus.synced;
    notifyListeners();

    _syncedTimer?.cancel();
    _syncedTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      debugPrint("Performing periodic task while synced...");
    });
  }

  static void _syncTask(IsolateData isolateData) async {
    print("1");
    final ReceivePort receivePort = ReceivePort();
    final SendPort sendPort = isolateData.sendPort;
    sendPort.send(receivePort.sendPort);

    final fastscanService = FastscanServiceManager();
    final result = fastscanService.create(
      privHex: await isolateData.theWallet.getHexPrivSpend(isolateData.mnemonic),
      startHeight: isolateData.theWallet.lastSyncedHeight,
      inputs: Transaction.encodeInputs(isolateData.theWallet.transactions),
      outputs: Transaction.encodeOutputs(isolateData.theWallet.transactions),
      rpcUrl: isolateData.node.url,
      rpcPort: isolateData.node.port,
      onNewData: (jsonData) {
        if (jsonData.containsKey("Data")) {
          sendPort.send(SendMessage(MessageType.updateData, jsonData["Data"]));
        }
      },
    );
    print("2");
    if (result.isNotEmpty) {
      print("errr");
      sendPort.send(SendMessage(MessageType.error, result));
      return;
    }
    print("3");
    fastscanService.sendCommand(Command.start);
    sendPort.send(SendMessage(MessageType.updateStatus, ServiceStatus.syncing));

    print("4");
    int syncHeight = isolateData.theWallet.birthdayHeight;
    int lastSyncedHeight = syncHeight;

    receivePort.listen((message) {
      if (message == SyncAction.stop) {
        fastscanService.sendCommand(Command.stop);
        fastscanService.dispose();
        receivePort.close();
        return;
      }
    });

    print("5");
    final val = await MoneroRpc.getBlockCount(isolateData.node);
    print("6");
    int networkHeight = 0;
    if (val is Error<int>) {
      sendPort.send(SendMessage(MessageType.error, val.errorMessage));
      return;
    } else if (val is Ok<int>) {
      networkHeight = val.value;
    }

    print("7");
    while (true) {
      Logger.root.log(Level.INFO, 'Syncing height: $syncHeight');

      await Future.delayed(const Duration(seconds: 1));

      final String response_tx = await fastscanService.sendCommand(Command.getStatus);
      final Map<String, dynamic> data = jsonDecode(response_tx);
      if (data["Status"][0] is Map<String, dynamic>) {
        if (data["Status"][0].containsKey("Error")) {
          sendPort.send(SendMessage(MessageType.error, data["Status"][0]["Error"]));
          return;
        }
      }
      if (syncHeight != data["Status"][1]) {
        syncHeight = data["Status"][1];
        sendPort.send(SendMessage(MessageType.updateHeight, data["Status"][1]));
      }
      if (syncHeight - lastSyncedHeight >= 200) {
        lastSyncedHeight = syncHeight;
        final String response_data = await fastscanService.sendCommand(Command.getCurrentData);
        final Map<String, dynamic> data = jsonDecode(response_data);
        if (data["Data"] is Map<String, dynamic>) {
          sendPort.send(SendMessage(MessageType.updateData, data["Data"]));
        }
      }
      if (syncHeight >= networkHeight) {
        sendPort.send(SendMessage(MessageType.updateHeight, ServiceStatus.synced));
      }
    }
  }

  @override
  void dispose() {
    stopSyncing();
    super.dispose();
  }
}

class IsolateData {
  final SendPort sendPort;
  final Wallet theWallet;
  final Node node;
  final String mnemonic;

  IsolateData(this.sendPort, this.theWallet, this.node, this.mnemonic);
}

class SendMessage {
  final MessageType messageType;
  final Object? value;

  SendMessage(this.messageType, this.value);
}

enum MessageType {
  updateHeight, // Updated height, value is the new synced height
  updateStatus, // Updated status, value is the new status message
  updateData,  // Updated data, value is the new data including txs and height from the fastscan service
  error, // Got error while fetching height, value is the error message
}

enum SyncAction {
  start,
  stop,
}

enum ServiceStatus {
  notSyncing,
  syncing,
  synced,
  error,
}