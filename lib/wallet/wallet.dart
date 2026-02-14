import 'package:objectbox/objectbox.dart';
import 'package:saketo/wallet/mnemonics/mnemonic_type.dart';

import '../db/secure/secure_db.dart';
import '../ffi/ffi.dart' as ffi;
import 'chain/data_types.dart';
import 'modes/wallet_mode_abstract.dart';

@Entity()
class Wallet {
  int? id; // ObjectBox ID

  String internalId; // UUIDv4 random ID of the wallet, used for secure storage keys
  String name; // User defined name of the wallet
  String primaryAddress; // Primary Address that starts with 4...
  int birthdayHeight; // Seed's birthday block height
  int lastSyncedHeight; // Last synced block height

  // Raw fields for ObjectBox storage, use getters and setters below instead
  String rawMode; // Name of the mode used by this wallet: Basic, Lightweight, Advanced etc.
  String rawMnemonicType; // Name of the mnemonic type used by this wallet: Polyseed, Legacy etc.
  String rawInputs; // JSON encoded list of TxIn
  String rawOutputs; // JSON encoded list of TxOut

  Wallet.create({
    this.id,
    required this.internalId,
    required this.name,
    required WalletMode mode,
    required MnemonicType mnemonicType,
    required this.primaryAddress,
    required this.birthdayHeight,
    required this.lastSyncedHeight,
    List<Transaction> transactions = const [],
  })  : rawMode = mode.name,
        rawMnemonicType = mnemonicType.name,
        rawInputs = Transaction.encodeInputs(transactions),
        rawOutputs = Transaction.encodeOutputs(transactions);

  Wallet({
    this.id,
    required this.internalId,
    required this.name,
    required this.primaryAddress,
    required this.birthdayHeight,
    required this.lastSyncedHeight,
    required this.rawMode,
    required this.rawMnemonicType,
    required this.rawInputs,
    required this.rawOutputs,
  });

  Future<bool> saveMnemonic(String mnemonic, String password) async {
    return await SecureDB.putValue("${internalId}_mnemonic", mnemonic, password);
  }

  Future<String?> getMnemonic(String password) async {
    return await SecureDB.getValue("${internalId}_mnemonic", password);
  }

  Future<String> getHexPrivSpend(String mnemonic) async {
    return ffi.getHexPrivSpend(mnemonic, mnemonicType);
  }

  // --- Getters and Setters ---

  WalletMode get mode {
    return WalletMode.fromString(rawMode);
  }

  set mode(WalletMode mode) {
    rawMode = mode.name;
  }

  MnemonicType get mnemonicType {
    return MnemonicType.fromString(rawMnemonicType);
  }

  set mnemonicType(MnemonicType mnemonicType) {
    rawMnemonicType = mnemonicType.name;
  }

  List<Transaction> get transactions {
    return Transaction.decodeTransactions(rawInputs, rawOutputs);
  }
}