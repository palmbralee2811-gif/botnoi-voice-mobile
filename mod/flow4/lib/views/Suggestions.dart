import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Suggestions extends StatefulWidget {
  const Suggestions({super.key});

  @override
  State<Suggestions> createState() => _SuggestionsState();
}

class _SuggestionsState extends State<Suggestions> {
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
          'Suggestions',
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
                  'Feelings',
                  style: GoogleFonts.prompt(
                    fontSize: 16.sp,
                    color: const Color(0xFF000000),
                  ),
                ),
              ),
            ),
            SizedBox(
              child: Text(
                'How do you feel after trying it out?',
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
                'Comment',
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
                  hintText: 'Type here...',
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
                  text: 'Sent Suggestion',
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

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  GradientButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: onPressed,
        child: Text(text, style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}
