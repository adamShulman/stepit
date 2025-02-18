
import 'package:flutter/material.dart';
import 'package:stepit/classes/challenge.dart';
import 'package:stepit/utils/utils.dart';
import 'package:stepit/widgets/background_gradient_container.dart';
import 'package:stepit/widgets/challenge_cards.dart';

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
            Hero(
              tag: widget.challenge.id,
              child: ChallengeUtils.buildChallengeWidget(
                widget.challenge, 
                callback: () => (),
                canNavigate: false
              )
            ),
            // SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: ElevatedButton(
                onPressed: () {
                  switch (widget.challenge.challengeStatus) {
                    case ChallengeStatus.inactive:
                      setState(() {
                        widget.challenge.start();
                      });
                    case ChallengeStatus.active:
                      setState(() {
                        widget.challenge.end();
                      });
                    case ChallengeStatus.completed:
                      setState(() {
                        // widget.challenge.end();
                      });
                    case ChallengeStatus.ended:
                      setState(() {
                        // widget.challenge.end();
                      });
                  }
                },
                  child: Text(buttonText()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22577A),
                    foregroundColor: Colors.white
                ),
              )
            ),
            
          ],
        ),
      ),
    );
  }

  String buttonText() {
    switch (widget.challenge.challengeStatus) {
      case ChallengeStatus.inactive:
        return "Start Challenge";
      case ChallengeStatus.active:
        return "Stop Challenge";
      case ChallengeStatus.completed:
        return "Challenge Completed";
      case ChallengeStatus.ended:
        return "Challenge Ended";
    }
  }
}

