// result_sharefile_function.dart

import 'package:botnoivoice/screen/main/home/function/random_string.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

/// ฟังก์ชันแชร์ Text/SRT ให้ใช้นามสกุลไฟล์ตามต้นฉบับ
Future<void> genSubShareTextFile(BuildContext context, String filePath) async {
  final box = context.findRenderObject() as RenderBox?;
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  // ดึงนามสกุลไฟล์จริงจาก Path (เช่น srt หรือ txt)
  String fileExtension = filePath.split('.').last;

  // กำหนด MimeType เป็น text/plain เพื่อให้รองรับแอปได้หลากหลาย
  String mimeType = 'text/plain';

  try {
    final shareResult = await Share.shareXFiles(
      [
        XFile(
          filePath,
          // ใช้นามสกุลไฟล์ตามไฟล์ต้นฉบับ
          name: "BotnoiGenSub${randomStringOfNumbers(6)}.$fileExtension",
          mimeType: mimeType,
        )
      ],
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );

    String message;
    switch (shareResult.status) {
      case ShareResultStatus.success:
        message = 'Share Text File Successful';
        break;
      case ShareResultStatus.dismissed:
        message = 'Share Text File Dismissed';
        break;
      default:
        message = 'Share Text File Failed';
        break;
    }

    scaffoldMessenger.showSnackBar(SnackBar(content: Text(message)));
  } catch (e) {
    scaffoldMessenger.showSnackBar(SnackBar(content: Text('Share Error: $e')));
  }
}

// ฟังก์ชันแชร์ Audio ให้ชื่อไฟล์และนามสกุลถูกต้อง
Future<void> genSubShareAudioFile(BuildContext context, String filePath) async {
  final box = context.findRenderObject() as RenderBox?;
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  // ดึงนามสกุลไฟล์จริงจาก Path (เช่น mp3, wav, m4a)
  String fileExtension = filePath.split('.').last;

  // Default MIME type
  String mimeType = 'audio/mpeg';
  final lowerPath = filePath.toLowerCase();

  // ระบุประเภทไฟล์ให้แม่นยำ (MimeType) สำหรับบอก OS ว่าเป็นไฟล์ชนิดไหน
  if (lowerPath.endsWith('.wav')) {
    mimeType = 'audio/wav';
  } else if (lowerPath.endsWith('.m4a') || lowerPath.endsWith('.aac')) {
    mimeType = 'audio/mp4'; 
  } else if (lowerPath.endsWith('.ogg')) {
    mimeType = 'audio/ogg';
  } else if (lowerPath.endsWith('.mp3')) {
    mimeType = 'audio/mpeg';
  }

  try {
    final shareResult = await Share.shareXFiles(
      [
        XFile(
          filePath,
          // ใช้ตัวแปร fileExtension แทนการ split mimeType
          // ทำให้ได้ชื่อไฟล์ เช่น BotnoiGenSub123456.mp3 หรือ .m4a อย่างถูกต้อง
          name: "BotnoiGenSub${randomStringOfNumbers(6)}.$fileExtension",
          mimeType: mimeType,
        )
      ],
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );

    if (shareResult.status == ShareResultStatus.success) {
      scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Share Audio Successful')));
    }
  } catch (e) {
    scaffoldMessenger.showSnackBar(SnackBar(content: Text('Share Error: $e')));
  }
}