import 'dart:io';

import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// It's a wrapper around the InternetConnectionChecker class that exposes a single method called
/// isConnected

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker _connectionChecker;

  NetworkInfoImpl(this._connectionChecker);

  @override
  Future<bool> get isConnected =>

      // checkConnection();

      _connectionChecker.hasConnection;

  Future<bool> checkConnection() async {
    bool previousConnection = false;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        previousConnection = true;
      } else {
        previousConnection = false;
      }
    } on SocketException catch (_) {
      previousConnection = false;
    }

    return previousConnection;
  }
}
