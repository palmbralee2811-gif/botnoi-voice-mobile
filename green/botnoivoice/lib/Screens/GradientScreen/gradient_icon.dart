// import 'dart:ffi';

import 'package:flutter/material.dart';

class GradientIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Gradient gradient;

  const GradientIcon({
    super.key,
    required this.icon,
    required this.size,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return gradient.createShader(Rect.fromLTWH(0, 0, size, size));
      },
      child: Icon(
        icon,
        size: size,
        color: Colors.white, // icon color จะไม่ถูกใช้
      ),
    );
  }
}
