import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;
import 'package:botnoivoice/screen/drawer/genskript/widgets/genskript_download_all_dialog.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../data/api_constants.dart';

class DownloadService {
  static Future<String?> requestDownloadUrl({
    required List<Map<String, dynamic>> payloadData,
    required int totalPoints,
    required String extension,
    required DownloadMode mode,
  }) async {
    debugPrint("Downloading All...");

    try {
      final Map<String, dynamic> requestBody = {
        "data": payloadData,
        "point": totalPoints,
        "format": extension,
        "is_zip": mode == DownloadMode.zip,
      };

      final response = await http.post(
        Uri.parse(ApiConstants.downloadVoiceEndpoint),
        headers: ApiConstants.generateHeaders,
        body: jsonEncode(requestBody),
      );

      debugPrint("Download API Status: ${response.statusCode}");
      debugPrint("Download API Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        return data['url'] ?? data['download_url'] ?? data['data'];
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Download Error: $e");
      return null;
    }
  }

  // ฟังก์ชันสำหรับโหลดแล้วทำไฟล์ Zip ภายในมือถือ
  static Future<String?> createLocalZip({
    required List<String> audioUrls,
    required String fileName,
    required String extension,
  }) async {
    try {
      debugPrint("Creating Local Zip with ${audioUrls.length} files...");
      final archive = Archive();

      // โหลดไฟล์เสียงแต่ละอันมาเก็บไว้ใน Memory
      for (int i = 0; i < audioUrls.length; i++) {
        final url = audioUrls[i];
        if (url.isNotEmpty) {
          String safeUrl = url.replaceAll(':443', '');

          final response = await http.get(
            Uri.parse(safeUrl),
            headers: {
              'Referer': 'https://voice.botnoi.ai/',
              'User-Agent': 'BotnoiVoiceMobile'
            },
          );
          if (response.statusCode == 200) {
            final List<int> bytes = response.bodyBytes;
            // ตั้งชื่อไฟล์ตามนามสกุลที่ผู้ใช้เลือก (mp3 / wav)
            final archiveFile =
                ArchiveFile('slide_${i + 1}.$extension', bytes.length, bytes);
            archive.addFile(archiveFile);
          } else {
            // พิมพ์ Log ออกมาถ้าโหลดไม่ได้ จะได้รู้ว่าพังที่ไฟล์ไหน
            debugPrint(
                "❌ Failed to download $safeUrl. Status: ${response.statusCode}");
          }
        }
      }
      if (archive.files.isEmpty) {
        debugPrint("❌ Error: Zip is empty because no files were downloaded.");
        return null;
      }

      // แปลงเป็นไฟล์ Zip
      final zipEncoder = ZipEncoder();
      final List<int>? zipData = zipEncoder.encode(archive);
      if (zipData == null) return null;

      // หาที่อยู่สำหรับเซฟไฟล์
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists())
          directory = await getExternalStorageDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      // บันทึกไฟล์ลงเครื่อง
      if (directory != null) {
        final zipFile = File('${directory.path}/$fileName');
        await zipFile.writeAsBytes(zipData);
        return zipFile.path;
      }
      return null;
    } catch (e) {
      debugPrint("Zip creation error: $e");
      return null;
    }
  }

  // ฟังก์ชันใหม่ สำหรับขอ API รวมไฟล์เสียงหลายลิงก์เป็นไฟล์เดียว
  static Future<String?> mergeAudioToSingleFile({
    required List<String> audioUrls,
    required String extension,
    required String workspaceId,
  }) async {
    debugPrint("Merging Audio to Single File via API...");
    try {
      // ดึง user_id ออกมาจาก Token ที่มีอยู่
      String userId = "";
      try {
        final parts = ApiConstants.Token.split('.');
        if (parts.length == 3) {
          final payload =
              utf8.decode(base64Url.decode(base64.normalize(parts[1])));
          final Map<String, dynamic> tokenData = jsonDecode(payload);
          userId = tokenData['user_id'] ?? "";
        }
      } catch (e) {
        debugPrint("Decode token error: $e");
      }

      final Map<String, dynamic> requestBody = {
        "link": audioUrls,
        "type_media": extension,
        "user_id": userId,
        "workspace_id": workspaceId,
      };

      final response = await http.post(
        Uri.parse(ApiConstants.mergeVoiceEndpoint),
        headers: ApiConstants.generateHeaders,
        body: jsonEncode(requestBody),
      );

      debugPrint("Merge API Status: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        // คืนค่า URL ที่ผ่านการ Merge เรียบร้อยแล้ว
        return data['url'] ?? data['data'] ?? data['file_url'];
      } else {
        debugPrint("Merge API Failed: ${response.body}");
      }
    } catch (e) {
      debugPrint("Merge Audio Error: $e");
    }
    return null;
  }
}
