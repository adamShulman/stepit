

import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stepit/classes/challenge_singleton.dart';
import 'package:stepit/classes/user.dart';
import 'package:stepit/firebase_options.dart';
import 'package:stepit/pages/identification.dart';
import 'package:stepit/pages/agreement.dart';
import 'package:stepit/pages/homepage.dart';
import 'package:stepit/services/dialog_service.dart';
import 'package:stepit/services/firebase_service.dart';
import 'package:stepit/widgets/background_gradient_container.dart';

class DataLoaderPage extends StatefulWidget {

  const DataLoaderPage({ super.key });

  @override 
  State createState() => _DataLoaderPageState();

}

class _DataLoaderPageState extends State<DataLoaderPage> {

  bool _isRunningTasks = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundGradientContainer(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/stepit_logo_foreground.png",
                height: 100.0,
                width: 100.0,
              ),
              StreamBuilder(
                stream: InternetConnection().onStatusChange,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final status = snapshot.data!;
                    switch (status) {
                      case InternetStatus.connected:
                        if(!_isRunningTasks) {
                          _userInitialization();
                        }
                      case InternetStatus.disconnected:
                        _showNoInternetMessage();
                    }
                  }
                  return const SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: Colors.white,
                    ),
                  );
                },
              )
            ],
          )
        ),
      )
    ); 
  }

  Future<void> _userInitialization() async {

    _isRunningTasks = true;

    try {

      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

      final prefs = await SharedPreferences.getInstance();

      final isFirstTime = prefs.getBool('first_time') ?? true;
      final uniqueNumber = prefs.getInt('uniqueNumber');

      Widget? destination;

      if ( uniqueNumber != null ) {
        final FirestoreService firestoreService = FirestoreService();
        final User currentUser = await firestoreService.getUser(uniqueNumber);
        LazySingleton.instance.currentUser = currentUser;
        destination = const HomePage();
        log('${currentUser.uniqueNumber}');
      } else {
        if (isFirstTime) {
          destination = const AgreementPage();
        } else {
          destination = const IdentificationPage();
        }
      }

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => destination!),
        );
      }

      _isRunningTasks = false;
      
    } catch (e) {
      log("Error during async tasks: $e");
    }
  }

  void _showNoInternetMessage() {

    const title = 'Connectivity';
    const message = 'Check your internet connection and try again.';

    SchedulerBinding.instance.addPostFrameCallback((_) {
      DialogService().showSingleDialog(context, title, message);
    });

    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: const Text('Connectivity'),
    //     content: Text(message),
    //     actions: <Widget>[
    //       TextButton(
    //         child: const Text('OK'),
    //         onPressed: () {
    //           Navigator.of(context).pop();
    //         },
    //       ),
    //     ],
    //   ),
    // );
  }

  @override
  void dispose() {
    super.dispose();
  }
}