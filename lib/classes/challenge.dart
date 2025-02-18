// enum ChallengeType implements Comparable<ChallengeType> {

//   steps(targetDuration: null)
//   speed(tires: 6, passengers: 50, carbonPerKilometer: 800),
//   distance(tires: 2, passengers: 1, carbonPerKilometer: 0),
//   duration(tires: 2, passengers: 1, carbonPerKilometer: 0),
//   influence(tires: 2, passengers: 1, carbonPerKilometer: 0);

//   const ChallengeType({
//      required this.targetDuration,
//     required this.targetSpeed,
//   });

//   factory ChallengeType.fromValue(int value) { return ChallengeType.values.firstWhere((x) => x.value == value); }

//   final int? targetSteps, targetDuration, targetSpeed, targetDistance, targetInfluence;
 
//   int get carbonFootprint => (carbonPerKilometer / passengers).round();

//   // bool get isTwoWheeled => this == ChallengeType.bicycle;

//   @override
//   int compareTo(ChallengeType other) => carbonFootprint - other.carbonFootprint;
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stepit/features/step_count.dart';

enum ChallengeStatus {
  inactive,
  active,
  ended,
  completed
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

abstract class Challenge {

  final int id;
  final String name;
  final String description;
  final int level;
  DateTime? startTime;
  DateTime? endTime;
  final ChallengeType challengeType;
  ChallengeStatus challengeStatus;


  bool completed = false;

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

