import 'package:tb_frontend/utils/constants.dart';

import '../utils/refreshToken.dart';
import '../utils/secureStorageManager.dart';
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

  const Ingredient(this.id, this.name, this.type,
      {this.description, this.supplier});

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
  final token = await SecureStorageManager.read('ACCESS_TOKEN');

  if (token != null) {
    final response =
        await http.get(Uri.parse('$uriPrefix/ingredients/$id'), headers: {
      HttpHeaders.authorizationHeader: token,
    });
    if (response.statusCode == HttpStatus.ok) {
      // If the server did return a 200 OK response, then parse the JSON.
      return Ingredient.fullFromJson(jsonDecode(response.body));
    } else if (response.statusCode == HttpStatus.unauthorized) {
      // If the server did not return a 200 OK response, then throw an exception.
      //throw Exception('Failed to load ingredient');
      final newToken = await fetchNewToken();
      SecureStorageManager.write('ACCESS_TOKEN', newToken);
      final response =
          await http.get(Uri.parse('$uriPrefix/ingredients/$id'), headers: {
        HttpHeaders.authorizationHeader: newToken,
      });
      if (response.statusCode == HttpStatus.ok) {
        // If the server did return a 200 OK response, then parse the JSON.
        return Ingredient.fullFromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 200 OK response, then throw an exception.
        throw Exception('Failed to load ingredient');
      }
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load ingredient');
    }
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load ingredient');
  }
}

Future<List<Ingredient>> fetchIngredients() async {
  final token = await SecureStorageManager.read('ACCESS_TOKEN');

  if (token != null) {
    final response =
        await http.get(Uri.parse('$uriPrefix/ingredients'), headers: {
      HttpHeaders.authorizationHeader: token,
    });
    if (response.statusCode == HttpStatus.ok) {
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData.map((json) => Ingredient.fullFromJson(json)).toList();
    } else if (response.statusCode == HttpStatus.unauthorized) {
      final newToken = await fetchNewToken();
      SecureStorageManager.write('ACCESS_TOKEN', newToken);
      final response =
          await http.get(Uri.parse('$uriPrefix/ingredients'), headers: {
        HttpHeaders.authorizationHeader: newToken,
      });
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData
            .map((json) => Ingredient.fullFromJson(json))
            .toList();
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load ingredients');
      }
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load ingredients');
    }
  } else {
    throw Exception('Failed to load token');
  }
}

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
      return Ingredient.fullFromJson(jsonDecode(response.body));
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
        return Ingredient.fullFromJson(jsonDecode(response.body));
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
