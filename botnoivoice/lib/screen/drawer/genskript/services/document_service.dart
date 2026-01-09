import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import '../data/api_constants.dart';

class DocumentService {
  static Future<PlatformFile?> pickFile({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: type,
        allowedExtensions: allowedExtensions,
      );
      return result?.files.first;
    } catch (e) {
      print("❌ Pick File Error: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> handleFileUpload(
    PlatformFile file,
  ) async {
    final String ext = file.extension?.toLowerCase() ?? '';
    print("📂 Processing: ${file.name} (Ext: $ext)");

    if (['png', 'jpg', 'jpeg'].contains(ext)) {
      return await _simpleImageUpload(file);
    } else if (['pdf', 'pptx', 'ppt'].contains(ext)) {
      return await _processThreeStepDocument(file, ext);
    }
    return null;
  }

  static Future<Map<String, dynamic>?> _processThreeStepDocument(
    PlatformFile file,
    String ext,
  ) async {
    final String cleanExt = ext.replaceAll('.', '').toLowerCase();
    final bool isPdf = cleanExt == 'pdf';

    final String countUrl = isPdf
        ? ApiConstants.countPdf
        : ApiConstants.countPptx;
    final String uploadUrl = isPdf
        ? ApiConstants.uploadPdf
        : ApiConstants.uploadPptx;
    String convertUrl = isPdf
        ? ApiConstants.convertPdf
        : ApiConstants.convertPptx;

    // --- เริ่มต้น Try บล็อกหลัก (Outer Try) ---
    try {
      print("🚀 Starting 3-Step Process for $ext");

      // --- Step 1: Count ---
      final countRes = await _multipartRequest(countUrl, file);
      final countBody = await countRes.stream.bytesToString();
      if (countRes.statusCode != 200) {
        print("❌ Step 1 Failed (${countRes.statusCode}): $countBody");
        return null;
      }
      final countData = jsonDecode(countBody);
      print("✅ Step 1 Success: $countData");

      // --- Step 2: Upload ---
      final uploadRes = await _multipartRequest(uploadUrl, file);
      final uploadBody = await uploadRes.stream.bytesToString();
      if (uploadRes.statusCode != 200) {
        print("❌ Step 2 Failed (${uploadRes.statusCode}): $uploadBody");
        return null;
      }
      final uploadData = jsonDecode(uploadBody);
      print("📍 Step 2 Result Body: $uploadData");

      String? fileUrl =
          uploadData['pdf_url'] ??
          uploadData['pptx_url'] ??
          uploadData['file_url'];

      if (fileUrl == null || !fileUrl.startsWith('http')) {
        print("❌ Step 3 Aborted: fileUrl is not a valid URL: $fileUrl");
        return null;
      }

      // --- Step 3: Convert (Nested Try) ---
      try {
        final String requestKey = isPdf ? 'pdf_url' : 'pptx_url';
        final String encodedBody = jsonEncode({requestKey: fileUrl});

        final Map<String, String> jsonHeaders = {
          ...ApiConstants.generateHeaders,
          "Content-Type": "application/json",
          "Accept": "application/json",
        };

        print("---------------- DEBUG STEP 3 ----------------");
        print("🔗 URL: $convertUrl");
        print("📤 Sending JSON with Key: $requestKey");

        var response = await http.post(
          Uri.parse(convertUrl),
          headers: jsonHeaders,
          body: encodedBody,
        );

        // Logic สำหรับ 422 Fallback
        if (response.statusCode == 422 || response.statusCode == 400) {
          print(
            "⚠️ JSON Failed (${response.statusCode}), trying Form-data fallback...",
          );
          final Map<String, String> fallbackHeaders = Map.from(
            ApiConstants.generateHeaders,
          );
          fallbackHeaders.removeWhere(
            (key, value) => key.toLowerCase() == 'content-type',
          );

          response = await http.post(
            Uri.parse(convertUrl),
            headers: fallbackHeaders,
            body: {requestKey: fileUrl},
          );
        }

        // ใน DocumentService.dart (Step 3)
        if (response.statusCode == 200) {
          final convertData = jsonDecode(response.body);

          // 🚩 บรรทัดสำคัญ: Print ดูว่าจริงๆ แล้ว Server ส่ง Key อะไรมา
          print("🌐 RAW SERVER RESPONSE (Step 3): $convertData");

          // ดึง List ออกมา
          List<dynamic> urlList = convertData['img_url_list'] ?? [];

          return {
            // ดึงรูปแรกมาเป็นตัวหลัก (ป้องกัน UI พัง)
            "image_url": urlList.isNotEmpty ? urlList[0] : null,
            // ส่ง List ทั้งหมดกลับไปด้วยเผื่ออยากโชว์ทุกหน้า
            "image_list": urlList,
            "page_count": countData['pages'] ?? urlList.length ?? 1,
          };
        } else {
          print("❌ Step 3 Failed Final (Status: ${response.statusCode})");
          print("📄 Server Response: ${response.body}");
          return null;
        }
      } catch (e) {
        print("💥 Step 3 Critical Exception: $e");
        return null;
      }
      // --- จบ Step 3 ---
    } catch (e) {
      // ✅ เพิ่ม Catch สำหรับบล็อก try ด้านบนสุด (แก้ไขข้อผิดพลาดที่แจ้ง)
      print("💥 Critical Error in 3-Step Process: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> _simpleImageUpload(
    PlatformFile file,
  ) async {
    final response = await _multipartRequest(ApiConstants.uploadEndpoint, file);
    if (response.statusCode == 200) {
      final data = jsonDecode(await response.stream.bytesToString());
      return {"image_url": data['img_url'] ?? data['url'], "page_count": 1};
    }
    return null;
  }

  static Future<http.StreamedResponse> _multipartRequest(
    String url,
    PlatformFile file,
  ) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(ApiConstants.generateHeaders);
    const String fileKey = 'file';
    if (file.bytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(fileKey, file.bytes!, filename: file.name),
      );
    } else if (file.path != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          fileKey,
          file.path!,
          filename: file.name,
        ),
      );
    }
    return await request.send();
  }
}
