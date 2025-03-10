
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';

class LocationService extends ChangeNotifier {

  Position? _currentPosition;
  bool _isTracking = false;
  Timer? _timer;
  Challenge? currentChallenge;

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
      
      // Call challenge model's Firestore method
      currentChallenge?.updateChallengeLocation(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
      
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }

  Future<void> startTracking({Duration interval = const Duration(seconds: 60)}) async {

    final hasPermission = await _requestPermission();

    if (!hasPermission) {
      return;
    }

    if (_isTracking) return;
    _isTracking = true;
    _updateLocation(); 
    _timer = Timer.periodic(interval, (_) => _updateLocation());
    notifyListeners();

  }

  void stopTracking() {
    _isTracking = false;
    _timer?.cancel();
    // notifyListeners();
  }

  @override
  void dispose() {
    stopTracking();
    super.dispose();
  }
}
