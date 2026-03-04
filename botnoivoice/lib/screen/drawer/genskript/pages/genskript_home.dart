import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:botnoivoice/screen/drawer/genskript/data/api_constants.dart';
import 'package:botnoivoice/screen/drawer/genskript/models/result_item_model.dart';
import 'package:botnoivoice/screen/drawer/genskript/widgets/genskript_uploader.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/components/mar_ads_points_badge.dart';
import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class GenskriptHome extends ConsumerStatefulWidget {
  const GenskriptHome({super.key});

  @override
  ConsumerState<GenskriptHome> createState() => _GenskriptHomeState();
}

class _GenskriptHomeState extends ConsumerState<GenskriptHome> {
  GenerationResult? _lastResult;
  String activeTab = 'upload';
  String fileType = 'image';
  double wordCount = 120;
  String language = 'ไทย';
  String contentType = 'นำเสนองาน';

  // สร้างสมการคำนวณพอยท์อัตโนมัติ
  int get _requiredPoints {
    int itemCount = 1;

    if (fileType == 'image') {
      // กรณีเป็นรูปภาพ ให้นับจากจำนวนไฟล์รูปภาพที่ผู้ใช้เลือก
      itemCount = _pickedFiles.length;
    } else {
      // กรณีเป็น PDF/PPTX ให้นับจากจำนวนหน้าที่ API คืนค่ามา (ถ้ายังโหลดไม่เสร็จให้ตั้งต้นที่ 1)
      itemCount = _pageCount ?? 1;
    }

    // ถ้าไม่ได้แนบไฟล์อะไรเลย (พิมพ์แค่คำสั่ง) ให้คิดขั้นต่ำ 1 รายการ
    if (itemCount == 0) itemCount = 1;

    return wordCount.toInt() * itemCount;
  }

  final TextEditingController _customPromptController = TextEditingController();

  bool _showResult = false;
  bool _hasGeneratedOnce = false;
  bool _isLoading = false;
  bool _isUploading = false;

  List<PlatformFile> _pickedFiles = [];
  List<String> _uploadedUrls = []; // ถ้า API รองรับหลาย URL
  String? uploadedUrl;

  // เพิ่มตัวแปรสำหรับเก็บข้อมูล PDF/PPTX
  int? _pageCount;
  List<String>? _previewUrls;

  bool get _isReadyToGenerate {
    bool hasFile = _pickedFiles.isNotEmpty;
    bool hasPrompt = _customPromptController.text.trim().isNotEmpty;
    return hasFile || hasPrompt;
  }

