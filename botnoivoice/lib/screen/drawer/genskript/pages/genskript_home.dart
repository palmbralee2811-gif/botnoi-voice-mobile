import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../data/app_data.dart' as models;
import '../widgets/file_type_selector.dart';
import '../services/document_service.dart';
import '../services/generation_service.dart';
import '../pages/result_screen.dart';
import '../data/app_data.dart';
import '../pages/history_page.dart';
import '../widgets/star_p_badge.dart';

class GenskriptHome extends StatefulWidget {
  const GenskriptHome({super.key});

  @override
  State<GenskriptHome> createState() => _GenskriptHomeState();
}

class _GenskriptHomeState extends State<GenskriptHome> {
  GenerationResult? _lastResult;
  String? uploadedUrl;
  String? _selectedFileName;
  String activeTab = 'upload';
  String fileType = 'image';
  double wordCount = 120;
  String language = 'ไทย';
  String contentType = 'นำเสนองาน';
  int userPoints = 2000;
  int _requiredPoints = 0;

  final TextEditingController _customPromptController = TextEditingController();

  bool _showResult = false;
  bool _hasGeneratedOnce = false;
  bool _isLoading = false;

  PlatformFile? _pickedFile;
  bool _isProcessingFile = false;
  int _pageCount = 0;
  double _uploadProgress = 0.0;

  bool get _isReadyToGenerate {
    bool hasFile = _selectedFileName != null && _selectedFileName!.isNotEmpty;
    bool hasPrompt = _customPromptController.text.trim().isNotEmpty;
    return hasFile && hasPrompt;
  }

  @override
  void initState() {
    super.initState();
    if (quickPresetChips[contentType] != null &&
        quickPresetChips[contentType]!.isNotEmpty) {
      _customPromptController.text = quickPresetChips[contentType]![0]['text']!;
    }
    _customPromptController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _customPromptController.dispose();
    super.dispose();
  }

