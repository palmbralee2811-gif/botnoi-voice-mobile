import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:botnoivoice/config/api_url_config.dart'; // Import config เพื่อใช้ apiReferer
import 'package:botnoivoice/screen/main/home/function/create_ios_app_folder.dart';
import 'package:botnoivoice/screen/main/home/function/download_file_to_temp.dart';
import 'package:botnoivoice/service/permission/android_permission.dart';
import 'package:botnoivoice/shared/dialog/open_app_settings/open_app_settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:share_plus/share_plus.dart';

class MarAdsDownloadLogic {
  final ReceivePort _port = ReceivePort();
  String? taskId;
  VoidCallback? _onDownloadSuccess;

  /// เริ่มต้นระบบ Downloader (เรียกใน initState)
  void initialize() {
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  /// ปิดระบบ Downloader (เรียกใน dispose)
  void dispose() {
    _unbindBackgroundIsolate();
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      String id = data[0];
      int status = data[1];
      int progress = data[2];

      debugPrint(
          "Download Callback: id=$id, status=$status, progress=$progress");
      debugPrint("Expected taskId: $taskId");

      // [เพิ่ม] เช็คสถานะ: 3 คือ DownloadTaskStatus.complete
      if (status == 3 && id == taskId) {
        if (_onDownloadSuccess != null) {
          _onDownloadSuccess!(); // เรียก Dialog แสดงผล
          _onDownloadSuccess = null; // เคลียร์ค่าทิ้ง
        }
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  /// ฟังก์ชันหลักสำหรับจัดการการดาวน์โหลด หรือ แชร์
  Future<void> handleDownload({
    required BuildContext context,
    required String url,
    required String? existingFileName,
    required bool isShare,
    required VoidCallback
        onSuccess, // Callback เมื่อโหลดเสร็จ (เพื่อโชว์ Dialog)
  }) async {
    final fileName = existingFileName ??
        "botnoi_marads_${DateTime.now().millisecondsSinceEpoch}.mp3";

    if (isShare) {
      await _handleShareProcess(context, url, fileName);
    } else {
      await _handleSaveToDeviceProcess(context, url, fileName, onSuccess);
    }
  }

  // --- Logic การแชร์ (โหลดลง Temp) ---
  Future<void> _handleShareProcess(
      BuildContext context, String url, String fileName) async {
    // 1. แสดง Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // 2. เรียก Service ดาวน์โหลด
    final file = await downloadFileToTemporaryDirectory(url, fileName);

    // 3. ปิด Loading
    if (context.mounted) Navigator.pop(context);

    // 4. เช็คผลลัพธ์
    if (file != null) {
      if (context.mounted) {
        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'เสียงโฆษณาจาก Botnoi Voice',
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("ดาวน์โหลดไม่สำเร็จ กรุณาลองใหม่อีกครั้ง")),
        );
      }
    }
  }

  // --- Logic การบันทึกลงเครื่อง (FlutterDownloader) ---
  Future<void> _handleSaveToDeviceProcess(BuildContext context, String url,
      String fileName, VoidCallback onSuccess) async {
    if (Platform.isAndroid) {
      final hasPermission =
          await AndroidPermission().requestAndroidPermission();
      if (!hasPermission) {
        if (context.mounted) {
          OpenAppSettingsDialog(
                  context: context,
                  text: 'สิทธิ์ถูกปฏิเสธ กรุณาไปที่การตั้งค่า')
              .showPermissionDeniedDialog();
        }
        return;
      }
    }

    // เริ่มดาวน์โหลด
    String folderPath = "";
    try {
      if (Platform.isAndroid) {
        folderPath = "/storage/emulated/0/Download";
      } else if (Platform.isIOS) {
        folderPath = await createiOSAppFolder();
      }

      _onDownloadSuccess = onSuccess;

      // เพิ่ม Headers
      taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: folderPath,
        fileName: fileName,
        headers: {
          "Referer": apiReferer,
          "Origin": apiReferer,
        },
        showNotification: true,
        openFileFromNotification: true,
      );

      // // เรียก Callback แจ้งเตือนว่าสำเร็จ
      // if (context.mounted) {
      //   // (Optional) ใส่ Delay นิดนึง (0.5วิ) ให้ความรู้สึกว่าระบบได้ประมวลผลแล้วค่อยเด้ง Dialog
      //   await Future.delayed(const Duration(milliseconds: 500));

      //   if (context.mounted) {
      //     onSuccess();
      //   }
      // }
    } catch (e) {
      _onDownloadSuccess = null;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("เกิดข้อผิดพลาด: $e")),
        );
      }
    }
  }
}
