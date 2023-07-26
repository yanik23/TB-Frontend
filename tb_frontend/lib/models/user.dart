
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:tb_frontend/utils/constants.dart';


/// This class is used to represent a user.
///
/// @author Yanik Lange
/// @date 26.07.2023
/// @version 1
class User {
  final String name;
  final String password;


  User({
    required this.name,
    required this.password,
  });

  /// This function is used to convert a user to a json.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['username'],
      password: json['password'],
    );
  }
}

/// This function is used to login a user.
///
/// if the login is successful, the authorization and refresh token are returned.
/// Otherwise an exception is thrown.
/// TIMEOUT: 5 seconds
///
/// @param name The name of the user.
/// @param password The password of the user.
/// @return The authorization and refresh token.
Future<(String, String)> login(String name, String password) async {
    final response = await http.post(
      Uri.parse('$uriPrefix/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'username': name,
        'password': password,
      }),
    ).timeout(const Duration(seconds: 5));

    if (response.statusCode == HttpStatus.ok) {
      return (response.headers['authorization']!, response.headers['refresh']!);
    } else {
      throw Exception(response.body);
    }

}