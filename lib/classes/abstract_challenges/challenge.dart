
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:stepit/classes/abstract_challenges/distance_challenge.dart';
import 'package:stepit/classes/abstract_challenges/duration_challenge.dart';
import 'package:stepit/classes/abstract_challenges/influence_challenge.dart';
import 'package:stepit/classes/abstract_challenges/speed_challenge.dart';
import 'package:stepit/classes/abstract_challenges/steps_challenge.dart';
import 'package:stepit/classes/challenge_singleton.dart';

abstract class Challenge {

  final int id;
  final String name;
  final String description;
  final int level;
  DateTime? startTime;
  DateTime? endTime;
  final ChallengeType challengeType;
  ChallengeStatus challengeStatus;

  Challenge({
    required this.name,
    required this.description,
    required this.startTime,
    this.endTime,
    required this.id,
    required this.level,
    required this.challengeType,
    this.challengeStatus = ChallengeStatus.inactive
  });

  bool isCompleted();

  Map<String, dynamic> toJson();

  factory Challenge.fromJson(Map<String, dynamic> json){
    ChallengeType type = json['type'] != null ? ChallengeType.fromValue(json['type']) : ChallengeType.steps;
    switch (type) {
      case ChallengeType.steps:
        return StepsChallenge.fromJson(json);
      case ChallengeType.speed:
        return SpeedChallenge.fromJson(json);
      case ChallengeType.distance:
        return DistanceChallenge.fromJson(json);
      case ChallengeType.duration:
        return DurationChallenge.fromJson(json);
      case ChallengeType.influence:
        return InfluenceChallenge.fromJson(json);
      default:
        return StepsChallenge.fromJson(json);
    }
  }

  String? getFormattedStartTime() {
    if (startTime == null ) { return null; }
    DateFormat dateFormat = DateFormat("HH:mm:ss");
    return dateFormat.format(startTime!);
  }

  String? getFormattedEndTime() {
    if (endTime == null ) { return null; }
    DateFormat dateFormat = DateFormat("HH:mm:ss");
    return dateFormat.format(endTime!);
  }

  void startChallenge() {
    startTime = DateTime.now();
    challengeStatus = ChallengeStatus.active;
    // LazySingleton.instance.challengeInProgress = true;
    LazySingleton.instance.activeChallenge = this;
    print("$name challenge started! $startTime");
  }

  void continueChallenge() {
    challengeStatus = ChallengeStatus.active;
    // LazySingleton.instance.challengeInProgress = true;
    LazySingleton.instance.activeChallenge = this;
    print("$name challenge continued! $startTime");
  }

  void endChallenge() {
    endTime = DateTime.now();
    challengeStatus = ChallengeStatus.ended;
    // LazySingleton.instance.challengeInProgress = false;
    LazySingleton.instance.activeChallenge = null;
    print("$name challenge ended!");
  }

  void pauseChallenge() {
    endTime = DateTime.now();
    challengeStatus = ChallengeStatus.paused;
    // LazySingleton.instance.challengeInProgress = false;
    LazySingleton.instance.activeChallenge = null;
    print("$name challenge ended!");
  }

  void completeChallenge() {
    endTime = DateTime.now();
    challengeStatus = ChallengeStatus.completed;
    // LazySingleton.instance.challengeInProgress = false;
    LazySingleton.instance.activeChallenge = null;
    print("$name challenge completed!");
  }

  void updateFirebase(Map<String, dynamic> jsonData) {

    final userId = LazySingleton.instance.currentUser?.uniqueNumber;
    
    if (userId == null ) { return; }

    CollectionReference userChallenges = FirebaseFirestore.instance
      .collection("users")
      .doc(userId.toString().padLeft(6, '0'))
      .collection("userGames");

    userChallenges.doc("game_$id").set(jsonData);
  }
}


enum ChallengeStatus {
  inactive,
  active,
  ended,
  completed,
  paused;

  factory ChallengeStatus.fromString(String description) { return ChallengeStatus.values.firstWhere((x) => x.description == description); }
}

extension ChallengeStatusExtension on ChallengeStatus {
  String get description {
    switch (this) {
      case ChallengeStatus.inactive:
        return "Inactive";
      case ChallengeStatus.active:
        return "Active";
      case ChallengeStatus.ended:
        return "Ended";
      case ChallengeStatus.completed:
        return "Completed";
      case ChallengeStatus.paused:
        return "Paused";
    }
  }
}

enum ChallengeType {

  steps,
  speed,
  distance,
  duration,
  influence;

  factory ChallengeType.fromValue(int value) { return ChallengeType.values.firstWhere((x) => x.value == value); }
}

extension ChallengeTypeExtension on ChallengeType {
  int get value {
    switch (this) {
      case ChallengeType.steps:
        return 0;
      case ChallengeType.speed:
        return 1;
      case ChallengeType.duration:
        return 2;
      case ChallengeType.distance:
        return 3;
      case ChallengeType.influence:
        return 4;
    }
  }

  String get description {
    switch (this) {
      case ChallengeType.steps:
        return "Steps";
      case ChallengeType.speed:
        return "Speed";
      case ChallengeType.duration:
        return "Duration";
      case ChallengeType.distance:
        return "Distance";
      case ChallengeType.influence:
        return "Influence";
    }
  }
}