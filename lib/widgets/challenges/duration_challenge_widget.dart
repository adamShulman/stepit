
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

  @override
  void startChallenge() {
    super.startChallenge();
    context.read<StepTrackerServiceNotifier>().startTracking();

    final locationService = context.read<LocationService>();
    locationService.currentChallenge = widget.challenge;

    locationService.startTracking();

    context.read<TimerService>().startTimer(widget.challenge.id, reset: true);
  }

  @override
  void pauseChallenge() {
    super.pauseChallenge();
    context.read<StepTrackerServiceNotifier>().pauseTracking();
    context.read<LocationService>().stopTracking();
    context.read<TimerService>().pauseTimer();
  }
  
  @override
  void resumeChallenge() {
    super.resumeChallenge();
    context.read<StepTrackerServiceNotifier>().resumeTracking();
    context.read<LocationService>().startTracking();
    context.read<TimerService>().resumeTimer(widget.challenge.id);
  }

  @override
  void endChallenge() {
    super.endChallenge();
    context.read<StepTrackerServiceNotifier>().endTracking();
    context.read<LocationService>().stopTracking();
    context.read<TimerService>().stopTimer();
  }

  @override
  void completeChallenge() {
    super.completeChallenge();
    context.read<StepTrackerServiceNotifier>().completeTracking();
    context.read<LocationService>().stopTracking();
    context.read<TimerService>().stopTimer();
  }

}