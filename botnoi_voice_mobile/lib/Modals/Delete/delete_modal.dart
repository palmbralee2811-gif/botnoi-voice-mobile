import 'dart:io';
import 'package:botnoi_voice_mobile/Modals/Delete/delete_popup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class Deletemodal extends StatefulWidget {
  const Deletemodal({super.key});

  @override
  State<Deletemodal> createState() => _DeleteModalState();
}

class _DeleteModalState extends State<Deletemodal> {
  void _openDelete() {
    showDialog(
      context: context,
      builder: (ctx) => const DeletePopup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
          child: SizedBox(
            width: double.infinity,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Image(
                      image: const AssetImage('assets/images/Delete.png'),
                      height: 54.h,
                      width: 54.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Text(
                      'คุณแน่ใจที่จะลบไฟล์นี้ใช่หรือไม่ ?',
                      style: GoogleFonts.prompt(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.prompt(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                    ),
                  ),
                  buildCustomRow(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCustomRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
            child: Container(
          alignment: Alignment.center,
          height: 60.h,
          width: 150.w,
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.grey.withOpacity(0.5),
                elevation: 7,
                padding: EdgeInsets.zero,
                side: BorderSide(color: Colors.transparent, width: 2.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: 60.h,
                  width: 150.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GradientText(
                        "ยกเลิก",
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF9340FF),
                            Color(0xFF34BDFA),
                          ],
                        ),
                        style: GoogleFonts.prompt(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )),
        Padding(
          padding: EdgeInsets.all(8.w),
          child: SizedBox(width: 10.w),
        ),
        Expanded(
            child: Container(
          alignment: Alignment.center,
          height: 60.h,
          width: 150.w,
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: OutlinedButton(
              onPressed: () {
                _openDelete();
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.grey.withOpacity(0.5),
                elevation: 7,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.zero,
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: 60.h,
                  width: 150.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "ลบ",
                        style: GoogleFonts.prompt(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )),
      ],
    );
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.gradient,
    required this.style,
  });

  final String text;
  final TextStyle style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
