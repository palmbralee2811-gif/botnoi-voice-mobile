import 'package:flutter/material.dart';

class Recommant extends StatelessWidget {
  const Recommant({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 26,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF9A96F5), Color(0xFF00E0FF)],
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(4),
        ),
        border: Border.all(
          color: const Color(0xFFE2E3E9),
          width: 1,
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'แนะนำ',
                style: TextStyle(fontSize: 12, color: Color(0xFF323130)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
