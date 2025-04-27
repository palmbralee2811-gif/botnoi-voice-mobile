import 'package:botnoivoice/screen/main/speaker/widget/filter_option.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// สร้าง Widget แบบ Stateless เพราะข้อมูลไม่เปลี่ยนแปลงภายในตัวมันเอง
class GenderFilterWidget extends StatelessWidget {
  // กำหนดตัวแปรที่รับค่าจากข้างนอกมาใช้งาน
  final String thaiName;         // ชื่อภาษาไทย
  final String englishName;      // ชื่อภาษาอังกฤษ
  final String indonesianName;   // ชื่อภาษาอินโดนีเซีย
  final String imagePath;        // path รูปภาพของเพศ
  final String gender;           // รหัสเพศ (เช่น male / female)
  final String selectedGender;   // เพศที่ถูกเลือกในปัจจุบัน (ใช้สำหรับเช็คว่าตัวนี้ถูกเลือกอยู่ไหม)
  final void Function(String displayText, String imagePath, String gender) onSelected; 
  // ฟังก์ชัน callback ที่จะถูกเรียกเมื่อกดเลือก (ส่งค่าชื่อ, รูป, และรหัสเพศกลับไปให้ parent)

  // Constructor ที่บังคับให้ทุกตัวต้องใส่ค่ามา (required)
  const GenderFilterWidget({
    super.key,
    required this.thaiName,
    required this.englishName,
    required this.indonesianName,
    required this.imagePath,
    required this.gender,
    required this.selectedGender,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    // ตรวจสอบภาษาปัจจุบันของแอพ (locale)
    String languageCode = Localizations.localeOf(context).languageCode;
    languageCode = languageCode.isNotEmpty ? languageCode : 'en'; // ถ้าไม่รู้ให้ใช้ภาษาอังกฤษ

    // map สำหรับเก็บชื่อเพศตามภาษาต่าง ๆ
    Map<String, String> languageMap = {
      'th': thaiName,
      'en': englishName,
      'id': indonesianName,
    };

    // เลือกแสดงชื่อเพศตามภาษาปัจจุบัน
    String displayText = languageMap[languageCode]?.isNotEmpty == true
        ? languageMap[languageCode]! // ถ้ามีชื่อในภาษานั้นก็ใช้
        : englishName;               // ถ้าไม่มีให้ fallback เป็นภาษาอังกฤษ

    return InkWell(
      // คลิกแล้วทำ 2 อย่าง:
      onTap: () {
        onSelected(displayText, imagePath, gender); // เรียก onSelected เพื่อบอก parent ว่าเลือกอันนี้
        context.pop(); // ปิดหน้าเลือก (pop กลับไปหน้าเดิม)
      },
      child: FilterOption(
        imagePath: imagePath,           // ส่ง path รูปเข้าไปแสดง
        text: displayText,              // ส่งชื่อที่เลือกตามภาษา
        isSelected: selectedGender == displayText, // เช็คว่าใช่ตัวที่เลือกอยู่ไหม (ถ้าใช่จะเน้นตัวหนา)
      ),
    );
  }
}