  Future<void> _handleFileUpload() async {
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
            uploadedUrl = result['image_url'];
            _pageCount = int.tryParse(result['page_count'].toString()) ?? 1;
            _uploadProgress = 1.0;
          });
        } else {
          throw Exception("ไม่พบ URL รูปภาพในระบบ");
        }
      } catch (e) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildHeader(),
      bottomNavigationBar: _showResult ? null : _buildBottomNavigation(),
      body: SafeArea(
        child: _showResult ? _buildResultPage() : _buildInputPage(),
      ),
    );
  }

  PreferredSizeWidget _buildHeader() {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      shape: Border(
        bottom: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded,
            size: 20.sp, color: Colors.black87),
        onPressed: () => context.go('/home'),
        tooltip: 'Back',
        splashRadius: 24,
      ),
      leadingWidth: 50.w,
      centerTitle: true,
      title: SvgPicture.asset(
        'assets/images/logo/appbar-icon.svg',
        height: 28.h,
        fit: BoxFit.contain,
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
                color: Color(0xFF333333), shape: BoxShape.circle),
            child:
                const Icon(Icons.stars, color: Colors.purpleAccent, size: 16),
          ),
          const SizedBox(width: 8),
          Text("$userPoints",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black)),
        ],
      ),
    );
  }

  Widget _buildInputPage() {
    if (_showResult && _lastResult != null) return _buildResultPage();
    if (activeTab == 'history') return const HistoryPage();

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 1024;
        return SingleChildScrollView(
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
        _buildBottomActionRow(),
        if (_hasGeneratedOnce)
          TextButton.icon(
            onPressed: () => setState(() => _showResult = true),
            icon: const Text("ย้อนกลับไปดูสคริปต์",
                style: TextStyle(color: Colors.blue)),
            label: const Icon(Icons.arrow_forward_ios,
                color: Colors.blue, size: 14),
          ),
      ],
    );
  }

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
                      colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
                    )
                  : LinearGradient(
                      colors: [Colors.grey.shade300, Colors.grey.shade400],
                    ),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: ElevatedButton(
              onPressed: ready
                  ? () async {
                      setState(() {
                        _isLoading = true;
                        _lastResult = null;
                        _showResult = true;
                      });

                      try {
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
                            _lastResult = result;
                            userPoints -= _requiredPoints;
                            _isLoading = false;
                            _hasGeneratedOnce = true;
                            _showResult = true;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "สร้างสคริปต์ไม่สำเร็จ: กรุณาตรวจสอบ Debug Console"),
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
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

  Widget _buildDynamicUploadBox() {
    if (_isProcessingFile) {
      return Container(
        height: 80,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.shade200),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.blue)),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("กำลังประมวลผล...",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text("กำลังนับจำนวนหน้า...",
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (_selectedFileName != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        fileType == 'pdf'
                            ? Icons.picture_as_pdf
                            : Icons.slideshow,
                        color: fileType == 'pdf' ? Colors.red : Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _selectedFileName!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    _selectedFileName = null;
                    _pickedFile = null;
                    _pageCount = 0;
                    _uploadProgress = 0.0;
                  }),
                  child:
                      const Icon(Icons.delete_outline, color: Colors.redAccent),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (fileType == 'image' && _pickedFile != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: kIsWeb
                    ? Image.memory(
                        _pickedFile!.bytes!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      )
                    : Image.file(
                        File(_pickedFile!.path!),
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
              )
            else
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.insert_drive_file,
                  size: 64,
                  color: Colors.grey.shade300,
                ),
              ),
            const SizedBox(height: 16),
            if (_uploadProgress < 1.0)
              Column(
                children: [
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
                  Text("กำลังอัปโหลด... ${(_uploadProgress * 100).toInt()}%",
                      style:
                          const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 18),
                      SizedBox(width: 4),
                      Text("พร้อมใช้งาน",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                    ],
                  ),
                  Text("$_pageCount หน้า",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey)),
                ],
              )
          ],
        ),
      );
    }

    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: _buildDefaultUploadPlaceholder(),
    );
  }

  Widget _buildDefaultUploadPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.cloud_upload_outlined, color: Colors.grey, size: 40),
        const SizedBox(height: 12),
        Text(
          fileType == 'image'
              ? "อัปโหลดรูปภาพ"
              : "อัปโหลดไฟล์ ${fileType.toUpperCase()}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const Text(
          "Limit: 200MB",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 24),
        Container(
          width: 200,
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
            ),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: ElevatedButton(
            onPressed: _handleFileUpload,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: const Text("อัปโหลด",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildWordCountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("จำนวนคำ / สไลด์",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
              backgroundColor: isSelected ? Colors.lightBlue : Colors.white,
              onPressed: () =>
                  setState(() => _customPromptController.text = c['text']!),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildResultImagePreview() {
    if (_pickedFile == null) return const SizedBox.shrink();
    return Column(
      children: [
        const Text("อัพสไลด์ ได้สคริปต์!",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        if (fileType == 'image')
          Container(
            width: double.infinity,
            height: 250,
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
                      : const Center(child: Text("ไม่สามารถโหลดรูปบนเว็บได้")))
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
                    color: Colors.black.withOpacity(0.03), blurRadius: 10),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16)),
                  child: Icon(
                    fileType == 'pdf' ? Icons.picture_as_pdf : Icons.slideshow,
                    color: fileType == 'pdf'
                        ? Colors.red.shade400
                        : Colors.orange.shade400,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _selectedFileName ?? "ไฟล์เอกสาร",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("$_pageCount หน้า",
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14)),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        fileType.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
          _buildResultImagePreview(),
          const SizedBox(height: 10),
          ResultScreen(
            script: _lastResult!.script,
            audioUrl: _lastResult!.audioUrl,
            imageUrl: uploadedUrl,
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

  // ✅ UPDATED BOTTOM NAVIGATION
  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), // Light shadow on top
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: activeTab == 'upload' ? 0 : 1,
        onTap: (index) =>
            setState(() => activeTab = index == 0 ? 'upload' : 'history'),
        backgroundColor: Colors.white,
        elevation: 0, // Remove default elevation
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[400],
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 12.sp,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Icon(Icons.cloud_upload_outlined, size: 24.r),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Icon(Icons.cloud_upload_rounded, size: 24.r),
            ),
            label: 'อัปโหลดไฟล์',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Icon(Icons.history_outlined, size: 24.r),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Icon(Icons.history_rounded, size: 24.r),
            ),
            label: 'ประวัติ',
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
      List<String> items, String current, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(12)),
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
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildHistoryEmptyState() =>
      const Center(child: Text("ยังไม่มีประวัติ"));
  Widget _buildHistoryDetailPlaceholder() =>
      const Center(child: Text("เลือกรายการเพื่อดูรายละเอียด"));

  // Helper placeholder methods for consistency if needed by desktop
  Widget _buildInitialPlaceholder({required bool isSelected}) {
    if (isSelected && _selectedFileName != null) {
      // Replicate the selected state UI logic or just use the main builder
      // For simplicity here, returning the dynamic box which handles states
      return _buildDynamicUploadBox();
    }
    return _buildDynamicUploadBox();
  }
}