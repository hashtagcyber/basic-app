import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:basic_app/services/auth_service.dart';

class ConnectivityService with ChangeNotifier {
  bool _isOffline = false;
  final AuthService _authService;

  ConnectivityService(this._authService) {
    Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  bool get isOffline => _isOffline;

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    final isOffline = result == ConnectivityResult.none;
    if (_isOffline && !isOffline) {
      // Device just came online, sync changes
      await _authService.syncOfflineChanges();
    }
    _isOffline = isOffline;
    notifyListeners();
  }
}