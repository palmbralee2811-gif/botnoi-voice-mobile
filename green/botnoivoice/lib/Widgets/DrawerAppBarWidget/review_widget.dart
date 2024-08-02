import 'package:botnoivoice/Screens/GradientScreen/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewWidget extends StatefulWidget {
  const ReviewWidget({super.key});

  @override
  State<ReviewWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  int? _selectedEmoji;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'ข้อเสนอเเนะ',
          style: GoogleFonts.prompt(
              fontSize: 16.sp,
              color: const Color(0xFF323130),
              fontWeight: FontWeight.w600),
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
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: SizedBox(
                child: Text(
                  'ความรู้สึก',
                  style: GoogleFonts.prompt(
                    fontSize: 16.sp,
                    color: const Color(0xFF000000),
                  ),
                ),
              ),
            ),
            SizedBox(
              child: Text(
                'คุณรู้สึกยังไงบ้างหลังจากได้ลองใช้งาน',
                style: GoogleFonts.prompt(
                    fontSize: 14.sp, color: const Color(0xFF605E5C)),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.sentiment_satisfied_alt,
                      size: 64.sp,
                      color: _selectedEmoji == 1 ? Colors.green : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedEmoji = 1;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.sentiment_neutral,
                      size: 64.sp,
                      color: _selectedEmoji == 2 ? Colors.amber : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedEmoji = 2;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.sentiment_dissatisfied,
                      size: 64.sp,
                      color: _selectedEmoji == 3 ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedEmoji = 3;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.sp),
            Padding(
              padding: EdgeInsets.only(
                right: 140.w,
              ),
              child: Text(
                'แสดงความคิดเห็น',
                style: GoogleFonts.prompt(
                  fontSize: 16.sp,
                  color: const Color(0xFF000000),
                ),
              ),
            ),
            SizedBox(height: 10.sp),
            Padding(
              padding: EdgeInsets.only(left: 30.w, right: 30.w),
              child: TextField(
                cursorColor: const Color(0xFF000000),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Color(0xFFD9D9D9),
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Color(0xFFD9D9D9),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Color(0xFFD9D9D9),
                      width: 1.0,
                    ),
                  ),
                  labelText: '',
                  labelStyle: GoogleFonts.prompt(
                      fontSize: 16.sp, color: const Color(0xFF000000)),
                  hintText: 'พิมพ์ข้อความ...',
                  hintStyle: GoogleFonts.prompt(
                      fontSize: 14.sp, color: const Color(0xFFA19F9D)),
                ),
                maxLines: 3,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: SizedBox(
                child: GradientButton(
                  text: 'ส่งข้อเสนอแนะ',
                  onPressed: () {
                    print('ส่งข้อเสนอแนะ');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
