


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';
import 'package:stepit/classes/abstract_challenges/influence_challenge.dart';
import 'package:stepit/widgets/challenge_card.dart';


class InfluenceChallengeCard extends ChallengeCard<InfluenceChallenge> {

  const InfluenceChallengeCard({super.key, required super.challenge, required super.canNavigate, super.callback});

  @override
  Widget buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Required Photos: ${challenge.requiredPhotos}"),
        Text("Photos Taken: ${challenge.photosTaken}"),
        Text("Step Limit: ${challenge.stepLimit}"),
        Text("Steps Used: ${challenge.progress ?? 0}"),
      ],
    );
  }

  @override
  ChallengeCardState<ChallengeCard<Challenge>> createState() => _InfluenceChallengeCardState();
}

class _InfluenceChallengeCardState extends ChallengeCardState<InfluenceChallengeCard> {

  int _stepCount = 0;

  bool isActive = false;
  
  late StreamSubscription _periodicSub;

  @override
  void initState() {
    _periodicSub = Stream.periodic(const Duration(milliseconds: 1000)).listen((_) {

      switch (widget.challenge.challengeStatus) {
        case ChallengeStatus.inactive:
          isActive = false;
          
        case ChallengeStatus.active:
          if (isActive) {

          } else {
            isActive = true;
            _startChallenge();
          }
          
        case ChallengeStatus.completed:
          if (isActive) {
            isActive = false;
            _completeChallenge();
          }
         
        case ChallengeStatus.ended:
        if (isActive) {
            isActive = false;
            _endChallenge();
          }

          case ChallengeStatus.paused:
          if (isActive) {
            isActive = false;
            // _pauseChallenge();
          }
         
      }
     
    });
    super.initState();
  }

  @override
  void dispose() {
    _periodicSub.cancel();
    super.dispose();
  }

  void _startChallenge() {
    
  }

  void _completeChallenge() {

    String message;
    message = 'Congratulations! You have completed the challenge.';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Challenge Completed!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _endChallenge() {


  }

}