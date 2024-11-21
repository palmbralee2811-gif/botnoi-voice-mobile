import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> createAppFolder() async {
  // ดึง directory ของแอพ
  final Directory appSupportDirectory = await getApplicationDocumentsDirectory();
  final Directory appFolder = Directory('${appSupportDirectory.path}/bnv');

  if (!(await appFolder.exists())) {
    await appFolder.create(recursive: true); // สร้างโฟลเดอร์ถ้ายังไม่มี
  }

  return appFolder.path; // ส่งคืนเส้นทางโฟลเดอร์
}
