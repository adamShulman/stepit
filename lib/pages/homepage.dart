
import 'package:flutter/material.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';
import 'package:stepit/services/firebase_service.dart';
import 'package:stepit/utils/utils.dart';
import 'package:stepit/widgets/background_gradient_container.dart';
import 'package:stepit/widgets/daily_step_counter.dart';

class HomePage extends StatefulWidget {

  const HomePage({ super.key });

  @override
  State createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> with WidgetsBindingObserver {

  final FirestoreService _firestoreService = FirestoreService();

  late final List<Challenge> _challenges;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
    //   _saveDataBeforeExit();
    // }
  }

  Future<void> _saveDataBeforeExit() async {
    // challenges.forEach((challenge) {
    //   challenge.end();
    // });
    print("data saved");
  }

  

  @override
  void dispose() {

    WidgetsBinding.instance.removeObserver(this);

    // for (var e in _challenges) {
    //   if (e.challengeStatus == ChallengeStatus.active) {
    //     e.endChallenge();
    //   }
    // }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // extendBody: true,
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: const Text(
          'Choose a challenge',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(1.0, -1.0),
                blurRadius: 1.0,
                color: Colors.white
              ),
            ],
          )
        ),
      ),
      body: BackgroundGradientContainer(
        child: SingleChildScrollView(
          child: Column(

            children: [
              const DailyStepCounter(),
              FutureBuilder(
                future: _firestoreService.fetchChallengesOnce(),
                builder: (context, snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50.0),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final challenges = snapshot.data!;
                    _challenges = challenges;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: challenges.length,
                      itemBuilder: (context, index) {
                        final challenge = challenges[index];
                        return Hero(
                          tag: challenge.id,
                          child: ChallengeUtils.buildChallengeWidget(
                            challenge,
                            canNavigate: true
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('No challenges found'),
                    );
                  }
                },
              )
            ],
          ),
        ),
      )
      
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     // await _firestoreService.addUser("New User", "newuser@example.com");
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
