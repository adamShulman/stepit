
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';
import 'package:stepit/classes/abstract_challenges/distance_challenge.dart';
import 'package:stepit/services/location_service.dart';
import 'package:stepit/services/step_tracker_service.dart';
import 'package:stepit/widgets/challenge_card.dart';


class DistanceChallengeCard extends ChallengeCard<DistanceChallenge> {

  const DistanceChallengeCard({super.key, required super.challenge, super.onChallengeTap, super.builder});

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Target: ${challenge.targetDistance} km"),
        Text("Progress: ${challenge.progress} km"),
      ],
    );
  }

  @override
  ChallengeCardState<ChallengeCard<Challenge>> createState() => _DistanceChallengeCardState();
}

class _DistanceChallengeCardState extends ChallengeCardState<DistanceChallengeCard> {

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