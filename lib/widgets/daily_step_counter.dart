
import 'package:flutter/material.dart';

class DailyStepCounter extends StatefulWidget {

  const DailyStepCounter({super.key});

  @override State<StatefulWidget> createState() => _DailyStepCounterState();
 
}

class _DailyStepCounterState extends State<DailyStepCounter> {

  @override
  Widget build(BuildContext context) {
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
                    const Text(
                      "Steps",
                      style: TextStyle(
                        color: Colors.deepOrange
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "18:00",
                      maxLines: 1,
                      style: TextStyle(
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
                    const Text(
                      "580",
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    const Text(
                      "steps",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 13.0,
                        fontWeight: FontWeight.normal,
                        
                      )
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.bar_chart,
                      color: Colors.blueGrey
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      )
    );

    // return Container(
    //   margin: EdgeInsetsDirectional.only(start: 8.0, top: 6.0, end: 8.0, bottom: 6.0),
    //   padding: EdgeInsetsDirectional.only(start: 12.0, top: 6.0, end: 12.0, bottom: 6.0),
    //   // color: Colors.white,
    //   decoration: BoxDecoration(
    //     borderRadius: const BorderRadius.all(Radius.circular(12.0)),
    //     border: Border.all(
    //       width: 5.0,
    //       color: const Color(0xFFC7F9CC)
    //     ),
    //     color: Colors.white,
        
    //   ),
    //   child: Column(
    //     children: [
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Row(
    //             children: [
    //               const Icon(
    //                 Icons.run_circle,
    //                 color: Colors.deepOrange,
    //               ),
    //               const SizedBox(
    //                 width: 4.0,
    //               ),
    //               const Text(
    //                 "Steps",
    //                 style: TextStyle(
    //                   color: Colors.deepOrange
    //                 ),
    //               )
    //             ],
    //           ),
    //           Row(
    //             children: [
    //               const Text(
    //                 "18:00",
    //                 maxLines: 1,
    //                 style: TextStyle(
    //                   color: Colors.blueGrey,
    //                   fontSize: 13.0,
    //                   fontWeight: FontWeight.normal,
    //                   // shadows: [
    //                   //   Shadow(
    //                   //     offset: Offset(2.0, 2.0),
    //                   //     blurRadius: 3.0,
    //                   //     color: Color.fromARGB(255, 0, 0, 0),
    //                   //   ),
    //                   // ],
    //                 )
    //               ),
    //               const Icon(
    //                 Icons.arrow_forward_ios,
    //                 color: Colors.blueGrey,
    //                 size: 14.0,
    //               ),
    //             ],
    //           )
    //         ],
    //       ),
    //       const SizedBox(
    //         height: 24.0,
    //       ),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Row(
    //             children: [
    //               const Text(
    //                 "580",
    //                 maxLines: 1,
    //                 style: TextStyle(
    //                   color: Colors.black,
    //                   fontSize: 24.0,
    //                   fontWeight: FontWeight.bold,
    //                 )
    //               ),
    //               const SizedBox(
    //                 width: 4.0,
    //               ),
    //               const Text(
    //                 "steps",
    //                 style: TextStyle(
    //                   color: Colors.blueGrey,
    //                   fontSize: 13.0,
    //                   fontWeight: FontWeight.normal,
                      
    //                 )
    //               ),
    //             ],
    //           ),
    //           Row(
    //             children: [
    //               Icon(
    //                 Icons.bar_chart,
    //                 color: Colors.blueGrey
    //               ),
    //             ],
    //           )
    //         ],
    //       )
    //     ],
    //   ),
    // );
  }

}