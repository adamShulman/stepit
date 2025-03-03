

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';
import 'package:stepit/classes/abstract_challenges/speed_challenge.dart';
import 'package:stepit/services/location_service.dart';
import 'package:stepit/services/step_tracker_service.dart';
import 'package:stepit/services/timer_service.dart';
import 'package:stepit/widgets/challenge_card.dart';
import 'package:stepit/widgets/timer_counter.dart';

class SpeedChallengeCard extends ChallengeCard<SpeedChallenge> {

  const SpeedChallengeCard({super.key, required super.challenge, super.onChallengeTap, super.builder});

  @override
  Widget buildContent(BuildContext context) {

    final stepService = context.watch<StepTrackerServiceNotifier>();

    challenge.challengePedestrianStatus = stepService.challengePedestrianStatus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Target: ${challenge.targetTime} min"),
        Text("Progress: ${challenge.progress} min"),
        challenge.challengeStatus == ChallengeStatus.active 
        ? Text("Pedestrian status: ${challenge.challengePedestrianStatus.description}") 
        : const SizedBox.shrink(),
        Text("time in seconds: ${challenge.elapsedSeconds}"),
        // const TimerCounterWidget(),
      ],
    );
      

    // return ChangeNotifierProvider(
    //   create: (_) => TimerService(),
    //   builder: (context, child) {
    //     return Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text("Target: ${challenge.targetTime} min"),
    //         Text("Progress: ${challenge.progress} min"),
    //         Text("Pedestrian status: ${challenge.challengePedestrianStatus.description}"),
    //         Text("time in seconds: ${context.read<TimerService>().elapsedSeconds}"),
    //         // const TimerCounterWidget(),
    //       ],
    //     );
    //   },
    // );
  }

  @override
  ChallengeCardState<ChallengeCard<Challenge>> createState() => _SpeedChallengeCardState();
}

class _SpeedChallengeCardState extends ChallengeCardState<SpeedChallengeCard> {

  late TimerService _timerService;
  int _elapsedSeconds = 0;

  late StreamSubscription _periodicSub;

  @override
  void initState() {
    super.initState();

    _timerService = TimerService(onTimerUpdate: onTimerUpdate);

    _periodicSub = Stream.periodic(const Duration(seconds: 2)).listen((_) {

      switch (widget.challenge.challengePedestrianStatus) {

        case ChallengePedestrianStatus.walking:
          if (_timerService.isRunning == false) {
            Future.delayed(const Duration(milliseconds: 100), () {
              _timerService.resumeTimer();
            });
            
          }
        case ChallengePedestrianStatus.stopped:
         if (_timerService.isRunning) {
            Future.delayed(const Duration(milliseconds: 100), () {
              _timerService.pauseTimer();
            });
            
          }
          
        case ChallengePedestrianStatus.unknown:
          if (_timerService.isRunning) {
            Future.delayed(const Duration(milliseconds: 100), () {
              _timerService.pauseTimer();
            });
            
          }
      }
     
    });
    
  }

  void onTimerUpdate(int elapsedTime) {

    if (widget.challenge.challengePedestrianStatus == ChallengePedestrianStatus.walking) {
      _elapsedSeconds = elapsedTime;
      widget.challenge.elapsedSeconds = elapsedTime;
    
      // if (_timerService.isRunning == false) {
      //   Future.delayed(const Duration(milliseconds: 100), () {
      //     _timerService.resumeTimer();
      //   });
        
      // }
      print("ChallengePedestrianStatus.walking");
    } else if (widget.challenge.challengePedestrianStatus == ChallengePedestrianStatus.stopped) {

      // if (_timerService.isRunning) {
      //   Future.delayed(const Duration(milliseconds: 100), () {
      //     _timerService.pauseTimer();
      //   });
      // }
      
      print("ChallengePedestrianStatus.stopped");
    } else {
      //  _timerService.pauseTimer();
        print("ChallengePedestrianStatus.unknown");
    }

    setState(() { });
      
  }

  @override
  void dispose() {
    _timerService.stopTimer();
    _periodicSub.cancel();
    super.dispose();
  }

  @override
  void pauseChallenge() {
    super.pauseChallenge();

    _timerService.pauseTimer();

    context.read<StepTrackerServiceNotifier>().pausePedestrianStatusTracking();

    context.read<LocationService>().stopTracking();
  }
  
  @override
  void startChallenge() {
    super.startChallenge();

    _timerService.startTimer();

    context.read<StepTrackerServiceNotifier>().startPedestrianStateTracking();

    final locationService = context.read<LocationService>();
    locationService.currentChallenge = widget.challenge;
    locationService.startTracking();

  }

  @override
  void resumeChallenge() {
    super.resumeChallenge();

    _timerService.resumeTimer();

    context.read<StepTrackerServiceNotifier>().resumePedestrianStatusTracking();
    context.read<LocationService>().startTracking();
  }

  @override
  void endChallenge() {
    super.endChallenge();

    _timerService.stopTimer();
    context.read<LocationService>().stopTracking();
  }

  @override
  void completeChallenge() {
    super.completeChallenge();

    _timerService.stopTimer();

    context.read<LocationService>().stopTracking();
    
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
}