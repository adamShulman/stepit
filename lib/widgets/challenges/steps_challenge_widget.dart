
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';
import 'package:stepit/classes/abstract_challenges/challenge_enums/challenge_status.dart';
import 'package:stepit/classes/abstract_challenges/steps_challenge.dart';
import 'package:stepit/services/location_service.dart';
import 'package:stepit/services/step_tracker_service.dart';
import 'package:stepit/utils/utils.dart';
import 'package:stepit/widgets/challenge_card.dart';

class StepsChallengeCard extends ChallengeCard<StepsChallenge> {
  
  const StepsChallengeCard({super.key, required super.challenge, super.onChallengeTap, super.builder});

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Target Steps: ${challenge.targetSteps}"),
        ListenableBuilder(
          listenable: challenge,
          builder: (context, child) {
            return Text('Progress: ${challenge.progress} steps');
          },
        ),
        Text("Started time: ${ChallengeUtils.formatChallengeTime(challenge.startTime)}"),
      ],
    );
  }

  @override
  ChallengeCardState<ChallengeCard<Challenge>> createState() => _StepsChallengeCardState();
}

class _StepsChallengeCardState extends ChallengeCardState<StepsChallengeCard> {

  late LocationService _locationService;
  late StepTrackerServiceNotifier _stepTrackerService;

  @override
  void didChangeDependencies() {
    _locationService = context.read<LocationService>();
    _stepTrackerService = context.read<StepTrackerServiceNotifier>();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    widget.challenge.addListener(_onStatusNotified);
  }

  void _onLocationUpdate() {
    final location = _locationService.currentPosition;
    if (location != null) {
       widget.challenge.updateChallengeLocation(location.latitude, location.longitude);
    }
  }

  void _onStatusNotified() {
    if (widget.challenge.progress >= widget.challenge.targetSteps) {
      if (widget.challenge.challengeStatus != ChallengeStatus.completed) {
        widget.challenge.removeListener(_onStatusNotified);
        widget.challenge.progress = widget.challenge.targetSteps;
        completeChallenge();
      }
    }
  }

  @override
  void startChallenge() {
    super.startChallenge();
    _stepTrackerService.startTracking(widget.challenge, progress: widget.challenge.progress);
    _locationService.startTracking();
    _locationService.addListener(_onLocationUpdate);
  }

  @override
  void pauseChallenge() {
    super.pauseChallenge();
    _stepTrackerService.pauseTracking();
    _locationService.pauseTracking();
    _locationService.removeListener(_onLocationUpdate);
  }

  @override
  void resumeChallenge() {
    super.resumeChallenge();
    _stepTrackerService.resumeTracking(widget.challenge, progress: widget.challenge.progress);
    _locationService.resumeTracking();
    _locationService.addListener(_onLocationUpdate);
  }

  @override
  void endChallenge() {
    super.endChallenge();
    _stepTrackerService.endTracking();
    _locationService.endTracking();
    _locationService.removeListener(_onLocationUpdate);
  }

  @override
  void completeChallenge() {
    super.completeChallenge();
    _stepTrackerService.completeTracking();
    _locationService.completeTracking();
    _locationService.removeListener(_onLocationUpdate);
  }

  @override
  void dispose() {
    widget.challenge.removeListener(_onStatusNotified);
    _locationService.removeListener(_onLocationUpdate);
    super.dispose();
  }
}
