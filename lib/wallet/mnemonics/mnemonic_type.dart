import 'legacy/legacy_mnemonic_type.dart';
import 'mymonero/mymonero_mnemonic_type.dart';
import 'polyseed/polyseed_mnemonic_type.dart';

abstract class MnemonicType {
  String get name;
  int get wordCount;
  List<String> generateMnemonic();
  (bool, String) isValidMnemonic(String mnemonic, String languageCode);

  factory MnemonicType.polyseed() => PolyseedMnemonicType();
  factory MnemonicType.legacy() => LegacyMnemonicType();
  factory MnemonicType.mymonero() => MyMoneroMnemonicType();

  factory MnemonicType.fromName(String name) {
    switch (name) {
      case 'Polyseed':
        return MnemonicType.polyseed();
      case 'Legacy':
        return MnemonicType.legacy();
      case 'MyMonero':
        return MnemonicType.mymonero();
      default:
        throw Exception('Unknown mnemonic type: $name');
    }
  }
}