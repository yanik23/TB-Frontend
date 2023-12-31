

import 'package:intl/intl.dart';
import '../dto/dishForDeliveryDTO.dart';
import '../utils/refreshToken.dart';
import '../utils/secureStorageManager.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tb_frontend/utils/constants.dart';

// date format used to display the date
final formatter = DateFormat('dd/MM/yyyy');

/// This class is used to manage the deliveries of the application.
///
/// @author Yanik Lange
/// @date 26.07.2023
/// @version 1
class Delivery {
  int id;
  String username;
  String clientName;
  DateTime deliveryDate;
  String? details;
  List<DishForDeliveryDTO>? dishes;

  Delivery(this.id, this.username, this.clientName, this.deliveryDate,
      this.details, this.dishes);


  /// This function is used to create a delivery from a json.
  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      json['id'],
      json['userName'],
      json['clientName'],
      DateTime.parse(json['deliveryDate']),
      json['details'],
      json['dishes'] != null
          ? (json['dishes'] as List)
              .map((i) => DishForDeliveryDTO.fromJson(i))
              .toList()
          : null,
    );
  }

  /// This function is used to convert a delivery to a json.
  Map<String, dynamic> toJson() => {
        'id': id,
        'userName': username,
        'clientName': clientName,
        'deliveryDate': deliveryDate.toIso8601String(),
        'details': details ?? '',
        'dishes': dishes != null
            ? dishes!.map((e) => e.toJson()).toList()
            : null,
      };
}

/// This function is used to fetch all deliveries from the server.
///
/// If the access token is invalid, a new one will be fetched using the refresh token and the request will be repeated.
/// If the refresh token is invalid, an exception will be thrown.
/// If the user is not authorized to fetch the deliveries, an exception will be thrown.
///
/// @return A list of all deliveries.
Future<List<Delivery>> fetchDeliveries() async {
  final token = await SecureStorageManager.read('ACCESS_TOKEN');

  if (token != null) {
    final response =
        await http.get(Uri.parse('$uriPrefix/deliveries'), headers: {
      HttpHeaders.authorizationHeader: token,
    });
    if (response.statusCode == HttpStatus.ok) {
      final List<dynamic> responseData =
          jsonDecode(utf8.decode(response.bodyBytes));
      return responseData.map((json) => Delivery.fromJson(json)).toList();
    } else if (response.statusCode == HttpStatus.unauthorized) {
      final newToken = await fetchNewToken();
      SecureStorageManager.write('ACCESS_TOKEN', newToken);
      final response =
          await http.get(Uri.parse('$uriPrefix/deliveries'), headers: {
        HttpHeaders.authorizationHeader: newToken,
      });
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> responseData =
            jsonDecode(utf8.decode(response.bodyBytes));
        return responseData.map((json) => Delivery.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load deliveries');
      }
    } else {
      throw Exception('Failed to load deliveries');
    }
  } else {
    throw Exception('Failed to load JWT');
  }
}

/// This function is used to fetch a delivery from the backend.
///
/// If the access token is invalid, a new one will be fetched using the refresh token and the request will be repeated.
/// If the refresh token is invalid, an exception will be thrown.
/// If the user is not authorized to fetch the delivery, an exception will be thrown.
///
/// @param id The id of the delivery to be fetched.
/// @return The delivery.
Future<Delivery> fetchDelivery(int id) async {
  final token = await SecureStorageManager.read('ACCESS_TOKEN');

  if (token != null) {
    final response =
        await http.get(Uri.parse('$uriPrefix/deliveries/$id'), headers: {
      HttpHeaders.authorizationHeader: token,
    });
    if (response.statusCode == HttpStatus.ok) {
      return Delivery.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == HttpStatus.unauthorized) {
      final newToken = await fetchNewToken();
      SecureStorageManager.write('ACCESS_TOKEN', newToken);
      final response =
          await http.get(Uri.parse('$uriPrefix/deliveries/$id'), headers: {
        HttpHeaders.authorizationHeader: newToken,
      });
      if (response.statusCode == HttpStatus.ok) {
        return Delivery.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw Exception('You don\'t have permission to view this delivery');
      } else {
        throw Exception('Failed to load delivery');
      }
    } else if (response.statusCode == HttpStatus.forbidden) {
      throw Exception('You don\'t have permission to view this delivery');
    } else {
      throw Exception('Failed to load delivery');
    }
  } else {
    throw Exception('Failed to load token');
  }
}

