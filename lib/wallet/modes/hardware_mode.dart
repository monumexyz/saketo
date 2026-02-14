import 'wallet_mode_abstract.dart';

class HardwareMode implements WalletMode {
  @override
  String get name => 'Hardware';

  @override
  String get icon => 'app_assets/shield.svg';
}