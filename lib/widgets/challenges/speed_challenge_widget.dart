
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';
import 'package:stepit/classes/abstract_challenges/speed_challenge.dart';
import 'package:stepit/services/location_service.dart';
import 'package:stepit/services/step_tracker_service.dart';
import 'package:stepit/services/timer_service.dart';
import 'package:stepit/widgets/challenge_card.dart';

class SpeedChallengeCard extends ChallengeCard<SpeedChallenge> {

  const SpeedChallengeCard({super.key, required super.challenge, super.onChallengeTap, super.builder});

  @override
  Widget buildContent(BuildContext context) {

    final stepService = context.watch<StepTrackerServiceNotifier>();

    challenge.challengePedestrianStatus.value = stepService.challengePedestrianStatus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Target: ${challenge.targetDuration} min"),
        Text("Progress: ${challenge.progress} min"),
        challenge.challengeStatus == ChallengeStatus.active 
        ? Text("Pedestrian status: ${challenge.challengePedestrianStatus.value.description}") 
        : const SizedBox.shrink(),
        // Text("time in seconds: ${challenge.elapsedSeconds}"),
        // const TimerCounterWidget(),
        Builder(
          builder: (context) {
            return Consumer<TimerService>(
              builder: (context, timerService, child) {
               return timerService.currentChallengeId == challenge.id ?
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Elapsed Time: ${timerService.elapsedSeconds} seconds'
                    ),
                    // const SizedBox(height: 20),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     ElevatedButton(
                    //       onPressed: timerService.isRunning
                    //           ? timerService.pauseTimer
                    //           : () => timerService.startTimer(autoStopAfterSeconds: 10),
                    //       child: Text(timerService.isRunning ? 'Pause' : 'Start (Auto-stop in 10s)'),
                    //     ),
                    //     const SizedBox(width: 10),
                    //     ElevatedButton(
                    //       onPressed: timerService.resumeTimer,
                    //       child: const Text('Resume'),
                    //     ),
                    //     const SizedBox(width: 10),
                    //     ElevatedButton(
                    //       onPressed: timerService.stopTimer,
                    //       child: const Text('Stop'),
                    //     ),
                    //   ],
                    // ),
                  ],
                )
                : const SizedBox.shrink();
              },
            );
          },
        ),
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

  @override
  void initState() {
    super.initState();
    widget.challenge.challengePedestrianStatus.addListener(_onStatusNotified);
  }

  void _onStatusNotified() {

    final challengePedestrianStatus = widget.challenge.challengePedestrianStatus.value;
    final timerService = context.read<TimerService>();

    switch (challengePedestrianStatus) {
      
      case ChallengePedestrianStatus.walking:
        timerService.resumeTimer(widget.challenge.id);
      case ChallengePedestrianStatus.stopped:
        timerService.pauseTimer();
      case ChallengePedestrianStatus.unknown:
        timerService.pauseTimer();
    }
  }

  @override
  void dispose() {
    widget.challenge.challengePedestrianStatus.removeListener(_onStatusNotified);
    super.dispose();
  }

  @override
  void startChallenge() {
    super.startChallenge();

    final challengePedestrianStatus = widget.challenge.challengePedestrianStatus.value;

    if(challengePedestrianStatus == ChallengePedestrianStatus.walking) {
      context.read<TimerService>().startTimer(widget.challenge.id, reset: true);
    }

    context.read<StepTrackerServiceNotifier>().startPedestrianStateTracking();

    final locationService = context.read<LocationService>();
    locationService.currentChallenge = widget.challenge;
    locationService.startTracking();

  }

  @override
  void pauseChallenge() {
    super.pauseChallenge();

    context.read<TimerService>().pauseTimer();

    context.read<StepTrackerServiceNotifier>().pausePedestrianStatusTracking();

    context.read<LocationService>().stopTracking();
    
  }
  
  @override
  void resumeChallenge() {
    super.resumeChallenge();

    final challengePedestrianStatus = widget.challenge.challengePedestrianStatus.value;

    if(challengePedestrianStatus == ChallengePedestrianStatus.walking) {
      context.read<TimerService>().resumeTimer(widget.challenge.id);
    }

    context.read<StepTrackerServiceNotifier>().resumePedestrianStatusTracking();
    context.read<LocationService>().startTracking();
  }

  @override
  void endChallenge() {
    super.endChallenge();
    context.read<TimerService>().stopTimer();
    context.read<LocationService>().stopTracking();
  }

  @override
  void completeChallenge() {
    super.completeChallenge();
    context.read<TimerService>().stopTimer();
    context.read<LocationService>().stopTracking();
  }
}