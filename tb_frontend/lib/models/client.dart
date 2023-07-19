import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:tb_frontend/data/database.dart';
import 'package:tb_frontend/utils/constants.dart';
import 'package:tb_frontend/utils/exceptionHandler.dart';

import '../utils/refreshToken.dart';
import '../utils/secureStorageManager.dart';

class Client {
  final int id;
  String? status;
  int? remoteId;
  final String name;
  final String addressName;
  final int addressNumber;
  final int zipCode;
  final String city;

  Client(this.id, this.name, this.addressName, this.addressNumber, this.zipCode,
      this.city,
      {this.status, this.remoteId});

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
        'status': status,
        'remoteId': remoteId,
        'name': name,
        'addressName': addressName,
        'addressNumber': addressNumber,
        'zipCode': zipCode,
        'city': city,
      };
}

Future<Client> fetchClient(int id) async {
  final token = await SecureStorageManager.read('ACCESS_TOKEN');

  if (token != null) {
    final response =
        await http.get(Uri.parse('$uriPrefix/clients/$id'), headers: {
      HttpHeaders.authorizationHeader: token,
    });
    if (response.statusCode == HttpStatus.ok) {
      // If the server did return a 200 OK response, then parse the JSON.
      return Client.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == HttpStatus.unauthorized) {
      final token = await fetchNewToken();
      SecureStorageManager.write('ACCESS_TOKEN', token);
      final response = await http
          .get(Uri.parse('$uriPrefix/clients/$id'), headers: {
        HttpHeaders.authorizationHeader: token,
      });
      if (response.statusCode == HttpStatus.ok) {
        // If the server did return a 200 OK response, then parse the JSON.
        return Client.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        // If the server did not return a 200 OK response, then throw an exception.
        throw Exception('Failed to load client');
      }
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load client');
    }
  } else {
    throw Exception('Failed to load token');
  }
}

Future<List<Client>> fetchClients() async {
  final accessToken = await SecureStorageManager.read('ACCESS_TOKEN');
  if (accessToken != null) {
    try {
      return await _fetchClientsWithToken(accessToken);
    } catch (exception) {
      ExceptionHandler.handleFetchClientsError(exception);
      return [];
    }
  } else {
    throw Exception('Failed to load JWT');
  }
}

Future<List<Client>> _fetchClientsWithToken(String accessToken) async {
  final response = await http.get(
    Uri.parse('$uriPrefix/clients'),
    headers: {
      HttpHeaders.authorizationHeader: accessToken,
    },
  ).timeout(const Duration(seconds: 5));
  if (response.statusCode == 200) {
    final List<dynamic> responseData =
        jsonDecode(utf8.decode(response.bodyBytes));
    return responseData.map((json) => Client.fromJson(json)).toList();
  } else if (response.statusCode == 401) {
    final token = await fetchNewToken();
    SecureStorageManager.write('ACCESS_TOKEN', token);
    final response =
        await http.get(Uri.parse('$uriPrefix/clients'), headers: {
      HttpHeaders.authorizationHeader: token,
    });
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));
      return responseData.map((json) => Client.fromJson(json)).toList();
    } else {
      throw Exception('A) Failed to load clients');
    }
  } else {
    throw Exception('B) Failed to load clients');
  }
}

