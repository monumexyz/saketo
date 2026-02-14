import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

import '../wallet/mnemonics/legacy_mnemonic_type.dart';
import '../wallet/mnemonics/mnemonic_type.dart';
import '../wallet/mnemonics/polyseed_mnemonic_type.dart';

final DynamicLibrary libsaketo = Platform.isAndroid
    ? DynamicLibrary.open("libsaketo_ffi.so")
    : (Platform.isIOS
        ? DynamicLibrary.process()
        : DynamicLibrary.open("libsaketo_ffi.dylib"));

final Pointer<Utf8> Function() _generatePolyseedMnemonic = libsaketo
    .lookup<NativeFunction<Pointer<Utf8> Function()>>(
        "generate_polyseed_mnemonic")
    .asFunction();

final Pointer<Utf8> Function() _generateLegacyMnemonic = libsaketo
    .lookup<NativeFunction<Pointer<Utf8> Function()>>(
        "generate_legacy_mnemonic")
    .asFunction();

final Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>)
    _encryptData = libsaketo
        .lookup<NativeFunction<Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>)>>(
            "encrypt_data")
        .asFunction();

final Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>)
    _decryptData = libsaketo
        .lookup<NativeFunction<Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Utf8>)>>(
            "decrypt_data")
        .asFunction();

final class ResultWithMessage extends Struct {
  @Bool()
  external bool success;
  external Pointer<Utf8> message;
}

final ResultWithMessage Function(Pointer<Utf8>, Pointer<Utf8>)
    _isValidPolyseedMnemonic = libsaketo
        .lookup<
            NativeFunction<
                ResultWithMessage Function(Pointer<Utf8>,
                    Pointer<Utf8>)>>("is_valid_polyseed_mnemonic")
        .asFunction();

final ResultWithMessage Function(Pointer<Utf8>, Pointer<Utf8>)
    _isValidLegacyMnemonic = libsaketo
        .lookup<
            NativeFunction<
                ResultWithMessage Function(Pointer<Utf8>,
                    Pointer<Utf8>)>>("is_valid_legacy_mnemonic")
        .asFunction();

final Pointer<Utf8> Function(Pointer<Utf8>)
    _getPrimaryAddressLegacy = libsaketo
        .lookup<NativeFunction<Pointer<Utf8> Function(Pointer<Utf8>)>>(
            "get_primary_address_monero_seed")
        .asFunction();

final Pointer<Utf8> Function(Pointer<Utf8>)
    _getPrimaryAddressPolyseed = libsaketo
        .lookup<NativeFunction<Pointer<Utf8> Function(Pointer<Utf8>)>>(
            "get_primary_address_polyseed")
        .asFunction();

final Pointer<Utf8> Function(Pointer<Utf8>) _getHexPrivSpendLegacy = libsaketo
    .lookup<NativeFunction<Pointer<Utf8> Function(Pointer<Utf8>)>>(
        "get_hex_priv_spend_monero_seed")
    .asFunction();

final Pointer<Utf8> Function(Pointer<Utf8>) _getHexPrivSpendPolyseed = libsaketo
    .lookup<NativeFunction<Pointer<Utf8> Function(Pointer<Utf8>)>>(
        "get_hex_priv_spend_polyseed")
    .asFunction();

final int Function(Pointer<Utf8>) _getBlockHeightPolyseed = libsaketo
    .lookup<NativeFunction<Int64 Function(Pointer<Utf8>)>>(
        "get_block_height_polyseed")
    .asFunction();

final int Function(int) _getBlockHeightFromUnixTime = libsaketo
    .lookup<NativeFunction<Int64 Function(Int64)>>("get_block_height_from_unix_time")
    .asFunction<int Function(int)>();

final void Function(Pointer<Utf8>) freeCString = libsaketo
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
  freeCString(seedPointer);
  return seed;
}

String encryptData(String data, String password) {
  final Pointer<Utf8> dataPointer = data.toNativeUtf8();
  final Pointer<Utf8> passwordPointer = password.toNativeUtf8();
  final Pointer<Utf8> encryptedDataPointer = _encryptData(passwordPointer, dataPointer);
  freeCString(dataPointer);
  freeCString(passwordPointer);
  final String encryptedData = encryptedDataPointer.toDartString();
  freeCString(encryptedDataPointer);
  return encryptedData;
}

String decryptData(String data, String password) {
  final Pointer<Utf8> dataPointer = data.toNativeUtf8();
  final Pointer<Utf8> passwordPointer = password.toNativeUtf8();
  final Pointer<Utf8> decryptedDataPointer = _decryptData(passwordPointer, dataPointer);
  freeCString(dataPointer);
  freeCString(passwordPointer);
  final String decryptedData = decryptedDataPointer.toDartString();
  freeCString(decryptedDataPointer);
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
  freeCString(mnemonicPointer);
  freeCString(languageCodePointer);
  final bool success = result.success;
  final String message = result.message.toDartString();
  freeCString(result.message);
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
  freeCString(mnemonicPointer);
  freeCString(primaryAddressPointer);
  return primaryAddress;
}

String getHexPrivSpend(String mnemonic, MnemonicType mnemonicType) {
  final Pointer<Utf8> mnemonicPointer = mnemonic.toNativeUtf8();
  late final Pointer<Utf8> hexPrivSpendPointer;
  switch (mnemonicType) {
    case PolyseedMnemonicType():
      hexPrivSpendPointer = _getHexPrivSpendPolyseed(mnemonicPointer);
    case LegacyMnemonicType():
      hexPrivSpendPointer = _getHexPrivSpendLegacy(mnemonicPointer);
    default:
      hexPrivSpendPointer = _getHexPrivSpendPolyseed(mnemonicPointer);
  }
  final String hexPrivSpend = hexPrivSpendPointer.toDartString();
  freeCString(mnemonicPointer);
  freeCString(hexPrivSpendPointer);
  return hexPrivSpend;
}

int getBlockHeightFromUnixTime(int unixTime) {
  return _getBlockHeightFromUnixTime(unixTime);
}

int getBlockHeightPolyseed(String mnemonic) {
  final Pointer<Utf8> mnemonicPointer = mnemonic.toNativeUtf8();
  final int blockHeight = _getBlockHeightPolyseed(mnemonicPointer);
  freeCString(mnemonicPointer);
  return blockHeight;
}
