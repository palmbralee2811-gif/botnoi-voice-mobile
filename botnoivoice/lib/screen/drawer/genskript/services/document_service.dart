import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:logger/logger.dart';
import '../data/api_constants.dart';

// Initialize the logger
var logger = Logger(
);

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
      logger.e("Pick File Error", error: e);
      return null;
    }
  }

  static Future<Map<String, dynamic>?> handleFileUpload(
    PlatformFile file,
  ) async {
    final String ext = file.extension?.toLowerCase() ?? '';
    logger.d("Processing: ${file.name} (Ext: $ext)");

    try {
      if (['png', 'jpg', 'jpeg'].contains(ext)) {
        return await _simpleImageUpload(file);
      } else if (['pdf', 'pptx', 'ppt'].contains(ext)) {
        return await _processThreeStepDocument(file, ext);
      }
      logger.d("Unsupported file extension: $ext");
      return null;
    } catch (e) {
      logger.e("Critical Error in handleFileUpload", error: e);
      return null;
    }
  }

  static Future<Map<String, dynamic>?> _processThreeStepDocument(
    PlatformFile file,
    String ext,
  ) async {
    final String cleanExt = ext.replaceAll('.', '').toLowerCase();
    final bool isPdf = cleanExt == 'pdf';

    final String countUrl = isPdf ? ApiConstants.countPdf : ApiConstants.countPptx;
    final String uploadUrl = isPdf ? ApiConstants.uploadPdf : ApiConstants.uploadPptx;
    String convertUrl = isPdf ? ApiConstants.convertPdf : ApiConstants.convertPptx;

    try {
      logger.d("Starting 3-Step Process for $ext");

      // --- Step 1: Count ---
      final countRes = await _multipartRequest(countUrl, file);
      final countBody = await countRes.stream.bytesToString();
      
      if (countRes.statusCode != 200) {
        logger.e("Step 1 Failed (${countRes.statusCode}): $countBody");
        return null;
      }
      
      final countData = jsonDecode(countBody);
      logger.d("Step 1 Success: $countData");

      // --- Step 2: Upload ---
      final uploadRes = await _multipartRequest(uploadUrl, file);
      final uploadBody = await uploadRes.stream.bytesToString();
      
      if (uploadRes.statusCode != 200) {
        logger.e("Step 2 Failed (${uploadRes.statusCode}): $uploadBody");
        return null;
      }
      
      final uploadData = jsonDecode(uploadBody);
      logger.d("Step 2 Result Body: $uploadData");

      String? fileUrl = uploadData['pdf_url'] ??
          uploadData['pptx_url'] ??
          uploadData['file_url'];

      if (fileUrl == null || !fileUrl.startsWith('http')) {
        logger.e("Step 3 Aborted: fileUrl is not a valid URL: $fileUrl");
        return null;
      }

      // --- Step 3: Convert (Nested Try for JSON logic) ---
      try {
        final String requestKey = isPdf ? 'pdf_url' : 'pptx_url';
        
        final Map<String, String> jsonHeaders = {
          ...ApiConstants.generateHeaders,
          "Content-Type": "application/json",
          "Accept": "application/json",
        };

        logger.d("DEBUG STEP 3 - URL: $convertUrl");
        logger.d("Sending JSON with Key: $requestKey");

        var response = await http.post(
          Uri.parse(convertUrl),
          headers: jsonHeaders,
          body: jsonEncode({requestKey: fileUrl}),
        );

        // Logic for 422/400 Fallback
        if (response.statusCode == 422 || response.statusCode == 400) {
          logger.d("JSON Failed (${response.statusCode}), trying Form-data fallback...");
          
          final Map<String, String> fallbackHeaders = Map.from(ApiConstants.generateHeaders);
          fallbackHeaders.removeWhere((key, value) => key.toLowerCase() == 'content-type');

          response = await http.post(
            Uri.parse(convertUrl),
            headers: fallbackHeaders,
            body: {requestKey: fileUrl},
          );
        }

        if (response.statusCode == 200) {
          final convertData = jsonDecode(response.body);
          logger.d("RAW SERVER RESPONSE (Step 3): $convertData");

          List<dynamic> urlList = convertData['img_url_list'] ?? [];

          // Fix for "getter 'length' called on null"
          // We default to 1 if urlList is empty, and ensure countData is valid
          int pageCount = 1;
          if (countData is Map && countData['pages'] != null) {
            pageCount = countData['pages'];
          } else {
            pageCount = urlList.isNotEmpty ? urlList.length : 1;
          }

          return {
            "image_url": urlList.isNotEmpty ? urlList[0] : null,
            "image_list": urlList,
            "page_count": pageCount,
          };
        } else {
          logger.e("Step 3 Failed Final (Status: ${response.statusCode})");
          logger.e("Server Response: ${response.body}");
          return null;
        }
      } catch (e) {
        logger.e("Step 3 Critical Exception", error: e);
        return null;
      }
    } catch (e) {
      logger.e("Critical Error in 3-Step Process", error: e);
      return null;
    }
  }

  static Future<Map<String, dynamic>?> _simpleImageUpload(
    PlatformFile file,
  ) async {
    try {
      final response = await _multipartRequest(ApiConstants.uploadEndpoint, file);
      final bodyString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(bodyString);
        
        String? imgUrl = data['img_url'] ?? data['url'];
        
        if (imgUrl == null) {
          logger.e("Image upload response missing URL: $data");
          return null;
        }

        return {
          "image_url": imgUrl, 
          "page_count": 1,
          "image_list": [imgUrl]
        };
      } else {
        logger.e("Image Upload Failed (${response.statusCode}): $bodyString");
      }
    } catch (e) {
      logger.e("Image Upload Exception", error: e);
    }
    return null;
  }

  static Future<http.StreamedResponse> _multipartRequest(
    String url,
    PlatformFile file,
  ) async {
    try {
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
      } else {
        throw Exception("File has no bytes and no path");
      }
      return await request.send();
    } catch (e) {
      logger.e("Multipart Request Failed", error: e);
      rethrow; // Rethrow to let the caller handle it or stop execution
    }
  }
}