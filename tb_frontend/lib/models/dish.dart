import 'dart:async';
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:tb_frontend/utils/SecureStorageManager.dart';

import '../utils/Constants.dart';



enum DishType {
  meat,
  vegetarian,
  vegan,
}

enum DishSize {
  fit,
  gain,
}
class Dish {
  final int id;
  String name;
  String? description;
  String currentType;
  String currentSize;
  double price;
  bool isAvailable;
  int calories;
  double? fats;
  double? saturatedFats;
  double? sodium;
  double? carbohydrates;
  double? fibers;
  double? sugars;
  double? proteins;
  double? calcium;
  double? iron;
  double? potassium;


  Dish({
    required this.id,
    required this.name,
    this.description,
    required this.currentType,
    required this.currentSize,
    required this.price,
    required this.isAvailable,
    required this.calories,
    this.fats,
    this.saturatedFats,
    this.sodium,
    this.carbohydrates,
    this.fibers,
    this.sugars,
    this.proteins,
    this.calcium,
    this.iron,
    this.potassium,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'],
      name: json['dishName'],
      currentType: json['dishType'],
      currentSize: json['dishSize'],
      price: json['price'],
      calories: json['calories'],
      isAvailable: json['available'],
    );
  }

  factory Dish.fromServerJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'],
      name: json['name'],
      currentType: json['currentType'],
      currentSize: json['currentSize'],
      price: json['price'],
      calories: json['calories'],
      isAvailable: json['available'],
      description: json['description'],
      fats: json['fats'],
      saturatedFats: json['saturatedFats'],
      sodium: json['sodium'],
      carbohydrates: json['carbohydrates'],
      fibers: json['fibers'],
      sugars: json['sugars'],
      proteins: json['proteins'],
      calcium: json['calcium'],
      iron: json['iron'],
      potassium: json['potassium'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dishName': name,
      'dishType': currentType,
      'dishSize': currentSize,
      'price': price,
      'calories': calories,
      'available': isAvailable,
    };
  }


}

Future<Dish> fetchDish(int id) async {
    final token = await SecureStorageManager.read('KEY_TOKEN');

    if(token != null) {
      final response = await http.get(Uri.parse('http://$ipAddress/dishes/$id'),
          headers: {
            HttpHeaders
                .authorizationHeader: token,
          });
      if (response.statusCode == 200) {
        // If the server returned a 200 OK response, parse the JSON.
        final responseData = jsonDecode(response.body);
        return Dish.fromServerJson(responseData);
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load dish');
      }
    } else {
      throw Exception('Failed to load token');
    }

}

Future<List<Dish>> fetchDishes() async {
  final token = await SecureStorageManager.read('KEY_TOKEN');

  if(token != null) {
    log("=================================> TOKEN: $token");
    final response = await http.get(Uri.parse('http://$ipAddress/dishes'),
        headers: {
          HttpHeaders
              .authorizationHeader: token,
        });
    if (response.statusCode == 200) {
      // If the server returned a 200 OK response, parse the JSON.
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData.map((json) => Dish.fromJson(json)).toList();
    } else {
      log("=================================> ERROR: ${response.statusCode}");
      final List<dynamic> responseData = jsonDecode(response.body);
      log("=================================> ERROR: $responseData");
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load dishes');
    }
  } else {
    throw Exception('Failed to load token');
  }
}

//Future<DishDTO>

