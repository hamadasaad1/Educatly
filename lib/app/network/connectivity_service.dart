import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  late StreamController<bool> _connectivityController;
  bool hasInternet = false;

  ConnectivityService() {
    _connectivityController = StreamController<bool>.broadcast();
    _startListening();
  }

  Stream<bool> get connectivityStream => _connectivityController.stream;

  void _startListening() {
    _connectivity.onConnectivityChanged
        .listen((ConnectivityResult result) async {
      hasInternet = await _checkInternetAccess();
      _connectivityController.add(hasInternet &&
          (result == ConnectivityResult.mobile ||
              result == ConnectivityResult.wifi));
    });
  }

  Future<bool> _checkInternetAccess() async {
    bool previousConnection = false;

    try {
      await Future.delayed(const Duration(seconds: 1));
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

  void dispose() {
    _connectivityController.close();
  }
}
