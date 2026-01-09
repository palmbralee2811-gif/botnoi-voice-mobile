import 'package:flutter/material.dart';
import '../services/script_service.dart';
import '../services/download_service.dart';
import '../services/translation_service.dart';
import '../services/video_service.dart';
import '../services/voice_service.dart';
import '../data/app_data.dart';
import '../widgets/star_p_badge.dart';

class ResultScreen extends StatefulWidget {
  final String script;
  final String? audioUrl;
  final String? imageUrl; // <--- 1. เพิ่มตัวแปรนี้
  final String language;
  final VoidCallback onBack;

  const ResultScreen({
    super.key,
    required this.script,
    this.audioUrl,
    this.imageUrl, // <--- 2. รับค่าจาก constructor
    required this.language,
    required this.onBack,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late TextEditingController _editController;

  @override
  void initState() {
    super.initState();
    // นำสคริปต์ที่ได้จาก AI มาใส่ใน Controller เพื่อให้แก้ไขได้
    _editController = TextEditingController(text: widget.script);
  }

  // ตัวแปรพอยท์ (ถ้ายังไม่มีการรับค่ามาจากหน้าแรก ให้กำหนดค่าเริ่มต้นไว้ทดสอบก่อนครับ)
  int userPoints = 2000;

  void _showLanguagePicker(BuildContext context) {
    String? tempSelected = ""; // เก็บค่าภาษาที่เลือกชั่วคราว

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height:
                  MediaQuery.of(context).size.height * 0.7, // สูง 70% ของหน้าจอ
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FB), // สีพื้นหลังเทาอ่อนตามรูป
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  const Text(
                    "เลือกภาษาที่ต้องการแปล",
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
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                // --- ส่วน Gradient เมื่อเลือกภาษา ---
                                gradient: isSelected
                                    ? const LinearGradient(
                                        colors: [
                                          Color(0xFFE1D5F5),
                                          Color(0xFFB3E5FC),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      )
                                    : null,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.grey.shade100,
                                  child: Text(
                                    lang['flag']!,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                                title: Text(
                                  lang['name']!,
                                  style: TextStyle(
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
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

                  // --- ส่วนแสดงคะแนนที่ต้องใช้ ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildStarPBadge(), // ใช้ Widget ดาวที่คุณมีอยู่แล้ว
                      const SizedBox(width: 8),
                      const Text(
                        "ใช้ครั้งละ 100 พอยท์",
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // --- ปุ่มยืนยันการแปล ---
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: tempSelected!.isEmpty
                          ? null
                          : () => Navigator.pop(context, tempSelected),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "ตกลง",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
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
        // เรียกฟังก์ชันแปลภาษาที่เราเขียนไว้ก่อนหน้านี้
        _executeTranslation(selectedLang);
      }
    });
  }

  void _executeTranslation(String targetLang) async {
    // 1. เช็คพอยท์ก่อน (สมมติว่าต้องใช้ 100)
    if (userPoints < 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("พอยท์ไม่เพียงพอ กรุณาเติมพอยท์")),
      );
      return;
    }

    // แสดง Loading Dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          const Center(child: CircularProgressIndicator(color: Colors.white)),
    );

    // 2. เรียก API แปลภาษา
    String? result = await TranslationService.handleTranslate(
      currentScript: _editController.text,
      targetLanguageName: targetLang,
      imageUrl: widget.imageUrl ?? "",
    );

    if (mounted) Navigator.pop(context); // ปิด Loading

    if (result != null) {
      setState(() {
        _editController.text = result; // อัปเดตสคริปต์บนหน้าจอ
        userPoints -= 100; // หักคะแนน
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "แปลเป็นภาษา $targetLang เรียบร้อยแล้ว! (ใช้ 100 พอยท์)",
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("แปลภาษาไม่สำเร็จ กรุณาลองใหม่อีกครั้ง")),
      );
    }
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _editController = TextEditingController();

    // Set default values that match your options
    String _selectedSpeed = '1x';
    String _selectedVolume = '100%';

    final List<String> speedOptions = [
      '0.5x',
      '0.6x',
      '0.7x',
      '0.8x',
      '0.9x',
      '1x',
      '1.2x',
      '1.5x',
      '2.0x',
    ];

    // NEW: Volume options from 50% to 150%
    final List<String> volumeOptions = [
      '50%',
      '60%',
      '70%',
      '80%',
      '90%',
      '100%',
      '110%',
      '120%',
      '130%',
      '140%',
      '150%',
    ];

    final List<Map<String, dynamic>> footerActions = [
      {
        'label': "เชื่อมสคริปต์",
        'icon': Icons.link,
        'action': () => ScriptService.handleJoinScript(),
      },
      {
        'label': "ดาวน์โหลดทั้งหมด",
        'icon': Icons.download_rounded,
        'action': () => DownloadService.handleDownloadAll(),
      },
      {
        'label': "แปลภาษา",
        'icon': Icons.translate,
        'action': () => _showLanguagePicker(context),
      },
      {
        'label': "สร้างวิดีโอฟรี",
        'icon': Icons.card_giftcard,
        'action': () => VideoService.handleFreeVideo(),
      },
      {
        'label': "สร้างเสียงอัตโนมัติ",
        'icon': Icons.settings_voice,
        'action': () => VoiceService.handleAutoVoice(),
      },
      {
        'label': "สร้างวิดีโอ",
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

            // --- Script Editor Box ---
            _buildScriptEditor(),

            const SizedBox(height: 20),

            // --- NEW: TOOLBAR FROM IMAGE ---
            Row(
              children: [
                // Speed & Volume Selectors
                _buildDropdownSelector(
                  icon: Icons.speed,
                  currentValue:
                      _selectedSpeed, // You can link this to a state variable
                  options: speedOptions,
                  title: "เลือกความเร็ว",
                  onChanged: (val) => setState(() => _selectedSpeed = val),
                ),
                const SizedBox(width: 8),
                // Volume Dropdown
                _buildDropdownSelector(
                  icon: Icons.volume_up_outlined,
                  currentValue: _selectedVolume,
                  options: volumeOptions,
                  title: "ระดับเสียง",
                  onChanged: (val) => print("Selected Volume: $val"),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // PT Count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${_editController.text.length} PT",
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                _buildGenerateButton(),
              ],
            ),
            const SizedBox(width: 10),

            // "สร้างเสียง" (Create Voice) Button
            if (widget.audioUrl != null && widget.audioUrl!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.cyan.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.audiotrack, color: Colors.cyan, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "ไฟล์เสียง: ${widget.audioUrl!.split('/').last}",
                        style: const TextStyle(
                          color: Colors.cyan,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // 6 Functions
            // Part of your build method
            Column(
              children: footerActions.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    width: double.infinity, // Ensures 1 button per line
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: item['action'],
                      icon: Icon(item['icon'], size: 22, color: Colors.cyan),
                      label: Text(
                        item['label'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        backgroundColor: Colors.white,
                        elevation: 0,
                        side: BorderSide(color: Colors.grey.shade200),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment:
                            Alignment.centerLeft, // Pins text/icon to the left
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
                label: const Text("ย้อนกลับไปฟอร์ม"),
                style: TextButton.styleFrom(foregroundColor: Colors.cyan),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScriptEditor() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6), // Light grey background from your image
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: _editController,
        maxLines: 12,
        minLines: 5,
        cursorColor: Colors.cyan,
        style: const TextStyle(
          fontSize: 15,
          height: 1.5,
          color: Colors.black87,
        ),
        onChanged: (text) {
          // Trigger a rebuild to update the "PT" character count in the toolbar
          setState(() {});
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "คลิกเพื่อเริ่มเขียนหรือแก้ไขสคริปต์...",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildGenerateButton() {
    return OutlinedButton(
      onPressed: () {
        // Logic for generating audio/voice
        VoiceService.handleAutoVoice();
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.cyan,
        side: const BorderSide(color: Colors.cyan),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ), // Reduced padding
        minimumSize: Size.zero, // Allows button to shrink if needed
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: const Text(
        "สร้างเสียง",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  // The UI for the selection sheet (similar to a language translator UI)
  Widget _buildDropdownSelector({
    required IconData icon,
    required String currentValue,
    required List<String> options,
    required String title,
    required Function(String) onChanged,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () => _showTranslatorStylePicker(
          context,
          title,
          options,
          currentValue,
          onChanged,
        ),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          // Setting a consistent padding ensures the button doesn't shrink/grow weirdly
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
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: Colors.black54,
              ),
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
            // Drag Handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
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
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Colors.cyan)
                        : null,
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
          onTap: () => print("Voice picker clicked!"),
          child: const Row(
            children: [
              Icon(Icons.account_circle_outlined, color: Colors.grey, size: 26),
              SizedBox(width: 8),
              Text(
                "เลือกเสียง",
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
              Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
            ],
          ),
        ),
        const Spacer(),
        Row(
          children: [
            // --- เก็บไว้เฉพาะปุ่ม Copy เท่านั้น ---
            _buildIconButton(Icons.copy_outlined, () {
              ScriptService.copyToClipboard(_editController.text, context);
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildIconButton(
    IconData icon,
    VoidCallback tap, {
    Color color = Colors.grey,
  }) {
    return InkWell(
      onTap: tap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}
