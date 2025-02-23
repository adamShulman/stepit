
import 'package:flutter/material.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';
import 'package:stepit/classes/challenge_singleton.dart';
import 'package:stepit/pages/challenge_page.dart';
import 'package:stepit/utils/utils.dart';

typedef MyBuilder = void Function(BuildContext context, void Function() methodFromChild);

abstract class ChallengeCard<T extends Challenge> extends StatefulWidget {

  final T challenge;

  final bool canNavigate;

  final void Function()? callback;
  
  final MyBuilder? builder;

  const ChallengeCard({super.key, required this.challenge, required this.canNavigate, this.callback, this.builder});

  Widget buildContent(BuildContext context); 

  @override
  ChallengeCardState createState();

}

abstract class ChallengeCardState<T extends ChallengeCard> extends State<T> {

  void startChallenge() {
    widget.challenge.start();
  }

  void pauseChallenge() {
    widget.challenge.pause();
  }

  void resumeChallenge() {
    widget.challenge.resume();
  }

  void endChallenge() {
    widget.challenge.end();
  }

  void completeChallenge() {
    widget.challenge.complete();
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
          // widget.challenge.continueChallenge();
        case ChallengeStatus.ended:
          break;
          // widget.challenge.continueChallenge();
        case ChallengeStatus.paused:
            resumeChallenge();
      }

      // setState(() { });

  }

  @override
  Widget build(BuildContext context) {

    widget.builder?.call(context, toggleChallenge);

    return GestureDetector(
      onTap: () {
        if (widget.canNavigate) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChallengePages(challenge: widget.challenge)
            ),
          );
        }
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
                  Text(widget.challenge.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Image.asset(
                    ChallengeUtils.imageNameFor(widget.challenge), 
                    width: 30, 
                    height: 30, 
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(widget.challenge.description, style: const TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 8),
              Text("Challenge type: ${widget.challenge.challengeType.description}", style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              widget.buildContent(context),
              const SizedBox(height: 12),
              Text("Status: ${widget.challenge.challengeStatus.description}",
                  style: const TextStyle(color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }
}
