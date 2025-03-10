
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';
import 'package:stepit/classes/abstract_challenges/steps_challenge.dart';
import 'package:stepit/services/location_service.dart';
import 'package:stepit/services/step_tracker_service.dart';
import 'package:stepit/widgets/challenge_card.dart';

class StepsChallengeCard extends ChallengeCard<StepsChallenge> {
  
  const StepsChallengeCard({super.key, required super.challenge, super.onChallengeTap, super.builder});

  @override
  Widget buildContent(BuildContext context) {
    
    final stepService = context.watch<StepTrackerServiceNotifier>();
    // final currentPosition = context.watch<LocationService>().currentPosition;
   
    if (stepService.currentSteps >= challenge.targetSteps) {
      challenge.progress = challenge.targetSteps;
      challenge.statusNotify(ChallengeStatus.completed);
      // challenge.challengeStatusNotifier.value = ChallengeStatus.completed;
    } else {
      challenge.progress = stepService.currentSteps;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Target Steps: ${challenge.targetSteps}"),
        // Text("Progress: ${stepService.currentSteps} steps"),
        ListenableBuilder(
          listenable: stepService,
          builder: (context, child) {
            return Text('Progress: ${challenge.progress} steps');
          },
        ),
        Text("Started time: ${challenge.getFormattedStartTime() ?? 0}"),
        // SizedBox(
        //   width: 50.0,
        //   height: 50.0,
        //   child: AspectRatio(
        //     aspectRatio: 1.0,
        //     child: CustomPaint(
        //       painter: RingPainter(
        //         progress: (challenge.progress * 100) / challenge.targetSteps / 100,
        //         taskCompletedColor: Colors.yellow,
        //         taskNotCompletedColor: Colors.orange
        //       )
        //     ),
        //   )
        // )
        
       
      ],
    );
  }

  @override
  ChallengeCardState<ChallengeCard<Challenge>> createState() => StepsChallengeCardState();
  
}

class StepsChallengeCardState extends ChallengeCardState<StepsChallengeCard> {

  // @override
  // void initState() {
  //   super.initState();

  //   // final stepService = context.watch<StepTrackerServiceNotifier>();
  //   // // final currentPosition = context.watch<LocationService>().currentPosition;

  //   // stepService.addListener(_onStatusNotified);
   
  //   // if (stepService.currentSteps >= widget.challenge.targetSteps) {
  //   //   widget.challenge.progress = widget.challenge.targetSteps;
  //   //   widget.challenge.statusNotify(ChallengeStatus.completed);
  //   //   // challenge.challengeStatusNotifier.value = ChallengeStatus.completed;
  //   // } else {
  //   //   widget.challenge.progress = stepService.currentSteps;
  //   // }
  // }

  // void _onStatusNotified() {

  //   final challengePedestrianStatus = widget.challenge.challengePedestrianStatus.value;
  //   final timerService = context.read<TimerService>();

  //   switch (challengePedestrianStatus) {
      
  //     case ChallengePedestrianStatus.walking:
  //       timerService.resumeTimer(widget.challenge.id);
  //     case ChallengePedestrianStatus.stopped:
  //       timerService.pauseTimer();
  //     case ChallengePedestrianStatus.unknown:
  //       timerService.pauseTimer();
  //   }
  // }

  @override
  void startChallenge() {
    super.startChallenge();
    context.read<StepTrackerServiceNotifier>().startTracking();

    final locationService = context.read<LocationService>();
    locationService.currentChallenge = widget.challenge;

    locationService.startTracking();
  }

  @override
  void pauseChallenge() {
    super.pauseChallenge();
    context.read<StepTrackerServiceNotifier>().pauseTracking();
    context.read<LocationService>().stopTracking();
  }
  


  @override
  void resumeChallenge() {
    super.resumeChallenge();
    context.read<StepTrackerServiceNotifier>().resumeTracking();
    context.read<LocationService>().startTracking();
  }

  @override
  void endChallenge() {
    super.endChallenge();
    context.read<StepTrackerServiceNotifier>().endTracking();
    context.read<LocationService>().stopTracking();
  }

  @override
  void completeChallenge() {
    super.completeChallenge();
    context.read<StepTrackerServiceNotifier>().completeTracking();
    context.read<LocationService>().stopTracking();
  }
}
