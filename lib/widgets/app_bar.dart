
import 'package:flutter/material.dart';

class StepItAppBar extends StatelessWidget implements PreferredSizeWidget {

  final String title;

  const StepItAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: true,
      titleSpacing: 0.0,
      actions: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(
            "assets/images/stepit_logo_foreground.png",
            height: 30.0,
            width: 30.0,
          ),
        ),
      ],
      title: FittedBox(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(1.0, -1.0),
                blurRadius: 1.0,
                color: Colors.white
              ),
            ],
          )
        ),
      )
      
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
