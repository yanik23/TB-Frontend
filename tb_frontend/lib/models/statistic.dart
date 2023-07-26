
import 'package:tb_frontend/utils/refreshToken.dart';

import '../utils/constants.dart';
import '../utils/secureStorageManager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';


/// This class is used to represent the average delivered per dish type.
///
/// @author Yanik Lange
/// @date 26.07.2023
/// @version 1
class AvgDeliveredPerType {

  /// The type of the dish.
  String currentType;

  /// The average quantity of the delivered dishes.
  double avgDelivered;

  AvgDeliveredPerType(this.currentType, this.avgDelivered);

  /// This function is used to create an average delivered per dish type from a json.
  factory AvgDeliveredPerType.fromJson(Map<String, dynamic> json) {

    return AvgDeliveredPerType(
      json['currentType'],
      json['quantityDelivered'] is int ? json['quantityDelivered'].toDouble() : json['quantityDelivered'],
    );
  }
}

/// This class is used to represent the quantity delivered per dish size.
///
/// @author Yanik Lange
/// @date 26.07.2023
/// @version 1
class QuantityDeliveredPerSize {
  // The size of the dish.
  String currentSize;
  // The quantity of the delivered dishes.
  double quantityDelivered;

  QuantityDeliveredPerSize(this.currentSize, this.quantityDelivered);

  /// This function is used to create a quantity delivered per dish size from a json.
  factory QuantityDeliveredPerSize.fromJson(Map<String, dynamic> json) {

    return QuantityDeliveredPerSize(
      json['currentSize'],
      json['quantityDelivered'] is int ? json['quantityDelivered'].toDouble() : json['quantityDelivered'],
    );
  }
}

/// This function is used to fetch the total delivered dishes per type.
///
/// If the access token is invalid, a new one will be fetched and the request will be repeated.
/// If the refresh token is invalid, an exception will be thrown.
/// If the user is not allowed to fetch the statistics, an exception will be thrown.
///
/// @return A list of the total delivered dishes per type.
Future<List<AvgDeliveredPerType>> fetchTotalDeliveriesPerType() async {
  final token = await SecureStorageManager.read('ACCESS_TOKEN');

  if (token != null) {
    final response = await http.get(
      Uri.parse('$uriPrefix/statistics/total-quantities-delivered-per-type'),
      headers: {
        HttpHeaders.authorizationHeader: token,
      });
    if (response.statusCode == HttpStatus.ok) {
      final List<dynamic> responseData = jsonDecode(
          utf8.decode(response.bodyBytes));
      return responseData.map((json) => AvgDeliveredPerType.fromJson(json))
          .toList();
      // return AvgDeliveredPerType.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == HttpStatus.unauthorized) {
      final newToken = await fetchNewToken();
      SecureStorageManager.write('ACCESS_TOKEN', newToken);
      final response = await http.get(
        Uri.parse('$uriPrefix/statistics/total-quantities-delivered-per-type'),
        headers: {
          HttpHeaders.authorizationHeader: newToken,
        },
      );
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));
        return responseData.map((json) => AvgDeliveredPerType.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load avgDeliveredPerType');
      }
    } else {
      throw Exception('Failed to load avgDeliveredPerType');
    }
  } else {
    throw Exception('Failed to load Token');
  }
}


/// This function is used to fetch the average delivered dishes per size.
///
/// If the access token is invalid, a new one will be fetched and the request will be repeated.
/// If the refresh token is invalid, an exception will be thrown.
/// If the user is not allowed to fetch the statistics, an exception will be thrown.
///
/// @return A list of the average delivered dishes per size.
Future<List<AvgDeliveredPerType>> fetchAvgDeliveriesPerType() async {
  final token = await SecureStorageManager.read('ACCESS_TOKEN');

  if (token == null) {
    throw Exception('No token');
  }
  final response = await http.get(
    Uri.parse('$uriPrefix/statistics/average-quantities-delivered-per-type'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: token,
    },
  );
  if (response.statusCode == 200) {
    final List<dynamic> responseData = jsonDecode(response.body);
    return responseData.map((json) => AvgDeliveredPerType.fromJson(json)).toList();
   // return AvgDeliveredPerType.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load avgDeliveredPerType');
  }
}

/// This function is used to fetch the total delivered dishes per size.
///
/// If the access token is invalid, a new one will be fetched and the request will be repeated.
/// If the refresh token is invalid, an exception will be thrown.
/// If the user is not allowed to fetch the statistics, an exception will be thrown.
///
/// @return A list of the total delivered dishes per size.
Future<List<QuantityDeliveredPerSize>> fetchQuantitiesDeliveredPerSize() async {
  final token = await SecureStorageManager.read('ACCESS_TOKEN');

  if (token == null) {
    throw Exception('No token');
  }
  final response = await http.get(
    Uri.parse('$uriPrefix/statistics/total-quantities-delivered-per-size'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: token,
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    final List<dynamic> responseData = jsonDecode(response.body);
    return responseData.map((json) => QuantityDeliveredPerSize.fromJson(json)).toList();
    // return AvgDeliveredPerType.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load avgDeliveredPerType');
  }
}

