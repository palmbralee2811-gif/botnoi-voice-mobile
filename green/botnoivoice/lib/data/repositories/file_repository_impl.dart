import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

/// Repository for file operations
abstract class FileRepository {
  Future<bool> saveFileCustomPath(String sourceFilePath);
}

/// Save File to Documents Directory
class FileRepositoryImpl implements FileRepository {
  final Logger logger = Logger();

  @override
  Future<bool> saveFileCustomPath(String sourceFilePath) async {
    try {
      // ตรวจสอบไฟล์ต้นทาง
      File sourceFile = File(sourceFilePath);
      if (!await sourceFile.exists()) {
        logger.w("ไม่พบไฟล์ต้นทาง: $sourceFilePath");
        return false;
      }

      // ให้ผู้ใช้เลือกโฟลเดอร์ปลายทาง
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory == null) {
        logger.w("ผู้ใช้ยกเลิกการเลือกโฟลเดอร์ปลายทาง");
        return false;
      }

      // ตรวจสอบการเลือกโฟลเดอร์
      Directory destinationDirectory = Directory(selectedDirectory);

      // หากผู้ใช้ไม่เลือกโฟลเดอร์ เราสามารถใช้ `path_provider` เป็น fallback
      if (!await destinationDirectory.exists()) {
        logger.w("โฟลเดอร์ที่เลือกไม่มีอยู่");
        if (Platform.isAndroid) {
          destinationDirectory = await getExternalStorageDirectory() ?? Directory('');
        } else if (Platform.isIOS) {
          destinationDirectory = await getApplicationDocumentsDirectory();
        }
      }

      if (!await destinationDirectory.exists()) {
        logger.w("ไม่สามารถกำหนดโฟลเดอร์ปลายทางได้");
        return false;
      }

      // กำหนดพาธไฟล์ปลายทาง
      String fileName = p.basename(sourceFilePath);
      String destinationFilePath = p.join(destinationDirectory.path, fileName);

      // เขียนไฟล์ไปยังปลายทาง
      File destinationFile = File(destinationFilePath);
      await destinationFile.writeAsBytes(await sourceFile.readAsBytes());

      logger.i("ไฟล์ถูกบันทึกลงใน: $destinationFilePath");
      return true;
    } catch (e) {
      logger.e("เกิดข้อผิดพลาดในการบันทึกไฟล์: $e");
    }
    return false;
  }
}