
import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationService extends ChangeNotifier {

  Position? _currentPosition;
  bool _isTracking = false;
  Timer? _timer;

  Position? get currentPosition => _currentPosition;
  bool get isTracking => _isTracking;

  Future<bool> _requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    return permission != LocationPermission.deniedForever;
  }

  Future<void> _updateLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition();
      notifyListeners();
    } catch (e) {
      log("Error getting location: $e");
    }
  }

  Future<void> startTracking({Duration interval = const Duration(seconds: 180), bool isFirstTime = true}) async {

    final hasPermission = await _requestPermission();

    if (!hasPermission) {
      return;
    }

    if (_isTracking) return;
    _isTracking = true;

    if (isFirstTime) {
      Future.delayed((const Duration(seconds: 1)), () {
      _updateLocation(); 
    });
    }
    
    _timer = Timer.periodic(interval, (_) => _updateLocation());

  }

  void pauseTracking() {
    stopTracking();
  }

  void resumeTracking({bool isFirstTime = false}) {
    startTracking(isFirstTime: isFirstTime);
  }

  void completeTracking() {
    stopTracking();
  }

  void endTracking() {
    stopTracking();
  }

  void stopTracking() {
    _isTracking = false;
    _timer?.cancel();
  }

  @override
  void dispose() {
    stopTracking();
    super.dispose();
  }
}
