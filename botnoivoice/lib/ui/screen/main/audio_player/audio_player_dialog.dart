import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:botnoivoice/ui/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/function/share_audio_file.dart';
import 'package:botnoivoice/function/create_ios_app_folder.dart';
import 'package:botnoivoice/service/permission/android_permission.dart';
import 'package:botnoivoice/ui/dialog/android_open_app_settings/android_open_app_settings_dialog.dart';
import 'package:botnoivoice/ui/widget/gradient/gradient_close_button.dart';
import 'package:botnoivoice/ui/widget/gradient/gradient_icon.dart';
import 'package:botnoivoice/ui/widget/gradient/gradient_row.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:logger/logger.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:provider/provider.dart';

// Play Audio on Temporary Directory, Download File, and Open Audio File
class AudioPlayerDialog extends StatefulWidget {
  final String filePath;
  final String audioUrl;

  const AudioPlayerDialog({super.key, required this.filePath, required this.audioUrl});

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
        await Provider.of<AndroidPermission>(context, listen: false)
            .requestAndroidPermission();

    // Show Alert if Permission Denied
    if (!hasPermission) {
      AndroidOpenAppSettingsDialog(
              context: context,
              text: 'audio_player.permission_denied'
                  .tr()) //สิทธิ์ถูกปฏิเสธ กรุณาไปที่การตั้งค่า
          .showPermissionDeniedDialog();
    } else {
      _startDownload().whenComplete(() {
        OpenFile.open(widget.filePath);
      });
    }
  }

  /// Initialize AudioPlayer and check if the file exists
  Future<void> _initAudioPlayer() async {
    try {
      final file = File(widget.filePath);
      if (!await file.exists() || await file.length() == 0) {
        throw Exception('audio_player.audio_file_not_found'
            .tr()); //ไม่พบไฟล์เสียงหรือไฟล์ว่างเปล่า
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
        // Close Audio Player Dialog
        context.pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "${'audio_player.error_playing_audio'.tr()} $e")), //เกิดข้อผิดพลาดในการเล่นไฟล์เสียง:
        );
      }
    }
  }

  /// Initialize the downloader using FlutterDownloader
  Future<void> _initializeDownloader() async {
    if (!FlutterDownloader.initialized) {
      await FlutterDownloader.initialize(
        debug: true,
        ignoreSsl: true,
      );
      _initDownloader();
    }
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

  /// Start the download using FlutterDownloader
  Future<void> _startDownload() async {
    String folderPath = "";
    if (Platform.isAndroid) {
      //WARNING: Change Path and File: android\app\src\main\res\xml\provider_paths.xml
      folderPath = "/storage/emulated/0/Download";
    } else if (Platform.isIOS) {
      folderPath = await createiOSAppFolder();
    }

    taskId = await FlutterDownloader.enqueue(
      url: widget.audioUrl,
      savedDir: folderPath,
      fileName: widget.filePath.split('/').last,
      showNotification: true,
      openFileFromNotification: true,
    );
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
        padding: EdgeInsets.all(
            ResponsiveDesignOrientation.isLandscape ? 12.w : 16.w),
        child: isLoading
            ? SizedBox(
                height: ResponsiveDesignOrientation.isLandscape ? 180.h : 150.h,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'audio_player.audio_created_successfully'
                        .tr(), //สร้างเสียงสำเร็จ
                    style: GoogleFonts.prompt(
                      fontSize: ResponsiveDesignOrientation.isLandscape
                          ? 14.sp
                          : 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'File: ${widget.filePath.split('/').last}',
                    style: GoogleFonts.prompt(
                      fontSize: ResponsiveDesignOrientation.isLandscape
                          ? 8.sp
                          : 14.sp,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: ResponsiveDesignOrientation.isLandscape
                            ? 15.sp
                            : 30.sp,
                        icon: GradientIcon(
                          icon: isPlaying
                              ? Icons.pause_circle_outline
                              : Icons.play_circle_outline,
                          size: ResponsiveDesignOrientation.isLandscape
                              ? 15.sp
                              : 30.sp,
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
                  SizedBox(
                      height: ResponsiveDesignOrientation.isLandscape
                          ? 40.h
                          : 20.h),
                  GradientRow(
                    onPressed: () async {
                      if (Platform.isIOS) {
                        _startDownload().whenComplete(() {
                          OpenFile.open(widget.filePath);
                        });
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
                          size: ResponsiveDesignOrientation.isLandscape
                              ? 15.sp
                              : 25.sp,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'audio_player.download'.tr(), //ดาวน์โหลด
                          style: GoogleFonts.prompt(
                            color: Colors.white,
                            fontSize: ResponsiveDesignOrientation.isLandscape
                                ? 12.sp
                                : 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      height: ResponsiveDesignOrientation.isLandscape
                          ? 20.h
                          : 10.h),
                  Builder(
                    builder: (BuildContext context) {
                      return GradientRow(
                        onPressed: () =>
                            shareAudioFile(context, widget.filePath),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.share,
                              size: ResponsiveDesignOrientation.isLandscape
                                  ? 15.sp
                                  : 25.sp,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'share'.tr(), //แชร์
                              style: GoogleFonts.prompt(
                                color: Colors.white,
                                fontSize:
                                    ResponsiveDesignOrientation.isLandscape
                                        ? 12.sp
                                        : 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                      height: ResponsiveDesignOrientation.isLandscape
                          ? 20.h
                          : 10.h),
                  GradientCloseButton(
                    text: 'audio_player.close'.tr(), //ปิด
                    onPressed: () {
                      // Close Audio Player Dialog
                      context.pop();
                    },
                  )
                ],
              ),
      ),
    );
  }
}
