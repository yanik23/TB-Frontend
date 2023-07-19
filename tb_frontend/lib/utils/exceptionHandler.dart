


import 'dart:async';
import 'dart:developer';
import 'dart:io';

class ExceptionHandler {
  static void handleFetchClientsError(error) {
    if (error is SocketException) {
      log('=================================> ERROR: No connection');
      throw Exception('Failed to load clients cause no connection');
    } else if (error is TimeoutException) {
      log('=================================> ERROR: Timeout');
      throw Exception('Failed to load clients cause timeout');
    } else if (error is FormatException) {
      log('=================================> ERROR: Format');
      throw Exception('Failed to load clients cause format');
    } else {
      //quand le token n'est plus valide on arrive dans cette erreur.
      log('=================================> ERROR: $error');
      throw Exception('Failed to load clients cause unknown error');
    }
  }
}