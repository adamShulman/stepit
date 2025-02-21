

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';
import 'package:stepit/classes/abstract_challenges/steps_challenge.dart';
import 'package:stepit/widgets/challenge_card.dart';

class StepsChallengeCard extends ChallengeCard<StepsChallenge> {
  
  const StepsChallengeCard({super.key, required super.challenge, required super.canNavigate, super.callback});

  @override
  Widget buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Target Steps: ${challenge.targetSteps}"),
        Text("Progress: ${challenge.progress ?? 0} steps"),
        Text("Started time: ${challenge.getFormattedStartTime() ?? 0}"),
      ],
    );
  }

  @override
  ChallengeCardState<ChallengeCard<Challenge>> createState() => _StepsChallengeCardState();
  
}

class _StepsChallengeCardState extends ChallengeCardState<StepsChallengeCard> {

  int _stepCount = 0;

  Timer? _timer;

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
            _pauseChallenge();
          }
         
      }
     
    });
    
    super.initState();
  }

  void _startTimer() {
    const oneSecond = Duration(seconds: 1);

    _timer = Timer.periodic(oneSecond, (timer) {
      // widget.challenge.progress += 1;
    setState(() {
      widget.challenge.progress += 1;
    });
       
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _periodicSub.cancel();
    super.dispose();
  }

  // void _updateFirebase() {

  //   final userProvider = Provider.of<UserProvider>(context, listen: false);

  //   CollectionReference userChallenges = FirebaseFirestore.instance
  //     .collection("users")
  //     .doc(userProvider.user?.uniqueNumber.toString().padLeft(6, '0'))
  //     .collection("userGames");

  //   userChallenges.doc(widget.challenge.id.toString()).set({
  //     'Completed': widget.challenge.isCompleted(),
  //     'End Time': widget.challenge.endTime,
  //     'Steps Taken during Challenge': _stepCount,
  //     'status': widget.challenge.challengeStatus.description
  //   });
  // }

  void _pauseChallenge() {
    _timer?.cancel();
  }

  void _startChallenge() {
    _startTimer();
  }

  void _completeChallenge() {

    _timer?.cancel();

    // widget.challenge.challengeStatus = ChallengeStatus.completed;
    // widget.challenge.endTime = DateTime.now();

    // _updateFirebase();

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

    
    _timer?.cancel();

    // widget.challenge.challengeStatus = ChallengeStatus.ended;
    // widget.challenge.endTime = DateTime.now();

    // _updateFirebase();

  }

  // @override
  // Widget build(BuildContext context) {
  //    return super.build(context);
  // }

}