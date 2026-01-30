import 'package:botnoivoice/screen/main/speaker/model/gender_filter.dart';
import 'package:botnoivoice/screen/main/speaker/model/language_filter.dart';
import 'package:botnoivoice/screen/main/speaker/model/speaker_model.dart';
import 'package:botnoivoice/screen/main/speaker/widget/language_filter_widget.dart';
import 'package:botnoivoice/screen/main/speaker/widget/modal_header.dart';
import 'package:botnoivoice/screen/main/speaker/widget/speaker_modal_selection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class MarAdsFilterModalSheet extends StatefulWidget {
  final String initialLangCode;
  final String initialLangName;
  final String initialLangImage;
  final String initialGender;
  final Set<String> initialCategories;
  final Set<String> initialStyles;

  const MarAdsFilterModalSheet({
    super.key,
    required this.initialLangCode,
    required this.initialLangName,
    required this.initialLangImage,
    required this.initialGender,
    required this.initialCategories,
    required this.initialStyles,
  });

  @override
  State<MarAdsFilterModalSheet> createState() => _MarAdsFilterModalSheetState();
}

class _MarAdsFilterModalSheetState extends State<MarAdsFilterModalSheet> {
  late String _langCode;
  late String _langName;
  late String _langImage;
  late String _gender;
  late String _genderName;
  late Set<String> _categories;
  late Set<String> _styles;
  bool _isInit = false; // ตัวแปรกันไม่ให้รันซ้ำ

  @override
  void initState() {
    super.initState();
    _langCode = widget.initialLangCode;
    _langName = widget.initialLangName;
    _langImage = widget.initialLangImage;
    _gender = widget.initialGender;
    _categories = Set.from(widget.initialCategories);
    _styles = Set.from(widget.initialStyles);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) return; // ทำงานแค่ครั้งแรก

    // หาชื่อ Gender เริ่มต้น
    final g = genderFilter.firstWhere(
      (element) => element['code'] == _gender,
      orElse: () => genderFilter[0],
    );

