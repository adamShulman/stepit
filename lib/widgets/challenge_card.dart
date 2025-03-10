
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';
import 'package:stepit/classes/challenge_singleton.dart';
import 'package:stepit/services/dialog_service.dart';
import 'package:stepit/utils/utils.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

typedef ChildCallbackBuilder = void Function(BuildContext context, void Function() methodFromChild);

abstract class ChallengeCard<T extends Challenge> extends StatefulWidget {

  final T challenge;

  final VoidCallback? onChallengeTap;
  
  final ChildCallbackBuilder? builder;

  const ChallengeCard({super.key, required this.challenge, this.onChallengeTap, this.builder});

  Widget buildContent(BuildContext context); 

  Widget buildBottom(BuildContext context) {
    return const SizedBox.shrink();
  }

  @override
  ChallengeCardState createState();

}

abstract class ChallengeCardState<T extends ChallengeCard> extends State<T> {

  @override
  void initState() {
    super.initState();
    widget.challenge.challengeStatusNotifier.addListener(_onStatusNotified);
  }

  void _onStatusNotified() {

    final challengeStatus = widget.challenge.challengeStatusNotifier.value;

    // if (challengeStatus == _previousChallengeStatus) { return; }

    // _previousChallengeStatus = challengeStatus;

    switch (challengeStatus) {

      case ChallengeStatus.completed:
        completeChallenge();
      case ChallengeStatus.ended:
        endChallenge();
      default:
        break;
    }
     log("Property changed: $challengeStatus");

  }

  void startChallenge() {
    widget.challenge.start();
    WakelockPlus.enable();
    
  }

  void pauseChallenge() {
    widget.challenge.pause();
    WakelockPlus.disable();
  }

  void resumeChallenge() {
    widget.challenge.resume();
    WakelockPlus.enable();
  }

  void endChallenge() {
    widget.challenge.end();
    WakelockPlus.disable();
  }

  void completeChallenge() {
    widget.challenge.complete();
    WakelockPlus.disable();

    final message = 'Congratulations! You have completed the challenge. You just received ${widget.challenge.getPoints()} points.';
    const title = 'Challenge Completed!';

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Confetti.launch(
        context,
        options: const ConfettiOptions(
          particleCount: 100, spread: 70, y: 0.6,
        )
      );
      DialogService().showSingleDialog(context, title, message);
    });
  }

  void toggleChallenge() {

    if (LazySingleton.instance.anotherChallengeInProgress(widget.challenge.id)) { return; }

      switch (widget.challenge.challengeStatus) {
        case ChallengeStatus.inactive:
          startChallenge();
        case ChallengeStatus.active:
          pauseChallenge();
        case ChallengeStatus.completed:
          break;
        case ChallengeStatus.ended:
          break;
        case ChallengeStatus.paused:
          resumeChallenge();
      }
  }

  @override
  Widget build(BuildContext context) {

    widget.builder?.call(context, toggleChallenge);

    return GestureDetector(
      onTap: () {
        widget.onChallengeTap != null ? widget.onChallengeTap!() : ();
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      widget.challenge.name, 
                      style: const TextStyle(
                        fontSize: 17.0, 
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ),
                  Image.asset(
                    ChallengeUtils.imageNameFor(widget.challenge), 
                    width: 30, 
                    height: 30, 
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.challenge.description, 
                style: const TextStyle(
                  fontSize: 14.0, 
                  color: Colors.grey
                )
              ),
              const SizedBox(height: 8.0),
              Text(
                "Challenge type: ${widget.challenge.challengeType.description}", 
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500
                )
              ),
              const SizedBox(height: 8.0),
              widget.buildContent(context),
              const SizedBox(height: 12.0),
              Text(
                "Status: ${widget.challenge.challengeStatus.description}",
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black
                )
              ),
              // widget.buildBottom(context)
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.challenge.challengeStatusNotifier.removeListener(_onStatusNotified);
    super.dispose();
  }
}
