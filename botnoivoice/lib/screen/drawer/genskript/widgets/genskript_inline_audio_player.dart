import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class GenskriptInlineAudioPlayer extends StatefulWidget {
  final String audioUrl;
  final int points;
  final VoidCallback onDownload;

  const GenskriptInlineAudioPlayer({
    super.key,
    required this.audioUrl,
    required this.points,
    required this.onDownload,
  });

  @override
  State<GenskriptInlineAudioPlayer> createState() =>
      _GenskriptInlineAudioPlayerState();
}

class _GenskriptInlineAudioPlayerState
    extends State<GenskriptInlineAudioPlayer> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  StreamSubscription? _durationSub;
  StreamSubscription? _positionSub;
  StreamSubscription? _playerStateSub;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  @override
  void didUpdateWidget(GenskriptInlineAudioPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.audioUrl != widget.audioUrl) {
      _initAudio();
    }
  }

  Future<void> _initAudio() async {
    try {
      await _player.stop();
      _durationSub?.cancel();
      _positionSub?.cancel();
      _playerStateSub?.cancel();

      _durationSub = _player.durationStream.listen((d) {
        if (mounted && d != null) setState(() => _duration = d);
      });

      _positionSub = _player.positionStream.listen((p) {
        if (mounted) setState(() => _position = p);
      });

      _playerStateSub = _player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          if (mounted) {
            setState(() => _isPlaying = false);
            _player.seek(Duration.zero);
            _player.pause();
          }
        }
      });

      // โหลดเสียงเมื่อ URL เปลี่ยน
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(Uri.encodeFull(widget.audioUrl)),
          headers: {
            'Referer': 'https://voice.botnoi.ai/',
            'User-Agent': 'BotnoiVoiceMobile'
          },
        ),
      );
    } catch (e) {
      debugPrint("Error loading inline audio: $e");
    }
  }

  void _togglePlay() {
    if (_isPlaying) {
      _player.pause();
    } else {
      _player.play();
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
    _durationSub?.cancel();
    _positionSub?.cancel();
    _playerStateSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ปุ่ม Play/Pause
        InkWell(
          onTap: _togglePlay,
          child: Icon(
            _isPlaying ? Icons.pause_circle_outline : Icons.play_arrow_outlined,
            color: Colors.lightBlue,
            size: 30,
          ),
        ),
        const SizedBox(width: 8),
        // เวลา
        Text(
          "${_formatDuration(_position)} / ${_formatDuration(_duration)}",
          style: const TextStyle(color: Colors.black87, fontSize: 12),
        ),
        // Slider
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: Colors.grey[400],
              inactiveTrackColor: Colors.grey[200],
              thumbColor: Colors.white,
            ),
            child: Slider(
              min: 0,
              max: _duration.inMilliseconds.toDouble() > 0
                  ? _duration.inMilliseconds.toDouble()
                  : 1.0,
              value: _position.inMilliseconds
                  .toDouble()
                  .clamp(0, _duration.inMilliseconds.toDouble()),
              onChanged: (value) async {
                final position = Duration(milliseconds: value.toInt());
                await _player.seek(position);
              },
            ),
          ),
        ),
        // Points
        Text("${widget.points} PT",
            style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(width: 8),
        // ปุ่ม Download
        Container(
          height: 32,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF9340FF), Color(0xFF34BDFA)]),
            borderRadius: BorderRadius.circular(6),
          ),
          child: ElevatedButton(
            onPressed: widget.onDownload,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text("ดาวน์โหลด",
                style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ),
      ],
    );
  }
}
