
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../dto/dishForDeliveryDTO.dart';
import '../utils/SecureStorageManager.dart';
import 'dish.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tb_frontend/utils/Constants.dart';


final formatter = DateFormat('dd/MM/yyyy');

class Delivery {
  int id;
  String username;
  String clientName;
  DateTime deliveryDate;
  String? details;
  List<DishForDeliveryDTO>? dishes;

  Delivery(this.id, this.username, this.clientName, this.deliveryDate, this.details, this.dishes);

  get formattedDate {
    return '${deliveryDate.day}/${deliveryDate.month}/${deliveryDate.year}';
  }

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      json['id'],
      json['userName'],
      json['clientName'],
      //DateTime.parse((json['deliveryDate'].toString().replaceAll('/', '-'))),
      DateTime.parse(json['deliveryDate']),
      json['details'],
      json['dishes'] != null ? (json['dishes'] as List).map((i) => DishForDeliveryDTO.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userName': username,
    'clientName': clientName,
    'deliveryDate': deliveryDate.toIso8601String(),
    'details': details ?? '',
    'dishes': dishes != null ? dishes!.map((e) => e.toJson()).toList() : null, //will add ingredients of dishes too.
  };

}

Future<List<Delivery>> fetchDeliveries() async {
  final token = await SecureStorageManager.read('KEY_TOKEN');

  if(token != null) {
    try {
      final response = await http
          .get(Uri.parse('http://$ipAddress/deliveries'),
          headers: {
            HttpHeaders.authorizationHeader: token,
          });

      if (response.statusCode == 200) {
        // If the server returned a 200 OK response, parse the JSON.
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((json) => Delivery.fromJson(json)).toList();
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load deliveries');
        return [];
      }
    } on SocketException {
      log('=================================> ERROR: No connection');
      throw Exception('Failed to load deliveries cause no connection');
    } on TimeoutException {
      log('=================================> ERROR: Timeout');
      throw Exception('Failed to load deliveries cause timeout');
    } catch (e) {
      //quand le token n'est plus valide on arrive dans cette erreur.
      log('=================================> ERROR: $e');
      throw Exception('Failed to load deliveries cause unknown error');
    }
  } else {
    throw Exception('Failed to load JWT');
  }
}

Future<Delivery> fetchDelivery(int id) async {
  final token = await SecureStorageManager.read('KEY_TOKEN');

  if(token != null) {
    final response = await http.get(
        Uri.parse('http://$ipAddress/deliveries/$id'),
        headers: {
          HttpHeaders
              .authorizationHeader: token,
        });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return Delivery.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load delivery');
    }
  } else {
    throw Exception('Failed to load token');
  }
}

Future<Delivery> createDelivery(Delivery delivery) async {
  final token = await SecureStorageManager.read('KEY_TOKEN');

  if(token != null) {
    final response = await http.post(
      Uri.parse('http://$ipAddress/deliveries'),
      headers: {
        HttpHeaders.authorizationHeader: token,
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(delivery.toJson()),
    );

    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response, then parse the JSON.
      return Delivery.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response, then throw an exception.
      throw Exception('Failed to create delivery');
    }
  } else {
    throw Exception('Failed to load token');
  }
}

Future<Delivery> updateDelivery(Delivery delivery) async {
  final token = await SecureStorageManager.read('KEY_TOKEN');

  if(token != null) {
    final response = await http.put(
      Uri.parse('http://$ipAddress/deliveries/${delivery.id}'),
      headers: {
        HttpHeaders.authorizationHeader: token,
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(delivery.toJson()),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return Delivery.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to update delivery');
    }
  } else {
    throw Exception('Failed to load token');
  }
}

Future<void> deleteDelivery(int id) async {
  final token = await SecureStorageManager.read('KEY_TOKEN');

  if(token != null) {
    final response = await http.delete(
      Uri.parse('http://$ipAddress/deliveries/$id'),
      headers: {
        HttpHeaders.authorizationHeader: token,
      },
    );

    if (response.statusCode == 204) {
      // If the server did return a 204 NO CONTENT response, then parse the JSON.
      return;
    } else {
      // If the server did not return a 204 NO CONTENT response, then throw an exception.
      throw Exception('Failed to delete delivery');
    }
  } else {
    throw Exception('Failed to load token');
  }
}