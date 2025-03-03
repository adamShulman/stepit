import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stepit/classes/cam_mode_notifier.dart';
import 'package:stepit/classes/game.dart';
import 'package:stepit/classes/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stepit/pages/data_loader.dart';
import 'package:stepit/services/location_service.dart';
import 'package:stepit/services/step_tracker_service.dart';
import 'package:stepit/services/timer_service.dart';
import 'firebase_options.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LocationService()),
      // ChangeNotifierProvider(create: (context) => StepCounterProvider()),
      ChangeNotifierProvider(create: (_) => StepTrackerServiceNotifier()),
      // ChangeNotifierProvider(create: (_) => TimerService()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => GameProvider()),
      ChangeNotifierProvider(create: (_) => CamModeNotifier())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {

  const MyApp({ super.key });

  @override
  MyAppState createState() => MyAppState();
  
}

class MyAppState extends State<MyApp> {

  MyAppState({ Key? key });

  static const AppLifecycleState _appLifecycleState = AppLifecycleState.resumed;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  static bool isAppInForeground() {
    return _appLifecycleState == AppLifecycleState.resumed;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        hintColor: const Color(0xFFC7F9CC),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 184, 239, 186), 
            textStyle: const TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 255, 255, 255),
              
            ),
          ),
        ),          
        appBarTheme: const AppBarTheme(
          color: Color(0xFFC7F9CC), 
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const DataLoaderPage(),
    );
  }
}

