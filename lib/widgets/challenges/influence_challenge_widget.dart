
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';
import 'package:stepit/classes/abstract_challenges/influence_challenge.dart';
import 'package:stepit/services/location_service.dart';
import 'package:stepit/services/step_tracker_service.dart';
import 'package:stepit/widgets/challenge_card.dart';


class InfluenceChallengeCard extends ChallengeCard<InfluenceChallenge> {

  const InfluenceChallengeCard({super.key, required super.challenge, super.onChallengeTap, super.builder});

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Required Photos: ${challenge.requiredPhotos}"),
        Text("Photos Taken: ${challenge.photosTaken}"),
        Text("Step Limit: ${challenge.stepLimit}"),
        Text("Steps Used: ${challenge.progress}"),
      ],
    );
  }

  @override
  ChallengeCardState<ChallengeCard<Challenge>> createState() => _InfluenceChallengeCardState();
}

class _InfluenceChallengeCardState extends ChallengeCardState<InfluenceChallengeCard> {

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