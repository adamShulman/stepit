
import 'package:flutter/material.dart';

class BackgroundGradientContainer extends StatelessWidget {

  final Widget? child;

  const BackgroundGradientContainer({super.key, this.child});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [
            0.01,
            0.29,
            0.48,
            0.67,
            0.98
          ],
          colors: [
            const Color(0xFFC7F9CC),
            const Color(0xFF80ED99),
            const Color(0xFF57CC99),
            const Color(0xFF38A3A5),
            const Color(0xFF22577A),
          ]
        )
      ),
      child: child
    );
  }

}