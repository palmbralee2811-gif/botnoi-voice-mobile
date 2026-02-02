import 'dart:io';
import 'package:botnoivoice/config/api_url_config.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

final _logger = Logger();

/// Download file and save to temporary directory
Future<File?> downloadFileToTemporaryDirectory(
    String audioUrl, String name) async {
  try {
    final downloadFolder = await getTemporaryDirectory();
    final String downloadDirectory = downloadFolder.path;
    final file = File("$downloadDirectory/$name");
    final response = await Dio().get(
      audioUrl,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          'Referer': refererUrl, // บัตรผ่านสำหรับ AWS S3
          'Origin': refererUrl,
        },
      ),
    );
    if (response.statusCode == 200) {
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      if (await file.exists() && await file.length() > 0) {
        _logger.i("File downloaded successfully: ${file.path}");
        return file;
      } else {
        throw Exception("File download failed, file is empty.");
      }
    } else {
      throw Exception("Failed to download file: ${response.statusCode}");
    }
  } catch (e) {
    _logger.e("Download file error: $e");
    return null;
  }
}
