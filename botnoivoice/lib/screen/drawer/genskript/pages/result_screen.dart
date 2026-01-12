import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:logger/logger.dart';
import '../services/script_service.dart';
import '../services/download_service.dart';
import '../services/translation_service.dart';
import '../services/video_service.dart';
import '../services/voice_service.dart'; 
import '../data/app_data.dart';
import '../data/api_constants.dart';
import '../widgets/star_p_badge.dart';

// Initialize Logger (No Emojis)
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

  // Audio Player State
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  String? _currentAudioUrl;

  String _selectedSpeed = '1x';
  String _selectedVolume = '100%';
  int userPoints = 2000; 

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
    _currentAudioUrl = widget.audioUrl;

    _initAudioPlayer();
  }

  void _initAudioPlayer() async {
    // 1. Set Release Mode (Important for Android stability)
    await _audioPlayer.setReleaseMode(ReleaseMode.stop);

    // 2. Listen to Audio Player Streams
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          _duration = newDuration;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          _position = newPosition;
        });
      }
    });

    // Log errors from the player itself
    _audioPlayer.onLog.listen((msg) {
      logger.d("AudioPlayer Log: $msg");
    });

    // Auto-load if URL exists initially
    if (_currentAudioUrl != null && _currentAudioUrl!.startsWith('http')) {
       _prepareAudio(_currentAudioUrl!);
    }
  }

  /// Prepares the audio source (Encodes URL + Sets Source)
  Future<void> _prepareAudio(String url) async {
    try {
      // 1. Encode URL (Fixes 'MEDIA_ERROR_UNKNOWN' caused by spaces in S3 URLs)
      final String encodedUrl = Uri.encodeFull(url);
      logger.d("Preparing audio source: $encodedUrl");
      
      // 2. Stop previous playback to reset state
      await _audioPlayer.stop(); 
      
      // 3. Set the new source
      await _audioPlayer.setSourceUrl(encodedUrl);
      
      // 4. Set volume
      await _audioPlayer.setVolume(1.0);
      
    } catch (e) {
      logger.e("Error setting audio source", error: e);
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to load audio file.")),
        );
      }
    }
  }

  @override
  void dispose() {
    _editController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  // --- Helpers for Audio ---
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  Future<void> _handlePlayPause() async {
    if (_currentAudioUrl == null) return;
    
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        // Encode URL before playing to be safe
        final String encodedUrl = Uri.encodeFull(_currentAudioUrl!);
        
        // If the player lost state or is at start, force play with Source
        if (_position == Duration.zero || _duration == Duration.zero) {
           await _audioPlayer.play(UrlSource(encodedUrl));
        } else {
           await _audioPlayer.resume();
        }
      }
    } catch (e) {
      logger.e("Audio Play/Pause Error", error: e);
      
      // Fallback: Try reloading and playing from scratch
      try {
        await _prepareAudio(_currentAudioUrl!);
        final String encodedUrl = Uri.encodeFull(_currentAudioUrl!);
        await _audioPlayer.play(UrlSource(encodedUrl));
      } catch (e2) {
         logger.e("Retry Play failed", error: e2);
      }
    }
  }

  // --- LOGIC: CREATE VOICE ---
  Future<void> _handleCreateVoice() async {
    if (_editController.text.isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );

    String? resultUrl;
    try {
      resultUrl = await VoiceService.handleCreateVoice(
        scriptText: _editController.text,
        speed: _selectedSpeed,
        volume: _selectedVolume,
        languageValue: widget.language == "ไทย" ? "th" : "en",
      );
    } catch (e) {
      logger.e("Error in handleCreateVoice wrapper", error: e);
    }

    if (mounted) Navigator.pop(context);

    if (resultUrl != null && resultUrl.isNotEmpty) {
      setState(() {
        _currentAudioUrl = resultUrl;
        // Reset UI state
        _position = Duration.zero;
        _duration = Duration.zero;
        _isPlaying = false;
      });
      
      // Prepare the new source immediately
      await _prepareAudio(resultUrl);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Voice generated successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error generating voice")),
      );
    }
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
    if (userPoints < 100) {
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
          userPoints -= 100;
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
    // Action List
    final List<Map<String, dynamic>> footerActions = [
      {
        'label': "Link Script",
        'icon': Icons.link,
        'action': () => ScriptService.handleJoinScript(),
      },
      {
        'label': "Download All",
        'icon': Icons.download_rounded,
        'action': () => DownloadService.handleDownloadAll(),
      },
      {
        'label': "Translate",
        'icon': Icons.translate,
        'action': () => _showLanguagePicker(context),
      },
      {
        'label': "Create Free Video",
        'icon': Icons.card_giftcard,
        'action': () => VideoService.handleFreeVideo(),
      },
      {
        'label': "Auto Voice",
        'icon': Icons.settings_voice,
        'action': () => _handleCreateVoice(),
      },
      {
        'label': "Create Video",
        'icon': Icons.movie_creation_outlined,
        'action': () => VideoService.handleCreateVideo(),
      },
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
            
            const SizedBox(height: 15),

            // Audio Player UI (Only if URL exists)
            if (_currentAudioUrl != null && _currentAudioUrl!.isNotEmpty)
              _buildAudioPlayerUI(),

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

  Widget _buildAudioPlayerUI() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Row(
        children: [
          // Play/Pause Icon
          InkWell(
            onTap: _handlePlayPause,
            child: Icon(
              _isPlaying ? Icons.pause_circle_outline : Icons.play_arrow_outlined,
              color: Colors.cyan,
              size: 32,
            ),
          ),
          const SizedBox(width: 8),

          // Duration Text
          Text(
            "${_formatDuration(_position)} / ${_formatDuration(_duration)}",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),

          // Slider
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.grey[300], 
                inactiveTrackColor: Colors.grey[200],
                thumbColor: Colors.cyan, 
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6), 
                trackHeight: 4.0,
                overlayShape: SliderComponentShape.noOverlay,
              ),
              child: Slider(
                min: 0,
                max: _duration.inSeconds.toDouble() > 0 ? _duration.inSeconds.toDouble() : 1.0,
                value: _position.inSeconds.toDouble().clamp(0, (_duration.inSeconds.toDouble() > 0 ? _duration.inSeconds.toDouble() : 1.0)),
                onChanged: (value) async {
                  try {
                    final position = Duration(seconds: value.toInt());
                    await _audioPlayer.seek(position);
                    await _audioPlayer.resume();
                  } catch (e) {
                    logger.e("Slider Error", error: e);
                  }
                },
              ),
            ),
          ),
          
          const SizedBox(width: 10),

          Text(
            "${_editController.text.length} PT",
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          
          const SizedBox(width: 10),

          // Download Button
          Container(
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF9C88FF), Color(0xFF00B0FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ElevatedButton(
              onPressed: () {
                if (_currentAudioUrl != null) {
                  try {
                    DownloadService.handleDownloadAll(); 
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Downloading...")));
                  } catch (e) {
                     logger.e("Download Error", error: e);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                "Download",
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

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