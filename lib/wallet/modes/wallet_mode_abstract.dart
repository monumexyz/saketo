import 'basic_mode.dart';
import 'lightweight_mode.dart';
import 'advanced_mode.dart';
import 'paranoia_mode.dart';
import 'hardware_mode.dart';
import 'business_mode.dart';
import 'multisignature_mode.dart';

abstract class WalletMode {
  String get name;
  String get icon;

  factory WalletMode.basic() => BasicMode();
  factory WalletMode.lightweight() => LightweightMode();
  factory WalletMode.advanced() => AdvancedMode();
  factory WalletMode.paranoia() => ParanoiaMode();
  factory WalletMode.hardware() => HardwareMode();
  factory WalletMode.business() => BusinessMode();
  factory WalletMode.multisignature() => MultisignatureMode();

  factory WalletMode.fromString(String mode) {
    switch (mode.toLowerCase()) {
      case 'basic':
        return WalletMode.basic();
      case 'lightweight':
        return WalletMode.lightweight();
      case 'advanced':
        return WalletMode.advanced();
      case 'paranoia':
        return WalletMode.paranoia();
      case 'hardware':
        return WalletMode.hardware();
      case 'business':
        return WalletMode.business();
      case 'multisignature':
        return WalletMode.multisignature();
      default:
        throw ArgumentError('Unknown wallet mode: $mode');
    }
  }
}