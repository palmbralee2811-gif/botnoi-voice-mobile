import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CinematicGenreFilter extends StatefulWidget {
  const CinematicGenreFilter({
    super.key,
  });

  @override
  State<CinematicGenreFilter> createState() => _CinematicGenreFilterState();
}

class _CinematicGenreFilterState extends State<CinematicGenreFilter> {
  bool _isSelected = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
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
                        'พากย์หนัง',
                        style: GoogleFonts.prompt(
                          fontSize: 12.sp,
                          color: const Color(0xFFFFFFFF),
                        ),
                      )
                    : Text(
                        'พากย์หนัง',
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
