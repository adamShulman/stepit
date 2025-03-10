
import 'dart:async';
import 'package:flutter/material.dart';

class TimerService with ChangeNotifier {

  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isPaused = true;
  int? _autoStopDuration;

  int get elapsedSeconds => _elapsedSeconds;
  bool get isRunning => !_isPaused;

  int? currentChallengeId;

  void startTimer(int challengeId, {int? autoStopAfterSeconds, bool reset = false}) {

    if (!_isPaused) return;
    if (reset) { _elapsedSeconds = 0; }
    currentChallengeId = challengeId;

    _isPaused = false;
    _autoStopDuration = autoStopAfterSeconds;
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

  void resumeTimer(int challengeId, {int? elapsedSeconds}) {
     if (!_isPaused) return;
     if (elapsedSeconds != null) { _elapsedSeconds = elapsedSeconds; }
     currentChallengeId = challengeId;
    // _isPaused = false;
     startTimer(challengeId, autoStopAfterSeconds: _autoStopDuration);
  }

  void stopTimer() {
    _isPaused = true;
    _timer?.cancel();
    _timer = null;
    _elapsedSeconds = 0;
    _autoStopDuration = null;
  }
}

