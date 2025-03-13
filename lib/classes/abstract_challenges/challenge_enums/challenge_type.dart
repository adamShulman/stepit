
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