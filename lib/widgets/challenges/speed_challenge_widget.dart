
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';
import 'package:stepit/classes/abstract_challenges/challenge_enums/challenge_pedestrian_status.dart';
import 'package:stepit/classes/abstract_challenges/speed_challenge.dart';
import 'package:stepit/services/location_service.dart';
import 'package:stepit/services/pedestrian_status_service.dart';
import 'package:stepit/services/step_tracker_service.dart';
import 'package:stepit/services/timer_service.dart';
import 'package:stepit/widgets/challenge_card.dart';

class SpeedChallengeCard extends ChallengeCard<SpeedChallenge> {

  const SpeedChallengeCard({super.key, required super.challenge, super.onChallengeTap, super.builder});

  @override
  Widget buildContent(BuildContext context) {

    // final stepService = context.watch<StepTrackerServiceNotifier>();

    // challenge.challengePedestrianStatus.value = stepService.challengePedestrianStatus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Target: ${challenge.targetDuration} min"),
        // Text("Progress: ${challenge.progress} min"),
        ValueListenableBuilder(
          valueListenable: challenge.challengePedestrianStatus,
          builder: (context, value, child) {
            return Text("Pedestrian status: ${challenge.challengePedestrianStatus.value.description}"); 
          },
        ),
        // challenge.challengeStatus == ChallengeStatus.active 
        // ? Text("Pedestrian status: ${challenge.challengePedestrianStatus.value.description}") 
        // : const SizedBox.shrink(),
        // Text("time in seconds: ${challenge.elapsedSeconds}"),
        // const TimerCounterWidget(),
        Builder(
          builder: (context) {
            return Consumer<TimerService>(
              builder: (context, timerService, child) {
               challenge.elapsedSeconds = timerService.elapsedSeconds;
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

  LocationService get _locationService {
    return context.read<LocationService>();
  }

  StepTrackerServiceNotifier get _stepTrackerService {
    return context.read<StepTrackerServiceNotifier>();
  }

  PedestrianTrackerServiceNotifier get _pedestrianStatusService {
    return context.read<PedestrianTrackerServiceNotifier>();
  }

  TimerService get _timerService {
    return context.read<TimerService>();
  }

  void _onStatusNotified() {

    final challengePedestrianStatus = widget.challenge.challengePedestrianStatus.value;

    switch (challengePedestrianStatus) {
      
      case ChallengePedestrianStatus.walking:
        _timerService.resumeTimer(widget.challenge.id, elapsedSeconds: widget.challenge.elapsedSeconds);
      case ChallengePedestrianStatus.stopped:
        _timerService.pauseTimer();
      case ChallengePedestrianStatus.unknown:
        _timerService.pauseTimer();
    }
  }

  // @override
  // void dispose() {
  //   // widget.challenge.challengePedestrianStatus.removeListener(_onStatusNotified);
  //   super.dispose();
  // }

  @override
  void startChallenge() {
    super.startChallenge();

    final challengePedestrianStatus = widget.challenge.challengePedestrianStatus.value;

    if(challengePedestrianStatus == ChallengePedestrianStatus.walking) {
      _timerService.startTimer(widget.challenge.id, elapsedSeconds: widget.challenge.elapsedSeconds);
    }

    _stepTrackerService.startTracking(widget.challenge, progress: widget.challenge.progress);
    _pedestrianStatusService.startTracking(widget.challenge);
    _locationService.startTracking();

    widget.challenge.challengePedestrianStatus.addListener(_onStatusNotified);

  }

  @override
  void pauseChallenge() {
    super.pauseChallenge();

    _timerService.pauseTimer();
    _stepTrackerService.pauseTracking();
    _pedestrianStatusService.pauseTracking();
    _locationService.pauseTracking();
    widget.challenge.challengePedestrianStatus.removeListener(_onStatusNotified);
    
  }
  
  @override
  void resumeChallenge() {
    super.resumeChallenge();

    final challengePedestrianStatus = widget.challenge.challengePedestrianStatus.value;
    if(challengePedestrianStatus == ChallengePedestrianStatus.walking) {
      _timerService.resumeTimer(widget.challenge.id, elapsedSeconds: widget.challenge.elapsedSeconds);
    }

    _pedestrianStatusService.resumeTracking(widget.challenge);
    _stepTrackerService.resumeTracking(widget.challenge, progress: widget.challenge.progress);
    _locationService.resumeTracking();

    widget.challenge.challengePedestrianStatus.addListener(_onStatusNotified);
  }

  @override
  void endChallenge() {
    super.endChallenge();
    _timerService.stopTimer();
    _locationService.endTracking();
    _pedestrianStatusService.endTracking();
    widget.challenge.challengePedestrianStatus.removeListener(_onStatusNotified);
  }

  @override
  void completeChallenge() {
    super.completeChallenge();
    _timerService.stopTimer();
    _locationService.completeTracking();
    _pedestrianStatusService.completeTracking();
    widget.challenge.challengePedestrianStatus.removeListener(_onStatusNotified);
  }
}