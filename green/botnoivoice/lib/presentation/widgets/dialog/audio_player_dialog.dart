import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_close_button.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_icon.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

class AudioPlayerDialog extends StatefulWidget {
  final String filePath;
  final String audioUrl;

  const AudioPlayerDialog(
      {super.key, required this.filePath, required this.audioUrl});

  @override
  State<AudioPlayerDialog> createState() => _AudioPlayerDialogState();
}

class _AudioPlayerDialogState extends State<AudioPlayerDialog> {
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
    _requestPermissions();
  }

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

  Future<void> _initializeDownloader() async {
    await FlutterDownloader.initialize(
      debug: true,
      ignoreSsl: true,
    );
    _initDownloader();
  }

  Future<void> _initDownloader() async {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      int status = data[1];
      int progress = data[2];
      debugPrint('Task ID: $id, Status: $status, Progress: $progress%');
      if (id == taskId && status == DownloadTaskStatus.complete.index) {
        _openDownloadedFile().whenComplete(() {
          debugPrint("_openDownloadedFile is DONE!!!");
        });
      }
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    if (send != null) {
      send.send([id, status, progress]);
    }
  }

  Future<void> _startDownload() async {
    taskId = await FlutterDownloader.enqueue(
      url: widget.audioUrl,
      savedDir: '/storage/emulated/0/Download',
      fileName: widget.filePath.split('/').last,
      showNotification: true,
      openFileFromNotification: true,
    );
    debugPrint('Task ID: $taskId');
  }

  Future<void> _openDownloadedFile() async {
    final filePath =
        '/storage/emulated/0/Download/${widget.filePath.split('/').last}';
    debugPrint('K9 -> File Path: $filePath');
    final result = await OpenFile.open(filePath);
    if (result.type.name != "done") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่สามารถเปิดไฟล์ได้')),
      );
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      int androidVersion =
          int.parse(Platform.operatingSystemVersion.split(" ")[0]);

      if (androidVersion >= 23 && androidVersion <= 29) {
        if (await Permission.storage.request().isGranted) {
          _startDownload();
        } else {
          print('Permission denied');
        }
      } else if (androidVersion >= 30 && androidVersion <= 32) {
        if (await Permission.manageExternalStorage.request().isGranted) {
          _startDownload();
        } else {
          print('Permission denied');
        }
      } else if (androidVersion >= 33) {
        var permissions = await [
          Permission.audio,
          Permission.videos,
          Permission.photos
        ].request();

        if (permissions[Permission.audio]!.isGranted &&
            permissions[Permission.videos]!.isGranted &&
            permissions[Permission.photos]!.isGranted) {
          _startDownload();
        } else {
          print('Permission denied');
        }
      }
    } else {
      _startDownload();
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
                    'สร้างเสียงสำเร็จ',
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
                    onPressed: () {
                      _startDownload();
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
                          "ดาวน์โหลด",
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
                    text: "ปิด",
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
