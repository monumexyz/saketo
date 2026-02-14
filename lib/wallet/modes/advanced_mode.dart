import 'wallet_mode_abstract.dart';

class AdvancedMode implements WalletMode {
  @override
  String get name => 'Advanced';

  @override
  String get icon => 'app_assets/adv_box.svg';
}