Future<Client> createClient(Client client) async {
  final token = await SecureStorageManager.read('ACCESS_TOKEN');

  if (token != null) {
    final response = await http.post(
      Uri.parse('$uriPrefix/clients'),
      headers: {
        HttpHeaders.authorizationHeader: token,
        HttpHeaders.contentTypeHeader: 'application/json'
      },
      body: jsonEncode(client.toJson()),
    );
    if (response.statusCode == 201) {
      return Client.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == HttpStatus.forbidden) {
      throw Exception('You don\'t have the permission to create a client');
    } else if (response.statusCode == 401) {
      final token = await fetchNewToken();
      SecureStorageManager.write('ACCESS_TOKEN', token);
      final response = await http.post(
        Uri.parse('$uriPrefix/clients'),
        headers: {
          HttpHeaders.authorizationHeader: token,
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: jsonEncode(client.toJson()),
      );
      if (response.statusCode == 201) {
        return Client.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else if (response.statusCode == HttpStatus.forbidden){
        throw Exception('You don\'t have the permission to create a client');
      } else {
        throw Exception('Failed to create client');
      }
    } else {
      throw Exception('Failed to create client');
    }
  } else {
    log('Failed to load token');
    throw Exception('Failed to load token');
  }
}

Future<Client> updateClient(Client client) async {
  final token = await SecureStorageManager.read('ACCESS_TOKEN');

  if (token != null) {
    final response = await http.put(
      Uri.parse('$uriPrefix/clients/${client.id}'),
      headers: {
        HttpHeaders.authorizationHeader: token,
        HttpHeaders.contentTypeHeader: 'application/json'
      },
      body: jsonEncode(client.toJson()),
    );
    if (response.statusCode == HttpStatus.ok) {
      return Client.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == HttpStatus.unauthorized) {
      final token = await fetchNewToken();
      SecureStorageManager.write('ACCESS_TOKEN', token);
      final response = await http.put(
        Uri.parse('$uriPrefix/clients/${client.id}'),
        headers: {
          HttpHeaders.authorizationHeader: token,
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: jsonEncode(client.toJson()),
      );
      if (response.statusCode == HttpStatus.ok) {
        return Client.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception('Failed to update client');
      }
    } else {
      throw Exception('Failed to update client');
    }
  } else {
    throw Exception('Failed to load token');
  }
}

Future<http.Response> deleteClient(int id) async {
  final token = await SecureStorageManager.read('ACCESS_TOKEN');

  if (token != null) {
    final response = await http.delete(
      Uri.parse('$uriPrefix/clients/$id'),
      headers: {
        HttpHeaders.authorizationHeader: token,
      },
    );
    if (response.statusCode == HttpStatus.noContent) {
      return response;
    } else if (response.statusCode == HttpStatus.unauthorized) {
      final token = await fetchNewToken();
      SecureStorageManager.write('ACCESS_TOKEN', token);
      final response = await http.delete(
        Uri.parse('$uriPrefix/clients/$id'),
        headers: {
          HttpHeaders.authorizationHeader: token,
        },
      );
      if (response.statusCode == HttpStatus.noContent) {
        return response;
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw Exception('A) You are not authorized to delete this client');
      } else {
        throw Exception('Failed to delete client');
      }
    } else if (response.statusCode == HttpStatus.forbidden) {
      throw Exception('B) You are not authorized to delete this client');
    } else {
      throw Exception('Failed to delete client');
    }
  } else {
    throw Exception('Failed to load token');
  }
}


Future<List<Client>> fetchClientsLocally() async {
  log('=================================> fetchClientsLocally');
  // Get a reference to the database.
  final Database db = await DBHelper.database;

  // Query the table for all The Clients.
  final List<Map<String, dynamic>> maps = await db.query('Client');

  // Convert the List<Map<String, dynamic> into a List<Client>.
  return List.generate(maps.length, (i) {
    return Client(
      maps[i]['id'],
      maps[i]['name'],
      maps[i]['addressName'],
      maps[i]['addressNumber'],
      maps[i]['zipCode'],
      maps[i]['city'],
      status: maps[i]['status'],
      remoteId: maps[i]['remoteId'],
    );
  });
}

Future<void> createClientLocally(Client client) async {
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

Future<void> updateClientLocally(Client client) async {
  final db = await DBHelper.database;

  await db.update(
    'Client',
    client.toMap(),
    where: "id = ?",
    whereArgs: [client.id],
  );
}

Future<void> deleteClientLocally(int id) async {
  final db = await DBHelper.database;

  await db.delete(
    'Client',
    where: "id = ?",
    whereArgs: [id],
  );
}