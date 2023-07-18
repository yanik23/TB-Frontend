





import '../utils/constants.dart';
import '../utils/secureStorageManager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';

class AvgDeliveredPerType {
  String currentType;
  double avgDelivered;

  AvgDeliveredPerType(this.currentType, this.avgDelivered);

  factory AvgDeliveredPerType.fromJson(Map<String, dynamic> json) {
    //dynamic quantityDelivered = json['quantityDelivered'];

    return AvgDeliveredPerType(
      json['currentType'],
      json['quantityDelivered'] is int ? json['quantityDelivered'].toDouble() : json['quantityDelivered'],
    );
  }
}
class QuantityDeliveredPerSize {
  String currentSize;
  double quantityDelivered;

  QuantityDeliveredPerSize(this.currentSize, this.quantityDelivered);

  factory QuantityDeliveredPerSize.fromJson(Map<String, dynamic> json) {
    //dynamic quantityDelivered = json['quantityDelivered'];

    return QuantityDeliveredPerSize(
      json['currentSize'],
      json['quantityDelivered'] is int ? json['quantityDelivered'].toDouble() : json['quantityDelivered'],
    );
  }
}

Future<List<AvgDeliveredPerType>> fetchTotalDeliveriesPerType() async {
  final token = await SecureStorageManager.read('ACCESS_TOKEN');

  if (token == null) {
    throw Exception('No token');
  }
  final response = await http.get(
    Uri.parse('$uriPrefix/statistics/total-quantities-delivered-per-type'),
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
  if (response.statusCode == 200) {
    final List<dynamic> responseData = jsonDecode(response.body);
    return responseData.map((json) => QuantityDeliveredPerSize.fromJson(json)).toList();
    // return AvgDeliveredPerType.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load avgDeliveredPerType');
  }
}

