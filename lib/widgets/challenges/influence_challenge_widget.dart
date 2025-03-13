
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

  LocationService get _locationService {
    return context.read<LocationService>();
  }

  StepTrackerServiceNotifier get _stepTrackerService {
    return context.read<StepTrackerServiceNotifier>();
  }

  @override
  void startChallenge() {
    super.startChallenge();
    _stepTrackerService.startTracking(widget.challenge);
    _locationService.startTracking();
  }

  @override
  void pauseChallenge() {
    super.pauseChallenge();
    _stepTrackerService.pauseTracking();
    _locationService.pauseTracking();
  }
  
  @override
  void resumeChallenge() {
    super.resumeChallenge();
    _stepTrackerService.resumeTracking(widget.challenge);
    _locationService.resumeTracking();
  }

  @override
  void endChallenge() {
    super.endChallenge();
    _stepTrackerService.endTracking();
    _locationService.endTracking();
  }

  @override
  void completeChallenge() {
    super.completeChallenge();
    _stepTrackerService.completeTracking();
    _locationService.completeTracking();
  }

}