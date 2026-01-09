import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class ScriptService {
  // ฟังก์ชันสำหรับการคัดลอกข้อความลงคลิปบอร์ด
  static Future<void> copyToClipboard(String text, BuildContext context) async {
    if (text.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: text));
      
      // แสดงแถบแจ้งเตือนด้านล่าง (SnackBar) เพื่อให้ผู้ใช้รู้ว่าคัดลอกแล้ว
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("คัดลอกสคริปต์ลงคลิปบอร์ดแล้ว"),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // ฟังก์ชันเดิมที่คุณมี (ถ้ามี)
  static void handleJoinScript() {
    print("Joining scripts...");
  }
}