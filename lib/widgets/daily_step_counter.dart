
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stepit/classes/challenge_singleton.dart';
import 'package:stepit/l10n/app_localizations.dart';
import 'package:stepit/services/firebase_service.dart';
import 'package:stepit/services/health_service.dart';

class DailyStepCounter extends StatefulWidget {

  const DailyStepCounter({super.key});

  @override 
  State<StatefulWidget> createState() => DailyStepCounterState();
 
}

class DailyStepCounterState extends State<DailyStepCounter> {

  final _healthService = HealthService();
  final _firestoreService = FirestoreService();

  int get _userId {
    return LazySingleton.instance.currentUser.uniqueNumber;
  }

  int get _userLevel {
    return LazySingleton.instance.currentUser.level;
  }

  @override
  Widget build(BuildContext context) {
     
    final now = DateTime.now();
    final formattedDate = DateFormat.EEEE(Localizations.localeOf(context).toString()).format(now);
    final formattedTime = DateFormat.jm(Localizations.localeOf(context).toString()).format(now);

    final date = '$formattedTime, $formattedDate';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsetsDirectional.symmetric(vertical: 6.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.run_circle,
                      color: Colors.deepOrange,
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    FutureBuilder(
                      future: _healthService.fetchStepData(),
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data?.toString() ?? "0",
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          )
                        );
                      },
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      AppLocalizations.of(context)!.steps,
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 13.0,
                        fontWeight: FontWeight.normal,
                        
                      )
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      date,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 13.0,
                        fontWeight: FontWeight.normal,
                        // shadows: [
                        //   Shadow(
                        //     offset: Offset(2.0, 2.0),
                        //     blurRadius: 3.0,
                        //     color: Color.fromARGB(255, 0, 0, 0),
                        //   ),
                        // ],
                      )
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.blueGrey,
                      size: 14.0,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 24.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    StreamBuilder(
                      stream: _firestoreService.getUserPointsStream(_userId),
                      builder: (context, snapshot) {
                        return Text(
                          snapshot.data?.toString() ?? "0",
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          )
                        );
                      },
                    ),
                    // const Text(
                    //   "580",
                    //   maxLines: 1,
                    //   style: TextStyle(
                    //     color: Colors.black,
                    //     fontSize: 24.0,
                    //     fontWeight: FontWeight.bold,
                    //   )
                    // ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      AppLocalizations.of(context)!.points,
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 13.0,
                        fontWeight: FontWeight.normal,
                        
                      )
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.level,
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 13.0,
                        fontWeight: FontWeight.normal,
                        
                      )
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "$_userLevel",
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    // Icon(
                    //   Icons.bar_chart,
                    //   color: Colors.blueGrey
                    // ),
                  ],
                )
              ],
            )
          ],
        ),
      )
    );
  }
}