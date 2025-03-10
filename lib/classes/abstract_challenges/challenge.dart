
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  double? latitude;
  double? longitude;

  final ValueNotifier<ChallengeStatus> challengeStatusNotifier = ValueNotifier(ChallengeStatus.inactive);

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

  factory Challenge.fromJson(Map<String, dynamic> json) {

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

    return challenge;
  }

  bool isCompleted();

  Map<String, dynamic> toJson();

  int getPoints();

  int getCompletionPoints() {
    return 500;
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

  void start() {
    startTime = DateTime.now();
    challengeStatus = ChallengeStatus.active;
    challengeStatusNotifier.value = challengeStatus;
    LazySingleton.instance.activeChallenge = this;
    log("$name challenge started! $startTime");
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

  void pause() {
    challengeStatus = ChallengeStatus.paused;
    challengeStatusNotifier.value = challengeStatus;
    LazySingleton.instance.activeChallenge = null;
    log("$name challenge paused!");
  }

  void statusNotify(ChallengeStatus status) {
    if (challengeStatusNotifier.value == status) { return; }
    challengeStatusNotifier.value = status;
  }

  void complete() {
    endTime = DateTime.now();
    challengeStatus = ChallengeStatus.completed;
    challengeStatusNotifier.value = challengeStatus;
    // LazySingleton.instance.challengeInProgress = false;
    LazySingleton.instance.activeChallenge = null;
    log("$name challenge completed!");
  }

  void updateFirebase(Map<String, dynamic> jsonData) {

    final userId = LazySingleton.instance.currentUser.uniqueNumber;

    final fireStoreChallengeReference = FirebaseFirestore.instance
      .collection("users")
      .doc(userId.toString().padLeft(6, '0'))
      .collection("userGames")
      .doc("game_$id");

    fireStoreChallengeReference.set(jsonData, SetOptions(merge: true));

    // _fireStoreChallengeReference?.set(jsonData, SetOptions(merge: true));
  }

  void updatePointsForUser(int points) {

    final userId = LazySingleton.instance.currentUser.uniqueNumber;

    try {
      
      final fireStoreChallengeReference = FirebaseFirestore.instance
        .collection("users")
        .doc(userId.toString().padLeft(6, '0'));

      fireStoreChallengeReference.update({'points': FieldValue.increment(points)});

    } catch (error) {
      log(error.toString());
    }

  }

  void updateChallengeLocation(double lat, double lng) {

    final userId = LazySingleton.instance.currentUser.uniqueNumber;

    latitude = lat;
    longitude = lng;
    
    final String now = DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now());
    
    try {

      final location = {
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': FieldValue.serverTimestamp(),
      };

      final fireStoreChallengeReference = FirebaseFirestore.instance
        .collection("users")
        .doc(userId.toString().padLeft(6, '0'))
        .collection("userGames")
        .doc("game_$id");

      fireStoreChallengeReference.collection("locations").doc(now).set(location);

      // CollectionReference userChallenges = FirebaseFirestore.instance
      //   .collection("users")
      //   .doc(userId.toString().padLeft(6, '0'))
      //   .collection("userGames");

      // await userChallenges.doc("game_$id").update({
      //   'locations': FieldValue.arrayUnion([location]),
      // });

      // _fireStoreChallengeReference?.collection("locations").doc(now).set(location);

      // _fireStoreChallengeReference?.update({
      //   'locations': FieldValue.arrayUnion([location]),
      // });

      log("🔥 Challenge location updated in Firestore!");  
    } catch (e) {
      log("❌ Error updating Firestore: $e");
    }
  }

  Future<void> clearLocationsSubCollection() async {

    final userId = LazySingleton.instance.currentUser.uniqueNumber;

    final fireStoreChallengeReference = FirebaseFirestore.instance
        .collection("users")
        .doc(userId.toString().padLeft(6, '0'))
        .collection("userGames")
        .doc("game_$id");
    
    final collection = await fireStoreChallengeReference.collection("locations").get();

    final batch = FirebaseFirestore.instance.batch();

    for (final doc in collection.docs) {
      batch.delete(doc.reference);
    }
    
    return batch.commit();
  }

  void fetchSomething({required String data}) {}
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

extension ChallengeStatusActionButtonTitleExtension on ChallengeStatus {
  String get challengeButtonTitle {
    switch (this) {
      case ChallengeStatus.inactive:
        return "Start challenge";
      case ChallengeStatus.active:
        return "Pause challenge";
      case ChallengeStatus.ended:
        return "Challenge ended";
      case ChallengeStatus.completed:
        return "Challenge completed";
      case ChallengeStatus.paused:
        return "Resume challenge";
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