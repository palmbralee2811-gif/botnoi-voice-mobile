import 'package:flutter/material.dart';
class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      decoration: const BoxDecoration(
        color: Colors.black, // Background color
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9.0),
        child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.graphic_eq,
              color: Colors.grey[500], // Icon color
              size: 22,
            ),
        
            Text(
              'Create',
              style: TextStyle(
                color: Colors.grey[500],
                fontFamily: 'Prompt',
                fontSize: 15,
              ),
              ),
          ],
        ),
      ),
    );
  }
}