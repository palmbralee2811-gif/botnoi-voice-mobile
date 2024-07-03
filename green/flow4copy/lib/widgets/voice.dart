import 'package:flutter/material.dart';
class Voice extends StatelessWidget {
  const Voice({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 63,
      height: 26,
      decoration: BoxDecoration(
        color: Colors.transparent,
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
                'พากย์หนัง',
                style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF323130)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
