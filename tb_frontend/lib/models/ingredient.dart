

import 'package:tb_frontend/utils/Constants.dart';

import '../utils/SecureStorageManager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';



enum IngredientType {
  meat,
  fish,
  starch,
  vegetable,
  fruit,
  grain,
  spice,
  sauce,
  other,
}

class Ingredient {
  final int id;
  final String name;
  final String type;
  final String? description;
  final String? supplier;


  const Ingredient(this.id, this.name, this.type, { this.description, this.supplier});

  factory Ingredient.fullFromJson(Map<String, dynamic> json) {
    return Ingredient(
      json['id'],
      json['name'],
      json['currentType'],
      description: json['description'],
      supplier: json['supplier'],
    );
  }

  factory Ingredient.lightFromJson(Map<String, dynamic> json) {
    return Ingredient(
      json['id'],
      json['name'],
      json['currentType'],
      description: json['description'],
      supplier: json['supplier'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'currentType': type.split('.').last,
    'description': description,
    'supplier': supplier,
  };
}


Future<Ingredient> fetchIngredient(int id) async {
  final token = await SecureStorageManager.read('KEY_TOKEN');

  if(token != null) {
    final response = await http.get(
        Uri.parse('http://$ipAddress/ingredients/$id'),
        headers: {
          HttpHeaders
              .authorizationHeader: token,
        });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return Ingredient.fullFromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load ingredient');
    }
  } else {
    throw Exception('Failed to load token');
  }
}

Future<List<Ingredient>> fetchIngredients() async {
  final result = await SecureStorageManager.read('KEY_TOKEN');

  if(result != null) {
    final response = await http.get(Uri.parse('http://$ipAddress/ingredients'),
        headers: {
          HttpHeaders
              .authorizationHeader: result,
        });
    if (response.statusCode == 200) {
      // If the server returned a 200 OK response, parse the JSON.
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData.map((json) => Ingredient.fullFromJson(json)).toList();
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load ingredients');
    }
  } else {
    throw Exception('Failed to load token');
  }
}

Future<Ingredient> createIngredient(Ingredient ingredient) async {
  final token = await SecureStorageManager.read('KEY_TOKEN');

  if(token != null) {
    final response = await http.post(
      Uri.parse('http://$ipAddress/ingredients'),
      headers: {
        HttpHeaders
            .authorizationHeader: token,
        HttpHeaders
            .contentTypeHeader: 'application/json',
      },
      body: jsonEncode(ingredient.toJson()),
    );

    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response, then parse the JSON.
      return Ingredient.fullFromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response, then throw an exception.
      throw Exception('Failed to create ingredient');
    }
  } else {
    throw Exception('Failed to load token');
  }
}


Future<Ingredient> updateIngredient(Ingredient ingredient) async {
  final token = await SecureStorageManager.read('KEY_TOKEN');

  if(token != null) {
    final response = await http.put(
      Uri.parse('http://$ipAddress/ingredients/${ingredient.id}'),
      headers: {
        HttpHeaders
            .authorizationHeader: token,
        HttpHeaders
            .contentTypeHeader: 'application/json',
      },
      body: jsonEncode(ingredient.toJson()),
      /*body: jsonEncode(<String, dynamic>{
        'name': ingredient.name,
        'currentType': ingredient.type,
        'description': ingredient.description,
        'supplier': ingredient.supplier,
      }),*/
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return Ingredient.fullFromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to update ingredient');
    }
  } else {
    throw Exception('Failed to load token');
  }
}

Future<void> deleteIngredient(int id) async {
  final token = await SecureStorageManager.read('KEY_TOKEN');

  if(token != null) {
    final response = await http.delete(
      Uri.parse('http://$ipAddress/ingredients/$id'),
      headers: {
        HttpHeaders
            .authorizationHeader: token,
      },
    );

    if (response.statusCode != 204) {
      // If the server did not return a 204 NO CONTENT response, then throw an exception.
      throw Exception('Failed to delete ingredient');
    }
  } else {
    throw Exception('Failed to load token');
  }
}

