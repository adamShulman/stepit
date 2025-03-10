

import 'package:flutter/material.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';
import 'package:stepit/classes/abstract_challenges/distance_challenge.dart';
import 'package:stepit/classes/abstract_challenges/duration_challenge.dart';
import 'package:stepit/classes/abstract_challenges/influence_challenge.dart';
import 'package:stepit/classes/abstract_challenges/speed_challenge.dart';
import 'package:stepit/classes/abstract_challenges/steps_challenge.dart';
import 'package:stepit/widgets/challenge_card.dart';
import 'package:stepit/widgets/challenges/distance_challenge_widget.dart';
import 'package:stepit/widgets/challenges/duration_challenge_widget.dart';
import 'package:stepit/widgets/challenges/influence_challenge_widget.dart';
import 'package:stepit/widgets/challenges/speed_challenge_widget.dart';
import 'package:stepit/widgets/challenges/steps_challenge_widget.dart';

class ChallengeUtils {

  ChallengeUtils._(); 

  static Widget buildChallengeWidget(Challenge challenge, { Key? key, VoidCallback? onTap, ChildCallbackBuilder? builder }) {
    return switch (challenge) {
      StepsChallenge stepsChallenge => StepsChallengeCard(key: key, challenge: stepsChallenge, onChallengeTap: onTap, builder: builder),
      SpeedChallenge speedChallenge => SpeedChallengeCard(key: key, challenge: speedChallenge, onChallengeTap: onTap, builder: builder),
      DistanceChallenge distanceChallenge => DistanceChallengeCard(key: key, challenge: distanceChallenge, onChallengeTap: onTap, builder: builder),
      DurationChallenge durationChallenge => DurationChallengeCard(key: key, challenge: durationChallenge, onChallengeTap: onTap, builder: builder),
      InfluenceChallenge influenceChallenge => InfluenceChallengeCard(key: key, challenge: influenceChallenge, onChallengeTap: onTap, builder: builder),
      _ => const SizedBox.shrink(), 
    };
  }

  static IconData buttonIconDataFor(ChallengeStatus status) {

    IconData icon;

    switch (status) {
      
      case ChallengeStatus.inactive:
        icon = Icons.play_arrow;
      case ChallengeStatus.active:
        icon = Icons.pause;
      case ChallengeStatus.ended:
        icon = Icons.alarm;
      case ChallengeStatus.completed:
        icon = Icons.alarm_on;
      case ChallengeStatus.paused:
        icon = Icons.play_arrow;
    }

    return icon;
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

  static List<Widget> floatingMenuButtons(ChallengeStatus challengeStatus) {

    switch (challengeStatus) {

      case ChallengeStatus.inactive:

        return [
          FloatingActionButton.small(
            shape: const CircleBorder(),
            heroTag: null,
            child: const Icon(Icons.play_arrow),
            onPressed: () {
              // Navigator.of(context).push(
              //     MaterialPageRoute(builder: ((context) => const NextPage())));
            },
          ),
          FloatingActionButton.small(
            shape: const CircleBorder(),
            heroTag: null,
            child: const Icon(Icons.map),
            onPressed: () {
              // Navigator.of(context).push(
              //     MaterialPageRoute(builder: ((context) => const NextPage())));
            },
          ),
        ];

      case ChallengeStatus.active:

      case ChallengeStatus.ended:

      case ChallengeStatus.completed:
      
      case ChallengeStatus.paused:
        
    }
    return [
      FloatingActionButton.small(
        shape: const CircleBorder(),
        heroTag: null,
        child: const Icon(Icons.search),
        onPressed: () {
          // Navigator.of(context).push(
          //     MaterialPageRoute(builder: ((context) => const NextPage())));
        },
      ),
    ];
  }
 
}

class GeneralUtils {

  GeneralUtils._();

  static InputDecoration formStandardDecoration(String labelText) => InputDecoration(
    labelStyle: const TextStyle(color: Colors.black),
    labelText: labelText,
    fillColor: Colors.black,
    contentPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
    errorStyle: const TextStyle(
      color: Colors.black,
      fontSize: 13,
      fontWeight: FontWeight.normal,
    ),
    border: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFF22577A),
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
      borderSide: BorderSide(
        width: 1,
        color: Color(0xFF22577A),
      ),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
      borderSide: BorderSide(
        color: Color(0xFF22577A),
        width: 1,
      ),
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
      borderSide: BorderSide(
        color: Color(0xFF22577A),
        width: 1,
      ),
    ),
    );
}