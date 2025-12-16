import 'package:botnoivoice/shared/function/app_language_function.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/screen/drawer/app_language_selection/model/app_language_model.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> showLanguageBottomSheet({
  required BuildContext context,
  required Function(String) onLanguageSelected,
}) async {
  String selectedLanguage = await loadSelectedLanguage();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        // ปรับความสูงให้พอดีกับเนื้อหา แต่ไม่เกิน 80% ของหน้าจอ
        constraints: BoxConstraints(
          maxHeight: 0.8.sh,
          minHeight: ResponsiveDesignOrientation.isLandscape ? 300.h : 350.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 12.h),
            // --- Drag Handle ---
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            
            // --- Header ---
            _buildHeader(context),
            
            Divider(height: 1, color: Colors.grey.shade100),

            // --- Language List ---
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Column(
                  children: appLanguageModel.map((lang) {
                    final bool isSelected = lang['code'] == selectedLanguage;
                    return _buildLanguageOption(
                      context,
                      onLanguageSelected,
                      lang['code']!,
                      lang['name']!,
                      lang['image']!,
                      isSelected,
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 20.h), // Safe area / Bottom padding
          ],
        ),
      );
    },
  );
}

Widget _buildHeader(BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'language'.tr(),
          style: GoogleFonts.prompt(
            fontSize: ResponsiveDesignOrientation.isLandscape ? 14.sp : 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        InkWell(
          onTap: () => context.pop(),
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.close_rounded,
              size: ResponsiveDesignOrientation.isLandscape ? 16.sp : 20.sp,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildLanguageOption(
  BuildContext context,
  Function(String) onLanguageSelected,
  String languageCode,
  String languageName,
  String imagePath,
  bool isSelected,
) {
  return Container(
    margin: EdgeInsets.only(bottom: 12.h),
    decoration: BoxDecoration(
      color: isSelected ? Colors.blue.withOpacity(0.04) : Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(
        color: isSelected ? Colors.blue : Colors.grey.shade200,
        width: isSelected ? 1.5 : 1,
      ),
    ),
    child: InkWell(
      onTap: () async {
        await _onLanguageSelected(
            context, onLanguageSelected, languageCode);
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Flag Image with Shadow
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              ),
              child: ClipOval(
                child: Image.asset(imagePath, width: 32.w, height: 32.w, fit: BoxFit.cover),
              ),
            ),
            SizedBox(width: 16.w),
            
            // Language Name
            Expanded(
              child: Text(
                languageName,
                style: GoogleFonts.prompt(
                  fontSize: ResponsiveDesignOrientation.isLandscape
                      ? 12.sp
                      : 16.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.blue.shade700 : Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Checkmark Icon if selected
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: Colors.blue,
                size: 24.sp,
              ),
          ],
        ),
      ),
    ),
  );
}

Future<void> _onLanguageSelected(
  BuildContext context,
  Function(String) onLanguageSelected,
  String languageCode,
) async {
  // Logic เดิม
  saveSelectedLanguage(languageCode);
  onLanguageSelected(languageCode);
  context.setLocale(Locale(languageCode));

  // ใช้ mounted check เพื่อความปลอดภัย
  if (!context.mounted) return;
  context.pop(); // Close BottomSheet

  if (!context.mounted) return;
  context.pop(); // Close Drawer (ถ้าเปิดอยู่)

  if (!context.mounted) return;
  context.go('/home'); // Redirect
}