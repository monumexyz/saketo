import 'wallet_mode_abstract.dart';

class BasicMode implements WalletMode {
  @override
  String get name => 'Basic';

  @override
  String get icon => 'app_assets/box.svg';
}