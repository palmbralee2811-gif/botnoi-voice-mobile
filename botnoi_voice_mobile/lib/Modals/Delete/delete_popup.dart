import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class DeletePopup extends StatefulWidget {
  const DeletePopup({super.key});

  @override
  State<DeletePopup> createState() => _DeletePopupState();
}

class _DeletePopupState extends State<DeletePopup> {
  bool isDone = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 160.h,
        width: 240.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: const EdgeInsets.only(),
          child: SizedBox(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Column(
                children: [
                  if (!isDone)
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1.0),
                      duration: const Duration(seconds: 5),
                      onEnd: () {
                        setState(() {
                          isDone = true;
                        });
                      },
                      builder: (context, value, child) => SizedBox(
                        height: 50.h,
                        width: 50.w,
                        child: CircularProgressIndicator(
                          value: value,
                          backgroundColor: const Color(0xFFF7F8FA),
                          strokeWidth: 5.w,
                        ),
                      ),
                    ),
                  if (!isDone)
                    Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: GradientText(
                        'กำลังลบ...',
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
                    )
                  else
                    Column(
                      children: [
                        ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: <Color>[
                              Color(0xFF9340FF),
                              Color(0xFF34BDFA),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(
                              Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 60.w,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.h),
                          child: GradientText(
                            'ลบไฟล์สำเร็จ',
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
                        )
                      ],
                    ),
                ],
              ),
            ]),
          ),
        ),
      ),
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
