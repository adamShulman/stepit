
import 'package:flutter/material.dart';

class BackgroundGradientContainer extends StatelessWidget {

  final Widget? child;

  const BackgroundGradientContainer({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(0.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
            0.01,
            0.29,
            0.48,
            0.67,
            0.98
          ],
          colors: [
            Color(0xFFC7F9CC),
            Color(0xFF80ED99),
            Color(0xFF57CC99),
            Color(0xFF38A3A5),
            Color(0xFF22577A),
          ]
        )
      ),
      child: child
    );
  }

}