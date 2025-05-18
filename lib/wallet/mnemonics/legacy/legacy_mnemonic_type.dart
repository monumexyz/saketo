import '../../../../rust_ffi/rust_ffi.dart';
import '../mnemonic_type.dart';

class LegacyMnemonicType implements MnemonicType {
  @override
  String get name => 'Legacy';

  @override
  int get wordCount => 25;

  @override
  List<String> generateMnemonic() => generateSeedString(MnemonicType.legacy()).split(' ');

  // TODO: Implement this method when the Legacy mnemonic validation is implemented
  @override
  (bool, String) isValidMnemonic(String mnemonic, String languageCode) => checkIsValidMnemonic(MnemonicType.legacy(), mnemonic, languageCode);
}