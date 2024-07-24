import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class About_us extends StatefulWidget {
  const About_us({super.key});

  @override
  State<About_us> createState() => _About_usState();
}

class _About_usState extends State<About_us> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'About us',
          style: GoogleFonts.prompt(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF323130)),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: const Color(0xFF323130),
            size: 24.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
            print('Back');
          },
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/logo/botnoivoice.png',
                  width: 54.71.w,
                  height: 62.h,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Botnoi Voice',
                  style: GoogleFonts.prompt(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF323130)),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Version 8.8.8',
                  style: GoogleFonts.prompt(
                      fontSize: 12.sp, color: const Color(0xFF323130)),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(left: 30.w, right: 30.w),
                child: Text(
                  'Easily convert text into realistic speech. More than 10+ languages to chooses, helping your work smoothly, whether it be voice over, dubbing, teaching media, reading news, presentation slides, podcasts, reading novels, finishing work easily, can be done anywhere.',
                  style: GoogleFonts.prompt(
                      fontSize: 14.sp, color: const Color(0xFF605E5C)),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 20.w),
              child: Center(
                child: Text(
                  'Copyright 2024 BOTNOI. All rights reserved',
                  style: GoogleFonts.prompt(
                      fontSize: 12.sp, color: const Color(0xFFA19F9D)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
