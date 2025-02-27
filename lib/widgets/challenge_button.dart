
import 'package:flutter/material.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';
import 'package:stepit/classes/challenge_singleton.dart';

class ChallengeButton extends StatelessWidget {

  final Challenge challenge;

  final VoidCallback onPressed;

  const ChallengeButton({super.key, required this.challenge, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        backgroundColor: LazySingleton.instance.isThereActiveChallenge() ? Colors.blueGrey :  const Color(0xFF22577A),
        foregroundColor: Colors.white
      ),
      child: Text(buttonText()),
    );
  }

  String buttonText() {
    if (LazySingleton.instance.anotherChallengeInProgress(challenge.id)) {
      return "Another challenge in progress";
    } else {
        switch (challenge.challengeStatus) {
        case ChallengeStatus.inactive:
          return "Start Challenge";
        case ChallengeStatus.active:
          return "Stop Challenge";
        case ChallengeStatus.completed:
          return "Challenge Completed";
        case ChallengeStatus.ended:
          return "Continue Challenge";
        case ChallengeStatus.paused:
          return "Continue Challenge";
      }
    }
  }
}