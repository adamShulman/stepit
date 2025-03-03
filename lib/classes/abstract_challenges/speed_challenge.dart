

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';
import 'package:stepit/services/step_tracker_service.dart';

class SpeedChallenge extends Challenge with ChangeNotifier {
  
  final int? targetSpeed;
  final int targetTime;

  int progress = 0;
  int elapsedSeconds = 0;

  ChallengePedestrianStatus challengePedestrianStatus = ChallengePedestrianStatus.unknown;

  SpeedChallenge({
    required super.id,
    required super.name,
    required super.description,
    required super.level,
    required super.challengeType,
    this.targetSpeed,
    required this.targetTime,
    super.startTime,
    super.endTime,
    super.challengeStatus
  });
        

  factory SpeedChallenge.fromJson(Map<String, dynamic> json) {
    return SpeedChallenge(
      id: json['identifier'],
      name: json['title'],
      description: json['description'],
      level: json['level'] ?? 1,
      challengeType: ChallengeType.fromValue(json['type']),
      challengeStatus: json['status'] != null ? ChallengeStatus.fromString(json['status']) : ChallengeStatus.inactive,
      targetTime: json['target_time'] ?? 0,
      startTime: json['start_time']?.toDate(),
      endTime: json['end_time']?.toDate(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'identifier': id,
      'title': name,
      'type': challengeType.value,
      'description': description,
      'completed': isCompleted(),
      'start_time': startTime,
      'end_time': endTime,
      'steps': progress,
      'target_time': targetTime,
      'status': challengeStatus.description,
    };
  }

  @override
  void start() {
    super.start();
    notifyListeners();
    super.updateFirebase(toJson());
  }

  @override
  void resume() {
    super.resume();
    notifyListeners();
    super.updateFirebase(toJson());
  }

  @override 
  void pause() {
    super.pause();
    notifyListeners();
    super.updateFirebase(toJson());
  }

  @override 
  void end() {
    super.end();
    notifyListeners();
    super.updateFirebase(toJson());
  }

  @override 
  void complete() {
    super.complete();
    notifyListeners();
    super.updateFirebase(toJson());
  }

  @override
  bool isCompleted() {
    return progress >= 100;
  }

  void setPedestrianStatus(ChallengePedestrianStatus pedestrianStatus) {
    challengePedestrianStatus = pedestrianStatus;
    notifyListeners();
  }

  @override
  void updateChallengeLocation(double lat, double lng) {
    super.updateChallengeLocation(lat, lng);
    notifyListeners();
  }
}