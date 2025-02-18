
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stepit/challenges/game_01_steps.dart';
import 'package:stepit/classes/challenge.dart';
import 'package:stepit/classes/game.dart';
import 'package:stepit/features/challenge_tile.dart';
import 'package:stepit/pages/challenge_page.dart';
import 'package:stepit/utils/utils.dart';

abstract class ChallengeCard<T extends Challenge> extends StatefulWidget {

  final T challenge;

  final bool canNavigate;

  final void Function()? callback;

  const ChallengeCard({Key? key, required this.challenge, required this.canNavigate, this.callback}) : super(key: key);

  Widget buildContent(); // Each subclass will implement this

  // @override State<ChallengeCard> createState() => _ChallengeCardState();

  @override
  ChallengeCardState createState();

}

abstract class ChallengeCardState<T extends ChallengeCard> extends State<T> {

  @override
  Widget build(BuildContext context) {
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
                    ChallengeUtils.imageNameFor(widget.challenge), // Replace with your image path
                    width: 30, // Adjust the width as needed
                    height: 30, // Adjust the height as needed
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(widget.challenge.description, style: const TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 8),
              Text("Challenge type: ${widget.challenge.challengeType.description}", style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              widget.buildContent(), // Call the subclass implementation
              const SizedBox(height: 12),
              Text("Status: ${widget.challenge.challengeStatus.description}",
                  style: TextStyle(color: Colors.black)),
              // Text("Completed: ${widget.challenge.challengeStatus.description ? "✅" : "❌"}",
                  // style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }
}
/*
class _ChallengeCardState extends State<ChallengeCard> {

  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChallengePages(challenge: widget.challenge)
          ),
        );
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
                    ChallengeUtils.imageNameFor(widget.challenge), // Replace with your image path
                    width: 30, // Adjust the width as needed
                    height: 30, // Adjust the height as needed
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(widget.challenge.description, style: const TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(height: 8),
              Text("Challenge type: ${widget.challenge.challengeType.description}", style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              widget.buildContent(), // Call the subclass implementation
              const SizedBox(height: 12),
              Text("Completed: ${widget.challenge.completed ? "✅" : "❌"}",
                  style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }
}
*/