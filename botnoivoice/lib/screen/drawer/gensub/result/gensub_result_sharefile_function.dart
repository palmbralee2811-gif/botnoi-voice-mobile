// result_sharefile_function.dart

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

/// ฟังก์ชันแชร์ Text/SRT ให้ใช้นามสกุลไฟล์ตามต้นฉบับ
Future<void> genSubShareTextFile(BuildContext context, String filePath) async {
  final box = context.findRenderObject() as RenderBox?;
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  // กำหนด MimeType เป็น text/plain เพื่อให้รองรับแอปได้หลากหลาย
  String mimeType = 'text/plain';

  try {
    final shareResult = await Share.shareXFiles(
      [
        XFile(
          filePath,
          mimeType: mimeType,
        )
      ],
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );

    String message;
    switch (shareResult.status) {
      case ShareResultStatus.success:
        message = 'Share Text File Successful ${filePath.split('/').last}';
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
