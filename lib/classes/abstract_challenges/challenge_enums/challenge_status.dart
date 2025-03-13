
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

extension ChallengeStatusFirestoreCollectionRef on ChallengeStatus {
  String get challengeFirestoreCollectionRef {
    switch (this) {
      case ChallengeStatus.inactive:
        return "resume_challenges";
      case ChallengeStatus.active:
        return "resume_challenges";
      case ChallengeStatus.ended:
        return "ended_challenges";
      case ChallengeStatus.completed:
        return "completed_challenges";
      case ChallengeStatus.paused:
        return "resume_challenges";
    }
  }
}