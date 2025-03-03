

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

  @override
  void updateChallengeLocation(double lat, double lng) {
    super.updateChallengeLocation(lat, lng);
    notifyListeners();
  }
}