  void start() {
    startTime = DateTime.now();
    challengeStatus = ChallengeStatus.active;
    print("$name challenge started! $startTime");
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

  void end() {
    endTime = DateTime.now();
    challengeStatus = ChallengeStatus.ended;
    print("$name challenge ended!");
  }

  void complete() {
    endTime = DateTime.now();
    challengeStatus = ChallengeStatus.completed;
    print("$name challenge completed!");
  }

  bool isCompleted();

  factory Challenge.fromJson(Map<String, dynamic> json){
    ChallengeType type = ChallengeType.fromValue(json['type']);
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

  /// ✅ Convert challenge to JSON (to store in database, API, etc.)
  Map<String, dynamic> toJson();
}

class StepsChallenge extends Challenge with ChangeNotifier {
  
  final int targetSteps;
  int progress = 0;
  
  StepsChallenge({
    required int id,
    required String name,
    required String description,
    required int level,
    required ChallengeType challengeType,
    required this.targetSteps,
    DateTime? startTime,
    DateTime? endTime,
  }) : super(
          id: id,
          name: name,
          description: description,
          level: level,
          startTime: startTime,
          endTime: endTime,
          challengeType: challengeType
        );

  factory StepsChallenge.fromJson(Map<String, dynamic> json) {
    return StepsChallenge(
      id: json['identifier'],
      name: json['title'],
      description: json['description'],
      level: json['level'],
      challengeType: ChallengeType.fromValue(json['type']),
      targetSteps: 150
      // startTime: DateTime.parse(json['startTime']),
      // endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': name,
      'description': description,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'type': challengeType,
      'targetSteps': targetSteps,
      'progress': progress,
      'completed': completed,
    };
  }

  @override
  void start() {
    // challengeStatus = ChallengeStatus.active;
    // notifyListeners();
    super.start();
    notifyListeners();
  }

  @override 
  void end() {
    
    super.end();
    notifyListeners();
  }


  @override
  bool isCompleted() {
    return progress >= targetSteps;
  }
  
}

class DurationChallenge extends Challenge {
  
  final int targetSteps;
  int progress = 0;
  
  DurationChallenge({
    required int id,
    required String name,
    required String description,
    required int level,
    required ChallengeType challengeType,
    DateTime? startTime,
    DateTime? endTime,
    required this.targetSteps,
  }) : super(
          id: id,
          name: name,
          description: description,
          level: level,
          challengeType: challengeType,
          startTime: startTime,
          endTime: endTime,
        );

  factory DurationChallenge.fromJson(Map<String, dynamic> json) {
    return DurationChallenge(
      id: json['identifier'],
      name: json['title'],
      description: json['description'],
      level: json['level'],
      challengeType: ChallengeType.fromValue(json['type']),
      targetSteps: 150
      // startTime: DateTime.parse(json['startTime']),
      // endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': name,
      'description': description,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'type': challengeType,
      'targetSteps': targetSteps,
      'progress': progress,
      'completed': completed,
    };
  }

  @override
  bool isCompleted() {
    return progress >= targetSteps;
  }
}

class SpeedChallenge extends Challenge {
  
  final double targetDistance;
  int progress = 0;

  SpeedChallenge({
    required int id,
    required String name,
    required String description,
    required int level,
    required ChallengeType challengeType,
    DateTime? startTime,
    DateTime? endTime,
    required this.targetDistance
  }) : super(
          id: id,
          name: name,
          description: description,
          level: level,
          challengeType: challengeType,
          startTime: startTime,
          endTime: endTime,
        );
        

  factory SpeedChallenge.fromJson(Map<String, dynamic> json) {
    return SpeedChallenge(
      id: json['identifier'],
      name: json['title'],
      description: json['description'],
      level: json['level'],
      challengeType: ChallengeType.fromValue(json['type']),
      targetDistance: 150
      // startTime: DateTime.parse(json['startTime']),
      // endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': name,
      'description': description,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'type': challengeType,
      'progress': progress,
      'completed': completed,
    };
  }

  @override
  bool isCompleted() {
    return progress >= 100;
  }
}

// Photo Challenge (Step-based + Photos)
class DistanceChallenge extends Challenge {

  final int? requiredPhotos;
  final int? stepLimit;

  int photosTaken = 0;
  int progress = 0;

  DistanceChallenge({
    required int id,
    required String name,
    required String description,
    required int level,
    required ChallengeType challengeType,
    required this.requiredPhotos,
    required this.stepLimit,
    DateTime? startTime,
    DateTime? endTime,
  }) : super(
          id: id,
          name: name,
          description: description,
          level: level,
          challengeType: challengeType,
          startTime: startTime,
          endTime: endTime,
        );


  factory DistanceChallenge.fromJson(Map<String, dynamic> json) {
    return DistanceChallenge(
      id: json['identifier'],
      name: json['title'],
      description: json['description'],
      level: json['level'],
      challengeType: ChallengeType.fromValue(json['type']), 
      requiredPhotos: null, 
      stepLimit: null,
      // startTime: DateTime.parse(json['startTime']),
      // endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': name,
      'description': description,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'type': challengeType,
      'progress': progress,
      'completed': completed,
    };
  }

  void addPhoto() {
    photosTaken++;
  }

  @override
  bool isCompleted() {
    return progress >= 100;
  }
}

class InfluenceChallenge extends Challenge {

  final int? requiredPhotos;
  final int? stepLimit;

  int photosTaken = 0;
  int progress = 0;

  InfluenceChallenge({
    required int id,
    required String name,
    required String description,
    required int level,
    required ChallengeType challengeType,
    required this.requiredPhotos,
    required this.stepLimit,
    DateTime? startTime,
    DateTime? endTime,
  }) : super(
          id: id,
          name: name,
          description: description,
          level: level,
          challengeType: challengeType,
          startTime: startTime,
          endTime: endTime,
        );


  factory InfluenceChallenge.fromJson(Map<String, dynamic> json) {
    return InfluenceChallenge(
      id: json['identifier'],
      name: json['title'],
      description: json['description'],
      level: json['level'],
      challengeType: ChallengeType.fromValue(json['type']), 
      requiredPhotos: null, 
      stepLimit: null,
      // startTime: DateTime.parse(json['startTime']),
      // endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': name,
      'description': description,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'type': challengeType,
      'progress': progress,
      'completed': completed,
    };
  }

  void addPhoto() {
    photosTaken++;
  }

  @override
  bool isCompleted() {
    return progress >= 100;
  }
}
