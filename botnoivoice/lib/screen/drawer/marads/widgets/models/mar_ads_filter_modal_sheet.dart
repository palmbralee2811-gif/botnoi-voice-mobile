import 'package:botnoivoice/screen/main/speaker/model/gender_filter.dart';
import 'package:botnoivoice/screen/main/speaker/model/language_filter.dart';
import 'package:botnoivoice/screen/main/speaker/model/speaker_model.dart';
import 'package:botnoivoice/screen/main/speaker/widget/language_filter_widget.dart';
import 'package:botnoivoice/screen/main/speaker/widget/modal_header.dart';
import 'package:botnoivoice/screen/main/speaker/widget/speaker_modal_selection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';

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
  final Logger _logger = Logger();

  late String _langCode;
  late String _langName;
  late String _langImage;
  late String _gender;
  late String _genderName;
  late Set<String> _categories;
  late Set<String> _styles;

  @override
  void initState() {
    super.initState();
    _langCode = widget.initialLangCode;
    _langName = widget.initialLangName;
    _langImage = widget.initialLangImage;
    _gender = widget.initialGender;
    _categories = Set.from(widget.initialCategories);
    _styles = Set.from(widget.initialStyles);

    // หาชื่อ Gender เริ่มต้น
    final g = genderFilter.firstWhere((element) => element['code'] == _gender,
        orElse: () => {'thaiName': 'ช/ญ'});
    _genderName = g['thaiName'] as String;
  }

  // ย้าย Logic Helper มาไว้ที่นี่
  List<String> _getVoiceStyles() {
    Set<String> stylesSet = {};
    final targetLang = _langCode.trim().toUpperCase();
    final isThai = targetLang == 'TH';

    for (var speaker in SpeakerModel.speakerItem) {
      if (!speaker.status) continue;
      final spkLangCode = speaker.languageCode.trim().toUpperCase();
      final spkLangName = speaker.language.trim().toUpperCase();

      if (spkLangCode == targetLang || spkLangName == targetLang) {
        if (isThai) {
          stylesSet.addAll(speaker.voiceStyle);
        } else {
          if (speaker.engVoiceStyle.isNotEmpty) {
            stylesSet.addAll(speaker.engVoiceStyle);
          } else {
            stylesSet.addAll(speaker.voiceStyle);
          }
        }
      }
    }
    return stylesSet.toList()..sort();
  }

  List<String> _getCategories() {
    Set<String> catSet = {};
    final targetLang = _langCode.trim().toUpperCase();
    final isThai = targetLang == 'TH';

    for (var speaker in SpeakerModel.speakerItem) {
      if (!speaker.status) continue;
      final spkLangCode = speaker.languageCode.trim().toUpperCase();
      final spkLangName = speaker.language.trim().toUpperCase();

      if (spkLangCode == targetLang || spkLangName == targetLang) {
        if (isThai) {
          catSet.addAll(speaker.speechStyle);
        } else {
          if (speaker.engSpeechStyle.isNotEmpty) {
            catSet.addAll(speaker.engSpeechStyle);
          } else {
            catSet.addAll(speaker.speechStyle);
          }
        }
      }
    }
    return catSet.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.h,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ModalHeader(title: "ตัวกรอง"),
          SizedBox(height: 20.h),

          // เลือกภาษา
          Text("ภาษา", style: GoogleFonts.prompt(fontWeight: FontWeight.w600)),
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
                        ModalHeader(title: 'language'.tr()),
                        ...languageFilter
                            .map((lang) => buildLanguageFilterWidget(
                                  thaiName: lang['thaiName'] as String,
                                  englishName: lang['englishName'] as String,
                                  indonesianName:
                                      lang['indonesianName'] as String,
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
                                ))
                            .toList()
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
          Text("เพศ", style: GoogleFonts.prompt(fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          Row(
            children: genderFilter.map((g) {
              final isSelected = _gender == g['code'];
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _gender = g['code'] as String;
                      _genderName = g['thaiName'] as String;
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
                        g['thaiName'] as String,
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
          Text("หมวดหมู่",
              style: GoogleFonts.prompt(fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          InkWell(
            onTap: () {
              final cats = _getCategories();
              showModalSelection(
                context: context,
                title: "เลือกหมวดหมู่",
                items: cats,
                selectedItems: _categories,
                onConfirm: (newSet) => setState(() => _categories = newSet),
              );
            },
            child: _buildFilterDisplayBox(
              _categories.isEmpty ? "ทั้งหมด" : _categories.join(", "),
              null,
              hasArrow: true,
            ),
          ),
          SizedBox(height: 16.h),

          // สไตล์เสียง
          Text("สไตล์เสียง",
              style: GoogleFonts.prompt(fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          InkWell(
            onTap: () {
              final styles = _getVoiceStyles();
              showModalSelection(
                context: context,
                title: "เลือกสไตล์",
                items: styles,
                selectedItems: _styles,
                onConfirm: (newSet) => setState(() => _styles = newSet),
              );
            },
            child: _buildFilterDisplayBox(
              _styles.isEmpty ? "ทั้งหมด" : _styles.join(", "),
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
                Navigator.pop(context, {
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
              child: Text("ดูผลลัพธ์",
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
                  style: GoogleFonts.prompt(),
                  overflow: TextOverflow.ellipsis)),
          if (hasArrow)
            Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colors.grey)
          else
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ],
      ),
    );
  }
}
