import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepit/classes/user.dart';
import 'package:stepit/pages/data_loader.dart';
import 'package:stepit/services/location_service.dart';
import 'package:stepit/services/step_tracker_service.dart';
import 'package:stepit/services/timer_service.dart';

void main()  {
  // WidgetsFlutterBinding.ensureInitialized();

  

  // Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LocationService()),
      // ChangeNotifierProvider(create: (context) => StepCounterProvider()),
      ChangeNotifierProvider(create: (_) => StepTrackerServiceNotifier()),
      ChangeNotifierProvider(create: (_) => TimerService()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      // ChangeNotifierProvider(create: (_) => GameProvider()),
      // ChangeNotifierProvider(create: (_) => CamModeNotifier())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color.fromARGB(255, 130, 132, 133),
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
