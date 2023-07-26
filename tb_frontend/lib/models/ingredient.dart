import 'package:tb_frontend/utils/constants.dart';
import '../utils/refreshToken.dart';
import '../utils/secureStorageManager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';

// enum to represent the type of an ingredient
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

/// This class is used to represent an ingredient.
///
/// @author Yanik Lange
/// @date 26.07.2023
/// @version 1
class Ingredient {
  final int id;
  final String name;
  final String type;
  final String? description;
  final String? supplier;

  const Ingredient(this.id, this.name, this.type,
      {this.description, this.supplier});

  /// This function is used to create an ingredient from a json.
  factory Ingredient.fullFromJson(Map<String, dynamic> json) {
    return Ingredient(
      json['id'],
      json['name'],
      json['currentType'],
      description: json['description'],
      supplier: json['supplier'],
    );
  }


  /// This function is used to convert an ingredient to a json.
  Map<String, dynamic> toJson() => {
        'name': name,
        'currentType': type.split('.').last,
        'description': description,
        'supplier': supplier,
      };
}

/// This function is used to fetch an ingredientfrom the backend.
///
/// If the access token is invalid, a new one will be fetched and the request will be repeated.
/// If the refresh token is invalid, an exception will be thrown.
/// If the user is not allowed to access the resource, an exception will be thrown.
///
/// @param id the id of the ingredient to be fetched
/// @return the fetched ingredient
Future<Ingredient> fetchIngredient(int id) async {
  final token = await SecureStorageManager.read('ACCESS_TOKEN');

  if (token != null) {
    final response =
        await http.get(Uri.parse('$uriPrefix/ingredients/$id'), headers: {
      HttpHeaders.authorizationHeader: token,
    });
    if (response.statusCode == HttpStatus.ok) {
      return Ingredient.fullFromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == HttpStatus.unauthorized) {
      final newToken = await fetchNewToken();
      SecureStorageManager.write('ACCESS_TOKEN', newToken);
      final response =
          await http.get(Uri.parse('$uriPrefix/ingredients/$id'), headers: {
        HttpHeaders.authorizationHeader: newToken,
      });
      if (response.statusCode == HttpStatus.ok) {
        return Ingredient.fullFromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception('Failed to load ingredient');
      }
    } else {
      throw Exception('Failed to load ingredient');
    }
  } else {
    throw Exception('Failed to load ingredient');
  }
}

/// This function is used to fetch all ingredients from the backend.
///
/// If the access token is invalid, a new one will be fetched and the request will be repeated.
/// If the refresh token is invalid, an exception will be thrown.
/// If the user is not allowed to access the resource, an exception will be thrown.
///
/// @return the fetched ingredients
Future<List<Ingredient>> fetchIngredients() async {
  final token = await SecureStorageManager.read('ACCESS_TOKEN');

  if (token != null) {
    final response =
        await http.get(Uri.parse('$uriPrefix/ingredients'), headers: {
      HttpHeaders.authorizationHeader: token,
    });
    if (response.statusCode == HttpStatus.ok) {
      final List<dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));
      return responseData.map((json) => Ingredient.fullFromJson(json)).toList();
    } else if (response.statusCode == HttpStatus.unauthorized) {
      final newToken = await fetchNewToken();
      SecureStorageManager.write('ACCESS_TOKEN', newToken);
      final response =
          await http.get(Uri.parse('$uriPrefix/ingredients'), headers: {
        HttpHeaders.authorizationHeader: newToken,
      });
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));
        return responseData
            .map((json) => Ingredient.fullFromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load ingredients');
      }
    } else {
      throw Exception('Failed to load ingredients');
    }
  } else {
    throw Exception('Failed to load token');
  }
}

