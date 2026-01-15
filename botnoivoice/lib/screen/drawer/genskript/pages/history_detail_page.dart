import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart'; // For Clipboard

class HistoryDetailPage extends StatefulWidget {
  final dynamic item;
  final VoidCallback onBack;

  const HistoryDetailPage({
    super.key,
    required this.item,
    required this.onBack,
  });

  @override
  State<HistoryDetailPage> createState() => _HistoryDetailPageState();
}

class _HistoryDetailPageState extends State<HistoryDetailPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  void _initAudio() async {
    // Get Audio URL from scripts
    List scripts = widget.item['scripts'] ?? [];
    if (scripts.isNotEmpty && scripts[0]['audio'] != null) {
      try {
        await _audioPlayer.setUrl(scripts[0]['audio']);
        _audioPlayer.durationStream.listen((d) {
          if (mounted) setState(() => _duration = d ?? Duration.zero);
        });
        _audioPlayer.positionStream.listen((p) {
          if (mounted) setState(() => _position = p);
        });
        _audioPlayer.playerStateStream.listen((state) {
          if (mounted) setState(() => _isPlaying = state.playing);
        });
      } catch (e) {
        debugPrint("Audio init error: $e");
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "${d.inMinutes}:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    // Extract Data
    List scripts = widget.item['scripts'] ?? [];
    final scriptData = scripts.isNotEmpty ? scripts[0] : {};
    String scriptText = scriptData['script'] ?? "";
    String? videoUrl = widget.item['video_url'] ?? widget.item['final_video_url'];
    // Fallback if video is inside script object
    if (videoUrl == null && scripts.isNotEmpty) {
      videoUrl = scriptData['video_url'];
    }

    // Fallback speaker name (API usually returns ID like "5", we simulate a name here)
    String speakerName = "Speaker ${scriptData['speaker'] ?? 'Unknown'}"; 

    return Column(
      children: [
        // SCROLLABLE CONTENT
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Speaker Header (Top Left)
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.person, size: 20, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Text(speakerName, style: GoogleFonts.prompt(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 20),

                // 2. Main Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card Header: #1 and Copy Icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("#1", style: GoogleFonts.prompt(fontSize: 18, fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.copy_outlined, size: 20, color: Colors.grey),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: scriptText));
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copied to clipboard")));
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      // Script Text
                      Text(
                        scriptText,
                        style: GoogleFonts.prompt(fontSize: 14, height: 1.6, color: Colors.black87),
                      ),
                      const SizedBox(height: 24),

                      // Audio Player Row
                      Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.black87, size: 28),
                            onPressed: () {
                              if (_isPlaying) _audioPlayer.pause();
                              else _audioPlayer.play();
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${_formatDuration(_position)} / ${_formatDuration(_duration)}",
                            style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                trackHeight: 4,
                                activeTrackColor: Colors.blue,
                                inactiveTrackColor: Colors.grey.shade200,
                                thumbColor: Colors.blue,
                              ),
                              child: Slider(
                                value: _position.inSeconds.toDouble(),
                                max: _duration.inSeconds.toDouble() > 0 ? _duration.inSeconds.toDouble() : 1,
                                onChanged: (v) => _audioPlayer.seek(Duration(seconds: v.toInt())),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text("0 PT", style: GoogleFonts.prompt(fontSize: 12, color: Colors.grey)), // Placeholder
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              minimumSize: Size.zero, 
                              elevation: 0,
                            ),
                            onPressed: () {
                               // Logic for single audio download
                               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Downloading audio...")));
                            },
                            child: Text("ดาวน์โหลด", style: GoogleFonts.prompt(fontSize: 12, color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // 3. Footer Section (Pinned to bottom)
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Download All Button
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF9C27B0), Color(0xFF00BCD4)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (videoUrl != null) {
                      // Trigger your DownloadService here using videoUrl
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Downloading Video: $videoUrl")));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No video available yet.")));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("ดาวน์โหลดทั้งหมด", style: GoogleFonts.prompt(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
              
              // Back Button
              TextButton.icon(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back, size: 18, color: Colors.black54),
                label: Text("กลับไปดูประวัติ", style: GoogleFonts.prompt(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}