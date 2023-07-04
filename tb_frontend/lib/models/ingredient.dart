

import 'package:tb_frontend/utils/Constants.dart';

import '../utils/SecureStorageManager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';

class Ingredient {
  final int id;
  final String name;
  final String type;
  final String? description;
  final String? supplier;


  const Ingredient(this.id, this.name, this.type, {this.description, this.supplier});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      json['id'],
      json['name'],
      json['type'],
      description: json['description'],
      supplier: json['supplier'],
    );
  }
}

Future<List<Ingredient>> fetchDishes() async {

  final result = await SecureStorageManager.read('KEY_TOKEN');

  if(result != null) {
    final response = await http.get(Uri.parse('http://$ipAddress/dishes'),
        headers: {
          HttpHeaders
              .authorizationHeader: result,
        });
    if (response.statusCode == 200) {
      // If the server returned a 200 OK response, parse the JSON.
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData.map((json) => Ingredient.fromJson(json)).toList();
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load dishes');
    }
  } else {
    throw Exception('Failed to load token');
  }
}