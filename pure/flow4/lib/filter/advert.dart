import 'package:flutter/material.dart';

class Advert extends StatefulWidget {
  const Advert({super.key});

  @override
  _AdvertState createState() => _AdvertState();
}


class _AdvertState extends State<Advert> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = 1;
        });
      },
      child: Container(
        width: 63,
        height: 26,
        decoration: BoxDecoration(
          color: selectedIndex == 1 ? const Color(0xFF9A96F5) : Colors.transparent,
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
                  'โฆษณา',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF323130),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
