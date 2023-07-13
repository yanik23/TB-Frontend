

import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:tb_frontend/utils/Constants.dart';

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


Future<String> login(String name, String password) async {
  try {
    final response = await http.post(
      Uri.parse('http://$ipAddress/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'username': name,
        'password': password,
      }),
    ).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      log("============================> GOT 200!");
      return response.headers['authorization']!;
    } else {
      log("==============================> ${response.statusCode}");
      throw Exception(response.body);
    }
  } on TimeoutException catch (e) {
    log("==============================> $e");
    throw Exception('Failed to login, timeout');
  } on SocketException catch (e) {
    log("==============================> $e");
    throw Exception('Failed to login');
  } catch (e) {

    log("==============================> $e");
    throw Exception(e);
  }
}