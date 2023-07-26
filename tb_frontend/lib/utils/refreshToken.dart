

import 'dart:io';
import 'SecureStorageManager.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';


/// This function is used to fetch a new access token from the server.
///
/// It uses the refresh token stored in the secure storage to fetch a new access token.
/// The access token is then stored in the secure storage.
///
/// @author Yanik Lange
/// @date 26.07.2023
/// @version 1
Future<String> fetchNewToken() async {
  // Read the refresh token from the secure storage
  final refreshToken = await SecureStorageManager.read('REFRESH_TOKEN');

  // If the refresh token is not null, fetch a new access token from the server
  if (refreshToken != null) {
    final response = await http
        .get(Uri.parse('$uriPrefix/users/refresh-token'), headers: {
      HttpHeaders.authorizationHeader: refreshToken,
    });
    if (response.statusCode == HttpStatus.ok) {
      SecureStorageManager.write(
          'ACCESS_TOKEN', response.headers['authorization']!);
      return response.headers['authorization']!;
    } else {
      throw Exception('Failed to load token');
    }
  } else {
    throw Exception('Failed to load refresh token');
  }
}