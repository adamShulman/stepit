

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';
import 'package:stepit/classes/abstract_challenges/challenge_enums/challenge_pedestrian_status.dart';

class PedestrianTrackerServiceNotifier with ChangeNotifier {
  
  static final PedestrianTrackerServiceNotifier _instance = PedestrianTrackerServiceNotifier._internal();
  factory PedestrianTrackerServiceNotifier() => _instance;
  PedestrianTrackerServiceNotifier._internal();

  StreamSubscription<PedestrianStatus>? _pedestrianStatusSubscription;

  bool _isTracking = false;
  bool get isTracking => _isTracking;

  ChallengePedestrianStatus _pedestrianStatus = ChallengePedestrianStatus.unknown;
  ChallengePedestrianStatus get challengePedestrianStatus => _pedestrianStatus;

  late Challenge? _currentChallenge;

  Future<bool> _checkPermission() async {
    final status = await Permission.activityRecognition.status;
    if (status.isGranted) return true;
    final result = await Permission.activityRecognition.request();
    return result.isGranted;
  }

  Future<void> startTracking(Challenge challenge) async {
    if (_isTracking) return;

    final hasPermission = await _checkPermission();
    if (!hasPermission) {
      notifyListeners();
      return;
    }

    _currentChallenge = challenge;
    _isTracking = true;

    _pedestrianStatusSubscription = Pedometer.pedestrianStatusStream.listen(
      (PedestrianStatus event) {
        _pedestrianStatus = ChallengePedestrianStatus.fromString(event.status);
        _currentChallenge?.updatePedestrianStatus(_pedestrianStatus);
        // _currentChallenge.challengeStatusNotifier.value = _pedestrianStatus;
        // notifyListeners(); 
      }
    );
    
    notifyListeners();
  }

  bool isPaused() {
    return _pedestrianStatusSubscription?.isPaused ?? false;
  }

  void resumeTracking(Challenge challenge) {
    startTracking(challenge);
  }

  void pauseTracking() {
    stopTracking();
  }

  void endTracking() {
    stopTracking();
  }

  void completeTracking() {
    stopTracking();
  }

  void stopTracking() {
    _pedestrianStatusSubscription?.cancel();
    _pedestrianStatusSubscription = null;
    _isTracking = false;
    _currentChallenge = null;
  }

  @override
  void dispose() {
    stopTracking();
    super.dispose();
  }
}

