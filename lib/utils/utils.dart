

import 'package:flutter/material.dart';
import 'package:stepit/classes/challenge.dart';
import 'package:stepit/widgets/challenge_cards.dart';

class ChallengeUtils {

  ChallengeUtils._(); 

  static Widget buildChallengeWidget(Challenge challenge, { void Function()? callback, bool canNavigate = true }) {
    return switch (challenge) {
      StepsChallenge stepsChallenge => StepsChallengeCard(challenge: stepsChallenge, callback: callback, canNavigate: canNavigate),
      // SpeedChallenge speedChallenge => SpeedChallengeCard(challenge: speedChallenge),
      // DistanceChallenge distanceChallenge => DistanceChallengeCard(challenge: distanceChallenge),
      // DurationChallenge durationChallenge => DurationChallengeCard(challenge: durationChallenge),
      // InfluenceChallenge influenceChallenge => InfluenceChallengeCard(challenge: influenceChallenge),
      _ => const SizedBox.shrink(), 
    };
  }

  static String imageNameFor(Challenge challenge) {

    String icon = "";

    switch (challenge.challengeType) {
      
      case ChallengeType.steps:

        icon = "assets/images/footsteps.png";

      case ChallengeType.speed:
      
        icon = "assets/images/15.png";

      case ChallengeType.duration:

         icon = "assets/images/one-hour.png";

      case ChallengeType.distance:

        icon = "assets/images/number-3.png";

      case ChallengeType.influence:

        switch (challenge.id) {

          case 13:
            icon = "assets/images/sidewalk.png";
          case 14:
            icon = "assets/images/students.png";
          case 15:
            icon = "assets/images/bike.png";
          case 16:
            icon = "assets/images/street-light.png";
          case 17:
            icon = "assets/images/park.png";
          case 18:
            icon = "assets/images/playground.png";
          case 19:
            icon = "assets/images/widening.png";
          case 20:
            icon = "assets/images/relax.png";
          case 21:
            icon = "assets/images/shadow.png";
          case 22:
            icon = "assets/images/beautifultree.png";
          case 23:
            icon = "assets/images/dust.png";
          case 24:
            icon = "assets/images/shovels.png";
          default:
            icon = "assets/images/number-3.png";

        }
    }
    return icon;
 }
 
}