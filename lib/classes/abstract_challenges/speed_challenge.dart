

import 'package:flutter/material.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';
import 'package:stepit/classes/abstract_challenges/challenge_enums/challenge_pedestrian_status.dart';
import 'package:stepit/classes/abstract_challenges/challenge_enums/challenge_status.dart';
import 'package:stepit/classes/abstract_challenges/challenge_enums/challenge_type.dart';

class SpeedChallenge extends Challenge with ChangeNotifier {
  
  final int? targetSpeed;
  final int targetDuration;

  int progress = 0;
  int elapsedSeconds = 0;

  // ChallengePedestrianStatus challengePedestrianStatus = ChallengePedestrianStatus.unknown;

  final ValueNotifier<ChallengePedestrianStatus> challengePedestrianStatus = ValueNotifier(ChallengePedestrianStatus.unknown);

  SpeedChallenge({
    required super.id,
    required super.name,
    required super.description,
    required super.level,
    required super.challengeType,
    required this.progress,
    required this.targetDuration,
    required this.elapsedSeconds,
    this.targetSpeed,
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
      targetDuration: json['target_duration'] ?? 0,
      startTime: json['start_time']?.toDate(),
      endTime: json['end_time']?.toDate(),
      progress: json['steps'] ?? 0,
      elapsedSeconds: json['elapsed_seconds'] ?? 0
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
      'target_duration': targetDuration,
      'status': challengeStatus.description,
      'elapsed_seconds': elapsedSeconds
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
  void updatePedestrianStatus(ChallengePedestrianStatus status) {
    super.updatePedestrianStatus(status);
    challengePedestrianStatus.value = status;
    // notifyListeners();
  }

  // @override
  // void updateChallengeLocation(double lat, double lng) {
  //   super.updateChallengeLocation(lat, lng);
  //   notifyListeners();
  // }

  @override
  void updateProgress(int progress) {
    super.updateProgress(progress);
    this.progress = progress; 
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