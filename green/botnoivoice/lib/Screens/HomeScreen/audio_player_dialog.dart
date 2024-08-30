import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:botnoivoice/Screens/GradientScreen/gradient_custom_button.dart';
import 'package:botnoivoice/Screens/GradientScreen/gradient_icon.dart';
import 'package:botnoivoice/Screens/GradientScreen/gradient_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';

class AudioPlayerDialog extends StatefulWidget {
  final String filePath;

  const AudioPlayerDialog({required this.filePath, super.key});

  @override
  _AudioPlayerDialogState createState() => _AudioPlayerDialogState();
}

class _AudioPlayerDialogState extends State<AudioPlayerDialog> {
  late AudioPlayer audioPlayer;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isPlaying = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    try {
      final file = File(widget.filePath);
      if (!await file.exists() || await file.length() == 0) {
        throw Exception("ไม่พบไฟล์เสียงหรือไฟล์ว่างเปล่า");
      }

      await audioPlayer.setSourceDeviceFile(widget.filePath);

      audioPlayer.onDurationChanged.listen((d) {
        setState(() {
          duration = d;
        });
      });

      audioPlayer.onPositionChanged.listen((p) {
        setState(() {
          position = p;
        });
      });

      audioPlayer.onPlayerStateChanged.listen((state) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      });

      audioPlayer.onPlayerComplete.listen((event) {
        setState(() {
          position = Duration.zero;
          isPlaying = false;
        });
      });

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("เกิดข้อผิดพลาดในการเล่นไฟล์เสียง: $e")),
      );
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
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
                    onPressed: () async {
                      await OpenFile.open(widget.filePath);
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
                        SizedBox(
                            width: 8.w), // เว้นระยะห่างระหว่างไอคอนและข้อความ
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
                  GradientCustomButton(
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
