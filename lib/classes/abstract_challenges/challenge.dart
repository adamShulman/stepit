
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:stepit/classes/abstract_challenges/challenge_enums/challenge_pedestrian_status.dart';
import 'package:stepit/classes/abstract_challenges/challenge_enums/challenge_status.dart';
import 'package:stepit/classes/abstract_challenges/challenge_enums/challenge_type.dart';
import 'package:stepit/classes/abstract_challenges/distance_challenge.dart';
import 'package:stepit/classes/abstract_challenges/duration_challenge.dart';
import 'package:stepit/classes/abstract_challenges/influence_challenge.dart';
import 'package:stepit/classes/abstract_challenges/speed_challenge.dart';
import 'package:stepit/classes/abstract_challenges/steps_challenge.dart';
import 'package:stepit/classes/challenge_singleton.dart';
import 'package:stepit/services/firebase_service.dart';

abstract class Challenge {

  final int id;
  final String name;
  final String description;
  final int level;
  DateTime? startTime;
  DateTime? endTime;
  final ChallengeType challengeType;
  ChallengeStatus challengeStatus;
  double? latitude;
  double? longitude;

  final ValueNotifier<ChallengeStatus> challengeStatusNotifier = ValueNotifier(ChallengeStatus.inactive);

  String get _userId {
    return LazySingleton.instance.currentUser.uniqueNumber.toString().padLeft(6, '0');
  }

  String get _challengeStatusFirestoreCollectionRef {
    return challengeStatus.challengeFirestoreCollectionRef;
  }

  Challenge({
    required this.name,
    required this.description,
    required this.startTime,
    this.endTime,
    required this.id,
    required this.level,
    required this.challengeType,
    this.challengeStatus = ChallengeStatus.inactive,
    this.latitude,
    this.longitude
  });

  factory Challenge.fromJson(Map<String, dynamic> json, { ChallengeStatus? challengeStatus }) {

    ChallengeType type = json['type'] != null ? ChallengeType.fromValue(json['type']) : ChallengeType.steps;
    Challenge challenge;

    switch (type) {
      case ChallengeType.steps:
        challenge = StepsChallenge.fromJson(json);
      case ChallengeType.speed:
        challenge = SpeedChallenge.fromJson(json);
      case ChallengeType.distance:
        challenge = DistanceChallenge.fromJson(json);
      case ChallengeType.duration:
        challenge = DurationChallenge.fromJson(json);
      case ChallengeType.influence:
        challenge = InfluenceChallenge.fromJson(json);
      }

      if (challengeStatus != null) {
        challenge.challengeStatus = challengeStatus; 
        challenge.challengeStatusNotifier.value = challengeStatus;
      }

    return challenge;
  }

  bool isCompleted();

  Map<String, dynamic> toJson();

  int getPoints();

  int getCompletionPoints() {
    return 500;
  }

  void updateProgress(int progress) {
    log('Progress updated: $progress');
  }

  void updatePedestrianStatus(ChallengePedestrianStatus status) {
    log('Pedestrian status updated: ${status.description}');
  }

  //MARK:- Challenge control methods.

  void start() {
    startTime = DateTime.now();
    challengeStatus = ChallengeStatus.active;
    challengeStatusNotifier.value = challengeStatus;
    LazySingleton.instance.activeChallenge = this;
    log("$name challenge started! $startTime");
  }

  void pause() {
    challengeStatus = ChallengeStatus.paused;
    challengeStatusNotifier.value = challengeStatus;
    LazySingleton.instance.activeChallenge = null;
    log("$name challenge paused!");
  }

  void resume() {
    challengeStatus = ChallengeStatus.active;
    challengeStatusNotifier.value = challengeStatus;
    LazySingleton.instance.activeChallenge = this;
    log("$name challenge continued! $startTime");
  }

  void end() {
    endTime = DateTime.now();
    challengeStatus = ChallengeStatus.ended;
    challengeStatusNotifier.value = challengeStatus;
    LazySingleton.instance.activeChallenge = null;
    log("$name challenge ended!");
  }

  void complete() {
    endTime = DateTime.now();
    challengeStatus = ChallengeStatus.completed;
    challengeStatusNotifier.value = challengeStatus;
    // LazySingleton.instance.challengeInProgress = false;
    LazySingleton.instance.activeChallenge = null;
    log("$name challenge completed!");
  }

   void statusNotify(ChallengeStatus status) {
    if (challengeStatusNotifier.value == status) { return; }
    challengeStatusNotifier.value = status;
  }

  //MARK:- Firestore methods.

  void updateFirebase(Map<String, dynamic> jsonData) {
    final FirestoreService firestoreService = FirestoreService();
    firestoreService.updateUserChallenge(jsonData, _userId, _challengeStatusFirestoreCollectionRef, id);
  }

  void removeFromFirestoreChallengeToResume() async {
    final FirestoreService firestoreService = FirestoreService();
    firestoreService.removeFromFirestoreChallengeToResume(_userId, _challengeStatusFirestoreCollectionRef, id);
  }

  void updatePointsForUser(int points) {
    final FirestoreService firestoreService = FirestoreService();
    firestoreService.updatePointsForUser(points, _userId);
  }

  void updateChallengeLocation(double lat, double lng) {

    latitude = lat;
    longitude = lng;

    final FirestoreService firestoreService = FirestoreService();
    firestoreService.updateChallengeLocation(lat, lng, _userId, _challengeStatusFirestoreCollectionRef, id);
        
  }

  Future<void> clearLocationsSubCollection() async {
    final FirestoreService firestoreService = FirestoreService();
    firestoreService.clearLocationsSubCollection(_userId, _challengeStatusFirestoreCollectionRef, id);
  }
}
