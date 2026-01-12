import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';

import '../services/script_service.dart';
import '../services/download_service.dart';
import '../services/translation_service.dart';
import '../services/video_service.dart';
import '../services/voice_service.dart'; 
import '../data/app_data.dart';
import '../data/api_constants.dart';
import '../widgets/star_p_badge.dart';

// Initialize Logger
var logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 80,
    colors: true,
    printEmojis: false, 
    printTime: false,
  ),
);

class ResultScreen extends StatefulWidget {
  final String script;
  final String? audioUrl;
  final String? imageUrl;
  final String language;
  final VoidCallback onBack;

  const ResultScreen({
    super.key,
    required this.script,
    this.audioUrl,
    this.imageUrl,
    required this.language,
    required this.onBack,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  // --- STATE VARIABLES ---
  late TextEditingController _editController;

  // JustAudio Player State
  final AudioPlayer _player = AudioPlayer(); 
  
  String _selectedSpeed = '1x';
  String _selectedVolume = '100%';
  
  // Settings Arrays
  final List<String> speedOptions = [
    '0.5x', '0.6x', '0.7x', '0.8x', '0.9x', 
    '1x', '1.2x', '1.5x', '2.0x'
  ];
  final List<String> volumeOptions = [
    '50%', '60%', '70%', '80%', '90%', 
    '100%', '110%', '120%', '130%', '140%', '150%'
  ];

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: widget.script);
  }

  @override
  void dispose() {
    _editController.dispose();
    _player.dispose(); // Dispose JustAudio player
    super.dispose();
  }

  // --- LOGIC: CREATE VOICE ---
  Future<void> _handleCreateVoice() async {
    if (_editController.text.isEmpty) return;

    // 1. Show Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );

    String? resultUrl;
    try {
      // Determine language code safely
      String langCode = 'th';
      if (widget.language.toLowerCase().contains('en')) {
        langCode = 'en';
      }

      resultUrl = await VoiceService.handleCreateVoice(
        scriptText: _editController.text,
        speed: _selectedSpeed,
        volume: _selectedVolume,
        languageValue: langCode,
      );
    } catch (e) {
      logger.e("Error in handleCreateVoice wrapper", error: e);
    }

    // 2. Hide Loading
    if (mounted) Navigator.pop(context);

    // 3. Handle Result
    if (resultUrl != null && resultUrl.isNotEmpty) {
      _loadAndShowDialog(resultUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error generating voice")),
      );
    }
  }

