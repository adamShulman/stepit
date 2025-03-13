

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stepit/classes/challenge_singleton.dart';
import 'package:stepit/classes/user.dart';
import 'package:stepit/firebase_options.dart';
import 'package:stepit/l10n/app_localizations.dart';
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

  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _subscribeToNetwork();
  }

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  void _subscribeToNetwork() async {

     _subscription?.cancel();

    _subscription = InternetConnection().onStatusChange.listen(
      (status) {
        if (status == InternetStatus.connected && !_isRunningTasks) {
          _userInitialization();
        } else if (status == InternetStatus.disconnected) {
          _showNoInternetMessage();
        }
      },
      onError: (error) {
        _showNoInternetMessage();
      },
    );
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
              const SizedBox(
                height: 20.0,
                width: 20.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: Colors.white,
                ),
              ),
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

    final title = AppLocalizations.of(context)!.internetConnection;
    final message = AppLocalizations.of(context)!.checkConnection;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      DialogService().showSingleDialog(context, title, message);
    });
  }
}