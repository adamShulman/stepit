
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
  double? latitude;
  double? longitude;

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

  bool isCompleted();

  Map<String, dynamic> toJson();

  late final DocumentReference? _fireStoreChallengeReference;

  void setUserId(String userId) {
    _fireStoreChallengeReference = FirebaseFirestore.instance
      .collection("users")
      .doc(userId.toString().padLeft(6, '0'))
      .collection("userGames")
      .doc("game_$id");
  }

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
      default:
        challenge = StepsChallenge.fromJson(json);
    }

    final userId = LazySingleton.instance.currentUser?.uniqueNumber;

    if (userId != null) {
      challenge.setUserId(userId.toString());
    }

    return challenge;
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
    LazySingleton.instance.activeChallenge = this;
    print("$name challenge started! $startTime");
  }

  void resume() {
    challengeStatus = ChallengeStatus.active;
    LazySingleton.instance.activeChallenge = this;
    print("$name challenge continued! $startTime");
  }

  void end() {
    endTime = DateTime.now();
    challengeStatus = ChallengeStatus.ended;
    LazySingleton.instance.activeChallenge = null;
    print("$name challenge ended!");
  }

  void pause() {
    challengeStatus = ChallengeStatus.paused;
    LazySingleton.instance.activeChallenge = null;
    print("$name challenge paused!");
  }

  void complete() {
    endTime = DateTime.now();
    challengeStatus = ChallengeStatus.completed;
    // LazySingleton.instance.challengeInProgress = false;
    LazySingleton.instance.activeChallenge = null;
    print("$name challenge completed!");
  }

  void updateFirebase(Map<String, dynamic> jsonData) {

    // final userId = LazySingleton.instance.currentUser?.uniqueNumber;

    // if (userId == null) { return; }

    // CollectionReference userChallenges = FirebaseFirestore.instance
    //   .collection("users")
    //   .doc(userId.toString().padLeft(6, '0'))
    //   .collection("userGames");

    // userChallenges.doc("game_$id").update(jsonData);

    _fireStoreChallengeReference?.update(jsonData);
  }

  void updateChallengeLocation(double lat, double lng) {

    latitude = lat;
    longitude = lng;

    // final userId = LazySingleton.instance.currentUser?.uniqueNumber;

    // if (userId == null) { return; }
    
    try {

      final location = {
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': Timestamp.now(),
      };

      // CollectionReference userChallenges = FirebaseFirestore.instance
      //   .collection("users")
      //   .doc(userId.toString().padLeft(6, '0'))
      //   .collection("userGames");

      // await userChallenges.doc("game_$id").update({
      //   'locations': FieldValue.arrayUnion([location]),
      // });

      _fireStoreChallengeReference?.update({
        'locations': FieldValue.arrayUnion([location]),
      });

      print("🔥 Challenge location updated in Firestore!");  
    } catch (e) {
      print("❌ Error updating Firestore: $e");
    }
  }

  void clearChallengeLocations() {
    _fireStoreChallengeReference?.update({
        'locations': FieldValue.arrayUnion([]),
    });
  }

  // Future<void> addLocationToArray(double latitude, double longitude) async {
  //   try {
  //     // Create a location object with latitude, longitude, and timestamp
  //     final location = {
  //       'latitude': latitude,
  //       'longitude': longitude,
  //       'timestamp': FieldValue.serverTimestamp(),
  //     };

  //     // Add the location to the array in Firestore
  //     await FirebaseFirestore.instance.collection('challenges').doc(challengeId).update({
  //       'locations': FieldValue.arrayUnion([location]), // Append new location to array
  //     });

  //     print("🔥 Location added to array in Firestore!");
  //   } catch (e) {
  //     print("❌ Error adding location: $e");
  //   }
  // }
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