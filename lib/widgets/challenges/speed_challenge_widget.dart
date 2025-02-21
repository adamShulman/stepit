

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';
import 'package:stepit/classes/abstract_challenges/speed_challenge.dart';
import 'package:stepit/widgets/challenge_card.dart';

class SpeedChallengeCard extends ChallengeCard<SpeedChallenge> {

  const SpeedChallengeCard({super.key, required super.challenge, required super.canNavigate, super.callback});

  @override
  Widget buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Target: ${challenge.targetTime} min"),
        Text("Progress: ${challenge.progress ?? 0} min"),
      ],
    );
  }

  @override
  ChallengeCardState<ChallengeCard<Challenge>> createState() => _SpeedChallengeCardState();
}

class _SpeedChallengeCardState extends ChallengeCardState<SpeedChallengeCard> {

  int _stepCount = 0;
  
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';
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

  @override
  void dispose() {
    _periodicSub.cancel();
    super.dispose();
  }


  void _pauseChallenge() {
    // _timer?.cancel();
  }

  void _startChallenge() {
    initPlatformState();
  }

  void _completeChallenge() {

    // widget.challenge.challengeStatus = ChallengeStatus.completed;
    // widget.challenge.endTime = DateTime.now();

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

  

   void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  Future<bool> _checkActivityRecognitionPermission() async {
    bool granted = await Permission.activityRecognition.isGranted;

    if (!granted) {
      granted = await Permission.activityRecognition.request() ==
          PermissionStatus.granted;
    }

    return granted;
  }

  Future<void> initPlatformState() async {
    bool granted = await _checkActivityRecognitionPermission();
    if (!granted) {
      // tell user, the app will not work
    }

    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    (_pedestrianStatusStream.listen(onPedestrianStatusChanged))
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

}