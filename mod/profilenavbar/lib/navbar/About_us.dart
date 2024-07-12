import 'package:flutter/material.dart';
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
          'เกี่ยวกับเรา',
          style: GoogleFonts.prompt(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
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
                  'assets/images/botnoivoice.png',
                  width: 54,
                  height: 62,
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF323130)),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Version 8.8.8',
                  style: GoogleFonts.prompt(
                      fontSize: 14, color: Color(0xFF323130)),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Text(
                  'Easily convert text into realistic speech. More than 10+ languages to chooses, helping your work smoothly, whether it be voice over, dubbing, teaching media, reading news, presentation slides, podcasts, reading novels, finishing work easily, can be done anywhere.',
                  style: GoogleFonts.prompt(
                      fontSize: 14, color: Color(0xFF605E5C)),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Center(
                child: Text(
                  'Copyright 2024 BOTNOI. All rights reserved',
                  style: GoogleFonts.prompt(
                      fontSize: 14, color: Color(0xFFA19F9D)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
