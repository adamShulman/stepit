
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';

// class StepTrackerService {

//   StreamSubscription<StepCount>? _subscription;
//   final _stepController = StreamController<int>.broadcast();
//   int _initialSteps = 0;

//   Stream<int> get stepStream => _stepController.stream;

//   Future<void> startTracking() async {
//     final hasPermission = await _checkPermission();
//     if (!hasPermission) {
//       _stepController.addError('Permission denied for step tracking');
//       return;
//     }

//     _subscription = Pedometer.stepCountStream.listen(
//       (StepCount event) {
//         if (_initialSteps == 0) _initialSteps = event.steps;
//         _stepController.add(event.steps - _initialSteps);
//       },
//       onError: (error) => _stepController.addError('Step tracking error: $error'),
//       cancelOnError: true,
//     );
//   }

//   Future<bool> _checkPermission() async {
//     final status = await Permission.activityRecognition.status;

//     if (status.isGranted) return true;

//     final result = await Permission.activityRecognition.request();
//     return result.isGranted;
//   }

//   bool isPaused() {
//     return _subscription?.isPaused ?? false;
//   }

//   void pauseTracking() {
//     _subscription?.pause();
//   }

//   void continueTracking() {
//     _subscription?.resume();
//   }

//   void stopTracking() {
//     _subscription?.cancel();
//     _subscription = null;
//     _initialSteps = 0;
//   }

//   void dispose() {
//     _stepController.close();
//   }
// }

// class StepTrackerService {
//   // 🔑 Singleton instance
//   static final StepTrackerService _instance = StepTrackerService._internal();

//   factory StepTrackerService() => _instance;

//   StepTrackerService._internal();

//   StreamSubscription<StepCount>? _subscription;
//   final _stepController = StreamController<int>.broadcast();
//   int _initialSteps = 0;
//   bool _isTracking = false;

//   Stream<int> get stepStream => _stepController.stream;

//   /// Checks for activity recognition permission.
//   Future<bool> _checkPermission() async {
//     final status = await Permission.activityRecognition.status;
//     if (status.isGranted) return true;
//     final result = await Permission.activityRecognition.request();
//     return result.isGranted;
//   }

//   /// Starts step tracking after verifying user permissions.
//   Future<void> startTracking() async {
//     if (_isTracking) return; // 🛑 Prevent multiple subscriptions

//     final hasPermission = await _checkPermission();
//     if (!hasPermission) {
//       _stepController.addError('Permission denied for step tracking');
//       return;
//     }

//     _isTracking = true;
//     _subscription = Pedometer.stepCountStream.listen(
//       (StepCount event) {
//         if (_initialSteps == 0) _initialSteps = event.steps;
//         _stepController.add(event.steps - _initialSteps);
//       },
//       onError: (error) => _stepController.addError('Step tracking error: $error'),
//       cancelOnError: true,
//     );
//   }

//   bool isPaused() {
//     return _subscription?.isPaused ?? false;
//   }

//   void pauseTracking() {
//     _subscription?.pause(); 
//   }

//   void continueTracking() {
//     _subscription?.resume();
//   }

//   /// Stops step tracking.
//   void stopTracking() {
//     if (!_isTracking) return;
//     _subscription?.cancel();
//     _subscription = null;
//     _initialSteps = 0;
//     _isTracking = false;
//   }

//   void dispose() {
//     _stepController.close();
//   }
// }



class StepTrackerServiceNotifier with ChangeNotifier {
  
  static final StepTrackerServiceNotifier _instance = StepTrackerServiceNotifier._internal();
  factory StepTrackerServiceNotifier() => _instance;
  StepTrackerServiceNotifier._internal();

  StreamSubscription<StepCount>? _subscription;

  int _initialSteps = 0;
  int _currentSteps = 0;
  bool _isTracking = false;

  int get currentSteps => _currentSteps;
  int get overallSteps => _initialSteps + _currentSteps;

  late Challenge? _currentChallenge;

  Future<bool> _checkPermission() async {
    final status = await Permission.activityRecognition.status;
    if (status.isGranted) return true;
    final result = await Permission.activityRecognition.request();
    return result.isGranted;
  }

  Future<void> startTracking(Challenge challenge, {int initialSteps = 0, int progress = 0}) async {
    if (_isTracking) return;

    final hasPermission = await _checkPermission();
    if (!hasPermission) {
      notifyListeners();
      return;
    }

    _currentChallenge = challenge;

    _isTracking = true;
    _initialSteps = initialSteps;
     _currentSteps = 0;

    _subscription = Pedometer.stepCountStream     
      .skipWhile((StepCount event) => _isTracking == false)
      .listen(
        (StepCount event) {
          if (_initialSteps == 0) _initialSteps = event.steps;
          _currentSteps = event.steps - _initialSteps;
          _currentChallenge?.updateProgress(_currentSteps + progress);
        },
      onError: (error) => notifyListeners(),
      cancelOnError: true,
    );
    
    notifyListeners();
  }


  void setInitialSteps(int steps) {
    _initialSteps = steps;
  }

  void setCurrentSteps(int steps) {
    _currentSteps = steps;
  }

  bool isPaused() {
    return _subscription?.isPaused ?? false;
  }

  void resumeTracking(Challenge challenge, {int initialSteps = 0, int progress = 0}) {
    startTracking(challenge, initialSteps: initialSteps, progress: progress);
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
    _subscription?.cancel();
    _subscription = null;
    _initialSteps = 0;
    _currentSteps = 0;
    _isTracking = false;
    _currentChallenge = null;
    // notifyListeners();
  }

  @override
  void dispose() {
    stopTracking();
    super.dispose();
  }
}

