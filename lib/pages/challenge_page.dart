
import 'package:flutter/material.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';
import 'package:stepit/utils/utils.dart';
import 'package:stepit/widgets/app_bar.dart';
import 'package:stepit/widgets/background_gradient_container.dart';
import 'package:stepit/widgets/challenge_button.dart';

class ChallengePages extends StatefulWidget {

  final Challenge challenge;
  
  const ChallengePages({ super.key, required this.challenge });

  @override
  State<StatefulWidget> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePages> {

  late void Function() childCallback;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      appBar: const StepItAppBar(
        title: 'Overview',
      ),
      body: BackgroundGradientContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              // key: ValueKey(widget.challenge.id),
              tag: widget.challenge.id,
              child: ChallengeUtils.buildChallengeWidget(
                widget.challenge, 
                builder: (context, callbackFromChild) {
                  childCallback = callbackFromChild;
                },
              )
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ChallengeButton(
                challenge: widget.challenge,
                onPressed: () {
                  childCallback.call();
                  setState(() { });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

