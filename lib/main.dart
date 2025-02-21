import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepit/classes/cam_mode_notifier.dart';
import 'package:stepit/classes/game.dart';
import 'package:stepit/classes/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stepit/pages/data_loader.dart';
import 'firebase_options.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  
  runApp(MultiProvider(
    providers: [
      // ChangeNotifierProvider(create: (context) => StepCounterProvider()),
      ChangeNotifierProvider(create: (context) => UserProvider()),
      ChangeNotifierProvider(create: (context) => GameProvider()),
      ChangeNotifierProvider(create: (context) => CamModeNotifier())
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        hintColor: const Color(0xFFC7F9CC),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 184, 239, 186), // Set your desired color here
            textStyle: const TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 255, 255, 255),
              
            ),
          ),
        ),          
        appBarTheme: const AppBarTheme(
          color: Color(0xFFC7F9CC), // Set your desired color here
        ),
        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        // textTheme: TextTheme(
        //   headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        //   headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        //   bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        // ),
      ),
      debugShowCheckedModeBanner: false,
      home: const DataLoaderPage(),
    );
  }
}

