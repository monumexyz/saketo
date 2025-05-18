import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

import '../wallet/mnemonics/legacy/legacy_mnemonic_type.dart';
import '../wallet/mnemonics/mnemonic_type.dart';
import '../wallet/mnemonics/polyseed/polyseed_mnemonic_type.dart';

final DynamicLibrary rustLib = Platform.isAndroid
    ? DynamicLibrary.open("libsaketo.so")
    : (Platform.isIOS
        ? DynamicLibrary.process()
        : DynamicLibrary.open("libsaketo.dylib"));

final Pointer<Utf8> Function() _generatePolyseedMnemonic = rustLib
    .lookup<NativeFunction<Pointer<Utf8> Function()>>(
        "generate_polyseed_mnemonic")
    .asFunction();

final Pointer<Utf8> Function() _generateLegacyMnemonic = rustLib
    .lookup<NativeFunction<Pointer<Utf8> Function()>>(
        "generate_legacy_mnemonic")
    .asFunction();

final Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>)
    _encryptData = rustLib
        .lookup<NativeFunction<Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>)>>(
            "encrypt_data")
        .asFunction();

final Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>)
    _decryptData = rustLib
        .lookup<NativeFunction<Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>)>>(
            "decrypt_data")
        .asFunction();

final class ResultWithMessage extends Struct {
  @Bool()
  external bool success;

  external Pointer<Utf8> message;
}

final ResultWithMessage Function(Pointer<Utf8>, Pointer<Utf8>)
    _isValidPolyseedMnemonic = rustLib
        .lookup<
            NativeFunction<
                ResultWithMessage Function(Pointer<Utf8>,
                    Pointer<Utf8>)>>("is_valid_polyseed_mnemonic")
        .asFunction();

final ResultWithMessage Function(Pointer<Utf8>, Pointer<Utf8>)
    _isValidLegacyMnemonic = rustLib
        .lookup<
            NativeFunction<
                ResultWithMessage Function(Pointer<Utf8>,
                    Pointer<Utf8>)>>("is_valid_legacy_mnemonic")
        .asFunction();

final Pointer<Utf8> Function(Pointer<Utf8>)
    _getPrimaryAddressLegacy = rustLib
        .lookup<NativeFunction<Pointer<Utf8> Function(Pointer<Utf8>)>>(
            "get_primary_address_monero_seed")
        .asFunction();

final Pointer<Utf8> Function(Pointer<Utf8>)
    _getPrimaryAddressPolyseed = rustLib
        .lookup<NativeFunction<Pointer<Utf8> Function(Pointer<Utf8>)>>(
            "get_primary_address_polyseed")
        .asFunction();

final int Function(Pointer<Utf8>) _getBlockHeightPolyseed = rustLib
    .lookup<NativeFunction<Int64 Function(Pointer<Utf8>)>>(
        "get_block_height_polyseed")
    .asFunction();

final int Function(int) _getBlockHeightFromUnixTime = rustLib
    .lookup<NativeFunction<Int64 Function(Int64)>>("get_block_height_from_unix_time")
    .asFunction<int Function(int)>();

final void Function(Pointer<Utf8>) _freeCString = rustLib
    .lookup<NativeFunction<Void Function(Pointer<Utf8>)>>("free_c_string")
    .asFunction();

String generateSeedString(MnemonicType mnemonicType) {
  late final Pointer<Utf8> seedPointer;
  switch (mnemonicType) {
    case PolyseedMnemonicType():
      seedPointer = _generatePolyseedMnemonic();
    case LegacyMnemonicType():
      seedPointer = _generateLegacyMnemonic();
    default:
      seedPointer = _generatePolyseedMnemonic();
  }
  final String seed = seedPointer.toDartString();
  _freeCString(seedPointer);
  return seed;
}

String encryptData(String data, String password) {
  final Pointer<Utf8> dataPointer = data.toNativeUtf8();
  final Pointer<Utf8> passwordPointer = password.toNativeUtf8();
  final Pointer<Utf8> encryptedDataPointer = _encryptData(passwordPointer, dataPointer);
  _freeCString(dataPointer);
  _freeCString(passwordPointer);
  final String encryptedData = encryptedDataPointer.toDartString();
  _freeCString(encryptedDataPointer);
  return encryptedData;
}

String decryptData(String data, String password) {
  final Pointer<Utf8> dataPointer = data.toNativeUtf8();
  final Pointer<Utf8> passwordPointer = password.toNativeUtf8();
  final Pointer<Utf8> decryptedDataPointer = _decryptData(passwordPointer, dataPointer);
  _freeCString(dataPointer);
  _freeCString(passwordPointer);
  final String decryptedData = decryptedDataPointer.toDartString();
  _freeCString(decryptedDataPointer);
  return decryptedData;
}

(bool, String) checkIsValidMnemonic(
    MnemonicType mnemonicType, String mnemonic, String languageCode) {
  final Pointer<Utf8> mnemonicPointer = mnemonic.toNativeUtf8();
  final Pointer<Utf8> languageCodePointer = languageCode.toNativeUtf8();
  late final ResultWithMessage result;
  switch (mnemonicType) {
    case PolyseedMnemonicType():
      result = _isValidPolyseedMnemonic(mnemonicPointer, languageCodePointer);
    case LegacyMnemonicType():
      result = _isValidLegacyMnemonic(mnemonicPointer, languageCodePointer);
    default:
      result = _isValidPolyseedMnemonic(mnemonicPointer, languageCodePointer);
  }
  _freeCString(mnemonicPointer);
  _freeCString(languageCodePointer);
  final bool success = result.success;
  final String message = result.message.toDartString();
  _freeCString(result.message);
  return (success, message);
}

String getPrimaryAddress(String mnemonic, MnemonicType mnemonicType) {
  final Pointer<Utf8> mnemonicPointer = mnemonic.toNativeUtf8();
  late final Pointer<Utf8> primaryAddressPointer;
  switch (mnemonicType) {
    case PolyseedMnemonicType():
      primaryAddressPointer = _getPrimaryAddressPolyseed(mnemonicPointer);
    case LegacyMnemonicType():
      primaryAddressPointer = _getPrimaryAddressLegacy(mnemonicPointer);
    default:
      primaryAddressPointer = _getPrimaryAddressPolyseed(mnemonicPointer);
  }
  final String primaryAddress = primaryAddressPointer.toDartString();
  _freeCString(mnemonicPointer);
  _freeCString(primaryAddressPointer);
  return primaryAddress;
}

int getBlockHeightFromUnixTime(int unixTime) {
  return _getBlockHeightFromUnixTime(unixTime);
}

int getBlockHeightPolyseed(String mnemonic) {
  final Pointer<Utf8> mnemonicPointer = mnemonic.toNativeUtf8();
  final int blockHeight = _getBlockHeightPolyseed(mnemonicPointer);
  _freeCString(mnemonicPointer);
  return blockHeight;
}
