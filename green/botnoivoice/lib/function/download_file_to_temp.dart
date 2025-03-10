import 'dart:io';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

final _logger = Logger();

/// Download file and save to temporary directory
  Future<File?> downloadFileToTemporaryDirectory(
      String url, String name) async {
    try {
      final downloadFolder = await getTemporaryDirectory();
      final String downloadDirectory = downloadFolder.path;
      final file = File("$downloadDirectory/$name");
      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: const Duration(seconds: 60),
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
