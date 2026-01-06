// lib/shared/widget/language_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/screen/main/speaker/model/language_filter.dart';

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
    return GestureDetector(
      onTap: () {
        setState(() => isExpanded = true);
        _openLanguageModal(context).whenComplete(() {
          if (mounted) setState(() => isExpanded = false);
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
      isScrollControlled: true, // ให้ Modal ยืดตามเนื้อหาได้สวยงาม
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          constraints: BoxConstraints(maxHeight: 0.8.sh), // สูงไม่เกิน 80% ของหน้าจอ
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Drag Handle ---
              SizedBox(height: 12.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 16.h),
              
              // --- Title ---
              Text(
                'language'.tr(),
                style: GoogleFonts.prompt(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16.h),
              
              // --- Divider ---
              Divider(height: 1, color: Colors.grey.shade200),

              // --- List ---
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveDesignOrientation.isLandscape ? 10.w : 16.w,
                    vertical: 8.h,
                  ),
                  child: Column(
                    children: languageFilter.map((lang) {
                      final bool isSelected = _getDisplayName(context, lang) == widget.selectedLanguage;
                      
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 4.h),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue.withOpacity(0.05) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                          leading: Container(
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
                              child: lang['image'].toString().endsWith('.svg')
                                  ? SvgPicture.asset(
                                      lang['image'].toString(),
                                      width: 28.w,
                                      height: 28.w,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      lang['image'].toString(),
                                      width: 28.w,
                                      height: 28.w,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          title: Text(
                            _getDisplayName(context, lang),
                            style: GoogleFonts.prompt(
                              fontSize: 16.sp,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              color: isSelected ? Colors.blue : Colors.black87,
                            ),
                          ),
                          trailing: isSelected 
                              ? Icon(Icons.check_circle_rounded, color: Colors.blue, size: 20.sp)
                              : null,
                          onTap: () {
                            widget.onSelected(lang);
                            
                            // Navigator.pop(context);
                            context.pop();
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 20.h), // Safe area bottom padding
            ],
          ),
        );
      },
    );
  }

  Widget _buildButtonContainer(String imagePath, String text, bool isExpanded) {
    // ปรับขนาด Container ตามดีไซน์ Minimal
    return Container(
      // ตัด width: 100.w ออกเพื่อให้ยืดหดตาม Parent หรือใส่ Constraints ถ้าต้องการ
      // แต่ถ้าต้องการ Fix width ตามเดิมก็สามารถใส่กลับได้
      constraints: BoxConstraints(
        minWidth: ResponsiveDesignOrientation.isLandscape ? 110.w : 120.w,
        maxWidth: 200.w, 
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r), // มุมมนมากขึ้น
        border: Border.all(
          color: isExpanded ? Colors.blue.withOpacity(0.5) : const Color(0xFFE0E0E0), // เปลี่ยนสีขอบเมื่อกด
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9E9E9E).withOpacity(0.1), // เงาบางๆ
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // จัดระยะห่างให้สวยงาม
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval( // ตัดภาพธงเป็นวงกลม
                child: imagePath.endsWith('.svg')
                    ? SvgPicture.asset(
                        imagePath,
                        width: 20.w,
                        height: 20.w,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        imagePath,
                        width: 20.w,
                        height: 20.w,
                        fit: BoxFit.cover,
                      ),
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.prompt(
                    fontSize: ResponsiveDesignOrientation.isLandscape ? 13.sp : 14.sp,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 8.w),
          Icon(
            isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
            size: 20.sp,
            color: Colors.grey[600],
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