  /// Loads audio with headers to bypass 403 Error
  Future<void> _loadAndShowDialog(String url) async {
    try {
      logger.d("Attempting to load URL with headers: $url");
      
      // Stop previous playback
      await _player.stop();

      // Encode URL (Handle spaces)
      final Uri uri = Uri.parse(Uri.encodeFull(url));

      // ✅ FIX 403: Use AudioSource.uri to attach Headers (Referer)
      await _player.setAudioSource(
        AudioSource.uri(
          uri,
          headers: {
            // This header is often required by S3/CloudFront to allow access
            'Referer': 'https://voice.botnoi.ai/', 
            'User-Agent': 'BotnoiVoiceMobile',
          },
        ),
      );
      
      if (mounted) {
        _showAudioPlayerDialog(_player, url);
      }
    } catch (e) {
      logger.e("Error loading audio for dialog", error: e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not play audio (403): $e")),
        );
      }
    }
  }

  // Show the Custom Dialog
  void _showAudioPlayerDialog(AudioPlayer player, String url) {
    showDialog(
      context: context,
      builder: (context) => GenskriptAudioPlayerDialog(
        player: player,
        fileName: url.split('/').last, // Extract filename from URL
        onDownload: () {
          Navigator.pop(context); // Close dialog
          DownloadService.handleDownloadAll(); 
          ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text("Downloading...")));
        },
        onShare: () {
          // Navigator.pop(context); 
          logger.d("Share button clicked");
        },
      ),
    );
  }

  // --- LOGIC: TRANSLATION ---
  void _showLanguagePicker(BuildContext context) {
    String? tempSelected = ""; 

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FB),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  const Text(
                    "Select Language",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListView.builder(
                        itemCount: AppData.languages.length,
                        itemBuilder: (context, index) {
                          final lang = AppData.languages[index];
                          bool isSelected = tempSelected == lang['name'];

                          return GestureDetector(
                            onTap: () {
                              setModalState(() => tempSelected = lang['name']!);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? const LinearGradient(
                                        colors: [Color(0xFFE1D5F5), Color(0xFFB3E5FC)],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      )
                                    : null,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.grey.shade100,
                                  child: Text(lang['flag']!, style: const TextStyle(fontSize: 20)),
                                ),
                                title: Text(
                                  lang['name']!,
                                  style: TextStyle(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildStarPBadge(),
                      const SizedBox(width: 8),
                      const Text(
                        "100 Points per use",
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: tempSelected!.isEmpty
                          ? null
                          : () => Navigator.pop(context, tempSelected),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Confirm", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((selectedLang) {
      if (selectedLang != null) {
        _executeTranslation(selectedLang);
      }
    });
  }

  void _executeTranslation(String targetLang) async {
    // Check points logic (mocked here)
    if (2000 < 100) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Insufficient Points")));
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.white)),
    );

    try {
      String? result = await TranslationService.handleTranslate(
        currentScript: _editController.text,
        targetLanguageName: targetLang,
        imageUrl: widget.imageUrl ?? "",
      );

      if (mounted) Navigator.pop(context);

      if (result != null) {
        setState(() {
          _editController.text = result;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Translated to $targetLang successfully!")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Translation Failed")));
      }
    } catch (e) {
      logger.e("Translation Error", error: e);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Footer Actions
    final List<Map<String, dynamic>> footerActions = [
      {'label': "Link Script", 'icon': Icons.link, 'action': () => ScriptService.handleJoinScript()},
      {'label': "Download All", 'icon': Icons.download_rounded, 'action': () => DownloadService.handleDownloadAll()},
      {'label': "Translate", 'icon': Icons.translate, 'action': () => _showLanguagePicker(context)},
      {'label': "Create Free Video", 'icon': Icons.card_giftcard, 'action': () => VideoService.handleFreeVideo()},
      {'label': "Auto Voice", 'icon': Icons.settings_voice, 'action': () => _handleCreateVoice()},
      {'label': "Create Video", 'icon': Icons.movie_creation_outlined, 'action': () => VideoService.handleCreateVideo()},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 20),

            _buildScriptEditor(),
            const SizedBox(height: 20),

            Row(
              children: [
                _buildDropdownSelector(
                  icon: Icons.speed,
                  currentValue: _selectedSpeed,
                  options: speedOptions,
                  title: "Select Speed",
                  onChanged: (val) => setState(() => _selectedSpeed = val),
                ),
                const SizedBox(width: 8),
                _buildDropdownSelector(
                  icon: Icons.volume_up_outlined,
                  currentValue: _selectedVolume,
                  options: volumeOptions,
                  title: "Volume",
                  onChanged: (val) => setState(() => _selectedVolume = val),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${_editController.text.length} PT",
                  style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
                ),
                _buildGenerateButton(), 
              ],
            ),
            
            const SizedBox(height: 20),

            // Footer Actions
            Column(
               children: footerActions.map((item) {
                 return Padding(
                   padding: const EdgeInsets.only(bottom: 12),
                   child: SizedBox(
                     width: double.infinity,
                     height: 55,
                     child: ElevatedButton.icon(
                       onPressed: item['action'],
                       icon: Icon(item['icon'], size: 22, color: Colors.cyan),
                       label: Text(
                         item['label'],
                         style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                       ),
                       style: ElevatedButton.styleFrom(
                         foregroundColor: Colors.black87,
                         backgroundColor: Colors.white,
                         elevation: 0,
                         side: BorderSide(color: Colors.grey.shade200),
                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                         alignment: Alignment.centerLeft,
                         padding: const EdgeInsets.symmetric(horizontal: 20),
                       ),
                     ),
                   ),
                 );
               }).toList(),
            ),

            const SizedBox(height: 6),

            Center(
              child: TextButton.icon(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back, size: 16),
                label: const Text("Back to Form"),
                style: TextButton.styleFrom(foregroundColor: Colors.cyan),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildScriptEditor() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: _editController,
        maxLines: 12,
        minLines: 5,
        cursorColor: Colors.cyan,
        style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black87),
        onChanged: (text) {
          setState(() {}); 
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Click to start writing or editing script...",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildGenerateButton() {
    return OutlinedButton(
      onPressed: _handleCreateVoice,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.cyan,
        side: const BorderSide(color: Colors.cyan),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: const Text("Create Voice", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  Widget _buildDropdownSelector({
    required IconData icon,
    required String currentValue,
    required List<String> options,
    required String title,
    required Function(String) onChanged,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () => _showTranslatorStylePicker(context, title, options, currentValue, onChanged),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: Colors.black87),
              const SizedBox(width: 8),
              Text(
                currentValue,
                style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }

  void _showTranslatorStylePicker(
    BuildContext context,
    String title,
    List<String> options,
    String selectedValue,
    Function(String) onSelect,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              height: 4, width: 40,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
            ),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final item = options[index];
                  final isSelected = item == selectedValue;
                  return ListTile(
                    title: Text(
                      item,
                      style: TextStyle(
                        color: isSelected ? Colors.cyan : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected ? const Icon(Icons.check, color: Colors.cyan) : null,
                    onTap: () {
                      onSelect(item);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {},
          child: const Row(
            children: [
              Icon(Icons.account_circle_outlined, color: Colors.grey, size: 26),
              SizedBox(width: 8),
              Text("Select Voice", style: TextStyle(color: Colors.grey, fontSize: 15)),
              Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
            ],
          ),
        ),
        const Spacer(),
        _buildIconButton(Icons.copy_outlined, () {
          ScriptService.copyToClipboard(_editController.text, context);
        }),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback tap, {Color color = Colors.grey}) {
    return InkWell(
      onTap: tap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}

// ------------------------------------------------------------------------
// GenskriptAudioPlayerDialog (Custom Dialog UI)
// ------------------------------------------------------------------------
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
    // 1. Listen for duration
    _durationSubscription = widget.player.durationStream.listen((d) {
      if (mounted && d != null) {
        setState(() => _duration = d);
      }
    });

    // 2. Listen for position
    _positionSubscription = widget.player.positionStream.listen((p) {
      if (mounted) setState(() => _position = p);
    });

    // 3. Listen for completion
    _playerStateSubscription = widget.player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (mounted) {
          setState(() => _isPlaying = false);
          widget.player.seek(Duration.zero);
          widget.player.pause();
        }
      }
    });

    // 4. Auto-Play if ready
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
                          value: _position.inMilliseconds.toDouble().clamp(0, (_duration.inMilliseconds.toDouble() > 0 ? _duration.inMilliseconds.toDouble() : 1.0)),
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
                    // Stop playing when closing the dialog
                    widget.player.stop();
                    Navigator.pop(context);
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