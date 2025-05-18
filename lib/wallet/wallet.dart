import 'package:objectbox/objectbox.dart';

import '../db/secure/secure_db.dart';

@Entity()
class Wallet {
  int? id; // ObjectBox ID

  String internalId; // UUIDv4 random ID
  String name; // User defined name
  String modeName; // Basic, Lightweight, Advanced etc.
  String mnemonicTypeName; // Polyseed, Legacy etc.
  String primaryAddress; // Primary Address that starts with 4...
  int birthdayHeight; // Seed's birthday block height
  int lastSyncedHeight; // Last synced block height

  Wallet({required this.internalId, required this.name, required this.modeName, required this.mnemonicTypeName, required this.primaryAddress, required this.birthdayHeight, required this.lastSyncedHeight});

  Future<bool> saveMnemonic(String mnemonic, String password) async {
    return await SecureDB.putValue("${internalId}_mnemonic", mnemonic, password);
  }

  Future<String?> getMnemonic(String password) async {
    return await SecureDB.getValue("${internalId}_mnemonic", password);
  }
}