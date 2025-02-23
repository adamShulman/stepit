

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stepit/classes/challenge_singleton.dart';
import 'package:stepit/classes/user.dart';
import 'package:stepit/pages/agreement.dart';
import 'package:stepit/pages/homepage.dart';
import 'package:stepit/services/firebase_service.dart';
import 'package:stepit/widgets/background_gradient_container.dart';

class DataLoaderPage extends StatefulWidget {

  const DataLoaderPage({ super.key });

  @override 
  State createState() => _DataLoaderPageState();

}

class _DataLoaderPageState extends State<DataLoaderPage> {

  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _performAsyncTasks();
  }

  Future<void> _performAsyncTasks() async {
    try {

      // final [prefs as SharedPreferences, challenges as List<Challenge>] = await Future.wait([
      //   SharedPreferences.getInstance(),
      //   _firestoreService.fetchChallengesOnce()
      // ]);

      Future.delayed(const Duration(seconds: 1), () async {

      final prefs = await SharedPreferences.getInstance();

      final isFirstTime = prefs.getBool('first_time') ?? true;
      final uniqueNumber = prefs.getInt('uniqueNumber');

      if ( uniqueNumber != null ) {
        final User currentUser = await _firestoreService.getUser(uniqueNumber);
        LazySingleton.instance.currentUser = currentUser;
        print(currentUser.username);
      }

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => isFirstTime ? const AgreementPage() : const HomePage()),
        );
      }

      });

      
    } catch (e) {
      print("Error during async tasks: $e");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,     
      body: BackgroundGradientContainer(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/stepit_logo_foreground.png",
                height: 200.0,
                width: 200.0,
              ),
              const CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          )
        ),
      )
    ); 
  }
}