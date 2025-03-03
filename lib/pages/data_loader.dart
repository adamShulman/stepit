

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stepit/classes/challenge_singleton.dart';
import 'package:stepit/classes/user.dart';
import 'package:stepit/pages/identification.dart';
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

  late final StreamSubscription<InternetStatus> _subscription;
  late final AppLifecycleListener _listener;

  bool _isRunningTasks = false;


  @override
  void initState() {
    super.initState();
    _startNetworkSubscription();
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

  void _startNetworkSubscription() {
    _subscription = InternetConnection().onStatusChange.listen((status) {
      switch (status) {
        case InternetStatus.connected:
          if(!_isRunningTasks) {
            _performAsyncTasks();
          }
        case InternetStatus.disconnected:
          _showNoInternetMessage();
      }
    });
    _listener = AppLifecycleListener(
      onResume: _subscription.resume,
      onHide: _subscription.pause,
      onPause: _subscription.pause,
    );
  }

  Future<void> _performAsyncTasks() async {

    //TODO: Check for internet connection before proceeding 

    _isRunningTasks = true;

    try {

      Future.delayed(const Duration(seconds: 1), () async {

      final prefs = await SharedPreferences.getInstance();

      final isFirstTime = prefs.getBool('first_time') ?? true;
      final uniqueNumber = prefs.getInt('uniqueNumber');

      Widget? destination;

      if ( uniqueNumber != null ) {
        final User currentUser = await _firestoreService.getUser(uniqueNumber);
        LazySingleton.instance.currentUser = currentUser;
        destination = const HomePage();
        print(currentUser.username);
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

      });

      
    } catch (e) {
      print("Error during async tasks: $e");
    }
  }

  void _showNoInternetMessage() {

    String message;
    message = 'Check your internet connection and try again.';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connectivity'),
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

  @override
  void dispose() {
    _subscription.cancel();
    _listener.dispose();
    super.dispose();
  }
}