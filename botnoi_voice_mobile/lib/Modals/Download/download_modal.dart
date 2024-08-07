import 'dart:io';
import 'dart:math';
import 'package:botnoi_voice_mobile/Modals/Download/download_popup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DownlaodModal extends StatefulWidget {
  const DownlaodModal({super.key});

  @override
  State<DownlaodModal> createState() => _DownlaodModalState();
}

class _DownlaodModalState extends State<DownlaodModal> {
  void _openDownloading() {
    showDialog(
      context: context,
      builder: (ctx) => const DownloadPopup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
          child: SizedBox(
            width: double.infinity,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Image(
                      image: const AssetImage('assets/images/Vector.png'),
                      height: 54.h,
                      width: 54.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Text(
                      'ดาวน์โหลดไฟล์',
                      style: GoogleFonts.prompt(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.prompt(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                    ),
                  ),
                  buildCustomRow(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCustomRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.all(8.w),
          child: ElevatedButton(
            onPressed: () => _openDownloading(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.grey.withOpacity(0.5),
              elevation: 7,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
              padding: EdgeInsets.zero,
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Container(
                alignment: Alignment.center,
                height: 50.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ดาวน์โหลด",
                      style: GoogleFonts.prompt(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.w),
                      child: Image(
                        image: const AssetImage('assets/images/point.png'),
                        height: 16.h,
                        width: 16.w,
                      ),
                    ),
                    Text(
                      ' 15',
                      style: GoogleFonts.prompt(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ))
      ],
    );
  }

  /// Download file and open it
  Future<void> downloadFile(String audioUrl) async {
    if (Platform.isAndroid) {
      await _androidDownloadFunction(audioUrl);
    } else if (Platform.isIOS) {
      await _iOSDownloadFunction(audioUrl);
    }
  }

  Future<void> _iOSDownloadFunction(String audioUrl) async {
    try {
      var response = await http.get(Uri.parse(audioUrl));
      if (response.statusCode == 200) {
        String filename = "BotnoiVoice${randomString(6)}.mp3";
        var tempDir = await getTemporaryDirectory();
        var path = '${tempDir.path}/$filename';
        var file = File(path);
        await file.writeAsBytes(response.bodyBytes);
        debugPrint("Printing Path: ");
        debugPrint(tempDir.toString());
        debugPrint(path);
        OpenAppFile.open(path);
      } else {
        debugPrint('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error ios downloading file: $e');
    }
  }

  Future<void> _androidDownloadFunction(String audioUrl) async {
    try {
      var filename = "BotnoiVoice${randomString(6)}.mp3";
      List<Directory>? directories =
          await getExternalStorageDirectories(type: StorageDirectory.downloads);
      if (directories == null || directories.isEmpty) {
        throw Exception('No external storage directories found');
      }
      String directoryPath = directories.first.path;
      String filePath = "$directoryPath/$filename";
      var file = File(filePath);
      var res = await http.get(Uri.parse(audioUrl));
      if (res.statusCode == 200) {
        await file.writeAsBytes(res.bodyBytes);
        debugPrint('Download successful: $filename');
        debugPrint('Download complete');
        debugPrint("Printing Path: ");
        debugPrint(filename);
        debugPrint(filePath);
        OpenAppFile.open(filePath);
      } else {
        debugPrint('Failed to download file: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('Error android downloading file: $e');
    }
  }
}

/// Generate a random string of numbers
String randomString(int length) {
  const characters = '0123456789';

  final random = Random();
  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => characters.codeUnitAt(
        random.nextInt(characters.length),
      ),
    ),
  );
}
