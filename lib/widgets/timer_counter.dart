

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stepit/services/timer_service.dart';

class TimerCounterWidget extends StatelessWidget {

  const TimerCounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Consumer<TimerService>(
      builder: (context, timerService, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Elapsed Time: ${timerService.elapsedSeconds} seconds',
            ),
            // const SizedBox(height: 20),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     ElevatedButton(
            //       onPressed: timerService.isRunning
            //           ? timerService.pauseTimer
            //           : () => timerService.startTimer(autoStopAfterSeconds: 10),
            //       child: Text(timerService.isRunning ? 'Pause' : 'Start (Auto-stop in 10s)'),
            //     ),
            //     const SizedBox(width: 10),
            //     ElevatedButton(
            //       onPressed: timerService.resumeTimer,
            //       child: const Text('Resume'),
            //     ),
            //     const SizedBox(width: 10),
            //     ElevatedButton(
            //       onPressed: timerService.stopTimer,
            //       child: const Text('Stop'),
            //     ),
            //   ],
            // ),
          ],
        );
      },
    );
      },
    );
    
  }
}