  @override
  void initState() {
    super.initState();
    _customPromptController.addListener(() => setState(() {}));
    // โหลด Point ล่าสุดทุกครั้งที่เข้าหน้านี้
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadAllTokensIfLoggedIn(ref);
    });
  }

  @override
  void dispose() {
    _customPromptController.dispose();
    super.dispose();
  }

  Future<void> _handleFilesChanged(List<PlatformFile> files) async {
    setState(() {
      _pickedFiles = files;
      _isLoading = true;
      _isUploading = true;
      _pageCount = null;
      _previewUrls = null;
    });

    // TODO: ตรงนี้คุณต้องวนลูป Upload หรือส่ง List ไปที่ Service ตาม API ของคุณ
    // ตัวอย่างการ Loop Upload (สมมติ):
    try {
      _uploadedUrls.clear();
      uploadedUrl = null;

      // สร้างตัวแปรชั่วคราวเพื่อสะสม URL ของทุกไฟล์
      List<String> allPreviewImages = [];

      for (var file in files) {
        // เรียก Service Upload ทีละไฟล์
        final result = await DocumentService.handleFileUpload(file);
        if (result != null) {
          // 1. เก็บ URL หลัก
          if (result['image_url'] != null) {
            _uploadedUrls.add(result['image_url']);
          }

          // 2. เก็บจำนวนหน้า (ถ้ามี)
          if (result['page_count'] != null) {
            setState(() {
              _pageCount = result['page_count'];
            });
          }

          // 3. เก็บรายการรูปภาพสำหรับ Preview (ถ้ามี)
          if (result['image_list'] != null) {
            allPreviewImages.addAll(List<String>.from(result['image_list']));
          } else if (result['image_url'] != null) {
            allPreviewImages.add(result['image_url']);
          }
        }
      }

      if (allPreviewImages.isNotEmpty) {
        _previewUrls = allPreviewImages;
      }

      // Logic: ถ้า API รับแค่ 1 รูป ให้ใช้รูปแรก, ถ้ารับหลายรูปต้องแก้ Service
      // สมมติว่าเอา URL แรกไปใช้งานก่อน
      if (_uploadedUrls.isNotEmpty) {
        uploadedUrl = _uploadedUrls.first;
      }
    } catch (e) {
      print("Upload error: $e");
    } finally {
      setState(() {
        _isLoading = false;
        _isUploading = false; // จบการอัปโหลด
      });
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
          padding: EdgeInsets.only(right: 16.w),
          child: _buildPointsBadge(),
        ),
      ],
    );
  }

  Widget _buildPointsBadge() {
    // เรียกใช้ Riverpod ดึง Point จริง
    final userToken = ref.watch(currentUserTokenStateProvider);
    final points = userToken.remainingCredits ?? 0;
    // ใช้ Widget มาตรฐานของแอปที่กดแล้วมี Payment Dialog เด้งได้
    return Center(child: MarAdsPointsBadge(points: points.toString()));
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
            _pickedFiles.clear();
            _pageCount = null;
            _previewUrls = null;
          }),
        ),
        const SizedBox(height: 20),
        GenskriptImageUploader(
          fileType: fileType,
          initialFiles: _pickedFiles,
          onFilesChanged: _handleFilesChanged,
          pageCount: _pageCount,
          previewUrls: _previewUrls,
          isLoading: _isUploading,
        ),
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
                      // ตรวจสอบยอดพอยท์คงเหลือก่อนเรียกใช้งาน API
                      final userToken = ref.read(currentUserTokenStateProvider);
                      final int currentPoints =
                          int.tryParse(userToken.remainingCredits.toString()) ??
                              0;

                      if (currentPoints < _requiredPoints) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("พอยท์ไม่เพียงพอ กรุณาเติมพอยท์"),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return; // หยุดการทำงาน ไม่ส่ง API
                      }

                      setState(() {
                        _isLoading = true;
                        _lastResult = null;
                        _showResult = true;
                      });

                      try {
                        // ใช้ _previewUrls เป็นหลักก่อน เพราะเก็บ URL ครบทุกหน้า (กรณี PDF/PPTX)
                        // ถ้าไม่มี (เช่น อัปโหลดรูปภาพปกติ) ค่อยดึงจาก _uploadedUrls แทน
                        String allImageUrlsString =
                            (_previewUrls != null && _previewUrls!.isNotEmpty)
                                ? _previewUrls!.join(',')
                                : _uploadedUrls.join(',');

                        final models.GenerationResult? result =
                            await GenerationService.generate(
                          prompt: _customPromptController.text,
                          imageUrl: allImageUrlsString,
                          language: language,
                          wordCount: wordCount,
                          temperature: 0.6,
                        );

                        if (result != null) {
                          // ยิง API หักพอยท์ตามยอดที่คำนวณไว้ หลังจากสร้างข้อความสำเร็จ
                          try {
                            await http.put(
                              Uri.parse(
                                  "https://api-voice.botnoi.ai/api/payment/v2/deduct_point"),
                              headers: {
                                "Content-Type": "application/json",
                                "Authorization": "Bearer ${ApiConstants.Token}"
                              },
                              body: jsonEncode({
                                "platform": "genskript",
                                "Credits": _requiredPoints,
                                "Monthly_point": 0
                              }),
                            );
                          } catch (e) {
                            debugPrint("Deduct Point Error: $e");
                          }

                          // 1. ใส่ await เพื่อรออัปเดต Point จากเซิร์ฟเวอร์ให้เสร็จสมบูรณ์ก่อน
                          await loadAllTokensIfLoggedIn(ref);

                          // 2. ค่อยสั่งอัปเดต UI เพื่อสลับหน้า (ตัวเลขพอยท์จะเปลี่ยนทันที)
                          if (mounted) {
                            setState(() {
                              _lastResult = result;
                              _isLoading = false;
                              _hasGeneratedOnce = true;
                              _showResult = true;
                            });
                          }
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
                        setState(() {
                          _isLoading = false;
                          _isUploading = false; // จบการอัปโหลด
                        });
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
                        SizedBox(width: 8.w),
                        SvgPicture.asset('assets/images/logo/credit-icon.svg',
                            width: 22.w, height: 22.h),
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
            ],
          ),
        ),
        SizedBox(width: 4.w),
        SvgPicture.asset('assets/images/logo/credit-icon.svg',
            width: 16.w, height: 16.h),
      ],
    );
  }

  Widget _buildWordCountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("จำนวนคำ/สไลด์",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("(100 คำ ประมาณ 30 วินาที)",
                    style: TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    "${wordCount.round()}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(width: 4),
                  const Text("คำ",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.lightBlueAccent,
            inactiveTrackColor: Colors.lightBlue.shade100,
            thumbColor: Colors.lightBlue,
            overlayColor: Colors.lightBlue.withOpacity(0.2),
            trackHeight: 10,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
          ),
          child: Slider(
            value: wordCount,
            min: 20,
            max: 200,
            divisions: 9,
            label: wordCount.round().toString(),
            onChanged: (value) {
              setState(() {
                wordCount = value;
              });
            },
          ),
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
          hintText:
              "เช่น เขียนสคริปต์สำหรับสไลด์เกี่ยวกับ... โดยใช้ภาษาที่เป็นมิตรและเข้าใจง่าย",
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
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
              onPressed: () => setState(() {
                // ถ้าเลือกอยู่แล้ว ให้ลบข้อความออก (Toggle Off)
                if (isSelected) {
                  _customPromptController.clear();
                } else {
                  // ถ้ายังไม่เลือก ให้ใส่ข้อความเข้าไป (Toggle On)
                  _customPromptController.text = c['text']!;
                }
              }),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildResultImagePreview() {
    if (_pickedFiles.isEmpty) return const SizedBox.shrink();

    // ดึงไฟล์แรกมาโชว์เป็นตัวอย่าง
    final firstFile = _pickedFiles.first;
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
                  ? (firstFile.bytes != null
                      ? Image.memory(firstFile.bytes!, fit: BoxFit.cover)
                      : const Center(child: Text("ไม่สามารถโหลดรูปบนเว็บได้")))
                  : Image.file(File(firstFile.path!), fit: BoxFit.cover),
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
                  firstFile.name,
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
                    Text("${(firstFile.size / 1024).toStringAsFixed(1)} KB",
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

    // เตรียมข้อมูล List<ResultItem>
    List<ResultItem> resultItems = [];

    // กรณีมี List URL (จาก PDF/PPT หรือ Upload หลายรูป)
    List<String> imagesToUse = _previewUrls ?? _uploadedUrls;
    if (imagesToUse.isEmpty && uploadedUrl != null) {
      imagesToUse = [uploadedUrl!];
    }

    String defaultScript = "";
    if (_lastResult != null && _lastResult!.script.isNotEmpty) {
      defaultScript = _lastResult!.script;
    } else {
      defaultScript = "ไม่พบข้อความที่สร้าง (กรุณาลองใหม่อีกครั้ง)";
    }

    if (imagesToUse.isNotEmpty) {
      // สร้าง ResultItem สำหรับแต่ละรูป
      for (int i = 0; i < imagesToUse.length; i++) {
        String scriptForThisSlide = "";

        if (_lastResult!.scripts != null && i < _lastResult!.scripts!.length) {
          var item = _lastResult!.scripts![i];
          if (item is Map) {
            scriptForThisSlide = item['script']?.toString() ?? defaultScript;
          } else {
            scriptForThisSlide = defaultScript;
          }
        } else if (i == 0) {
          scriptForThisSlide = defaultScript;
        } else {
          scriptForThisSlide = "";
        }

        resultItems.add(ResultItem(
          imageUrl: imagesToUse[i],
          script: scriptForThisSlide,
          audioUrl: (i == 0) ? _lastResult!.audioUrl : null,
        ));
      }
    } else {
      // Fallback กรณีไม่มีรูป หรือมีแค่ 1 รูปปกติ
      resultItems.add(ResultItem(
        imageUrl: uploadedUrl ?? "",
        script: defaultScript,
        audioUrl: _lastResult!.audioUrl,
      ));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 10),
          ResultScreen(
            items: resultItems,
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
    return _buildInitialPlaceholder();
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
  Widget _buildInitialPlaceholder() {
    // เปลี่ยนมาเรียก Widget ใหม่ในโหมด View หรือ Upload ก็ได้
    return GenskriptImageUploader(
      fileType: fileType,
      initialFiles: _pickedFiles,
      onFilesChanged: _handleFilesChanged,
    );
  }
}
