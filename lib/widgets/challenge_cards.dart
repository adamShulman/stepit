
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepit/classes/challenge.dart';
import 'package:stepit/classes/user.dart';
import 'package:stepit/features/step_count.dart';
import 'package:stepit/widgets/challenge_card.dart';


class StepsChallengeCard extends ChallengeCard<StepsChallenge> {
  
  const StepsChallengeCard({Key? key, required StepsChallenge challenge, required bool canNavigate, super.callback}) : super(key: key, challenge: challenge, canNavigate: canNavigate);

  @override
  Widget buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Target Steps: ${challenge.targetSteps}"),
        Text("Progress: ${challenge.progress ?? 0} steps"),
        Text("Started time: ${challenge.getFormattedStartTime() ?? 0}"),
      ],
    );
  }

  @override
  ChallengeCardState<ChallengeCard<Challenge>> createState() => _StepsChallengeCardState();
  
}

class _StepsChallengeCardState extends ChallengeCardState<StepsChallengeCard> {

  int _stepCount = 0;

  Timer? _timer;
  
  late StreamSubscription _periodicSub;

  @override
  void initState() {
    
    // Future.delayed(Duration.zero, () {
    //   final provider = Provider.of<StepCounterProvider>(context, listen: false);
    //   provider.stepCountStream.listen((stepCount) {
    //     setState(() {
    //       _stepCount = stepCount;
    //       widget.challenge.progress += 1;
    //     });
    //     if (_stepCount >= 5000) {
    //       _endChallenge();
    //     }
    //   });
    // });

    // Future.delayed(Durations.medium3, () {
    //   widget.challenge.progress += 1;
    // });

    if (widget.challenge.challengeStatus == ChallengeStatus.active) {

      if (_timer?.isActive ?? false) {
        _timer?.cancel();
      }

      
    }

    _periodicSub = Stream.periodic(const Duration(milliseconds: 1000)).listen((_) {
       if (widget.challenge.challengeStatus == ChallengeStatus.ended || widget.challenge.challengeStatus == ChallengeStatus.completed) {
        _timer?.cancel();
       } else if (widget.challenge.challengeStatus == ChallengeStatus.active) {
        if (_timer != null) {
          if (_timer!.isActive == false) {
            _startTimer();
          }
        }
        
       }
    });
    // int updatedNumber = Provider.of<StepCounterProvider>(context, listen: true).stepCount;
    
    super.initState();
  }

  void _startTimer() {
    const oneSecond = Duration(seconds: 1);

    _timer = Timer.periodic(oneSecond, (timer) {

    setState(() {
      widget.challenge.progress += 1;
    });
       
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _periodicSub.cancel();
    super.dispose();
  }

  void _updateFirebase() {

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    CollectionReference userChallenges = FirebaseFirestore.instance
      .collection("users")
      .doc(userProvider.user?.uniqueNumber.toString().padLeft(6, '0'))
      .collection("userGames");

    userChallenges.doc(widget.challenge.id.toString()).update({
      'Completed': true,
      'End Time': widget.challenge.endTime,
      'Steps Taken during Challenge': _stepCount,
    });
  }

  void _startChallenge() {

  }

  void _completeChallenge() {

    _timer?.cancel();

    widget.challenge.endTime = DateTime.now();

    _updateFirebase();

    String message;
    message = 'Congratulations! You have completed the challenge.';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Challenge Completed!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _endChallenge() {

    
    _timer?.cancel();

    widget.challenge.endTime = DateTime.now();

    // _updateFirebase();

    

    String message;
    message = 'Congratulations! You have completed the challenge.';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Challenge Completed!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //    return super.build(context);
  // }

}

// class SpeedChallengeCard extends ChallengeCard<SpeedChallenge> {
//   const SpeedChallengeCard({Key? key, required SpeedChallenge challenge}) : super(key: key, challenge: challenge);

//   @override
//   void initState() {

//   }

//   @override
//   Widget buildContent() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Target Distance: ${challenge.targetDistance} km"),
//         Text("Progress: ${challenge.progress ?? 0} km"),
//       ],
//     );
//   }
// }

// class DurationChallengeCard extends ChallengeCard<DurationChallenge> {
//   const DurationChallengeCard({Key? key, required DurationChallenge challenge}) : super(key: key, challenge: challenge);

//   @override
//   Widget buildContent() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Text("Target Distance: ${challenge.targetDistance} km"),
//         Text("Progress: ${challenge.progress ?? 0} km"),
//       ],
//     );
//   }
  
//   @override
//   void initState() {
//     // TODO: implement initState
//   }
// }


// class DistanceChallengeCard extends ChallengeCard<DistanceChallenge> {
//   const DistanceChallengeCard({Key? key, required DistanceChallenge challenge}) : super(key: key, challenge: challenge);

//   @override
//   Widget buildContent() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Required Photos: ${challenge.requiredPhotos}"),
//         Text("Photos Taken: ${challenge.photosTaken}"),
//         Text("Step Limit: ${challenge.stepLimit}"),
//         Text("Steps Used: ${challenge.progress ?? 0}"),
//       ],
//     );
//   }
  
//   @override
//   void initState() {
//     // TODO: implement initState
//   }
// }

// class InfluenceChallengeCard extends ChallengeCard<InfluenceChallenge> {
//   const InfluenceChallengeCard({Key? key, required InfluenceChallenge challenge}) : super(key: key, challenge: challenge);

//   @override
//   Widget buildContent() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Required Photos: ${challenge.requiredPhotos}"),
//         Text("Photos Taken: ${challenge.photosTaken}"),
//         Text("Step Limit: ${challenge.stepLimit}"),
//         Text("Steps Used: ${challenge.progress ?? 0}"),
//       ],
//     );
//   }
  
//   @override
//   void initState() {
//     // TODO: implement initState
//   }
  
// }