/// This function is used to create a delivery on the backend.
///
/// If the access token is invalid, a new one will be fetched using the refresh token and the request will be repeated.
/// If the refresh token is invalid, an exception will be thrown.
/// If the user is not authorized to create the delivery, an exception will be thrown.
///
/// @param delivery The delivery to be created.
/// @return The created delivery.
Future<Delivery> createDelivery(Delivery delivery) async {
  final token = await SecureStorageManager.read('ACCESS_TOKEN');

  if (token != null) {
    final response = await http.post(
      Uri.parse('$uriPrefix/deliveries'),
      headers: {
        HttpHeaders.authorizationHeader: token,
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(delivery.toJson()),
    );

    if (response.statusCode == HttpStatus.created) {
      // If the server did return a 201 CREATED response, then parse the JSON.
      return Delivery.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == HttpStatus.forbidden) {
      throw Exception('You don\'t have permission to create this delivery');
    } else if (response.statusCode == HttpStatus.unauthorized) {
      final newToken = await fetchNewToken();
      SecureStorageManager.write('ACCESS_TOKEN', newToken);
      final response = await http.post(
        Uri.parse('$uriPrefix/deliveries'),
        headers: {
          HttpHeaders.authorizationHeader: newToken,
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(delivery.toJson()),
      );
      if (response.statusCode == HttpStatus.created) {
        // If the server did return a 201 CREATED response, then parse the JSON.
        return Delivery.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw Exception('You don\'t have permission to create this delivery');
      } else {
        throw Exception('Failed to create delivery');
      }
    } else {
      throw Exception('Failed to create delivery');
    }
  } else {
    throw Exception('Failed to load token');
  }
}

/// This function is used to update a delivery on the backend.
///
/// If the access token is invalid, a new one will be fetched using the refresh token and the request will be repeated.
/// If the refresh token is invalid, an exception will be thrown.
/// If the user is not authorized to update the delivery, an exception will be thrown.
///
/// @param delivery The delivery to be updated.
/// @return The updated delivery.
Future<Delivery> updateDelivery(Delivery delivery) async {
  final token = await SecureStorageManager.read('ACCESS_TOKEN');

  if (token != null) {
    final response = await http.put(
      Uri.parse('$uriPrefix/deliveries/${delivery.id}'),
      headers: {
        HttpHeaders.authorizationHeader: token,
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(delivery.toJson()),
    );

    if (response.statusCode == HttpStatus.ok) {
      return Delivery.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == HttpStatus.forbidden) {
      throw Exception('You don\'t have the permission to update this delivery');
    } else if (response.statusCode == HttpStatus.unauthorized) {
      final newToken = await fetchNewToken();
      SecureStorageManager.write('ACCESS_TOKEN', newToken);
      final response = await http.put(
        Uri.parse('$uriPrefix/deliveries/${delivery.id}'),
        headers: {
          HttpHeaders.authorizationHeader: newToken,
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(delivery.toJson()),
      );
      if (response.statusCode == HttpStatus.ok) {
        return Delivery.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw Exception('You don\'t have permission to update this delivery');
      } else {
        throw Exception('Failed to update delivery');
      }
    } else {
      throw Exception('Failed to update delivery');
    }
  } else {
    throw Exception('Failed to load token');
  }
}

/// This function is used to delete a delivery on the backend.
///
/// If the access token is invalid, a new one will be fetched using the refresh token and the request will be repeated.
/// If the refresh token is invalid, an exception will be thrown.
/// If the user is not authorized to delete the delivery, an exception will be thrown.
///
/// @param id The id of the delivery to be deleted.
/// @return The status code of the request.
Future<int> deleteDelivery(int id) async {
  final token = await SecureStorageManager.read('ACCESS_TOKEN');

  if (token != null) {
    final response = await http.delete(
      Uri.parse('$uriPrefix/deliveries/$id'),
      headers: {
        HttpHeaders.authorizationHeader: token,
      },
    );

    if (response.statusCode == HttpStatus.noContent) {
      return response.statusCode;
    } else if (response.statusCode == HttpStatus.forbidden) {
      throw Exception('You don\'t have permission to delete this delivery');
    } else if (response.statusCode == HttpStatus.unauthorized) {
      final newToken = await fetchNewToken();
      SecureStorageManager.write('ACCESS_TOKEN', newToken);
      final response = await http.delete(
        Uri.parse('$uriPrefix/deliveries/$id'),
        headers: {
          HttpHeaders.authorizationHeader: newToken,
        },
      );
      if (response.statusCode == HttpStatus.noContent) {
        return response.statusCode;
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw Exception('You don\'t have permission to delete this delivery');
      } else {
        throw Exception('Failed to delete delivery');
      }
    } else {
      throw Exception('Failed to delete delivery');
    }
  } else {
    throw Exception('Failed to load token');
  }
}
