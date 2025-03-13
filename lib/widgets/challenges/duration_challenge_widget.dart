
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';
import 'package:stepit/classes/abstract_challenges/duration_challenge.dart';
import 'package:stepit/services/location_service.dart';
import 'package:stepit/services/step_tracker_service.dart';
import 'package:stepit/services/timer_service.dart';
import 'package:stepit/widgets/challenge_card.dart';


class DurationChallengeCard extends ChallengeCard<DurationChallenge> {

  const DurationChallengeCard({super.key, required super.challenge, super.onChallengeTap, super.builder});

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Target steps: ${challenge.targetSteps}"),
        Text("Target duration: ${challenge.targetDuration} minutes"),
        // Text("Progress: ${challenge.progress} steps"),
        
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
  }

  @override
  ChallengeCardState<ChallengeCard<Challenge>> createState() => _DurationChallengeCardState();
}

class _DurationChallengeCardState extends ChallengeCardState<DurationChallengeCard> {

  LocationService get _locationService {
    return context.read<LocationService>();
  }

  StepTrackerServiceNotifier get _stepTrackerService {
    return context.read<StepTrackerServiceNotifier>();
  }

  TimerService get _timerService {
    return context.read<TimerService>();
  }

  @override
  void startChallenge() {
    super.startChallenge();
    _stepTrackerService.startTracking(widget.challenge);
    _locationService.startTracking();
    _timerService.startTimer(widget.challenge.id, elapsedSeconds: widget.challenge.elapsedSeconds);
  }

  @override
  void pauseChallenge() {
    super.pauseChallenge();
    _stepTrackerService.pauseTracking();
    _locationService.pauseTracking();
    _timerService.pauseTimer();
  }
  
  @override
  void resumeChallenge() {
    super.resumeChallenge();
    _stepTrackerService.resumeTracking(widget.challenge);
    _locationService.resumeTracking();
    _timerService.resumeTimer(widget.challenge.id, elapsedSeconds: widget.challenge.elapsedSeconds);
  }

  @override
  void endChallenge() {
    super.endChallenge();
    _stepTrackerService.endTracking();
    _locationService.endTracking();
    _timerService.stopTimer();
  }

  @override
  void completeChallenge() {
    super.completeChallenge();
    _stepTrackerService.completeTracking();
    _locationService.completeTracking();
    _timerService.stopTimer();
  }
}