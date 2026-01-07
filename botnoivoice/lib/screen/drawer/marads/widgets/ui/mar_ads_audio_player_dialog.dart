import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';

/// Widget สำหรับ Dialog เล่นเสียง
class MarAdsAudioPlayerDialog extends StatefulWidget {
  final AudioPlayer player;
  final String fileName;
  final VoidCallback onDownload;
  final VoidCallback onShare;

  const MarAdsAudioPlayerDialog({
    super.key,
    required this.player,
    required this.fileName,
    required this.onDownload,
    required this.onShare,
  });

  @override
  State<MarAdsAudioPlayerDialog> createState() =>
      _MarAdsAudioPlayerDialogState();
}

class _MarAdsAudioPlayerDialogState extends State<MarAdsAudioPlayerDialog> {
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  //สำหรับเก็บ Subscription
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  /// โหลดและเล่นเสียงอัตโนมัติ
  Future<void> _initAudio() async {
    // ฟังค่า Duration แบบ Real-time (เผื่อโหลดเสร็จทีหลัง)
    _durationSubscription = widget.player.durationStream.listen((d) {
      if (mounted && d != null) {
        setState(() => _duration = d);
      }
    });

    // ฟังค่าตำแหน่งปัจจุบัน (Position) เพื่อขยับ Slider
    _positionSubscription = widget.player.positionStream.listen((p) {
      if (mounted) setState(() => _position = p);
    });

    // เมื่อเล่นจบ ให้ปุ่มกลับมาเป็น Play เหมือนเดิม
    _playerStateSubscription = widget.player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (mounted) {
          setState(() => _isPlaying = false);
          widget.player.seek(Duration.zero);
          widget.player.pause();
        }
      }
    });

    // เช็คสถานะเริ่มต้น (กรณี Player เล่นอยู่แล้ว)
    if (widget.player.playing) {
      setState(() => _isPlaying = true);
    } else {
      // สั่งเล่นอัตโนมัติเมื่อเปิด Dialog
      widget.player.play();
      setState(() => _isPlaying = true);
    }
  }

  void _togglePlay() {
    if (_isPlaying) {
      widget.player.pause();
    } else {
      widget.player.play();
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    // ยกเลิกการฟัง Stream ทั้งหมดก่อนปิด
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();

    widget.player.dispose(); // ปิด player ที่รับเข้ามา
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Center(
            child: Text("สร้างเสียงสำเร็จ",
                style: GoogleFonts.prompt(fontWeight: FontWeight.bold))),
        content: SizedBox(
          width: 300.w, // ความกว้างเท่ากับ Loading Dialog
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("File: ${widget.fileName}",
                  style: TextStyle(fontSize: 12.sp)),
              SizedBox(height: 20.h),

              // ส่วน Player: ถ้าโหลดอยู่หมุนติ้วๆ ถ้าเสร็จแล้วโชว์ปุ่ม Play/Pause
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        iconSize: 40.sp,
                        onPressed: _togglePlay,
                        icon: Icon(
                          _isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_fill,
                          color: const Color(0xFF262626),
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          min: 0,
                          max: _duration.inMilliseconds.toDouble(),
                          value: _position.inMilliseconds
                              .toDouble()
                              .clamp(0, _duration.inMilliseconds.toDouble()),
                          activeColor: const Color(0xFF262626),
                          inactiveColor: Colors.grey[300],
                          onChanged: (value) async {
                            final position =
                                Duration(milliseconds: value.toInt());
                            await widget.player.seek(position);
                          },
                        ),
                      ),
                    ],
                  ),
                  // แสดงเวลา 00:00 / 00:00
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(_position),
                            style: GoogleFonts.inter(fontSize: 10.sp)),
                        Text(_formatDuration(_duration),
                            style: GoogleFonts.inter(fontSize: 10.sp)),
                      ],
                    ),
                  )
                ],
              ),

              SizedBox(height: 20.h),
              Row(
                children: [
                  // ปุ่มแชร์ (สีขาว ขอบดำ)
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        side: const BorderSide(color: Color(0xFF262626)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      onPressed: widget.onShare,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.share,
                              size: 18.sp, color: const Color(0xFF262626)),
                          SizedBox(width: 5.w),
                          Text("แชร์",
                              style: GoogleFonts.prompt(
                                color: const Color(0xFF262626),
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  // ปุ่มดาวน์โหลด (สีดำ)
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF262626),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r))),
                      onPressed: widget.onDownload,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.download,
                              size: 18.sp, color: Colors.white),
                          SizedBox(width: 5.w),
                          Text("ดาวน์โหลด",
                              style: GoogleFonts.prompt(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    // ใช้ขอบสีเทาอ่อน เพื่อไม่ให้แย่งความเด่นจากปุ่มหลัก
                    side: const BorderSide(color: Color(0xFFE5E5E5), width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    // สี Effect เวลาแตะปุ่ม
                    foregroundColor: const Color(0xFF262626),
                  ),
                  child: Text(
                    "ปิด",
                    style: GoogleFonts.prompt(
                      color: const Color(0xFF262626),
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
