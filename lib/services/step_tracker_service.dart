
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

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
  bool get isTracking => _isTracking;

  Future<bool> _checkPermission() async {
    final status = await Permission.activityRecognition.status;
    if (status.isGranted) return true;
    final result = await Permission.activityRecognition.request();
    return result.isGranted;
  }

  Future<void> startTracking() async {
    if (_isTracking) return;

    final hasPermission = await _checkPermission();
    if (!hasPermission) {
      notifyListeners();
      return;
    }

    _isTracking = true;
    _subscription = Pedometer.stepCountStream.listen(
      (StepCount event) {
        if (_initialSteps == 0) _initialSteps = event.steps;
        _currentSteps = event.steps - _initialSteps;
        notifyListeners(); // 🔥 UI updates automatically
      },
      onError: (error) => notifyListeners(),
      cancelOnError: true,
    );
    notifyListeners();
  }

  bool isPaused() {
    return _subscription?.isPaused ?? false;
  }

  void pauseTracking() {
    _subscription?.pause(); 
    notifyListeners();
  }

  void resumeTracking() {
    _subscription?.resume();
    notifyListeners();
  }

  void endTracking() {
    _stopTracking();
  }

  void completeTracking() {
    _stopTracking();
  }

  void _stopTracking() {
    if (!_isTracking) return;
    _subscription?.cancel();
    _subscription = null;
    _initialSteps = 0;
    _currentSteps = 0;
    _isTracking = false;
    notifyListeners();
  }
}