
import 'dart:async';
import 'package:flutter/material.dart';

class TimerService with ChangeNotifier {

  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isPaused = true;
  int? _autoStopDuration;

  int get elapsedSeconds => _elapsedSeconds;
  bool get isRunning => !_isPaused;

  int? _currentChallengeId;
  int? get currentChallengeId => _currentChallengeId;

  void startTimer(int challengeId, {int? autoStopAfterSeconds, int elapsedSeconds = 0}) {

    if (!_isPaused) return;

    _isPaused = false;
    _currentChallengeId = challengeId;
    _autoStopDuration = autoStopAfterSeconds;
    _elapsedSeconds = elapsedSeconds;

    _timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPaused == false) {
        _elapsedSeconds++;
        notifyListeners();
      }
      
      if (_autoStopDuration != null && _elapsedSeconds >= _autoStopDuration!) {
        stopTimer();
      }
    });
  }

  void pauseTimer() {
    if (_isPaused) return;
    _isPaused = true;
    _timer?.cancel();
    _timer = null;
  }

  void resumeTimer(int challengeId, {int elapsedSeconds = 0}) {
     if (!_isPaused) return;
     startTimer(challengeId, autoStopAfterSeconds: _autoStopDuration, elapsedSeconds: elapsedSeconds);
  }

  void stopTimer() {
    _isPaused = true;
    _timer?.cancel();
    _timer = null;
    _elapsedSeconds = 0;
    _autoStopDuration = null;
  }
}

