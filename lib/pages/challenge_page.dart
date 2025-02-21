
import 'package:flutter/material.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';
import 'package:stepit/classes/challenge_singleton.dart';
import 'package:stepit/utils/utils.dart';
import 'package:stepit/widgets/background_gradient_container.dart';

class ChallengePages extends StatefulWidget {

  final Challenge challenge;
  
  const ChallengePages({ super.key, required this.challenge });

  @override
  State<StatefulWidget> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePages> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Challenge overview',
          style: TextStyle(
            color: Colors.black,
            textBaseline: TextBaseline.alphabetic,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            // shadows: [
            //   Shadow(
            //     offset: Offset(1.0, 1.0),
            //     blurRadius: 1.0,
            //     color: Color.fromARGB(255, 0, 0, 0),
            //   ),
            // ],
          )
        ),
      ),
      body: BackgroundGradientContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero(
            //   tag: widget.challenge.id,
            //   child: KeyedSubtree(
            //     key: chKey,
            //     child: ChallengeUtils.buildChallengeWidget(
            //       widget.challenge, 
            //       callback: () => (),
            //       canNavigate: true
            //     ),
            //   )
            // ),
            Hero(
              // key: ValueKey(widget.challenge.id),
              tag: widget.challenge.id,
              child: ChallengeUtils.buildChallengeWidget(
                widget.challenge, 
                callback: () => (),
                canNavigate: false
              )
            ),
            // SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                onPressed: () {
                  if (LazySingleton.instance.anotherChallengeInProgress(widget.challenge.id)) { return; }

                  switch (widget.challenge.challengeStatus) {
                    case ChallengeStatus.inactive:
                      widget.challenge.startChallenge();
                    case ChallengeStatus.active:
                      widget.challenge.pauseChallenge();
                    case ChallengeStatus.completed:
                      break;
                      // widget.challenge.continueChallenge();
                    case ChallengeStatus.ended:
                      break;
                      // widget.challenge.continueChallenge();
                    case ChallengeStatus.paused:
                       widget.challenge.continueChallenge();
                  }

                  setState(() { });

                },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LazySingleton.instance.isThereActiveChallenge() ? Colors.blueGrey :  const Color(0xFF22577A),
                    foregroundColor: Colors.white
                ),
                  child: Text(buttonText()),
              )
            ),
            
          ],
        ),
      ),
    );
  }

  String buttonText() {
    if (LazySingleton.instance.anotherChallengeInProgress(widget.challenge.id)) {
      return "Another challenge in progress";
    } else {
        switch (widget.challenge.challengeStatus) {
        case ChallengeStatus.inactive:
          return "Start Challenge";
        case ChallengeStatus.active:
          return "Stop Challenge";
        case ChallengeStatus.completed:
          return "Challenge Completed";
        case ChallengeStatus.ended:
          return "Continue Challenge";
        case ChallengeStatus.paused:
          return "Continue Challenge";
      }
    }
    
  }
}

