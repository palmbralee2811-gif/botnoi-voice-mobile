import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../marads_ui_style.dart';

class MarAdsResultModeSelector extends StatelessWidget {
  final String selectedMode;
  final Function(String) onModeChanged;
  final VoidCallback onHistoryPressed;

  const MarAdsResultModeSelector({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
    required this.onHistoryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showSelectorModal(context),
      child: CustomPaint(
        painter: GradientBorderPainter(
          gradient: MarAdsUIStyle.cyanPurpleGradient,
          radius: 8.r,
        ),
        child: Container(
          height: 33.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (bounds) =>
                    MarAdsUIStyle.cyanPurpleGradient.createShader(bounds),
                child: Icon(
                  Icons.tune_rounded,
                  size: 14.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 6.w),
              ShaderMask(
                shaderCallback: (bounds) =>
                    MarAdsUIStyle.cyanPurpleGradient.createShader(bounds),
                child: Text(
                  selectedMode,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.67,
                    letterSpacing: 0.25,
                  ),
                ),
              ),
              SizedBox(width: 5.w),
              ShaderMask(
                shaderCallback: (bounds) =>
                    MarAdsUIStyle.cyanPurpleGradient.createShader(bounds),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 17.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSelectorModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 40.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              "marads_mode_selector.select_mode".tr(),
              style: GoogleFonts.prompt(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 24.h),
            _buildModeOption(
              context: context,
              icon: Icons.remove_red_eye_outlined,
              label: 'marads_mode_selector.mode_result'.tr(),
              isSelected: selectedMode == 'Result',
              onTap: () {
                // Close Dialog
                context.pop();

                // Call Function
                onModeChanged('Result');
              },
            ),
            SizedBox(height: 12.h),
            _buildModeOption(
              context: context,
              icon: Icons.edit_note_rounded,
              label: 'marads_mode_selector.mode_edit'.tr(),
              isSelected: selectedMode == 'Edit',
              onTap: () {
                // Close Dialog
                context.pop();

                // Call Function
                onModeChanged('Edit');
              },
            ),
            SizedBox(height: 12.h),
            _buildModeOption(
              context: context,
              icon: Icons.history_rounded,
              label: 'marads_mode_selector.mode_history'.tr(),
              isSelected: false,
              onTap: () {
                // Close Dialog
                context.pop();

                // Call Function
                onHistoryPressed();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: isSelected
              ? null
              : Border.all(color: const Color(0xFFE0E0E0), width: 1),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF9747FF).withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: isSelected
            ? CustomPaint(
                painter: GradientBorderPainter(
                  gradient: MarAdsUIStyle.cyanPurpleGradient,
                  radius: 16.r,
                  strokeWidth: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          MarAdsUIStyle.cyanPurpleGradient.createShader(bounds),
                      child: Icon(icon, size: 24.sp, color: Colors.white),
                    ),
                    SizedBox(width: 12.w),
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          MarAdsUIStyle.cyanPurpleGradient.createShader(bounds),
                      child: Text(
                        label,
                        style: GoogleFonts.prompt(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 24.sp, color: const Color(0xFF888888)),
                  SizedBox(width: 12.w),
                  Text(
                    label,
                    style: GoogleFonts.prompt(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF262626),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
