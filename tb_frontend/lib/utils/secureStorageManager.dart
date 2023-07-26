
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


/// This class is used to manage the secure storage of the application.
///
/// The storage is used to store the JWT access and refresh token.
/// It stores the username and password of the last user that logged in.
///
/// @author Yanik Lange
/// @date 26.07.2023
/// @version 1
class SecureStorageManager {

  /// The storage object.
  static const _storage = FlutterSecureStorage();

  /// Writes a value to the storage.
  static Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Reads a value from the storage.
  static Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// Deletes a value from the storage.
  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Deletes all values from the storage.
  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}