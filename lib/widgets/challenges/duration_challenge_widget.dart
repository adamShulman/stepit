




import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';
import 'package:stepit/classes/abstract_challenges/duration_challenge.dart';
import 'package:stepit/widgets/challenge_card.dart';


class DurationChallengeCard extends ChallengeCard<DurationChallenge> {

  const DurationChallengeCard({super.key, required super.challenge, required super.canNavigate, super.callback});

  @override
  Widget buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Target: ${challenge.targetSteps} steps"),
        Text("Progress: ${challenge.progress} steps"),
      ],
    );
  }

  @override
  ChallengeCardState<ChallengeCard<Challenge>> createState() => _DurationChallengeCardState();
}

class _DurationChallengeCardState extends ChallengeCardState<DurationChallengeCard> {

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