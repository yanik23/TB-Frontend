import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:tb_frontend/data/database.dart';
import 'package:tb_frontend/utils/Constants.dart';

import '../utils/SecureStorageManager.dart';



class Client {
  final int id;
  String? status;
  int? remoteId;
  final String name;
  final String addressName;
  final int addressNumber;
  final int zipCode;
  final String city;

  Client(this.id, this.name, this.addressName, this.addressNumber,
      this.zipCode, this.city, {this.status, this.remoteId});

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

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'addressName': addressName,
    'addressNumber': addressNumber,
    'zipCode': zipCode,
    'city': city,
  };

  Map<String, dynamic> toMap() => {
    'id': id,
    'status' : status,
    'remoteId' : remoteId,
    'name': name,
    'addressName': addressName,
    'addressNumber': addressNumber,
    'zipCode': zipCode,
    'city': city,
  };
}

Future<Client> fetchClient(int id) async {
  final token = await SecureStorageManager.read('KEY_TOKEN');

  if(token != null) {
    final response = await http.get(
        Uri.parse('http://$ipAddress/clients/$id'),
        headers: {
          HttpHeaders
              .authorizationHeader: token,
        });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return Client.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load client');
    }
  } else {
    throw Exception('Failed to load token');
  }
}

Future<List<Client>> fetchClients() async {
  final token = await SecureStorageManager.read('KEY_TOKEN');

  if(token != null) {
    try {
      final response = await http
          .get(Uri.parse('http://$ipAddress/clients'),
          headers: {
            HttpHeaders.authorizationHeader: token,
          });

      if (response.statusCode == 200) {
        // If the server returned a 200 OK response, parse the JSON.
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((json) => Client.fromJson(json)).toList();
      } else {
        // If the server did not return a 200 OK response, throw an exception.
        throw Exception('Failed to load clients');
        return [];
      }
    } on SocketException {
      log('=================================> ERROR: No connection');
      throw Exception('Failed to load clients cause no connection');
    } on TimeoutException {
      log('=================================> ERROR: Timeout');
      throw Exception('Failed to load clients cause timeout');
    } catch (e) {
      //quand le token n'est plus valide on arrive dans cette erreur.
      log('=================================> ERROR: $e');
      throw Exception('Failed to load clients cause unknown error');
    }
  } else {
    throw Exception('Failed to load JWT');
  }
}

Future<Client> createClient(Client client) async {
  final token = await SecureStorageManager.read('KEY_TOKEN');

  if(token != null) {
    final response = await http.post(
      Uri.parse('http://$ipAddress/clients'),
      headers: {
        HttpHeaders.authorizationHeader: token,
        HttpHeaders.contentTypeHeader: 'application/json'
      },
      body: jsonEncode(<String, dynamic>{
        'name': client.name,
        'addressName': client.addressName,
        'addressNumber': client.addressNumber,
        'zipCode': client.zipCode,
        'city': client.city,
      }),
    );
    if (response.statusCode == 201) {
      return Client.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 403) {
      throw Exception('You are not authorized to create a client');
    } else {
      throw Exception('Failed to create client');
    }
  } else {
    log('Failed to load token');
    throw Exception('Failed to load token');
  }
}

Future<Client> updateClient(Client client) async {
  final token = await SecureStorageManager.read('KEY_TOKEN');

  if(token != null) {
    final response = await http.put(
      Uri.parse('http://$ipAddress/clients/${client.id}'),
      headers: {
        HttpHeaders.authorizationHeader: token,
        HttpHeaders.contentTypeHeader: 'application/json'
      },
      body: jsonEncode(<String, dynamic>{
        'name': client.name,
        'addressName': client.addressName,
        'addressNumber': client.addressNumber,
        'zipCode': client.zipCode,
        'city': client.city,
      }),
    );
    if (response.statusCode == 200) {
      return Client.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 403) {
      throw Exception('You are not authorized to update a client');
    } else {
      throw Exception('Failed to update client');
    }
  } else {
    throw Exception('Failed to load token');
  }
}

Future<http.Response> deleteClient(int id) async {
  final token = await SecureStorageManager.read('KEY_TOKEN');

  if(token != null) {
    final response = await http.delete(
      Uri.parse('http://$ipAddress/clients/$id'),
      headers: {
        HttpHeaders.authorizationHeader: token,
      },
    );

    if (response.statusCode == 204) {
      return response;
    } else {
      throw Exception('Failed to delete client');
    }
  } else {
    throw Exception('Failed to load token');
  }
}


Future<void> insertClient(Client client) async {
  // Get a reference to the database.
  final Database db = await DBHelper.database;

  // Insert the Client into the correct table. Also specify the
  // `conflictAlgorithm`. In this case, if the same client is inserted
  // multiple times, it replaces the previous data.
  await db.insert(
  'Client',
  client.toMap(),
  conflictAlgorithm: ConflictAlgorithm.replace,
  );
}