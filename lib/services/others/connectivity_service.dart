// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService extends ChangeNotifier {
  late Connectivity _connectivity;
  late bool _isConnected;
  bool get isConnected => _isConnected;

  ConnectivityService() {
    _isConnected = false; // Default status is disconnected

    _connectivity = Connectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus as void
        Function(List<ConnectivityResult> event)?);
    _checkConnection(); // Check initial connection status
  }

  Future<void> _checkConnection() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    _updateConnectionStatus(connectivityResult as ConnectivityResult);
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
