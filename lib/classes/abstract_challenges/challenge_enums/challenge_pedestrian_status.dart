
enum ChallengePedestrianStatus {
  walking,
  stopped,
  unknown;

  factory ChallengePedestrianStatus.fromString(String description) { return ChallengePedestrianStatus.values.firstWhere((x) => x.description == description); }
}

extension ChallengeStatusExtension on ChallengePedestrianStatus {
  String get description {
    switch (this) {
      case ChallengePedestrianStatus.walking:
        return "walking";
      case ChallengePedestrianStatus.stopped:
        return "stopped";
      case ChallengePedestrianStatus.unknown:
        return "unknown";
    }
  }
}