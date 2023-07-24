import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:tb_frontend/data/dummyDishes.dart';
import 'package:tb_frontend/dto/ingredientLessDTO.dart';
import 'dart:convert';
import 'dart:io';
import 'package:tb_frontend/utils/secureStorageManager.dart';
import '../utils/constants.dart';
import '../utils/refreshToken.dart';

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
  List<IngredientLessDTO>? ingredients;


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
    this.ingredients,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'],
      name: json['name'],
      currentType: json['currentType'],
      currentSize: json['currentSize'],
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
      ingredients: json['ingredients'] != null ? (json['ingredients'] as List).map((i) => IngredientLessDTO.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'currentType': currentType.split('.').last,
      'currentSize': currentSize.toString().split('.').last,
      'price': price,
      'calories': calories,
      'isAvailable': isAvailable,
      'description': description,
      'fats': fats,
      'saturatedFats': saturatedFats,
      'sodium': sodium,
      'carbohydrates': carbohydrates,
      'fibers': fibers,
      'sugars': sugars,
      'proteins': proteins,
      'calcium': calcium,
      'iron': iron,
      'potassium': potassium,
      'ingredients': ingredients != null ? ingredients!.map((i) => i.toJson()).toList() : null,
    };
  }

}

Future<Dish> fetchDish(int id) async {
    final token = await SecureStorageManager.read('ACCESS_TOKEN');

    if(token != null) {
      try {
        final response = await http.get(
            Uri.parse('$uriPrefix/dishes/$id'),
            headers: {
              HttpHeaders
                  .authorizationHeader: token,
            }).timeout(const Duration(seconds: 3));
        if (response.statusCode == HttpStatus.ok) {
          final responseData = jsonDecode(utf8.decode(response.bodyBytes));
          return Dish.fromServerJson(responseData);
        } else if (response.statusCode == HttpStatus.unauthorized) {
          final newToken = await fetchNewToken();
          SecureStorageManager.write('ACCESS_TOKEN', newToken);
          final response = await http.get(
              Uri.parse('$uriPrefix/dishes/$id'),
              headers: {
                HttpHeaders
                    .authorizationHeader: newToken,
              }).timeout(const Duration(seconds: 3));
          if (response.statusCode == HttpStatus.ok) {
            final responseData = jsonDecode(utf8.decode(response.bodyBytes));
            return Dish.fromServerJson(responseData);
          } else if (response.statusCode == HttpStatus.forbidden) {
            throw Exception('You are not allowed to access this resource');
          } else {
            throw Exception('Failed to load dish');
          }
        } else if (response.statusCode == HttpStatus.forbidden) {
          throw Exception('You are not allowed to access this resource');
        } else {
          // If the server did not return a 200 OK response, throw an exception.
          throw Exception('Failed to load dish');
        }
      } catch (e) {
        return dummyDishes.firstWhere((dish) => dish.id == id);
      }
    } else {
      throw Exception('Failed to load token');
    }

}

Future<List<Dish>> fetchDishes() async {
  final token = await SecureStorageManager.read('ACCESS_TOKEN');

  if(token != null) {
    try {
      final response = await http.get(Uri.parse('$uriPrefix/dishes'),
          headers: {
            HttpHeaders
                .authorizationHeader: token,
          }).timeout(const Duration(seconds: 5));
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> responseData = jsonDecode(
            utf8.decode(response.bodyBytes));
        return responseData.map((json) => Dish.fromJson(json)).toList();
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw Exception('You are not allowed to access this resource');
      } else if (response.statusCode == HttpStatus.unauthorized) {
        final newToken = await fetchNewToken();
        SecureStorageManager.write('ACCESS_TOKEN', newToken);
        final response = await http.get(Uri.parse('$uriPrefix/dishes'),
            headers: {
              HttpHeaders
                  .authorizationHeader: newToken,
            });
        if (response.statusCode == HttpStatus.ok) {
          final List<dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));
          return responseData.map((json) => Dish.fromJson(json)).toList();
        } else if (response.statusCode == HttpStatus.forbidden) {
          throw Exception('You are not allowed to access this resource');
        } else {
          // If the server did not return a 200 OK response, throw an exception.
          throw Exception('Failed to load dishes');
        }
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load dishes');
      }
    } catch (e) {
      throw Exception('Failed to load dishes cause no co');
      //return List<Dish>.empty();
    }
  } else {
    throw Exception('Failed to load token');
  }
}