/// This function is used to create an ingredient on the backend.
///
/// If the access token is invalid, a new one will be fetched and the request will be repeated.
/// If the refresh token is invalid, an exception will be thrown.
/// If the user is not allowed to access the resource, an exception will be thrown.
///
/// @param ingredient the ingredient to be created
/// @return the created ingredient
Future<Ingredient> createIngredient(Ingredient ingredient) async {
  final token = await SecureStorageManager.read('ACCESS_TOKEN');

  if (token != null) {
    final response = await http.post(
      Uri.parse('$uriPrefix/ingredients'),
      headers: {
        HttpHeaders.authorizationHeader: token,
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(ingredient.toJson()),
    );

    if (response.statusCode == HttpStatus.created) {
      // If the server did return a 201 CREATED response, then parse the JSON.
      return Ingredient.fullFromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == HttpStatus.forbidden) {
      // If the server did not return a 201 CREATED response, then throw an exception.
      throw Exception('You don\'t have permission to create this ingredient');
    } else if (response.statusCode == HttpStatus.unauthorized) {
      final newToken = await fetchNewToken();
      SecureStorageManager.write('ACCESS_TOKEN', newToken);
      final response = await http.post(
        Uri.parse('$uriPrefix/ingredients'),
        headers: {
          HttpHeaders.authorizationHeader: newToken,
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(ingredient.toJson()),
      );
      if (response.statusCode == HttpStatus.created) {
        // If the server did return a 201 CREATED response, then parse the JSON.
        return Ingredient.fullFromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else if (response.statusCode == HttpStatus.forbidden) {
        // If the server did not return a 201 CREATED response, then throw an exception.
        throw Exception('You don\'t have permission to create this ingredient');
      } else {
        // If the server did not return a 201 CREATED response, then throw an exception.
        throw Exception('Failed to create ingredient');
      }
    } else {
      // If the server did not return a 201 CREATED response, then throw an exception.
      throw Exception('Failed to create ingredient');
    }
  } else {
    throw Exception('Failed to load token');
  }
}

/// This function is used to update an ingredient on the backend.
///
/// If the access token is invalid, a new one will be fetched and the request will be repeated.
/// If the refresh token is invalid, an exception will be thrown.
/// If the user is not allowed to access the resource, an exception will be thrown.
///
/// @param ingredient the ingredient to be updated
/// @return the updated ingredient
Future<Ingredient> updateIngredient(Ingredient ingredient) async {
  final token = await SecureStorageManager.read('ACCESS_TOKEN');
  if (token != null) {
    final response = await http.put(
      Uri.parse('$uriPrefix/ingredients/${ingredient.id}'),
      headers: {
        HttpHeaders.authorizationHeader: token,
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(ingredient.toJson()),
    );
    if (response.statusCode == HttpStatus.ok) {
      // If the server did return a 200 OK response, then parse the JSON.
      return Ingredient.fullFromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == HttpStatus.forbidden) {
      throw Exception('You don\'t have permission to update this ingredient');
    } else if (response.statusCode == HttpStatus.unauthorized) {
      final newToken = await fetchNewToken();
      SecureStorageManager.write('ACCESS_TOKEN', newToken);
      final response = await http.put(
        Uri.parse('$uriPrefix/ingredients/${ingredient.id}'),
        headers: {
          HttpHeaders.authorizationHeader: newToken,
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(ingredient.toJson()),
      );
      if (response.statusCode == HttpStatus.ok) {
        // If the server did return a 200 OK response, then parse the JSON.
        return Ingredient.fullFromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw Exception('You don\'t have permission to update this ingredient');
      } else {
        // If the server did not return a 200 OK response, then throw an exception.
        throw Exception('Failed to update ingredient');
      }
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to update ingredient');
    }
  } else {
    throw Exception('Failed to load token');
  }
}

/// This function is used to delete an ingredient on the backend.
///
/// If the access token is invalid, a new one will be fetched and the request will be repeated.
/// If the refresh token is invalid, an exception will be thrown.
/// If the user is not allowed to access the resource, an exception will be thrown.
///
/// @param id the id of the ingredient to be deleted
/// @return the status code of the request
Future<int> deleteIngredient(int id) async {
  final token = await SecureStorageManager.read('ACCESS_TOKEN');

  if (token != null) {
    final response = await http.delete(
      Uri.parse('$uriPrefix/ingredients/$id'),
      headers: {
        HttpHeaders.authorizationHeader: token,
      },
    );
    if (response.statusCode == HttpStatus.noContent) {
      return response.statusCode;
    } else if (response.statusCode == HttpStatus.forbidden) {
      // If the server did not return a 204 NO CONTENT response, then throw an exception.
      throw Exception('You don\'t have permission to delete this ingredient');
    } else if (response.statusCode == HttpStatus.unauthorized) {
      final newToken = await fetchNewToken();
      SecureStorageManager.write('ACCESS_TOKEN', newToken);
      final response = await http.delete(
        Uri.parse('$uriPrefix/ingredients/$id'),
        headers: {
          HttpHeaders.authorizationHeader: newToken,
        },
      );
      if (response.statusCode == HttpStatus.noContent) {
        return response.statusCode;
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw Exception('You don\'t have permission to delete this ingredient');
      } else {
        throw Exception('Failed to delete ingredient');
      }
    } else {
      throw Exception('Failed to delete ingredient');
    }
  } else {
    throw Exception('Failed to load token');
  }
}
