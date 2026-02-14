import 'wallet_mode_abstract.dart';

class ParanoiaMode implements WalletMode {
  @override
  String get name => 'Paranoia';

  @override
  String get icon => 'app_assets/eye_off.svg';
}