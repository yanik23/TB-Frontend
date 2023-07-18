

import 'dart:developer';
import 'dart:io';
import 'SecureStorageManager.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';

Future<String> fetchNewToken() async {
  final refreshToken = await SecureStorageManager.read('REFRESH_TOKEN');

  if (refreshToken != null) {
    //try {
    final response = await http
        .get(Uri.parse('$uriPrefix/users/refresh-token'), headers: {
      HttpHeaders.authorizationHeader: refreshToken,
    });
    if (response.statusCode == 200) {
      log('=================================> REFRESH_TOKEN: $refreshToken');
      SecureStorageManager.write(
          'ACCESS_TOKEN', response.headers['authorization']!);
      return response.headers['authorization']!;
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load token');
    }
  } else {
    throw Exception('Failed to load token');
  }
}