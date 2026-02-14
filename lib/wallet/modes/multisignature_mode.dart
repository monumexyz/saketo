import 'wallet_mode_abstract.dart';

class MultisignatureMode implements WalletMode {
  @override
  String get name => 'Multisignature';

  @override
  String get icon => 'app_assets/multisignature.svg';
}