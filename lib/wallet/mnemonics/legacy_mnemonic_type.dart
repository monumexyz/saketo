import '../../ffi/ffi.dart';
import 'mnemonic_type.dart';

class LegacyMnemonicType implements MnemonicType {
  @override
  String get name => 'Legacy';

  @override
  int get wordCount => 25;

  @override
  List<String> generateMnemonic() => generateSeedString(MnemonicType.legacy()).split(' ');

  @override
  (bool, String) isValidMnemonic(String mnemonic, String languageCode) => checkIsValidMnemonic(MnemonicType.legacy(), mnemonic, languageCode);
}