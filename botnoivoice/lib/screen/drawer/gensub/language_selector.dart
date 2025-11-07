// lib/shared/widget/language_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/screen/main/speaker/model/language_filter.dart'; // ใช้ตัวนี้

class LanguageSelector extends StatefulWidget {
  final String selectedLanguage;
  final String selectedLanguageImage;
  final ValueChanged<Map<String, dynamic>> onSelected;

  const LanguageSelector({
    super.key,
    required this.selectedLanguage,
    required this.selectedLanguageImage,
    required this.onSelected,
  });

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() => isExpanded = true);
        _openLanguageModal(context).whenComplete(() {
          setState(() => isExpanded = false);
        });
      },
      child: _buildButtonContainer(
        widget.selectedLanguageImage,
        widget.selectedLanguage,
        isExpanded,
      ),
    );
  }

  Future<void> _openLanguageModal(BuildContext context) async {
    await showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(ResponsiveDesignOrientation.isLandscape ? 10.w : 12.w),
              child: Column(
                children: [
                  Text(
                    'language'.tr(),
                    style: GoogleFonts.prompt(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...languageFilter.map((lang) {
                    return ListTile(
                      leading: lang['image'].toString().endsWith('.svg')
    ? SvgPicture.asset(lang['image'].toString(), width: 30)
    : Image.asset(lang['image'].toString(), width: 30),
                      title: Text(
                        _getDisplayName(context, lang),
                        style: GoogleFonts.prompt(fontSize: 16.sp),
                      ),
                      onTap: () {
                        widget.onSelected(lang);
                        Navigator.pop(context);
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildButtonContainer(String imagePath, String text, bool isExpanded) {
    return Container(
      width: ResponsiveDesignOrientation.isLandscape ? 90.w : 100.w,
      height: ResponsiveDesignOrientation.isLandscape ? 55.h : 35.h,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(color: const Color(0xFFE2E3E9), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imagePath.endsWith('.svg')
              ? SvgPicture.asset(imagePath, width: 24.w, height: 24.h)
              : Image.asset(imagePath, width: 24.w, height: 24.h),
          SizedBox(width: 6.w),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                text,
                style: GoogleFonts.prompt(
                  fontSize:
                      ResponsiveDesignOrientation.isLandscape ? 12.sp : 16.sp,
                ),
              ),
            ),
          ),
          Icon(
            isExpanded
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
            size: 20,
          ),
        ],
      ),
    );
  }

  String _getDisplayName(BuildContext context, Map<String, dynamic> lang) {
    final locale = Localizations.localeOf(context).languageCode;
    switch (locale) {
      case 'th':
        return lang['thaiName']!;
      case 'id':
        return lang['indonesianName']!;
      default:
        return lang['englishName']!;
    }
  }
}
