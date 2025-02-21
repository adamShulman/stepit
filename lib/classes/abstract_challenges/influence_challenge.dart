

import 'package:flutter/material.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';

class InfluenceChallenge extends Challenge with ChangeNotifier {

  final int? requiredPhotos;
  final int? stepLimit;

  int photosTaken = 0;
  int progress = 0;

  InfluenceChallenge({
    required super.id,
    required super.name,
    required super.description,
    required super.level,
    required super.challengeType,
    required this.requiredPhotos,
    required this.stepLimit,
    super.startTime,
    super.endTime,
  });


  factory InfluenceChallenge.fromJson(Map<String, dynamic> json) {
    return InfluenceChallenge(
      id: json['identifier'],
      name: json['title'],
      description: json['description'],
      level: json['level'],
      challengeType: ChallengeType.fromValue(json['type']), 
      requiredPhotos: null, 
      stepLimit: null,
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
      'target': requiredPhotos,
      'status': challengeStatus.description,
    };
  }

  void addPhoto() {
    photosTaken++;
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
