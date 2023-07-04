

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
  final response = await http.post(
    Uri.parse('http://$ipAddress/login'),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, String>{
      'username': name,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    log("============================> GOT 200!");
    return response.headers['authorization']!;
  } else {
    log("==============================> ${response.statusCode}");
    throw Exception('Failed to login');
  }
}