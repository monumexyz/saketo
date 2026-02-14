import 'wallet_mode_abstract.dart';

class LightweightMode implements WalletMode {
  @override
  String get name => 'Lightweight';

  @override
  String get icon => 'app_assets/cloud.svg';
}