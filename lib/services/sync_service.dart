import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:saketo/nodes/node.dart';

import '../db/main/objectbox.dart';
import '../error_handling/result.dart';
import '../main.dart';
import '../rpc/monero_rpc.dart';
import '../wallet/wallet.dart';

class SyncService extends ChangeNotifier {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  int _syncStatus = 0; // 0 - Not Syncing, 1 - Syncing, 2 - Synced, 3 - Error
  int _syncHeight = 0;
  String _message = "";
  Isolate? _syncIsolate;
  ReceivePort? _receivePort;
  SendPort? _sendPort;
  Timer? _syncedTimer;

  int get syncStatus => _syncStatus;

  int get syncHeight => _syncHeight;

  String get message => _message;

  Future<void> startSyncing(Wallet theWallet, Node node) async {
    if (_syncStatus == 1) return; // Already syncing

    _syncStatus = 1;
    _syncHeight = theWallet.birthdayHeight;
    notifyListeners();

    _receivePort = ReceivePort();
    _syncIsolate = await Isolate.spawn(_syncTask, IsolateData(_receivePort!.sendPort, theWallet, node));

    _receivePort!.listen((message) {
      if (message is SendPort) {
        _sendPort = message;
      } else if (message is SendMessage) {
        switch (message.messageType) {
          case MessageType.heightError:
            Logger.root.log(Level.SEVERE, 'Error while fetching height from node: ${message.value}');
            _syncStatus = 3;
            _message = message.value as String;
            notifyListeners();
          case MessageType.updateHeight:
            _syncStatus = 1;
            _syncHeight = message.value as int;
            _message = "";
            notifyListeners();
            break;
          case MessageType.synced:
            _syncStatus = 2;
            _message = "";
            _setSyncedStatus();
            notifyListeners();
            break;
          default:
            break;
        }
      }
      });
  }

  void stopSyncing() {
    if (_syncStatus == 0 || _syncStatus == 3) return; // Already stopped

    _syncStatus = 0;
    notifyListeners();

    _sendPort?.send(SendMessage(MessageType.stop, null));
    _syncIsolate?.kill(priority: Isolate.immediate);
    _receivePort?.close();
    _syncIsolate = null;

    _syncedTimer?.cancel();
    _syncedTimer = null;
  }

  void _setSyncedStatus() {
    _syncStatus = 2;
    notifyListeners();

    // Start periodic function when synced
    _syncedTimer?.cancel();
    _syncedTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      debugPrint("Performing periodic task while synced...");
    });
  }

  static void _syncTask(IsolateData isolateData) async {
    final ReceivePort receivePort = ReceivePort();
    final SendPort sendPort = isolateData.sendPort;
    sendPort.send(receivePort.sendPort);

    bool syncing = true;
    int syncHeight = isolateData.theWallet.birthdayHeight;

    receivePort.listen((message) {
      if (message is SendMessage) {
        switch (message.messageType) {
          case MessageType.stop:
            syncing = false;
            break;
          default:
            break;
        }
      }
    });

    final val = await MoneroRpc.getBlockCount(isolateData.node);
    int networkHeight = 0;
    if (val is Error<int>) {
      sendPort.send(SendMessage(MessageType.heightError, val.errorMessage));
      return;
    } else if (val is Ok<int>) {
      networkHeight = val.value;
    }

    while (syncing) {
      Logger.root.log(Level.INFO, 'Syncing height: $syncHeight');

      await Future.delayed(const Duration(microseconds: 1)); // Ensure proper delay

      syncHeight += 1;
      if (syncHeight >= networkHeight) {
        sendPort.send(SendMessage(MessageType.updateHeight, syncHeight));
        sendPort.send(SendMessage(MessageType.synced, null));
        syncing = false;
      } else {
        sendPort.send(SendMessage(MessageType.updateHeight, syncHeight));
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

  IsolateData(this.sendPort, this.theWallet, this.node);
}

class SendMessage {
  final MessageType messageType;
  final Object? value;

  SendMessage(this.messageType, this.value);
}

enum MessageType {
  updateHeight, // Updated height, value is the new synced height
  heightError, // Got error while fetching height, value is the error message
  synced, // Wallet is synced with the network, starting periodic task
  stop, // Stop syncing
}