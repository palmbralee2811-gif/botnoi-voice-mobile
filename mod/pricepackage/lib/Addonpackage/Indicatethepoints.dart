import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Indicatethepoints extends StatefulWidget {
  const Indicatethepoints({super.key});

  @override
  State<Indicatethepoints> createState() => _IndicatethepointsState();
}

class _IndicatethepointsState extends State<Indicatethepoints> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Color(0xFFBBBFC4),
          width: 2.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image(
                image: AssetImage('assets/images/point4.png'),
                width: 32,
                height: 32,
              ),
              Text(
                'ระบุจำนวนพอยท์',
                style: GoogleFonts.prompt(
                  fontSize: 16,
                  color: Color(0xFF605E5C),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              hintText: 'กรอกจำนวนพอยท์ที่ต้องการ . . .',
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [Color(0xFF9340FF), Color(0xFF01BFFB)],
                ),
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  '0 บาท',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
