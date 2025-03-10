
import 'package:flutter/material.dart';

class ChallengeButton extends StatelessWidget {

  final String text;


  final VoidCallback onPressed;

  final IconData icon;

  final OutlinedBorder? shape;

  const ChallengeButton({
    super.key, 
    required this.text, 
    required this.onPressed, 
    required this.icon, 
    this.shape
  });
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: Colors.black,
        shape: shape
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black),
          Expanded(
            child: FittedBox(
              
              fit: BoxFit.scaleDown,
              child: Text(
              text,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold
              ),
            ),
            ),
             
          ),
        ],
      ),
      )
    );
  }
}
