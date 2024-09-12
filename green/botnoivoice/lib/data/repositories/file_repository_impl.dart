import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:botnoivoice/domain/repositories/file_repository.dart';

/// Save File to Documents Directory
class FileRepositoryImpl implements FileRepository {
  @override
  Future<bool> saveFileCustomPath(String sourceFilePath) async {
    try {
      // ตรวจสอบไฟล์ต้นทาง
      File sourceFile = File(sourceFilePath);
      if (!await sourceFile.exists()) {
        print("ไม่พบไฟล์ต้นทาง: $sourceFilePath");
        return false;
      }

      // กำหนดโฟลเดอร์ปลายทางบน Android (Downloads)
      Directory? destinationDirectory;
      if (Platform.isAndroid) {
        destinationDirectory = Directory('/storage/emulated/0/Download/bnv');
      } else if (Platform.isIOS) {
        destinationDirectory = await getApplicationDocumentsDirectory();
      }

      if (destinationDirectory != null) {
        // ตรวจสอบว่าโฟลเดอร์ปลายทางมีอยู่แล้วหรือไม่ ถ้าไม่มีให้สร้าง
        if (!await destinationDirectory.exists()) {
          await destinationDirectory.create(recursive: true);
          print("สร้างโฟลเดอร์ดาวน์โหลดใหม่: ${destinationDirectory.path}");
        }

        String fileName = p.basename(sourceFilePath);
        String destinationFilePath =
            p.join(destinationDirectory.path, fileName);

        // บันทึกไฟล์จากต้นทางไปยังโฟลเดอร์ปลายทาง
        File destinationFile = File(destinationFilePath);
        await destinationFile.writeAsBytes(await sourceFile.readAsBytes());

        print("ไฟล์ถูกบันทึกลงใน: $destinationFilePath");
        return true;
      } else {
        print("ไม่สามารถรับพาธของโฟลเดอร์ดาวน์โหลดได้");
      }
    } catch (e) {
      print("Error on saveFileToDocuments(): $e");
    }
    return false;
  }
}
