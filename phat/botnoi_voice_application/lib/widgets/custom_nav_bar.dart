import 'package:flutter/material.dart';
class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key});
  @override

  Widget build(BuildContext context) {
    return Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             Container(
               width: MediaQuery.of(context).size.width * 1,
               height: MediaQuery.of(context).size.height * 0.11,
               decoration: const BoxDecoration(
                 color: Colors.black, // Background color
                 //borderRadius: BorderRadius.circular(8),
               ),
               padding: const EdgeInsets.symmetric(vertical: 10),
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
                       fontSize: 15,
                     ),
                     ),
                 ],
               ),
             )
           ]
        );
  }
}