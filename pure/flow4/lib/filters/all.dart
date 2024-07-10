
import 'package:flow3/screen/seeall.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class All extends StatefulWidget {
  const All({
    super.key,
  });

  @override
  State<All> createState() => _AllState();
}

class _AllState extends State<All> {
  bool ishover = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

        setState(() {
          ishover = !ishover;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => const SeeAll()));
        

      },
      child: Container(
        width: 63.w,
        height: 26.h,
       decoration:BoxDecoration(
          gradient: ishover ? const LinearGradient(
            colors: [Color(0xFF9A96F5), Color(0xFF00E0FF)],
          ) : null,
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
                  'ดูทั้งหมด',
                  style: GoogleFonts.prompt(
                    fontSize: 12.sp,
                    color: const Color(0xFFFFFFFF),
                  ),
                ) : Text(
                  'ดูทั้งหมด',
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
