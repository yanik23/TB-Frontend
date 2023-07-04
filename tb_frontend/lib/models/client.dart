import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:tb_frontend/utils/Constants.dart';

import '../utils/SecureStorageManager.dart';



class Client {
  final int id;
  final String name;
  final String addressName;
  final int addressNumber;
  final int zipCode;
  final String city;

  const Client(this.id, this.name, this.addressName, this.addressNumber,
      this.zipCode, this.city);

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      json['id'],
      json['name'],
      json['addressName'],
      json['addressNumber'],
      json['zipCode'],
      json['city'],
    );
  }
}

Future<List<Client>> fetchClients() async {

  final result = await SecureStorageManager.read('KEY_TOKEN');

  if(result != null) {
    log("=================================> TOKEN: $result");
    final response = await http
        .get(Uri.parse('http://$ipAddress/clients'),
    headers: {
          HttpHeaders.authorizationHeader: result,
    });

    if (response.statusCode == 200) {
      // If the server returned a 200 OK response, parse the JSON.
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData.map((json) => Client.fromJson(json)).toList();
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load clients');
    }
  } else {
    throw Exception('Failed to load JWT');
  }
}