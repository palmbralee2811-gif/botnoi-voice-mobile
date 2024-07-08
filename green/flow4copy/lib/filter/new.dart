import 'package:flutter/material.dart';
class New extends StatelessWidget {
  const New({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 63,
      height: 26,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF9A96F5),
            Color(0xFF00E0FF)
          ],
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
                'อ่านข่าว',
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