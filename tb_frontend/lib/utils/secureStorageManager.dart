
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class SecureStorageManager {
  //static final SecureStorageManager _instance = SecureStorageManager._internal();

  /*factory SecureStorageManager() {
    return _instance;
  }

  SecureStorageManager._internal();*/

  static const _storage = FlutterSecureStorage();

  static Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}