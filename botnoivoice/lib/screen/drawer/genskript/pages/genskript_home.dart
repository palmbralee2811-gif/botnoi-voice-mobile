import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';
import '../data/app_data.dart' as models;
import '../widgets/file_type_selector.dart';
import '../services/document_service.dart';
import '../services/generation_service.dart';
import '../pages/result_screen.dart';
import '../data/app_data.dart';
import 'history_page.dart';
import '../widgets/star_p_badge.dart';

class GenskriptHome extends StatefulWidget {
  const GenskriptHome({super.key});

  @override
  State<GenskriptHome> createState() => _GenskriptHomeState();
}

class _GenskriptHomeState extends State<GenskriptHome> {
  GenerationResult? _lastResult;
  // --- State Variables ---
  String? uploadedUrl;
  String? _selectedFileName;
  String activeTab = 'upload';
  String fileType = 'image';
  double wordCount = 120;
  String language = 'ไทย';
  String contentType = 'นำเสนองาน';
  int userPoints = 2000;
  int _requiredPoints = 0; // คะแนนที่จะใช้ (ปรับเปลี่ยนได้ตาม Logic)

  final TextEditingController _customPromptController = TextEditingController();

  bool _showResult = false;
  bool _hasGeneratedOnce = false;
  bool _isLoading = false; // สำหรับแสดงสถานะการโหลดบนปุ่ม

  // เพิ่มตัวแปรเหล่านี้ใน _GenskriptHomeState
  PlatformFile? _pickedFile; // ตัวแปรที่เก็บข้อมูลไฟล์ทั้งหมด
  bool _isProcessingFile = false; // สถานะกำลังนับหน้า/อัปโหลด
  int _pageCount = 0; // จำนวนหน้าที่นับได้
  double _uploadProgress = 0.0; // % การโหลด (0.0 - 1.0)

  // --- Logic Getters ---

  // ตรวจสอบความพร้อม: ต้องมีไฟล์ และ ต้องมีข้อความใน Prompt
  bool get _isReadyToGenerate {
    bool hasFile = _selectedFileName != null && _selectedFileName!.isNotEmpty;
    bool hasPrompt = _customPromptController.text.trim().isNotEmpty;
    return hasFile && hasPrompt;
  }

  @override
  void initState() {
    super.initState();
    // ตั้งค่าเริ่มต้นสำหรับ Prompt ตามประเภทเนื้อหา
    if (quickPresetChips[contentType] != null &&
        quickPresetChips[contentType]!.isNotEmpty) {
      _customPromptController.text = quickPresetChips[contentType]![0]['text']!;
    }

    // สำคัญ: ทำให้หน้าจอ Refresh ทุกครั้งที่พิมพ์ เพื่ออัปเดตสถานะปุ่ม "สร้างข้อความ"
    _customPromptController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _customPromptController.dispose();
    super.dispose();
  }

  // --- Actions ---

