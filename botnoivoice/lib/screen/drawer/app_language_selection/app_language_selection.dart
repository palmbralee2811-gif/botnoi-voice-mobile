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

  if (!context.mounted) return;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      // --- Responsive Logic for Tablet Landscape ---
      bool isTablet = MediaQuery.of(context).size.shortestSide > 550;
      bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
      // ลดขนาดลง 30% ถ้าเป็น Tablet แนวนอน
      double scaleFactor = (isTablet && isLandscape) ? 0.7 : 1.0;

      return Container(
        // ปรับความสูงให้พอดีกับเนื้อหา และ Scale ตาม Device
        constraints: BoxConstraints(
          maxHeight: 0.8.sh,
          minHeight: (ResponsiveDesignOrientation.isLandscape ? 300.h : 350.h) * scaleFactor,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r * scaleFactor)),
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
            SizedBox(height: 12.h * scaleFactor),
            // --- Drag Handle ---
            Container(
              width: 40.w * scaleFactor,
              height: 4.h * scaleFactor,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r * scaleFactor),
              ),
            ),
            
            // --- Header ---
            _buildHeader(context, scaleFactor),
            
            Divider(height: 1, color: Colors.grey.shade100),

            // --- Language List ---
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w * scaleFactor, 
                  vertical: 10.h * scaleFactor
                ),
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
                      scaleFactor,
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 20.h * scaleFactor), // Safe area / Bottom padding
          ],
        ),
      );
    },
  );
}

Widget _buildHeader(BuildContext context, double scaleFactor) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: 24.w * scaleFactor, 
      vertical: 16.h * scaleFactor
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'language'.tr(),
          style: GoogleFonts.prompt(
            fontSize: (ResponsiveDesignOrientation.isLandscape ? 18.sp : 18.sp) * scaleFactor,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        InkWell(
          onTap: () => context.pop(),
          borderRadius: BorderRadius.circular(20.r * scaleFactor),
          child: Container(
            padding: EdgeInsets.all(6.r * scaleFactor),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.close_rounded,
              size: (ResponsiveDesignOrientation.isLandscape ? 20.sp : 20.sp) * scaleFactor,
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
  double scaleFactor,
) {
  return Container(
    margin: EdgeInsets.only(bottom: 12.h * scaleFactor),
    decoration: BoxDecoration(
      color: isSelected ? Colors.blue.withOpacity(0.04) : Colors.white,
      borderRadius: BorderRadius.circular(12.r * scaleFactor),
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
      borderRadius: BorderRadius.circular(12.r * scaleFactor),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 12.h * scaleFactor, 
          horizontal: 16.w * scaleFactor
        ),
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
                child: Image.asset(
                  imagePath, 
                  width: 32.w * scaleFactor, 
                  height: 32.w * scaleFactor, // ใช้ width เพื่อให้เป็นวงกลมสมบูรณ์
                  fit: BoxFit.cover
                ),
              ),
            ),
            SizedBox(width: 16.w * scaleFactor),
            
            // Language Name
            Expanded(
              child: Text(
                languageName,
                style: GoogleFonts.prompt(
                  fontSize: (ResponsiveDesignOrientation.isLandscape ? 16.sp : 16.sp) * scaleFactor,
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
                size: 24.sp * scaleFactor,
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