    String locale = context.locale.languageCode;
    _genderName = (locale == 'th')
        ? g['thaiName'] as String
        : (locale == 'id')
            ? g['indonesianName'] as String
            : g['englishName'] as String;
    _isInit = true;
  }

  // ย้าย Logic Helper มาไว้ที่นี่
  List<String> _getVoiceStyles() {
    Set<String> stylesSet = {};
    final targetLang = _langCode.trim().toUpperCase();
    final isAppLanguageThai = context.locale.languageCode == 'th';

    for (var speaker in SpeakerModel.speakerItem) {
      if (!speaker.status) continue;
      final spkLangCode = speaker.languageCode.trim().toUpperCase();
      final spkLangName = speaker.language.trim().toUpperCase();

      if (spkLangCode != targetLang && spkLangName != targetLang) continue;

      // หา Style
      if (_categories.isNotEmpty) {
        final speakerCats = isAppLanguageThai
            ? speaker.speechStyle
            : (speaker.engSpeechStyle.isNotEmpty
                ? speaker.engSpeechStyle
                : speaker.speechStyle);

        // ถ้า Speaker คนนี้ไม่มี Category ที่เลือกเลย -> ข้าม (ไม่เอา Style เขามาโชว์)
        if (!speakerCats.any((c) => _categories.contains(c))) continue;
      }

      // ดึง Category ตามภาษาเครื่อง (App Language)
      if (isAppLanguageThai) {
        stylesSet.addAll(speaker.voiceStyle);
      } else {
        if (speaker.engVoiceStyle.isNotEmpty) {
          stylesSet.addAll(speaker.engVoiceStyle);
        }
      }
    }
    // return stylesSet.toList()..sort();
    return stylesSet.where((s) => s.isNotEmpty).toList()..sort();
  }

  List<String> _getCategories() {
    Set<String> catSet = {};
    final targetLang = _langCode.trim().toUpperCase();
    final isAppLanguageThai = context.locale.languageCode == 'th';

    for (var speaker in SpeakerModel.speakerItem) {
      if (!speaker.status) continue;
      final spkLangCode = speaker.languageCode.trim().toUpperCase();
      final spkLangName = speaker.language.trim().toUpperCase();

      if (spkLangCode != targetLang && spkLangName != targetLang) continue;

      // หา Category
      if (_styles.isNotEmpty) {
        final speakerStyles = isAppLanguageThai
            ? speaker.voiceStyle
            : (speaker.engVoiceStyle.isNotEmpty
                ? speaker.engVoiceStyle
                : speaker.voiceStyle);

        // ถ้า Speaker คนนี้ไม่มี Style ที่เลือกเลย -> ข้าม
        if (!speakerStyles.any((s) => _styles.contains(s))) continue;
      }

      // ดึง Style ตามภาษาเครื่อง (App Language)
      if (isAppLanguageThai) {
        catSet.addAll(speaker.speechStyle);
      } else {
        if (speaker.engSpeechStyle.isNotEmpty) {
          catSet.addAll(speaker.engSpeechStyle);
        }
      }
    }
    // return catSet.toList()..sort();
    return catSet.where((c) => c.isNotEmpty).toList()..sort();
  }

  // ฟังก์ชันจัดเรียงภาษา
  List<Map<String, dynamic>> _getSortedLanguageFilter(BuildContext context) {
    List<Map<String, dynamic>> sortedList =
        languageFilter.map((e) => Map<String, dynamic>.from(e)).toList();
    final deviceLang = context.locale.languageCode.toUpperCase();

    // กำหนด ID: ภาษาเครื่อง = 1, อื่นๆ = index + 2
    for (int i = 0; i < sortedList.length; i++) {
      final lang = sortedList[i];
      if ((lang['code'] as String).toUpperCase() == deviceLang) {
        lang['id'] = 1;
      } else {
        lang['id'] = i + 2;
      }
    }

    // เรียงตาม ID
    sortedList.sort((a, b) => (a['id'] as int).compareTo(b['id'] as int));

    return sortedList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.h,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModalHeader(title: 'filter'.tr()),
          SizedBox(height: 20.h),

          // เลือกภาษา
          Text('language'.tr(),
              style: GoogleFonts.prompt(fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                builder: (c) => SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 10.h),
                        // เพิ่ม Padding ครอบ ModalHeader เพื่อดัน "ภาษา" และ "X" เข้ามาจากขอบจอ
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: ModalHeader(title: 'language'.tr()),
                        ),
                        ..._getSortedLanguageFilter(context)
                            // ใช้ Transform.scale ครอบเพื่อปรับขนาด List ให้เล็กลง (0.95 = 95%)
                            .map(
                          (lang) => Transform.scale(
                            scale: 0.95,
                            child: buildLanguageFilterWidget(
                              thaiName: lang['thaiName'] as String,
                              englishName: lang['englishName'] as String,
                              indonesianName: lang['indonesianName'] as String,
                              imagePath: lang['image'] as String,
                              lang: lang['code'] as String,
                              context: context,
                              setState: setState,
                              selectedLanguage: _langName,
                              onSelected: (code, name, img) {
                                setState(() {
                                  _langCode = code;
                                  _langName = name;
                                  _langImage = img;
                                  _styles.clear();
                                  _categories.clear();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: _buildFilterDisplayBox(_langName, _langImage),
          ),

          SizedBox(height: 16.h),

          // เลือกเพศ
          Text('gender'.tr(),
              style: GoogleFonts.prompt(fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          Row(
            children: genderFilter.map((g) {
              final isSelected = _gender == g['code'];
              String currentGenderName = (context.locale.languageCode == 'th')
                  ? g['thaiName'] as String
                  : (context.locale.languageCode == 'id')
                      ? g['indonesianName'] as String
                      : g['englishName'] as String;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _gender = g['code'] as String;
                      _genderName = currentGenderName;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 8.w),
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Text(
                        currentGenderName,
                        style: GoogleFonts.prompt(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 16.h),

          // หมวดหมู่
          Text('category'.tr(),
              style: GoogleFonts.prompt(fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          InkWell(
            onTap: () {
              final cats = _getCategories();
              showModalSelection(
                context: context,
                title: 'category'.tr(),
                items: cats,
                selectedItems: _categories,
                onConfirm: (newSet) {
                  setState(() {
                    _categories = newSet;
                    // รีเฟรชหา Style ที่เป็นไปได้สำหรับ Category นี้
                    final validStyles = _getVoiceStyles();
                    // ตัด Style เก่าที่ไม่อยู่ในรายการใหม่ออก
                    _styles =
                        _styles.where((s) => validStyles.contains(s)).toSet();
                  });
                },
              );
            },
            child: _buildFilterDisplayBox(
              _categories.isEmpty ? 'unlimited'.tr() : _categories.join(", "),
              null,
              hasArrow: true,
            ),
          ),
          SizedBox(height: 16.h),

          // สไตล์เสียง
          Text('style'.tr(),
              style: GoogleFonts.prompt(fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          InkWell(
            onTap: () {
              final styles = _getVoiceStyles();
              showModalSelection(
                context: context,
                title: 'style'.tr(),
                items: styles,
                selectedItems: _styles,
                onConfirm: (newSet) {
                  setState(() {
                    _styles = newSet;
                    // รีเฟรชหา Category ที่เป็นไปได้สำหรับ Style นี้
                    final validCategories = _getCategories();
                    // ตัด Category เก่าที่ไม่อยู่ในรายการใหม่ออก
                    _categories = _categories
                        .where((c) => validCategories.contains(c))
                        .toSet();
                  });
                },
              );
            },
            child: _buildFilterDisplayBox(
              _styles.isEmpty ? 'unlimited'.tr() : _styles.join(", "),
              null,
              hasArrow: true,
            ),
          ),

          const Spacer(),
          // ปุ่มดูผลลัพธ์ (ส่งค่ากลับ)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // ส่ง Map กลับไปให้หน้าหลัก
                context.pop({
                  'langCode': _langCode,
                  'langName': _langName,
                  'langImage': _langImage,
                  'gender': _gender,
                  'genderName': _genderName,
                  'categories': _categories,
                  'styles': _styles,
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: Text('confirm'.tr(),
                  style: GoogleFonts.prompt(color: Colors.white)),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildFilterDisplayBox(String text, String? imagePath,
      {bool hasArrow = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          if (imagePath != null) ...[
            Image.asset(imagePath, width: 20.w),
            SizedBox(width: 8.w),
          ],
          Expanded(
            child: Text(text,
                style: GoogleFonts.prompt(), overflow: TextOverflow.ellipsis),
          ),
          if (hasArrow)
            Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.grey)
          else
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ],
      ),
    );
  }
}
