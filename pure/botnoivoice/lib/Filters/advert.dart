import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Advert extends StatefulWidget {
  const Advert({super.key});

  @override
  _AdvertState createState() => _AdvertState();
}

class _AdvertState extends State<Advert> {
  bool ishover = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          ishover = !ishover;
        });
        /////////////////////////////
      },
      child: Container(
        width: 68.w,
        height: 26.h,
        decoration: BoxDecoration(
          gradient: ishover
              ? const LinearGradient(
                  colors: [Color(0xFF9A96F5), Color(0xFF00E0FF)],
                )
              : null,
          borderRadius: const BorderRadius.all(
            Radius.circular(4),
          ),
          border: Border.all(
            color: const Color(0xFFE2E3E9),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ishover ? Text(
                  'โฆษณา',
                  style: GoogleFonts.prompt(
                    fontSize: 12.sp,
                    color: const Color(0xFFFFFFFF),
                  ),
                ) : Text(
                  'โฆษณา',
                  style: GoogleFonts.prompt(
                    fontSize: 12.sp,
                    color: const Color(0xFF323130),
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
