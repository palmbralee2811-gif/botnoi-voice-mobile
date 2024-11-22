import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:botnoivoice/data/repositories/file_repository_impl.dart';
import 'package:botnoivoice/presentation/providers/permission/permission_provider.dart';
import 'package:botnoivoice/presentation/widgets/dialog/android_permission_dialog.dart';
import 'package:botnoivoice/presentation/widgets/popup/notification_popup.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_close_button.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_icon.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:logger/logger.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:provider/provider.dart';

// Play Audio on Temporary Directory, Download File, and Open Audio File
class AudioPlayerDialog extends StatefulWidget {
  final String filePath;
  final String audioUrl;

  const AudioPlayerDialog(
      {super.key, required this.filePath, required this.audioUrl});

  @override
  State<AudioPlayerDialog> createState() => _AudioPlayerDialogState();
}

class _AudioPlayerDialogState extends State<AudioPlayerDialog> {
  final Logger logger = Logger(); // Logger for Debugging mode
  late AudioPlayer audioPlayer;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isPlaying = false;
  bool isLoading = true;

  final ReceivePort _port = ReceivePort();
  String? taskId;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _initAudioPlayer();
    _initializeDownloader();
  }

  /// Check Android Request Permission
  Future<void> _checkAndroidRequestPermissions() async {
    bool hasPermission =
        await Provider.of<PermissionProvider>(context, listen: false)
            .requestAndroidPermission();

    // Show Alert if Permission Denied
    if (!hasPermission) {
      AndroidPermissionDialog(
              context: context, text: "สิทธิ์ถูกปฏิเสธ กรุณาไปที่การตั้งค่า")
          .showPermissionDeniedDialog();
    } else {
      _startDownload().whenComplete(() {
        _downloadFileToCustomPath().whenComplete(() {
          OpenFile.open(widget.filePath);
        });
      });
    }
  }

  /// Initialize AudioPlayer and check if the file exists
  Future<void> _initAudioPlayer() async {
    try {
      final file = File(widget.filePath);
      if (!await file.exists() || await file.length() == 0) {
        throw Exception("ไม่พบไฟล์เสียงหรือไฟล์ว่างเปล่า");
      }
      await audioPlayer.setSourceDeviceFile(widget.filePath);
      audioPlayer.onDurationChanged.listen((d) {
        if (mounted) {
          setState(() {
            duration = d;
          });
        }
      });
      audioPlayer.onPositionChanged.listen((p) {
        if (mounted) {
          setState(() {
            position = p;
          });
        }
      });
      audioPlayer.onPlayerStateChanged.listen((state) {
        if (mounted) {
          setState(() {
            isPlaying = state == PlayerState.playing;
          });
        }
      });
      audioPlayer.onPlayerComplete.listen((event) {
        if (mounted) {
          setState(() {
            position = Duration.zero;
            isPlaying = false;
          });
        }
      });
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("เกิดข้อผิดพลาดในการเล่นไฟล์เสียง: $e")),
        );
      }
    }
  }

  /// Initialize the downloader using FlutterDownloader
  Future<void> _initializeDownloader() async {
    await FlutterDownloader.initialize(
      debug: true,
      ignoreSsl: true,
    );
    _initDownloader();
  }

  /// Initialize the downloader using FlutterDownloader
  Future<void> _initDownloader() async {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      int status = data[1];
      int progress = data[2];
      logger.i("Task ID: $id, Status: $status, Progress: $progress%");
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  /// Callback function used to download the file using FlutterDownloader
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    if (send != null) {
      send.send([id, status, progress]);
    }
  }

  /// Start downloading the file using FlutterDownloader (Don't working on Android 10)
  Future<void> _startDownload() async {
    taskId = await FlutterDownloader.enqueue(
      url: widget.audioUrl,
      //WARNING: Change Path and File: android\app\src\main\res\xml\provider_paths.xml
      savedDir: '/storage/emulated/0/Download',
      fileName: widget.filePath.split('/').last,
      showNotification: true,
      openFileFromNotification: true,
    );
  }

  /// Save file to Local Path (Don't working on Android 10, 11, 12)
  Future<void> _downloadFileToCustomPath() async {
    FileRepositoryImpl fileRepository = FileRepositoryImpl();
    bool isSaved = await fileRepository.saveFileCustomPath(widget.filePath);
    if (isSaved == false) {
      NotificationPopup(context: context, text: "ไม่สามารถบันทึกไฟล์ได้") //
          .showAsError();
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: isLoading
            ? SizedBox(
                height: 150.h,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'สร้างเสียงสำเร็จ', //สร้างเสียงสำเร็จ
                    style: GoogleFonts.prompt(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'File: ${widget.filePath.split('/').last}',
                    style: GoogleFonts.prompt(
                      fontSize: 14.sp,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 30.sp,
                        icon: GradientIcon(
                          icon: isPlaying
                              ? Icons.pause_circle_outline
                              : Icons.play_circle_outline,
                          size: 30.sp,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        onPressed: () async {
                          if (isPlaying) {
                            await audioPlayer.pause();
                          } else {
                            await audioPlayer
                                .play(DeviceFileSource(widget.filePath));
                          }
                        },
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: StreamBuilder<Duration>(
                          stream: audioPlayer.onPositionChanged,
                          builder: (context, snapshot) {
                            final position = snapshot.data ?? Duration.zero;
                            return Slider(
                              activeColor: Colors.blue,
                              inactiveColor: Colors.grey[300],
                              min: 0,
                              max: duration.inMilliseconds.toDouble(),
                              value: position.inMilliseconds
                                  .toDouble()
                                  .clamp(0, duration.inMilliseconds.toDouble()),
                              onChanged: (value) async {
                                final newPosition =
                                    Duration(milliseconds: value.toInt());
                                await audioPlayer.seek(newPosition);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  GradientRow(
                    onPressed: () async {
                      if (Platform.isIOS) {
                        OpenFile.open(widget.filePath);
                      } else if (Platform.isAndroid) {
                        await _checkAndroidRequestPermissions();
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.file_download_outlined,
                          size: 25.sp,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "ดาวน์โหลด", //ดาวน์โหลด
                          style: GoogleFonts.prompt(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  GradientCloseButton(
                    text: "ปิด", //ปิด
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
      ),
    );
  }
}
