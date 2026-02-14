import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';

import '../../ffi/ffi.dart';

class SecureDB {
  static Future<String?> getValue(String key, String password) async {
    final encryptedData = await const FlutterSecureStorage().read(key: key);
    if (encryptedData == null) {
      Logger("SecureDB").log(Level.SEVERE, "ERR: Encrypted data is null");
      return null;
    }
    final decryptedData = decryptData(encryptedData, password);
    if (decryptedData == "INVALID_BASE64") {
      Logger("SecureDB").log(Level.SEVERE, "ERR: Invalid base64 data");
      return null;
    } else if (decryptedData == "INVALID_DATA") {
      Logger("SecureDB").log(Level.SEVERE, "ERR: Invalid data, less than 28 bytes");
      return null;
    } else if (decryptedData == "DECRYPTION_FAILED") {
      Logger("SecureDB").log(Level.SEVERE, "ERR: Decryption failed");
      return null;
    }
    return decryptedData;
  }

  static Future<bool> putValue(String key, String value, String password) async {
    try {
      final encryptedData = encryptData(value, password);
      if (encryptedData == "") {
        Logger("SecureDB").log(Level.SEVERE, "ERR: Encrypted data is empty");
        return false;
      } else if (encryptedData == "ENCRYPTION_FAILED") {
        Logger("SecureDB").log(Level.SEVERE, "ERR: Encryption failed");
        return false;
      }
      await const FlutterSecureStorage().write(key: key, value: encryptedData);
      return true;
    } catch (e) {
      return false;
    }
  }
}