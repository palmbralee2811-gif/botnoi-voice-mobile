import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:go_router/go_router.dart';

class GenskriptAudioPlayerDialog extends StatefulWidget {
  final AudioPlayer player;
  final String fileName;
  final VoidCallback onDownload;
  final VoidCallback onShare;

  const GenskriptAudioPlayerDialog({
    super.key,
    required this.player,
    required this.fileName,
    required this.onDownload,
    required this.onShare,
  });

  @override
  State<GenskriptAudioPlayerDialog> createState() => _GenskriptAudioPlayerDialogState();
}

class _GenskriptAudioPlayerDialogState extends State<GenskriptAudioPlayerDialog> {
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    _durationSubscription = widget.player.durationStream.listen((d) {
      if (mounted && d != null) setState(() => _duration = d);
    });

    _positionSubscription = widget.player.positionStream.listen((p) {
      if (mounted) setState(() => _position = p);
    });

    _playerStateSubscription = widget.player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (mounted) {
          setState(() => _isPlaying = false);
          widget.player.seek(Duration.zero);
          widget.player.pause();
        }
      }
    });

    if (widget.player.playing) {
      setState(() => _isPlaying = true);
    } else {
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
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    widget.player.stop(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Center(
            child: Text("Create Voice Success",
                style: GoogleFonts.prompt(fontWeight: FontWeight.bold))),
        content: SizedBox(
          width: 300.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("File: ${widget.fileName}", style: TextStyle(fontSize: 12.sp), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
              SizedBox(height: 20.h),
              
              // Controls
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        iconSize: 40.sp,
                        onPressed: _togglePlay,
                        icon: Icon(
                          _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                          color: const Color(0xFF262626),
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          min: 0,
                          max: _duration.inMilliseconds.toDouble() > 0 ? _duration.inMilliseconds.toDouble() : 1.0,
                          value: _position.inMilliseconds.toDouble().clamp(0, _duration.inMilliseconds.toDouble()),
                          activeColor: const Color(0xFF262626),
                          inactiveColor: Colors.grey[300],
                          onChanged: (value) async {
                            final position = Duration(milliseconds: value.toInt());
                            await widget.player.seek(position);
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(_position), style: GoogleFonts.inter(fontSize: 10.sp)),
                        Text(_formatDuration(_duration), style: GoogleFonts.inter(fontSize: 10.sp)),
                      ],
                    ),
                  )
                ],
              ),
              
              SizedBox(height: 20.h),
              
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        side: const BorderSide(color: Color(0xFF262626)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                      ),
                      onPressed: widget.onShare,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.share, size: 18.sp, color: const Color(0xFF262626)),
                          SizedBox(width: 5.w),
                          Text("Share", style: GoogleFonts.prompt(color: const Color(0xFF262626), fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF262626),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))),
                      onPressed: widget.onDownload,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.download, size: 18.sp, color: Colors.white),
                          SizedBox(width: 5.w),
                          Text("Download", style: GoogleFonts.prompt(color: Colors.white, fontWeight: FontWeight.w600)),
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
                  onPressed: () {
                    widget.player.stop();
                    context.pop();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    side: const BorderSide(color: Color(0xFFE5E5E5), width: 1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    foregroundColor: const Color(0xFF262626),
                  ),
                  child: Text("Close", style: GoogleFonts.prompt(color: const Color(0xFF262626), fontWeight: FontWeight.w600, fontSize: 14.sp)),
                ),
              ),
            ],
          ),
        ));
  }
}