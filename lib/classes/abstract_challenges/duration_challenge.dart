

import 'package:flutter/material.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';

class DurationChallenge extends Challenge with ChangeNotifier {
  
  final int targetSteps;
  final int targetDuration;
  int progress = 0;
  
  DurationChallenge({
    required super.id,
    required super.name,
    required super.description,
    required super.level,
    required super.challengeType,
    required this.targetSteps,
    required this.targetDuration,
    super.startTime,
    super.endTime,
    super.challengeStatus
  });

  factory DurationChallenge.fromJson(Map<String, dynamic> json) {
    return DurationChallenge(
      id: json['identifier'],
      name: json['title'],
      description: json['description'],
      level: json['level'],
      challengeType: ChallengeType.fromValue(json['type']),
      challengeStatus: json['status'] != null ? ChallengeStatus.fromString(json['status']) : ChallengeStatus.inactive,
      targetSteps: json['target_steps'] ?? 0,
      targetDuration: json['target_duration'] ?? 0,
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
      'target_steps': targetSteps,
      'target_duration': targetDuration,
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
    return progress >= targetSteps;
  }

  @override
  void updateChallengeLocation(double lat, double lng) {
    super.updateChallengeLocation(lat, lng);
    notifyListeners();
  }
}