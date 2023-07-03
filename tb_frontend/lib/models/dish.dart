import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';



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
      id: 1,
      name: json['dishName'],
      currentType: json['dishType'],
      currentSize: json['dishSize'],
      price: json['price'],
      calories: 100,
      isAvailable: true,

    );

  }
}

Future<List<Dish>> fetchDishes() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8080/dishes'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJMZW9uYXJkbyIsInJvbGVzIjpbIkVNUExPWUVFIl0sImV4cCI6MTY4ODQwMzA5Nn0.gEGn7p2RNTbvwYg6qObut5Mn06Ic2Lgb2onFywI2rdRxLXEZZmXjAIw0zimx0oTmAYrvMdQGF-3p-WZ7Q1ph2A',
      });

  if (response.statusCode == 200) {
    // If the server returned a 200 OK response, parse the JSON.
    final List<dynamic> responseData = jsonDecode(response.body);
    return responseData.map((json) => Dish.fromJson(json)).toList();
  } else {
    // If the server did not return a 200 OK response, throw an exception.
    throw Exception('Failed to load dishes');
  }
}

