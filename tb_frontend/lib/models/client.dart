
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:tb_frontend/data/database.dart';
import 'package:tb_frontend/utils/constants.dart';
import 'package:tb_frontend/utils/exceptionHandler.dart';
import '../utils/refreshToken.dart';
import '../utils/secureStorageManager.dart';

/// This class represents a client model.
///
/// @author Yanik Lange
/// @date 26.07.2023
/// @version 1
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

  /// This method is used to create a client object from a JSON object.
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

  /// This method is used to create a JSON object from a client object.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'addressName': addressName,
        'addressNumber': addressNumber,
        'zipCode': zipCode,
        'city': city,
      };

  /// This method is used to create a map object from a client object. Used at the beginning for the local database.
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

/// This method is used to fetch a client from the backend.
Future<Client> fetchClient(int id) async {
  final token = await SecureStorageManager.read('ACCESS_TOKEN');

  if (token != null) {
    final response =
        await http.get(Uri.parse('$uriPrefix/clients/$id'), headers: {
      HttpHeaders.authorizationHeader: token,
    });
    if (response.statusCode == HttpStatus.ok) {
      return Client.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == HttpStatus.unauthorized) {
      final token = await fetchNewToken();
      SecureStorageManager.write('ACCESS_TOKEN', token);
      final response = await http
          .get(Uri.parse('$uriPrefix/clients/$id'), headers: {
        HttpHeaders.authorizationHeader: token,
      });
      if (response.statusCode == HttpStatus.ok) {
        return Client.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      } else {
        throw Exception('Failed to load client');
      }
    } else {
      throw Exception('Failed to load client');
    }
  } else {
    throw Exception('Failed to load token');
  }
}

/// This method is used to fetch all clients from the backend.
///
/// if the access token is invalid, an exception is thrown.
Future<List<Client>> fetchClients() async {
  final accessToken = await SecureStorageManager.read('ACCESS_TOKEN');
  if (accessToken != null) {
    try {
      return await fetchClientsWithToken(accessToken);
    } catch (exception) {
      ExceptionHandler.handleError(exception);
      return [];
    }
  } else {
    throw Exception('Failed to load JWT');
  }
}

/// This method is used to fetch all clients from the backend with a given access token.
///
/// if the access token is invalid, a new one will be fetched using the refresh token and the request will be repeated.
/// if the refresh token is invalid, an exception will be thrown.
/// if the user is not authorized to fetch the clients, an exception will be thrown.
///
/// @param accessToken The access token to use for the request.
/// @return A list of clients.
Future<List<Client>> fetchClientsWithToken(String accessToken) async {
  final response = await http.get(
    Uri.parse('$uriPrefix/clients'),
    headers: {
      HttpHeaders.authorizationHeader: accessToken,
    },
  ).timeout(const Duration(seconds: 5));
  if (response.statusCode == HttpStatus.ok) {
    final List<dynamic> responseData =
        jsonDecode(utf8.decode(response.bodyBytes));
    return responseData.map((json) => Client.fromJson(json)).toList();
  } else if (response.statusCode == HttpStatus.unauthorized) {
    final token = await fetchNewToken();
    SecureStorageManager.write('ACCESS_TOKEN', token);
    final response =
        await http.get(Uri.parse('$uriPrefix/clients'), headers: {
      HttpHeaders.authorizationHeader: token,
    });
    if (response.statusCode == HttpStatus.ok) {
      final List<dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));
      return responseData.map((json) => Client.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load clients');
    }
  } else {
    throw Exception('Failed to load clients');
  }
}

/// This method is used to create a client on the backend.
///
/// If the access token is invalid, a new one will be fetched using the refresh token and the request will be repeated.
/// If the refresh token is invalid, an exception will be thrown.
/// If the user is not authorized to create a client, an exception will be thrown.
///
/// @param client The client to create.
/// @return The created client.
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
    if (response.statusCode == HttpStatus.created) {
      return Client.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == HttpStatus.forbidden) {
      throw Exception('You don\'t have the permission to create a client');
    } else if (response.statusCode == HttpStatus.unauthorized) {
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
      if (response.statusCode == HttpStatus.created) {
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

/// This method is used to update a client on the backend.
/// If the access token is invalid, a new one will be fetched using the refresh token and the request will be repeated.
/// If the refresh token is invalid, an exception will be thrown.
/// If the user is not authorized to update a client, an exception will be thrown.
///
/// @param client The client to update.
/// @return The updated client.
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
    } else if (response.statusCode == HttpStatus.forbidden) {
      throw Exception('You don\'t have permission to update this client');
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
      } else if (response.statusCode == HttpStatus.forbidden) {
        throw Exception('You don\'t have permission to update this client');
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

/// This method is used to delete a client on the backend.
/// If the access token is invalid, a new one will be fetched using the refresh token and the request will be repeated.
/// If the refresh token is invalid, an exception will be thrown.
/// If the user is not authorized to delete a client, an exception will be thrown.
///
/// @param id The id of the client to delete.
/// @return The response of the request.
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
        throw Exception('You don\'t have the permission to delete this client');
      } else {
        throw Exception('Failed to delete client');
      }
    } else if (response.statusCode == HttpStatus.forbidden) {
      throw Exception('You are not authorized to delete this client');
    } else {
      throw Exception('Failed to delete client');
    }
  } else {
    throw Exception('Failed to load token');
  }
}

/// This method is used to fetch all clients from the local database.
///
/// @return A list of clients.
Future<List<Client>> fetchClientsLocally() async {
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


/// This method is used to create a client on the local database.
///
/// @param client The client to create.
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

/// This method is used to update a client on the local database.
///
/// @param client The client to update.
Future<void> updateClientLocally(Client client) async {
  final db = await DBHelper.database;

  await db.update(
    'Client',
    client.toMap(),
    where: "id = ?",
    whereArgs: [client.id],
  );
}

/// This method is used to delete a client on the local database.
///
/// @param id The id of the client to delete.
Future<void> deleteClientLocally(int id) async {
  final db = await DBHelper.database;

  await db.delete(
    'Client',
    where: "id = ?",
    whereArgs: [id],
  );
}