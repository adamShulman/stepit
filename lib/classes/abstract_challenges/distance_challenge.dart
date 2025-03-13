
import 'package:flutter/material.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';
import 'package:stepit/classes/abstract_challenges/challenge_enums/challenge_status.dart';
import 'package:stepit/classes/abstract_challenges/challenge_enums/challenge_type.dart';

class DistanceChallenge extends Challenge with ChangeNotifier {

  int progress = 0;
  final int targetDistance;
  
  DistanceChallenge({
    required super.id,
    required super.name,
    required super.nameHe,
    required super.description,
    required super.descriptionHe,
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
      name: json['title'] ?? '',
      nameHe: json['title_he'] ?? '',
      description: json['description'] ?? '',
      descriptionHe: json['description_he'] ?? '',
      level: json['level'] ?? 1,
      challengeType: json['type'] != null ? ChallengeType.fromValue(json['type']) : ChallengeType.steps,
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
      'title_he': nameHe,
      'description_he': descriptionHe,
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
    super.removeFromFirestoreChallengeToResume();
  }

  @override 
  void complete() {
    super.complete();
    notifyListeners();
    super.updateFirebase(toJson());
    super.updatePointsForUser(getPoints());
    super.removeFromFirestoreChallengeToResume();
  }

 @override
  bool isCompleted() {
    return challengeStatus == ChallengeStatus.completed;
  }

  @override
  void updateChallengeLocation(double lat, double lng) {
    super.updateChallengeLocation(lat, lng);
    notifyListeners();
  }

  @override
  int getPoints() {
    int points;
    if (isCompleted()) {
      points = (super.getCompletionPoints() + (progress / 10).toInt());
    } else {
      points = (progress / 10).toInt();
    }
    return points;
  }
}