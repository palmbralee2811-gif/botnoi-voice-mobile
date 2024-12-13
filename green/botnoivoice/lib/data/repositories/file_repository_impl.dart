import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

/// Repository for file operations
abstract class FileRepository {
  Future<bool> saveFileCustomPath(String sourceFilePath);
}

/// Save File using SAF
class FileRepositoryImpl implements FileRepository {
  final Logger logger = Logger();

  @override
  Future<bool> saveFileCustomPath(String sourceFilePath) async {
    try {
      // Check if the source file exists
      if (sourceFilePath.isEmpty) {
        logger.e("Source file path is empty.");
        return false;
      }

      File sourceFile = File(sourceFilePath);
      if (!await sourceFile.exists()) {
        logger.w("Source file does not exist: $sourceFilePath");
        return false;
      }

      // Allow user to select a folder
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      Directory? destinationDirectory;

      if (selectedDirectory != null) {
        destinationDirectory = Directory(selectedDirectory);
      } else {
        // Fallback to "Downloads" directory
        if (Platform.isAndroid) {
          destinationDirectory = Directory('/storage/emulated/0/Download');
        } else if (Platform.isIOS) {
          destinationDirectory = await getApplicationDocumentsDirectory();
        }
      }

      if (destinationDirectory == null || !await destinationDirectory.exists()) {
        logger.w("Destination directory is not accessible.");
        return false;
      }

      // Define destination file path
      String fileName = p.basename(sourceFilePath);
      if (fileName.isEmpty) {
        logger.e("Cannot extract file name from sourceFilePath.");
        return false;
      }

      String destinationFilePath = p.join(destinationDirectory.path, fileName);

      // Copy file to the selected location
      File destinationFile = File(destinationFilePath);
      await destinationFile.writeAsBytes(await sourceFile.readAsBytes());

      logger.i("File successfully saved to: $destinationFilePath");
      return true;
    } catch (e, stackTrace) {
      logger.e("Error saving the file: $e", error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// ตรวจสอบเวอร์ชัน Android
  int androidVersion() {
    try {
      String osVersion = Platform.operatingSystemVersion;

      // พยายามดึง API Level หากมีข้อความเกี่ยวกับ SDK
      if (osVersion.contains("SDK")) {
        int sdkIndex = osVersion.indexOf("SDK");
        String sdkValue = osVersion.substring(sdkIndex + 3).trim();
        return int.tryParse(sdkValue.split('.')[0]) ?? 0;
      }

      // หากไม่พบข้อมูล ให้คืนค่าเริ่มต้น
      return 30; // ค่าเริ่มต้นหากไม่สามารถตรวจสอบ API Level ได้
    } catch (e) {
      logger.e("เกิดข้อผิดพลาดในการตรวจสอบเวอร์ชัน Android: $e");
      return 30; // ค่าเริ่มต้นในกรณีที่เกิดข้อผิดพลาด
    }
  }
}











// import 'dart:io';
// import 'package:logger/logger.dart';
// import 'package:path/path.dart' as p;
// import 'package:path_provider/path_provider.dart';
// import 'package:file_picker/file_picker.dart';

// /// Repository for file operations
// abstract class FileRepository {
//   Future<bool> saveFileCustomPath(String sourceFilePath);
// }

// /// Save File to Documents Directory
// class FileRepositoryImpl implements FileRepository {
//   final Logger logger = Logger();

//   @override
//   Future<bool> saveFileCustomPath(String sourceFilePath) async {
//     try {
//       // ตรวจสอบไฟล์ต้นทาง
//       File sourceFile = File(sourceFilePath);
//       if (!await sourceFile.exists()) {
//         logger.w("ไม่พบไฟล์ต้นทาง: $sourceFilePath");
//         return false;
//       }

//       // ให้ผู้ใช้เลือกโฟลเดอร์ปลายทาง
//       String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
//       if (selectedDirectory == null) {
//         logger.w("ผู้ใช้ยกเลิกการเลือกโฟลเดอร์ปลายทาง");
//         return false;
//       }

//       // ตรวจสอบการเลือกโฟลเดอร์
//       Directory destinationDirectory = Directory(selectedDirectory);

//       // หากผู้ใช้ไม่เลือกโฟลเดอร์ เราสามารถใช้ `path_provider` เป็น fallback
//       if (!await destinationDirectory.exists()) {
//         logger.w("โฟลเดอร์ที่เลือกไม่มีอยู่");
//         if (Platform.isAndroid) {
//           destinationDirectory = await getExternalStorageDirectory() ?? Directory('');
//         } else if (Platform.isIOS) {
//           destinationDirectory = await getApplicationDocumentsDirectory();
//         }
//       }

//       if (!await destinationDirectory.exists()) {
//         logger.w("ไม่สามารถกำหนดโฟลเดอร์ปลายทางได้");
//         return false;
//       }

//       // กำหนดพาธไฟล์ปลายทาง
//       String fileName = p.basename(sourceFilePath);
//       String destinationFilePath = p.join(destinationDirectory.path, fileName);

//       // เขียนไฟล์ไปยังปลายทาง
//       File destinationFile = File(destinationFilePath);
//       await destinationFile.writeAsBytes(await sourceFile.readAsBytes());

//       logger.i("ไฟล์ถูกบันทึกลงใน: $destinationFilePath");
//       return true;
//     } catch (e) {
//       logger.e("เกิดข้อผิดพลาดในการบันทึกไฟล์: $e");
//     }
//     return false;
//   }
// }