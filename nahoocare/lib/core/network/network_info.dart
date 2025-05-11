import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    try {
      final result = await connectivity.checkConnectivity();
      if (result == ConnectivityResult.none) {
        return false;
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('NetworkInfo Error: $e');
      }
      return false;
    }
  }
}
