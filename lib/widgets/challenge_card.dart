
import 'package:flutter/material.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';
import 'package:stepit/classes/challenge_singleton.dart';
import 'package:stepit/utils/utils.dart';
// import 'package:wakelock_plus/wakelock_plus.dart';

typedef ChildCallbackBuilder = void Function(BuildContext context, void Function() methodFromChild);

abstract class ChallengeCard<T extends Challenge> extends StatefulWidget {

  final T challenge;

  final VoidCallback? onChallengeTap;
  
  final ChildCallbackBuilder? builder;

  const ChallengeCard({super.key, required this.challenge, this.onChallengeTap, this.builder});

  Widget buildContent(BuildContext context); 

  @override
  ChallengeCardState createState();

}

abstract class ChallengeCardState<T extends ChallengeCard> extends State<T> {

  void startChallenge() {
    widget.challenge.start();
    // WakelockPlus.enable();
  }

  void pauseChallenge() {
    widget.challenge.pause();
    // WakelockPlus.disable();
  }

  void resumeChallenge() {
    widget.challenge.resume();
    // WakelockPlus.enable();
  }

  void endChallenge() {
    widget.challenge.end();
    // WakelockPlus.disable();
  }

  void completeChallenge() {
    widget.challenge.complete();
    // WakelockPlus.disable();
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            ],
          ),
        ),
      ),
    );
  }
}
