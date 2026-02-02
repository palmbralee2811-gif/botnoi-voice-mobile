import 'package:botnoivoice/screen/drawer/marads/widgets/ui/marads_ui_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      color: Colors.white,
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: onTap,
          child: CustomPaint(
            painter: GradientBorderPainter(
              gradient: MarAdsUIStyle.cyanPurpleGradient,
              radius: 12.r,
              strokeWidth: 1.5,
            ),
            child: Container(
              height: 36.h,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        MarAdsUIStyle.cyanPurpleGradient.createShader(bounds),
                    child: Text(
                      selectedMode,
                      style: GoogleFonts.prompt(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  ShaderMask(
                    shaderCallback: (bounds) =>
                        MarAdsUIStyle.cyanPurpleGradient.createShader(bounds),
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

  // เพิ่ม Static Method สำหรับเรียก Modal เลือกโหมด
  static void show(
      BuildContext context, String currentMode, Function(String) onSelect) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _MarAdsModeSheet(
        currentMode: currentMode,
        onSelect: onSelect,
      ),
    );
  }
}

// Widget สำหรับแสดงรายการเลือกโหมด (Private Widget)
class _MarAdsModeSheet extends StatelessWidget {
  final String currentMode;
  final Function(String) onSelect;

  const _MarAdsModeSheet({
    required this.currentMode,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final modes = ['Basic mode', 'Advanced mode', 'History'];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            width: 36.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 24.h),
          // Loop สร้างปุ่มเลือกโหมด
          ...modes.map((mode) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _buildOption(context, mode),
              )),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, String mode) {
    final isSelected = currentMode == mode;

    return GestureDetector(
      onTap: () {
        // Close Dialog Before Run Function
        context.pop(); // ปิด Modal ก่อน
        onSelect(mode); // ส่งค่ากลับ
      },
      child: Container(
        height: 50.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          // ถ้าไม่ได้เลือก ให้ใส่ขอบสีเทาอ่อน ถ้าเลือกแล้ว CustomPaint จะวาดขอบ Gradient ให้เอง
          border:
              isSelected ? null : Border.all(color: const Color(0xFFDBDBDB)),
        ),
        child: isSelected
            ? CustomPaint(
                painter: GradientBorderPainter(
                  gradient: MarAdsUIStyle.cyanPurpleGradient,
                  radius: 16.r,
                  strokeWidth: 1.5,
                ),
                child: Center(
                  child: ShaderMask(
                    shaderCallback: (bounds) =>
                        MarAdsUIStyle.cyanPurpleGradient.createShader(bounds),
                    child: Text(
                      mode,
                      style: GoogleFonts.prompt(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            : Center(
                child: Text(
                  mode,
                  style: GoogleFonts.prompt(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFC4C4C4),
                  ),
                ),
              ),
      ),
    );
  }
}
