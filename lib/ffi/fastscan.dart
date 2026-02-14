import 'dart:convert';
import 'dart:core';
import 'dart:ffi';
import 'dart:isolate';
import 'package:ffi/ffi.dart';
import 'package:saketo/ffi/ffi.dart';

final _fastscanNew = libsaketo.lookupFunction<
    FFIServiceResult Function(Pointer<Utf8>, Uint64, Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>, Uint16, Int64),
    FFIServiceResult Function(Pointer<Utf8>, int, Pointer<Utf8>, Pointer<Utf8>, Pointer<Utf8>, int, int)
>("fastscan_service_new");

final _freeErrorMsg = libsaketo.lookupFunction<
    Void Function(Pointer<Utf8>),
    void Function(Pointer<Utf8>)
>("free_error_msg");

final _fastscanSend = libsaketo.lookupFunction<
    Pointer<Utf8> Function(Pointer<Void>, Uint8),
    Pointer<Utf8> Function(Pointer<Void>, int)
>("fastscan_service_send_command");

final _serviceFree = libsaketo.lookupFunction<
    Void Function(Pointer<Void>),
    void Function(Pointer<Void>)
>("fastscan_service_free");

final _registerPost = libsaketo.lookupFunction<
    Void Function(Pointer<NativeFunction<Int8 Function(Int64, Pointer<Void>)>>),
    void Function(Pointer<NativeFunction<Int8 Function(Int64, Pointer<Void>)>>)
>("register_dart_post_cobject");

final class FFIServiceResult extends Struct {
  external Pointer<Void> servicePtr;
  external Pointer<Utf8> errorMsg;
}

class FastscanServiceManager {
  Pointer<Void>? _servicePtr;
  ReceivePort? _receivePort;

  bool get isInitialized => _servicePtr != null;
  Pointer<Void>? get servicePtr => _servicePtr;

  String create({
    required String privHex,
    required int startHeight,
    required String inputs,
    required String outputs,
    required String rpcUrl,
    required int rpcPort,
    required Function(dynamic) onNewData,
  }) {
    _registerPost(NativeApi.postCObject.cast());

    _receivePort = ReceivePort();
    _receivePort!.listen((message) async {
      if (message == 0) {
        final jsonResponse = await sendCommand(Command.getCurrentData);
        final data = jsonDecode(jsonResponse);
        onNewData(data);
      }
    });

    final privPtr = privHex.toNativeUtf8();
    final inputsPtr = inputs.toNativeUtf8();
    final outputsPtr = outputs.toNativeUtf8();
    final urlPtr = ("https://$rpcUrl").toNativeUtf8();

    final result = _fastscanNew(
      privPtr,
      startHeight,
      inputsPtr,
      outputsPtr,
      urlPtr,
      rpcPort,
      _receivePort!.sendPort.nativePort,
    );

    malloc.free(privPtr);
    malloc.free(inputsPtr);
    malloc.free(outputsPtr);
    malloc.free(urlPtr);

    if (result.servicePtr == nullptr || result.servicePtr.address == 0) {
      String error = "FastscanService initialization failed, but no error message provided.";
      if (result.errorMsg != nullptr) {
        error = "FastscanService initialization failed: ${result.errorMsg.toDartString()}";
        _freeErrorMsg(result.errorMsg);
      }
      return error;
    }

    _servicePtr = result.servicePtr;
    return "";
  }

  Future<String> sendCommand(int cmd) async {
    if (_servicePtr == null) {
      throw Exception("Service not initialized. Call create() first.");
    }

    final respPtr = _fastscanSend(_servicePtr!, cmd);
    if (respPtr == nullptr) return "";
    final resp = respPtr.toDartString();
    freeCString(respPtr);

    return resp;
  }

  void dispose() {
    if (_servicePtr != null) {
      _serviceFree(_servicePtr!);
      _servicePtr = null;
    }
    _receivePort?.close();
    _receivePort = null;
  }
}

abstract class Command {
  static const int start = 0;
  static const int stop = 1;
  static const int getStatus = 2;
  static const int getNewTransactions = 3;
  static const int getCurrentData = 4;
}