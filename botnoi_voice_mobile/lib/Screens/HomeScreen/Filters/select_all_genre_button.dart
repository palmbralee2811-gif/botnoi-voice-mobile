import 'package:botnoi_voice_mobile/Screens/HomeScreen/display_all_voice_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectAllGenreButton extends StatefulWidget {
  const SelectAllGenreButton({
    super.key,
  });

  @override
  State<SelectAllGenreButton> createState() => _SelectAllGenreButtonState();
}

class _SelectAllGenreButtonState extends State<SelectAllGenreButton> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          if (_isSelected == true) {
            _isSelected = !_isSelected;
          }
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const DisplayAllVoiceScreen()));
      },
      child: Container(
        width: 63.w,
        height: 26.h,
        decoration: BoxDecoration(
          gradient: _isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF9A96F5), Color(0xFF00E0FF)],
                )
              : null,
          borderRadius: BorderRadius.all(
            Radius.circular(4.r),
          ),
          border: Border.all(
            color: const Color(0xFFE2E3E9),
            width: 1.w,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _isSelected
                    ? Text(
                        'ดูทั้งหมด',
                        style: GoogleFonts.prompt(
                          fontSize: 12.sp,
                          color: const Color(0xFFFFFFFF),
                        ),
                      )
                    : Text(
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

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GradientButton(
      {super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
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
        child: Text(text,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}