  Future<void> _handleFileUpload() async {
    // กำหนดนามสกุลที่อนุญาตตามตัวเลือก UI
    final Map<String, List<String>> extensionConfig = {
      'image': ['jpg', 'jpeg', 'png'],
      'pdf': ['pdf'],
      'pptx': ['pptx', 'ppt'],
    };

    final List<String> allowedExtensions =
        extensionConfig[fileType] ?? ['jpg', 'jpeg', 'png'];

    final PlatformFile? pickedFile = await DocumentService.pickFile(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );

    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
        _selectedFileName = pickedFile.name;
        _isProcessingFile = true;
        _uploadProgress = 0.2;
      });

      try {
        
        final Map<String, dynamic>? result =
            await DocumentService.handleFileUpload(pickedFile);

        if (result != null && result['image_url'] != null) {
          setState(() {
            // ดึงรูปแรกมาแสดงผลตัวอย่าง
            uploadedUrl = result['image_url'];

            // ถ้าคุณมีตัวแปรเก็บ List รูปภาพทั้งหมด
            // allPageImages = List<String>.from(result['image_list']);

            _pageCount = int.tryParse(result['page_count'].toString()) ?? 1;
            _uploadProgress = 1.0;
          });
          print(
            "🎉 Success! โหลดรูปแรกจากทั้งหมด ${result['image_list'].length} หน้า",
          );
        } else {
          throw Exception("ไม่พบ URL รูปภาพในระบบ (img_url_list อาจจะว่าง)");
        }

      } catch (e) {
        print("❌ UI Error Details: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("เกิดข้อผิดพลาด: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isProcessingFile = false);
      }
    }
  }

  // --- UI Builders ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: _buildHeader(),
      bottomNavigationBar: _showResult ? null : _buildBottomNavigation(),
      body: SafeArea(
        child: _showResult
            ? _buildResultPage() // ถ้าสร้างเสร็จแล้ว ไปหน้าผลลัพธ์
            : _buildInputPage(), // ถ้ายังไม่เสร็จ อยู่หน้ากรอกข้อมูล
      ),
    );
  }

  PreferredSizeWidget _buildHeader() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.black87),
        onPressed: () {
          context.pop();
        },
      ),
      centerTitle: true,
      title: SizedBox(
        height: 35,
        child: Image.asset(
          'pic/logo.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.rocket_launch, color: Colors.blue),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: _buildPointsBadge(),
        ),
      ],
    );
  }

  Widget _buildPointsBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Color(0xFF333333),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.stars,
              color: Colors.purpleAccent,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "$userPoints",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildInputPage() {
    // 1. ลำดับความสำคัญแรก: ถ้ามีการกดสร้างข้อความสำเร็จ ให้แสดงหน้า Result ก่อน
    if (_showResult && _lastResult != null) {
      return _buildResultPage();
    }

    // 2. ลำดับความสำคัญที่สอง: ถ้าเลือก Tab ประวัติ ให้แสดงหน้า History
    if (activeTab == 'history') {
      return const HistoryPage();
    }

    // 3. ลำดับสุดท้าย: แสดงหน้าฟอร์มกรอกข้อมูล (แยก Mobile/Desktop)
    return LayoutBuilder(
      builder: (context, constraints) {
        // ตรวจสอบขนาดหน้าจอ
        bool isMobile = constraints.maxWidth < 1024;

        return SingleChildScrollView(
          // ปรับ Padding ตามขนาดหน้าจอ
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: isMobile ? _buildMobileUI() : _buildDesktopUI(),
        );
      },
    );
  }

  Widget _buildMobileUI() {
    return Column(
      children: [
        _buildUploadPanel(),
        const SizedBox(height: 20),
        _buildInitialPlaceholder(isSelected: _selectedFileName != null),
      ],
    );
  }

  Widget _buildDesktopUI() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 420, child: _buildUploadPanel()),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            children: [const SizedBox(height: 24), _buildResultArea()],
          ),
        ),
      ],
    );
  }

  Widget _buildUploadPanel() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          activeTab == 'upload'
              ? _buildUploadContent()
              : _buildHistoryEmptyState(),
        ],
      ),
    );
  }

  Widget _buildUploadContent() {
    return Column(
      children: [
        FileTypeSelector(
          selected: fileType,
          onSelect: (id) => setState(() {
            fileType = id;
            _selectedFileName = null;
            _requiredPoints = 0;
          }),
        ),
        const SizedBox(height: 20),
        _buildDynamicUploadBox(),
        const SizedBox(height: 24),
        _buildWordCountSection(),
        const SizedBox(height: 24),
        _buildDropdownSection(),
        const SizedBox(height: 24),
        _buildCustomInstructionField(),
        _buildDynamicChipsRow(),
        const SizedBox(height: 30),
        _buildBottomActionRow(), // ปุ่มสร้างข้อความ
        if (_hasGeneratedOnce)
          TextButton.icon(
            onPressed: () => setState(() => _showResult = true),
            icon: const Text(
              "ย้อนกลับไปดูสคริปต์",
              style: TextStyle(color: Colors.cyan),
            ),
            label: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.cyan,
              size: 14,
            ),
          ),
      ],
    );
  }

  // --- ปุ่มสร้างข้อความและแสดง Point ---

  // ปรับปรุงปุ่มใน _buildBottomActionRow
  Widget _buildBottomActionRow() {
    final bool ready = _isReadyToGenerate && !_isLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPointDisplay(),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: Container(
            decoration: BoxDecoration(
              gradient: ready
                  ? const LinearGradient(
                      colors: [Color(0xFFB39DDB), Color(0xFF00B0FF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : LinearGradient(
                      colors: [Colors.grey.shade300, Colors.grey.shade400],
                    ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton(
              onPressed: ready
                  ? () async {
                      setState(() {
                        _isLoading = true;
                        _lastResult =
                            null; // ล้างค่าเก่าทิ้งเพื่อให้หน้า Result ขึ้น "กำลังประมวลผล"
                        _showResult = true; // เปิดหน้า Result รอไว้เลย
                      });

                      try {
                        // --- จุดที่แก้ไข: รับค่าเป็น GenerationResult แทน bool ---
                        final models.GenerationResult? result =
                            await GenerationService.generate(
                              prompt: _customPromptController.text,
                              imageUrl: uploadedUrl,
                              language: language,
                              wordCount: wordCount,
                              temperature: 0.6,
                            );

                        if (result != null) {
                          setState(() {
                            _lastResult =
                                result; // เก็บข้อมูลลง Model ที่เราสร้างไว้
                            userPoints -=
                                _requiredPoints; // หักคะแนนผู้ใช้ตามที่ระบุไว้
                            _isLoading = false;
                            _hasGeneratedOnce = true;
                            _showResult = true; // เปลี่ยนหน้าไปหน้า Result
                          });
                        } else {
                          // กรณีที่ result เป็น null (เช่น Error 422 หรือกุญแจไม่ผ่าน)
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "สร้างสคริปต์ไม่สำเร็จ: กรุณาตรวจสอบ Debug Console",
                              ),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      } catch (e) {
                        debugPrint("Error during generation: $e");
                      } finally {
                        setState(() => _isLoading = false);
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "สร้างข้อความ",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        buildStarPBadge(),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPointDisplay() {
    return Row(
      children: [
        const Icon(Icons.help_outline, size: 18, color: Colors.black54),
        const SizedBox(width: 8),
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 14, color: Color(0xFF5C89C1)),
            children: [
              const TextSpan(text: "ใช้: "),
              TextSpan(
                text: "$_requiredPoints",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const TextSpan(text: " พอยท์"),
            ],
          ),
        ),
      ],
    );
  }

  // --- Helper Widgets (Upload Box, Dropdowns, Chips) ---

  Widget _buildDynamicUploadBox() {
    // 1. สถานะกำลังประมวลผล (สำหรับ PDF/PPTX หรือขณะนับหน้า) - ส่วนที่คุณส่งมา
    if (_isProcessingFile) {
      return Container(
        height: 80,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.cyan.shade200,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.cyan,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "กำลังประมวลผล...",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    "กำลังนับจำนวนหน้า...",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // 2. สถานะเลือกไฟล์เรียบร้อยแล้ว (แสดงชื่อไฟล์และปุ่มลบ)
    if (_selectedFileName != null) {
      return Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.cyan),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // แสดง Preview เล็กๆ: เช็ค kIsWeb เพื่อใช้ bytes หรือ path
            if (fileType == 'image' && _pickedFile != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: kIsWeb
                    ? Image.memory(
                        _pickedFile!.bytes!,
                        width: 45,
                        height: 45,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(_pickedFile!.path!),
                        width: 45,
                        height: 45,
                        fit: BoxFit.cover,
                      ),
              )
            else
              const Icon(
                Icons.insert_drive_file_outlined,
                color: Colors.cyan,
                size: 30,
              ),

            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedFileName!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Text(
                    "พร้อมสำหรับประมวลผล",
                    style: TextStyle(color: Colors.cyan, fontSize: 10),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => setState(() {
                _selectedFileName = null;
                _pickedFile = null;
                _pageCount = 0;
                _uploadProgress = 0.0;
              }),
            ),
          ],
        ),
      );
    }

    // 3. สถานะเริ่มต้น (ยังไม่ได้เลือกไฟล์)
    return Container(
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: _buildDefaultUploadPlaceholder(),
    );
  }

  Widget _buildDefaultUploadPlaceholder() {
    return Row(
      children: [
        const SizedBox(width: 16),
        const Icon(Icons.cloud_upload_outlined, color: Colors.grey, size: 30),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fileType == 'image'
                    ? "อัปโหลดรูปภาพ"
                    : "อัปโหลดไฟล์ ${fileType.toUpperCase()}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                "Limit: 200MB",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: ElevatedButton(
            onPressed: _handleFileUpload, // เรียกฟังก์ชันอัปโหลดที่คุณมีอยู่
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyan,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text("อัปโหลด", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildWordCountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "จำนวนคำ / สไลด์",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 8),
        _buildDropdown(
          List.generate(10, (i) => ((i + 1) * 20).toString()),
          wordCount.round().toString(),
          (v) {
            if (v != null) setState(() => wordCount = double.parse(v));
          },
        ),
      ],
    );
  }

  Widget _buildDropdownSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputLabel(
          "ภาษาของสคริปต์",
          _buildDropdown(
            ['ไทย', 'ENG'],
            language,
            (v) => setState(() => language = v!),
          ),
        ),
        const SizedBox(height: 20),
        _buildInputLabel(
          "ประเภทเนื้อหา",
          _buildDropdown(
            ['นำเสนองาน', 'สอนวิธีทำ', 'เล่าเรื่อง', 'บรรยายอาจารย์'],
            contentType,
            (v) {
              if (v != null)
                setState(() {
                  contentType = v;
                  if (quickPresetChips[v]!.isNotEmpty)
                    _customPromptController.text =
                        quickPresetChips[v]![0]['text']!;
                });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCustomInstructionField() {
    return _buildInputLabel(
      "คำสั่งกำหนดเอง (optional)",
      TextField(
        controller: _customPromptController,
        maxLines: 4,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicChipsRow() {
    final chips = quickPresetChips[contentType] ?? [];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: chips.map((c) {
          bool isSelected = _customPromptController.text == c['text'];
          return Padding(
            padding: const EdgeInsets.only(right: 8, top: 12),
            child: ActionChip(
              label: Text(
                c['label']!,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
              backgroundColor: isSelected ? Colors.cyan : Colors.white,
              onPressed: () =>
                  setState(() => _customPromptController.text = c['text']!),
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- Placeholders & Navigation ---

  Widget _buildInitialPlaceholder({required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: isSelected
          ? _buildFileSelectedCard()
          : _buildRainbowInstructionBox(),
    );
  }

  Widget _buildFileSelectedCard() {
    // ตรวจสอบว่าเป็นรูปภาพหรือไม่
    bool isImage = fileType == 'image' && _pickedFile != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Header: แสดงชื่อไฟล์และประเภท (พร้อมปุ่มลบ)
        Row(
          children: [
            Icon(
              fileType == 'pdf' ? Icons.picture_as_pdf : Icons.slideshow,
              color: fileType == 'pdf' ? Colors.red : Colors.orange,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _selectedFileName ?? "ไม่ได้ระบุชื่อไฟล์",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // ปุ่มลบไฟล์
            GestureDetector(
              onTap: () => setState(() {
                _selectedFileName = null;
                _pickedFile = null;
                _pageCount = 0;
              }),
              child: const Icon(
                Icons.delete_outline,
                color: Colors.grey,
                size: 20,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 2. ส่วนแสดงผลพรีวิว (รูปภาพ หรือ Thumbnails เอกสาร)
        if (isImage)
          _buildImageThumbnail() // ฟังก์ชันแสดงรูปที่คุณมี
        else
          _buildDocumentThumbnails(),

        const SizedBox(height: 16),

        // 3. แถบสถานะการโหลด (Linear Progress)
        // ตรวจสอบสถานะการอัปโหลด
        _uploadProgress < 1.0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. แสดงแถบ Progress ขณะกำลังโหลด
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _uploadProgress,
                      backgroundColor: Colors.grey.shade200,
                      color: const Color(0xFF455A64),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "กำลังอัปโหลด... ${(_uploadProgress * 100).toInt()}%",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              )
            : Row(
                // 2. แสดงข้อความเมื่ออัปโหลดสำเร็จ (แถบ Progress จะหายไป)
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    "อัปโหลดสำเร็จ",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

        const SizedBox(height: 12),

        // 4. ข้อมูลสรุป (จำนวนหน้า และประเภทไฟล์)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "จำนวนหน้า:",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                Text(
                  "$_pageCount หน้า",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                fileType.toUpperCase(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageThumbnail() {
    // ตรวจสอบความปลอดภัยถ้าไม่มีไฟล์
    if (_pickedFile == null) return const SizedBox.shrink();

    return Center(
      child: Container(
        height: 150, // ปรับความสูงตามความเหมาะสมของ Mobile UI
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          // แยกการแสดงผลระหว่าง Web และ Mobile
          child: kIsWeb
              ? (_pickedFile!.bytes != null
                    ? Image.memory(_pickedFile!.bytes!, fit: BoxFit.cover)
                    : const Center(child: Text("ไม่สามารถโหลดรูปบนเว็บได้")))
              : Image.file(File(_pickedFile!.path!), fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildDocumentThumbnails() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Container(
        width:
            100, // ปรับขนาดให้ใหญ่ขึ้นเล็กน้อยเพื่อให้ดูเหมาะสมเมื่ออยู่ไอคอนเดียว
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              fileType == 'pdf' ? Icons.picture_as_pdf : Icons.slideshow,
              color: Colors.grey.shade400,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRainbowInstructionBox() {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Colors.purpleAccent, Colors.cyanAccent, Colors.greenAccent],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          children: [
            Text(
              "อัปโหลดไฟล์เพื่อเริ่มสร้างผลลัพธ์",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Icon(Icons.arrow_upward, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // ภายในหน้า ResultScreen หรือฟังก์ชันที่สร้าง Result UI

  Widget _buildResultImagePreview() {
    if (_pickedFile == null) return const SizedBox.shrink();

    return Column(
      children: [
        const Text(
          "อัพสไลด์ ได้สคริปต์!",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 16),
        if (fileType == 'image')
          Container(
            width: double.infinity,
            height: 250, // ขนาดใหญ่กว่าในหน้าแรกเพื่อให้เห็นชัดเจน
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: kIsWeb
                  ? (_pickedFile!.bytes != null
                        ? Image.memory(_pickedFile!.bytes!, fit: BoxFit.cover)
                        : const Center(
                            child: Text("ไม่สามารถโหลดรูปบนเว็บได้"),
                          ))
                  : Image.file(File(_pickedFile!.path!), fit: BoxFit.cover),
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                // แสดงไอคอนตามประเภทไฟล์
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    fileType == 'pdf' ? Icons.picture_as_pdf : Icons.slideshow,
                    color: fileType == 'pdf'
                        ? Colors.red.shade400
                        : Colors.orange.shade400,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 16),
                // แสดงชื่อไฟล์
                Text(
                  _selectedFileName ?? "ไฟล์เอกสาร",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // แสดงจำนวนหน้าและประเภทไฟล์
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$_pageCount หน้า",
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        fileType.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildResultPage() {
    if (_lastResult == null)
      return const Center(child: CircularProgressIndicator());

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        children: [
          // --- ส่วนที่เพิ่มเข้ามา: แสดงพรีวิวไฟล์ที่เราอัปโหลดไป ---
          _buildResultImagePreview(),

          const SizedBox(height: 10),

          // --- หน้า ResultScreen เดิมของคุณ ---
          ResultScreen(
            script: _lastResult!.script,
            audioUrl: _lastResult!.audioUrl,
            imageUrl:
                uploadedUrl, // <--- ส่ง URL จริงที่อัปโหลดสำเร็จไปให้หน้า Result
            language: language,
            onBack: () => setState(() => _showResult = false),
          ),
        ],
      ),
    );
  }

  Widget _buildResultArea() {
    if (activeTab == 'history') return _buildHistoryDetailPlaceholder();
    if (_showResult) return _buildResultPage();
    return _buildInitialPlaceholder(isSelected: _selectedFileName != null);
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: activeTab == 'upload' ? 0 : 1,
      onTap: (i) => setState(() => activeTab = i == 0 ? 'upload' : 'history'),
      selectedItemColor: Colors.cyan,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.cloud_upload),
          label: 'อัปโหลดไฟล์',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'ประวัติ'),
      ],
    );
  }

  Widget _buildDropdown(
    List<String> items,
    String current,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(current) ? current : items[0],
          isExpanded: true,
          items: items
              .map((i) => DropdownMenuItem(value: i, child: Text(i)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildHistoryEmptyState() =>
      const Center(child: Text("ยังไม่มีประวัติ"));
  Widget _buildHistoryDetailPlaceholder() =>
      const Center(child: Text("เลือกรายการเพื่อดูรายละเอียด"));
}
