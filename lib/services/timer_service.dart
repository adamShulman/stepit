
import 'dart:async';
import 'package:flutter/material.dart';

class TimerService {

  TimerService({required this.onTimerUpdate});

  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isPaused = true;
  int? _autoStopDuration;
  Function(int) onTimerUpdate;

  int get elapsedSeconds => _elapsedSeconds;
  bool get isRunning => !_isPaused;

  void startTimer({int? autoStopAfterSeconds, bool reset = false}) {
    if (!_isPaused) return;
    if (reset) { _elapsedSeconds = 0; }
    _isPaused = false;
    _autoStopDuration = autoStopAfterSeconds;
    _timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPaused == false) {
        _elapsedSeconds++;
        onTimerUpdate(_elapsedSeconds);
      }
      
      if (_autoStopDuration != null && _elapsedSeconds >= _autoStopDuration!) {
        stopTimer();
      }
    });
  }

  void pauseTimer() {
    // if (_isPaused) return;
    _isPaused = true;
    //  _timer?.cancel();
    // _timer = null;
  }

  void resumeTimer() {
    // if (!_isPaused) return;
    _isPaused = false;
    // startTimer(autoStopAfterSeconds: _autoStopDuration);
  }

  void stopTimer() {
    _isPaused = true;
    _timer?.cancel();
    _timer = null;
    _elapsedSeconds = 0;
    _autoStopDuration = null;
  }
}

