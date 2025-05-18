import 'package:saketo/rust_ffi/rust_ffi.dart';
import '../mnemonic_type.dart';

class PolyseedMnemonicType implements MnemonicType {
  @override
  String get name => 'Polyseed';

  @override
  int get wordCount => 16;

  @override
  List<String> generateMnemonic() => generateSeedString(MnemonicType.polyseed()).split(' ');

  @override
  (bool, String) isValidMnemonic(String mnemonic, String languageCode) => checkIsValidMnemonic(MnemonicType.polyseed(), mnemonic, languageCode);
}