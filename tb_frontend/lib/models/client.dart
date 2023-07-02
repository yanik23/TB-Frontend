import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

Future<List<Client>> fetchAlbums() async {
  final response = await http
      .get(Uri.parse('http://10.0.2.2:8080/clients'));

  if (response.statusCode == 200) {
    // If the server returned a 200 OK response, parse the JSON.
    final List<dynamic> responseData = jsonDecode(response.body);
    return responseData.map((json) => Client.fromJson(json)).toList();
  } else {
    // If the server did not return a 200 OK response, throw an exception.
    throw Exception('Failed to load albums');
  }
}

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