import 'package:botnoivoice/screen/main/speaker/entities/speaker_entity.dart';
import 'package:botnoivoice/screen/main/speaker/model/speaker_model.dart';
import 'package:botnoivoice/screen/main/speaker/widget/speaker_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';

// สร้าง instance ของ Logger สำหรับใช้ log ข้อมูล
final Logger logger = Logger();

class FavoriteFilter extends StatelessWidget {
  // รายการ speakerId ที่ผู้ใช้กด Favorite ไว้
  final List<String> selectedIndexFavorites;

  // ชุด index ของไอเทมที่ถูกเลือก (selected) ใน Grid
  final Set<int> selectedIndex;

  // ฟังก์ชัน callback เมื่อผู้ใช้กดไอเทม
  final Function(int index, SpeakerEntity speaker) onSpeakerTap;

  // ฟังก์ชัน callback เมื่อผู้ใช้ toggle favorite
  final Function(String speakerId) onFavoriteToggle;

  // ภาษาในปัจจุบันที่ใช้สำหรับ filter
  final String currentLanguage;

  // เซ็ตของ category ที่ใช้ filter
  final Set<String> currentCategories;

  // เซ็ตของ voice style ที่ใช้ filter
  final Set<String> currentStyles;

  // เพศที่ใช้ filter
  final String currentGender;

  const FavoriteFilter({
    super.key,
    required this.selectedIndexFavorites,
    required this.selectedIndex,
    required this.onSpeakerTap,
    required this.onFavoriteToggle,
    required this.currentLanguage,
    required this.currentCategories,
    required this.currentStyles,
    required this.currentGender,
  });

  /// ฟังก์ชันสำหรับกรองรายชื่อ speaker ที่ถูกกด favorite และตรงตาม filter อื่นๆ
  List<SpeakerEntity> _filterFavorites(BuildContext context) {
    // ดึงรหัสภาษาปัจจุบันจาก locale ของ context
    String languageCode = Localizations.localeOf(context).languageCode;

    // เริ่มต้นด้วยการกรองเฉพาะ speaker ที่อยู่ใน selectedIndexFavorites
    List<SpeakerEntity> filtered = SpeakerModel.speakerItem
        .where((item) => selectedIndexFavorites.contains(item.speakerId))
        .toList();

    // กรองตามภาษา ถ้าไอเทมตรงกับ currentLanguage
    filtered = filtered.where((item) => item.language == currentLanguage).toList();

    // ถ้าไม่มีไอเทมตรงภาษา ให้เลือกไอเทมที่ availableLanguage มีภาษาปัจจุบัน
    if (filtered.isEmpty) {
      filtered = SpeakerModel.speakerItem
          .where((item) =>
              selectedIndexFavorites.contains(item.speakerId) &&
              item.availableLanguage.contains(currentLanguage.toLowerCase()) &&
              item.language != currentLanguage)
          .toList();
    }

    // กรองตามเพศ ถ้ามีการกำหนด
    if (currentGender.isNotEmpty) {
      filtered = filtered.where((item) => item.gender == currentGender).toList();
    }

    // กรองตาม voice style ถ้ามีการกำหนด
    if (currentStyles.isNotEmpty) {
      filtered = filtered.where((item) {
        if (languageCode == 'th') {
          // ถ้าเป็นภาษาไทย ตรวจสอบ voiceStyle ของ item
          return item.voiceStyle.isNotEmpty &&
              item.voiceStyle.any((style) => currentStyles.contains(style));
        } else {
          // ถ้าไม่ใช่ภาษาไทย ตรวจสอบ engVoiceStyle
          return item.engVoiceStyle.isNotEmpty &&
              item.engVoiceStyle.any((style) => currentStyles.contains(style));
        }
      }).toList();
    }

    // กรองตาม speech style หรือ category ถ้ามีการกำหนด
    if (currentCategories.isNotEmpty) {
      filtered = filtered.where((item) {
        if (languageCode == 'th') {
          // ตรวจสอบ speechStyle ของภาษาไทย
          return item.speechStyle.isNotEmpty &&
              item.speechStyle.any((category) => currentCategories.contains(category));
        } else {
          // ตรวจสอบ engSpeechStyle ของภาษาอื่น
          return item.engSpeechStyle.isNotEmpty &&
              item.engSpeechStyle.any((category) => currentCategories.contains(category));
        }
      }).toList();
    }

    // log จำนวน speaker ที่ผ่านการกรองแล้ว
    logger.i("Total favorite speakers after filtering: ${filtered.length}");

    // คืนค่า filtered list
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    // เรียกฟังก์ชันกรอง speaker
    final favoriteSpeakers = _filterFavorites(context);

    // ถ้าไม่มี speaker ที่ตรงกับ filter แสดงข้อความแจ้งผู้ใช้
    if (favoriteSpeakers.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(top: 50.h),
          child: Text(
            'ไม่มีผู้พูดที่ถูกใจในภาษานี้',
            style: GoogleFonts.prompt(fontSize: 16.sp, color: Colors.black54),
          ),
        ),
      );
    }

    // แสดง speaker ใน GridView ที่อยู่ใน SingleChildScrollView
    return SingleChildScrollView(
      child: Column(
        children: [
          // GridView.builder สำหรับสร้างไอเทม speaker
          GridView.builder(
            shrinkWrap: true, // ทำให้ GridView ไม่ใช้พื้นที่มากเกินไป
            physics: const NeverScrollableScrollPhysics(), // ป้องกันการ scroll ของ GridView
            itemCount: favoriteSpeakers.length, // จำนวนไอเทม
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // จำนวนคอลัมน์ใน Grid
              crossAxisSpacing: 0, // ระยะห่างระหว่างคอลัมน์
              mainAxisSpacing: 0, // ระยะห่างระหว่างแถว
              childAspectRatio: 0.8, // อัตราส่วนของแต่ละไอเทม
            ),
            itemBuilder: (context, index) {
              // ดึงข้อมูล speaker จาก filtered list
              final data = favoriteSpeakers[index];

              // หา index ดั้งเดิมของ speaker ในรายการทั้งหมด
              final originalIndex = SpeakerModel.speakerItem
                  .indexWhere((s) => s.speakerId == data.speakerId);

              // แสดงไอเทมด้วย Widget SpeakerGridItem
              return SpeakerGridItem(
                key: ValueKey(data.speakerId), // ใช้ speakerId เป็น key
                speakerItem: data, // ข้อมูลของ speaker
                index: originalIndex, // index ดั้งเดิม
                isSelected: selectedIndex.contains(originalIndex), // ตรวจสอบว่า item ถูกเลือก
                isFavorite: true, // แสดงว่าเป็น favorite
                onSpeakerTap: onSpeakerTap, // callback เมื่อกดไอเทม
                onFavoriteToggle: onFavoriteToggle, // callback เมื่อ toggle favorite
              );
            },
          ),

          // เพิ่มพื้นที่ว่างด้านล่าง เพื่อให้ scroll ลงสุดหน้าจอได้
          SizedBox(height: 50.h),
        ],
      ),
    );
  }
}
