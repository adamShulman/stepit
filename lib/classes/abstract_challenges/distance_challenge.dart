
import 'package:flutter/material.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';

class DistanceChallenge extends Challenge with ChangeNotifier {

  int progress = 0;
  final double targetDistance;
  
  DistanceChallenge({
    required super.id,
    required super.name,
    required super.description,
    required super.level,
    required super.challengeType,
    required this.targetDistance,
    super.startTime,
    super.endTime,
    super.challengeStatus
  });


  factory DistanceChallenge.fromJson(Map<String, dynamic> json) {
    return DistanceChallenge(
      id: json['identifier'],
      name: json['title'],
      description: json['description'],
      level: json['level'],
      challengeType: ChallengeType.fromValue(json['type']),
      challengeStatus: json['status'] != null ? ChallengeStatus.fromString(json['status']) : ChallengeStatus.inactive,
      targetDistance: json['target_distance'] ?? 0,
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
      'target_distance': targetDistance,
      'status': challengeStatus.description,
    };
  }

  @override
  void startChallenge() {
    super.startChallenge();
    notifyListeners();
    super.updateFirebase(toJson());
  }

  @override
  void continueChallenge() {
    super.continueChallenge();
    notifyListeners();
    super.updateFirebase(toJson());
  }

  @override 
  void pauseChallenge() {
    super.pauseChallenge();
    notifyListeners();
    super.updateFirebase(toJson());
  }

  @override 
  void endChallenge() {
    super.endChallenge();
    notifyListeners();
    super.updateFirebase(toJson());
  }

  @override 
  void completeChallenge() {
    super.completeChallenge();
    notifyListeners();
    super.updateFirebase(toJson());
  }

  @override
  bool isCompleted() {
    return progress >= 100;
  }
}