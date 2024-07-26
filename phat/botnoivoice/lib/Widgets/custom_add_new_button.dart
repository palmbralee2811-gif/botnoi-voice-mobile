import 'package:botnoivoice/Screens/HomeScreen/home.dart';
import 'package:botnoivoice/Screens/LoginScreen/login.dart';
import 'package:botnoivoice/widgets/decorations/gradient_border_painter.dart';
import 'package:flutter/material.dart';
class CustomAddNewButton extends StatelessWidget {
  const CustomAddNewButton({super.key});
  @override
  
  Widget build(BuildContext context) {
    double borderRadius = 10;
    final List<Color> gradientColors = [
      Color.fromARGB(255, 242, 124, 255),
      Color.fromARGB(255, 31, 195, 255),
      ]; 
    double paddingWidth = MediaQuery.of(context).size.width*0.06;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:paddingWidth,vertical: 5),
        child: CustomPaint(
          painter: GradientBorderPainter(
            gradientColors: gradientColors,borderRadius: borderRadius),
          child: Container(
              decoration: BoxDecoration(
              color: Color.fromARGB(255, 227, 227, 227).withOpacity(0.3), // Slightly grey and transparent background
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: OutlinedButton.icon(
              onPressed: () { 
                Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
              },
              icon: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: const Icon(
                Icons.add,
                color: Colors.white, // This color will be overridden by ShaderMask
              ),
              ),
              label: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child: const Text(
                  'สร้างเสียงใหม่',
                  style: TextStyle(
                  color: Colors.white,fontFamily: 'Prompt', // This color will be overridden by ShaderMask
                  fontSize: 16,
                ),
              ),
              ),
              style: OutlinedButton.styleFrom(
              minimumSize: const Size(40, 50),
              maximumSize: const Size(150, 150),
              //foregroundColor: Colors.purple,
              side: const BorderSide(color: Colors.transparent, width: 2),
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              )
              ),
            ),
          ),
        ),
    );
  }
}