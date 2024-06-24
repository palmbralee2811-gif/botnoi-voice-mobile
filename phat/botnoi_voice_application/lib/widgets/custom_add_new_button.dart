import 'package:botnoi_voice_application/widgets/gradient_border_painter.dart';
import 'package:flutter/material.dart';
class CustomAddNewButton extends StatelessWidget {
  const CustomAddNewButton({super.key});
  @override

  Widget build(BuildContext context) {
    return Container(
           alignment: Alignment.center,
           decoration: const BoxDecoration(
           ),
           padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
           child: CustomPaint(
             painter: GradientBorderPainter(),
             child: OutlinedButton.icon(
               style: OutlinedButton.styleFrom(
                 minimumSize: const Size(500, 50),
                 foregroundColor: Colors.purple, 
                 side: const BorderSide(
                   width: 1,
                   color: Colors.transparent,
                   ),
               ),
               icon: const Icon(Icons.settings),
               label: const Text('Add new', style: TextStyle(fontFamily: 'Prompt'),),
               onPressed: () { },
             ),
           ),
         );
  }
}