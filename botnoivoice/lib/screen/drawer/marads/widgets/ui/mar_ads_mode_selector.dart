import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MarAdsModeSelector extends StatelessWidget {
  final String selectedMode;
  final VoidCallback onTap;

  const MarAdsModeSelector({
    super.key,
    required this.selectedMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const gradient = LinearGradient(
      colors: [Color(0xFF01BFFB), Color(0xFFEB85FC)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      color: Colors.white,
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: onTap,
          child: CustomPaint(
            painter: _GradientBorderPainter(
              gradient: gradient,
              radius: 18.r,
            ),
            child: Container(
              height: 36.h, // ← ฟิกความสูงให้คอนเทนต์อยู่กลางแน่นอน
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center, // ← จัดกึ่งกลาง
                crossAxisAlignment: CrossAxisAlignment.center, // ← จัดกึ่งกลางแนวตั้ง
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => gradient.createShader(bounds),
                    child: Text(
                      selectedMode,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  ShaderMask(
                    shaderCallback: (bounds) => gradient.createShader(bounds),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  final Gradient gradient;
  final double radius;

  _GradientBorderPainter({required this.gradient, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
