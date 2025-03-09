import 'package:botnoivoice/ui/screen/main/home/home_screen.dart';
import 'package:botnoivoice/ui/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/ui/screen/app_language/app_select_language_screen.dart';
import 'package:botnoivoice/data/model/languages_drawer_model.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      return GestureDetector(
        onTap: () => Navigator.pop(context),
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          height: ResponsiveDesignOrientation.isLandscape ? 400.h : 300.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: languagesDrawerModel.map((lang) {
                      return _buildLanguageOption(
                        context,
                        onLanguageSelected,
                        lang['code']!,
                        lang['name']!,
                        lang['image']!,
                        selectedLanguage,
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildHeader(BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'language'.tr(),
          style: GoogleFonts.prompt(
            fontSize: ResponsiveDesignOrientation.isLandscape ? 12.sp : 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.close,
            size: ResponsiveDesignOrientation.isLandscape ? 14.sp : 24.sp,
            color: Colors.black,
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
  String selectedLanguage,
) {
  return Column(
    children: [
      Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            await _onLanguageSelected(
                context, onLanguageSelected, languageCode);
          },
          highlightColor: Colors.grey[300],
          splashColor: Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(imagePath, width: 26.w, height: 26.h),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    languageName,
                    style: GoogleFonts.prompt(
                      fontSize: ResponsiveDesignOrientation.isLandscape
                          ? 12.sp
                          : 14.sp,
                      fontWeight: selectedLanguage == languageCode
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                    softWrap: true, // ข้อความสามารถขึ้นบรรทัดใหม่ได้
                    maxLines: null, // ไม่จำกัดจำนวนบรรทัด
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      SizedBox(height: 16.h),
    ],
  );
}

Future<void> _onLanguageSelected(
  BuildContext context,
  Function(String) onLanguageSelected,
  String languageCode,
) async {
  await saveSelectedLanguage(languageCode);
  onLanguageSelected(languageCode);
  context.setLocale(Locale(languageCode));

  Navigator.of(context).pop(); // ปิด Bottom Sheet
  Navigator.of(context).popUntil((route) => route.isFirst); // ปิด Drawer

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const HomeScreen()),
  );
}
