import 'legacy_mnemonic_type.dart';
import 'mymonero_mnemonic_type.dart';
import 'polyseed_mnemonic_type.dart';

abstract class MnemonicType {
  String get name;
  int get wordCount;
  List<String> generateMnemonic();
  (bool, String) isValidMnemonic(String mnemonic, String languageCode);

  factory MnemonicType.polyseed() => PolyseedMnemonicType();
  factory MnemonicType.legacy() => LegacyMnemonicType();
  factory MnemonicType.mymonero() => MyMoneroMnemonicType();

  factory MnemonicType.fromString(String name) {
    switch (name.toLowerCase()) {
      case 'polyseed':
        return MnemonicType.polyseed();
      case 'legacy':
        return MnemonicType.legacy();
      case 'mymonero':
        return MnemonicType.mymonero();
      default:
        throw Exception('Unknown mnemonic type: $name');
    }
  }
}