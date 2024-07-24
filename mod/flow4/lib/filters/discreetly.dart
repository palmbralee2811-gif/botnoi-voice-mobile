import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Discreetly extends StatefulWidget {
  const Discreetly({
    super.key,
  });

  @override
  State<Discreetly> createState() => _DiscreetlyState();
}

class _DiscreetlyState extends State<Discreetly> {
  bool ishover = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          ishover = !ishover;
        });
        ////////////////////////////////
      },
      child: Container(
        width: 38.w,
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
                ishover
                    ? Text(
                        'Discreetly',
                        style: GoogleFonts.prompt(
                          fontSize: 12.sp,
                          color: const Color(0xFFFFFFFF),
                        ),
                      )
                    : Text(
                        'Discreetly',
                        style: GoogleFonts.prompt(
                          fontSize: 12.sp,
                          color: const Color(0xFF323130),
                        ),
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
