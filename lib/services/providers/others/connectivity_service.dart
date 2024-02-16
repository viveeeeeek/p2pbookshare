import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider extends ChangeNotifier {
  late Connectivity _connectivity;
  late bool _isConnected;
  bool get isConnected => _isConnected;

  ConnectivityProvider() {
    _isConnected = false; // Default status is disconnected

    _connectivity = Connectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _checkConnection(); // Check initial connection status
  }

  Future<void> _checkConnection() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    bool isConnected = _getStatusFromResult(connectivityResult);

    if (isConnected != _isConnected) {
      _isConnected = isConnected;
      notifyListeners();
    }
  }

  bool _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        return true;
      case ConnectivityResult.none:
      default:
        return false;
    }
  }
}
