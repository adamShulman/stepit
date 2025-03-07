
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
    challenge.progress = stepService.currentSteps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Target Steps: ${challenge.targetSteps}"),
        Text("Progress: ${stepService.currentSteps} steps"),
        Text("Started time: ${challenge.getFormattedStartTime() ?? 0}"),
      ],
    );
  }

  @override
  ChallengeCardState<ChallengeCard<Challenge>> createState() => StepsChallengeCardState();
  
}

class StepsChallengeCardState extends ChallengeCardState<StepsChallengeCard> {

  @override
  void initState() {
    super.initState();
    
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void pauseChallenge() {
    super.pauseChallenge();

    // _isTracking = false;
    context.read<StepTrackerServiceNotifier>().pauseTracking();
    context.read<LocationService>().stopTracking();
  }
  
  @override
  void startChallenge() {
    super.startChallenge();

    // _isTracking = true;
    context.read<StepTrackerServiceNotifier>().startTracking();
    // final locationService = context.watch<LocationService>();

    final locationService = context.read<LocationService>();
    locationService.currentChallenge = widget.challenge;

    locationService.startTracking();
    
  }

  @override
  void resumeChallenge() {
    super.resumeChallenge();

    // _isTracking = true;
    context.read<StepTrackerServiceNotifier>().resumeTracking();
    context.read<LocationService>().startTracking();
  }

  @override
  void endChallenge() {
    super.endChallenge();

    // _isTracking = false;
    context.read<StepTrackerServiceNotifier>().endTracking();
    context.read<LocationService>().stopTracking();
  }

  @override
  void completeChallenge() {
    super.completeChallenge();

    // _isTracking = false;
    context.read<StepTrackerServiceNotifier>().completeTracking();
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

// class StepsChallengeCard extends ChallengeCard<StepsChallenge> {
//   const StepsChallengeCard({
//     super.key,
//     required super.challenge,
//     required super.canNavigate,
//     super.callback,
//   });

//   @override
//   Widget buildContent(BuildContext context) {
//     final stepService = context.watch<StepTrackerServiceNotifier>();
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Target Steps: ${challenge.targetSteps}"),
//         Text("Progress: ${stepService.currentSteps} steps"),
//         Text("Started time: ${challenge.getFormattedStartTime() ?? 0}"),
//         // Add StepTrackingButton for start/stop
//         // _StepTrackingButton(),
//         // Display the current step count
//         // _StepProgress(),
//       ],
//     );
//   }

//   @override
//   ChallengeCardState<ChallengeCard<Challenge>> createState() => _StepsChallengeCardState();
// }

// class _StepsChallengeCardState extends ChallengeCardState<StepsChallengeCard> {

//   @override
//   Widget build(BuildContext context) {
    
//     // You can use context.watch or Consumer here to watch the state changes
//     return super.build(context);
//   }

//   // 
// }


// class _StepProgress extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final stepService = context.watch<StepTrackerServiceNotifier>();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Steps Taken: ${stepService.currentSteps}', style: const TextStyle(fontSize: 16)),
//         // Optionally, add a progress bar or circular progress indicator here.
//       ],
//     );
//   }
// }