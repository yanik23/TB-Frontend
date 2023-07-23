
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:tb_frontend/utils/constants.dart';

class User {
  final String name;
  final String password;


  User({
    required this.name,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['username'],
      password: json['password'],
    );
  }
}


Future<(String, String)> login(String name, String password) async {
  //try {
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

    if (response.statusCode == 200) {
      return (response.headers['authorization']!, response.headers['refresh']!);
    } else {
      throw Exception(response.body);
    }

}