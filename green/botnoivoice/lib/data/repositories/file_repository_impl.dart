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
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  @override
  Future<bool> saveFileCustomPath(String sourceFilePath) async {
    try {
      // Check if the source file exists
      if (sourceFilePath.isEmpty) {
        _errorMessage = "Source file path is empty.";
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
        _errorMessage = "Cannot extract file name from sourceFilePath.";
        logger.e("Cannot extract file name from sourceFilePath.");
        return false;
      }

      String destinationFilePath = p.join(destinationDirectory.path, fileName);

      // Copy file to the selected location
      File destinationFile = File(destinationFilePath);
      await destinationFile.writeAsBytes(await sourceFile.readAsBytes());

      logger.i("File successfully saved to: $destinationFilePath");
      _errorMessage = null;
      return true;
    } catch (e, stackTrace) {
      _errorMessage = e.toString();
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