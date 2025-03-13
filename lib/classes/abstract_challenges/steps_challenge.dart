

import 'package:flutter/material.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';
import 'package:stepit/classes/abstract_challenges/challenge_enums/challenge_status.dart';
import 'package:stepit/classes/abstract_challenges/challenge_enums/challenge_type.dart';

class StepsChallenge extends Challenge with ChangeNotifier {
  
  final int targetSteps;
  int progress = 0;
  
  StepsChallenge({
    required super.id,
    required super.name,
    required super.nameHe,
    required super.description,
    required super.descriptionHe,
    required super.level,
    required super.challengeType,
    required this.targetSteps,
    required this.progress,
    super.startTime,
    super.endTime,
    super.challengeStatus,
    super.latitude,
    super.longitude
  });

  factory StepsChallenge.fromJson(Map<String, dynamic> json) {
    return StepsChallenge(
      id: json['identifier'],
      name: json['title'] ?? '',
      nameHe: json['title_he'] ?? '',
      description: json['description'] ?? '',
      descriptionHe: json['description_he'] ?? '',
      level: json['level'] ?? 1,
      challengeType: json['type'] != null ? ChallengeType.fromValue(json['type']) : ChallengeType.steps,
      challengeStatus: json['status'] != null ? ChallengeStatus.fromString(json['status']) : ChallengeStatus.inactive,
      targetSteps: json['target_steps'] ?? 0,
      startTime: json['start_time']?.toDate(),
      endTime: json['end_time']?.toDate(),
      progress: json['steps'] ?? 0,
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
      'target_steps': targetSteps,
      'status': challengeStatus.description,
      'points': getPoints()
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
  void updateProgress(int progress) {
    super.updateProgress(progress);
    this.progress = progress; //+ initialSteps;
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