Future<Dish> createDish(Dish dish) async {
  final token = await SecureStorageManager.read('ACCESS_TOKEN');
  if(token != null) {
      final response = await http.post(Uri.parse('$uriPrefix/dishes'),
          headers: {
            HttpHeaders
                .authorizationHeader: token,
            HttpHeaders.contentTypeHeader: 'application/json'
          },
          body: jsonEncode(dish.toJson()));
      if (response.statusCode == HttpStatus.created) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        return Dish.fromServerJson(responseData);
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw Exception('You don\'t have permission to create this dish');
      } else if (response.statusCode == HttpStatus.unauthorized) {
        final newToken = await fetchNewToken();
        SecureStorageManager.write('ACCESS_TOKEN', newToken);
        final response = await http.post(Uri.parse('$uriPrefix/dishes'),
            headers: {
              HttpHeaders
                  .authorizationHeader: newToken,
              HttpHeaders.contentTypeHeader: 'application/json'
            },
            body: jsonEncode(dish.toJson()));
        if (response.statusCode == HttpStatus.created) {
          final responseData = jsonDecode(utf8.decode(response.bodyBytes));
          return Dish.fromServerJson(responseData);
        } else if (response.statusCode == HttpStatus.forbidden) {
          throw Exception('You don\'t have permission to create this dish');
        } else {
          throw Exception('Failed to create dish');
        }
      } else {
        throw Exception('Failed to create dish');
      }
  } else {
    throw Exception('Failed to load token');
  }
}

Future<Dish> updateDish(Dish dish) async {
  final token = await SecureStorageManager.read('ACCESS_TOKEN');

  if(token != null) {
    //try {
      final response = await http.put(Uri.parse('$uriPrefix/dishes/${dish.id}'),
          headers: {
            HttpHeaders
                .authorizationHeader: token,
            HttpHeaders.contentTypeHeader: 'application/json'
          },
          body: jsonEncode(dish.toJson()));
      if (response.statusCode == HttpStatus.ok) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        return Dish.fromServerJson(responseData);
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw Exception('You don\'t have permission to update this dish');
      } else if (response.statusCode == HttpStatus.unauthorized) {
        final newToken = await fetchNewToken();
        SecureStorageManager.write('ACCESS_TOKEN', newToken);
        final response = await http.put(Uri.parse('$uriPrefix/dishes/${dish.id}'),
            headers: {
              HttpHeaders
                  .authorizationHeader: newToken,
              HttpHeaders.contentTypeHeader: 'application/json'
            },
            body: jsonEncode(dish.toJson()));
        if (response.statusCode == HttpStatus.ok) {
          final responseData = jsonDecode(utf8.decode(response.bodyBytes));
          return Dish.fromServerJson(responseData);
        } else if (response.statusCode == HttpStatus.forbidden) {
          throw Exception('You don\'t have permission to update this dish');
        } else {
          throw Exception('Failed to update dish');
        }
      } else {
        throw Exception('Failed to update dish');
      }
    /*} catch (e) {
      throw Exception('Failed to update dish');
    }*/
  } else {
    throw Exception('Failed to load token');
  }
}

Future<http.Response> deleteDish(int id) async {
  final token = await SecureStorageManager.read('ACCESS_TOKEN');

  if(token != null) {
    //try {
      final response = await http.delete(Uri.parse('$uriPrefix/dishes/$id'),
          headers: {
            HttpHeaders
                .authorizationHeader: token,
          });
      if (response.statusCode == HttpStatus.noContent) {
        return response;
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw Exception('You don\'t have the permission to delete this dish');
      } else if (response.statusCode == HttpStatus.unauthorized) {
        final newToken = await fetchNewToken();
        SecureStorageManager.write('ACCESS_TOKEN', newToken);
        final response = await http.delete(Uri.parse('$uriPrefix/dishes/$id'),
            headers: {
              HttpHeaders
                  .authorizationHeader: newToken,
            });
        if (response.statusCode == HttpStatus.noContent) {
          return response;
        } else if (response.statusCode == HttpStatus.forbidden) {
          throw Exception('You don\'t have the permission to delete this dish');
        } else {
          throw Exception('Failed to delete dish');
        }
      } else {
        throw Exception('Failed to delete dish');
      }
  } else {
    throw Exception('Failed to load token');
  }
}


