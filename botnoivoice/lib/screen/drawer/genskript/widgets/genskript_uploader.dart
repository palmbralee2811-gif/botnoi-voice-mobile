import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GenskriptImageUploader extends StatefulWidget {
  final Function(List<PlatformFile> files) onFilesChanged;
  final List<PlatformFile> initialFiles;
  final String fileType;
  final int? pageCount;
  final List<String>? previewUrls;
  final bool isLoading;

  const GenskriptImageUploader({
    super.key,
    required this.onFilesChanged,
    this.initialFiles = const [],
    this.fileType = 'image',
    this.pageCount,
    this.previewUrls,
    this.isLoading = false,
  });

  @override
  State<GenskriptImageUploader> createState() => _GenskriptImageUploaderState();
}

class _GenskriptImageUploaderState extends State<GenskriptImageUploader> {
  List<PlatformFile> _selectedFiles = [];

  BoxDecoration get _commonDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFDBDBDB)),
      );

  @override
  void initState() {
    super.initState();
    _selectedFiles = List.from(widget.initialFiles);
  }

  Future<void> _pickFiles() async {
    // กำหนดนามสกุลไฟล์ตามประเภท
    final Map<String, List<String>> extensionConfig = {
      'image': ['jpg', 'jpeg', 'png'],
      'pdf': ['pdf'],
      'pptx': ['pptx', 'ppt'],
    };

    final List<String> allowedExtensions =
        extensionConfig[widget.fileType] ?? ['jpg', 'jpeg', 'png'];

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: widget.fileType == 'image', // อนุญาตหลายไฟล์เฉพาะรูปภาพ
        withData: kIsWeb,
      );

      if (result != null) {
        setState(() {
          if (widget.fileType == 'image') {
            // ถ้ารูปภาพ ให้เพิ่มเข้าไปในลิสต์
            _selectedFiles.addAll(result.files);
          } else {
            // ถ้าเป็น PDF/PPTX ให้แทนที่เลย
            _selectedFiles = result.files;
          }
        });
        widget.onFilesChanged(_selectedFiles);
      }
    } catch (e) {
      debugPrint("Error picking files: $e");
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
    widget.onFilesChanged(_selectedFiles);
  }

  void _clearAll() {
    setState(() {
      _selectedFiles.clear();
    });
    widget.onFilesChanged([]);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) return _buildLoadingState();

    // กรณีที่ยังไม่มีไฟล์เลือกเลย
    if (_selectedFiles.isEmpty) {
      return _buildEmptyState();
    }
    if (widget.fileType != 'image') {
      return _buildFilePreviewArea();
    }

    // กรณีมีไฟล์แล้ว
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImageHeader(),
        SizedBox(height: 16.h),
        _buildFilePreviewArea(),
        SizedBox(height: 24.h),
        _buildSummaryCount(),
      ],
    );
  }

  Widget _buildFilePreviewArea() {
    if (widget.fileType == 'image') {
      return GridView.builder(
        shrinkWrap: true,
        physics:
            const NeverScrollableScrollPhysics(), // ปิด scroll ของ grid ให้เลื่อนตาม parent
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 10.h,
          childAspectRatio: 1.0,
        ),
        itemCount: _selectedFiles.length,
        itemBuilder: (context, index) {
          final file = _selectedFiles[index];
          return Stack(
            clipBehavior: Clip.none,
            children: [
              // ส่วนแสดงรูปภาพ (ปรับให้เต็มช่อง Grid อัตโนมัติ)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: kIsWeb
                      ? Image.memory(
                          file.bytes!,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(file.path!),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              // ปุ่มลบ (X) มุมขวาบน
              Positioned(
                top: 4,
                right: 4,
                child: InkWell(
                  onTap: () => _removeFile(index),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 2,
                            offset: Offset(0, 1))
                      ],
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 10.sp),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      // PDF / PPTX
      final file = _selectedFiles.first;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. กล่องแสดงชื่อไฟล์ + ปุ่มลบ
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: _commonDecoration,
            child: Row(
              children: [
                Icon(
                  widget.fileType == 'pdf'
                      ? Icons.picture_as_pdf
                      : Icons.slideshow,
                  color: widget.fileType == 'pdf' ? Colors.red : Colors.orange,
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    file.name, // แสดงชื่อไฟล์
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'Prompt',
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: _clearAll,
                  icon: Icon(Icons.delete_outline,
                      color: Colors.grey, size: 20.sp),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // 2. แสดงรูป Preview เล็กๆ (ถ้ามี)
          if (widget.previewUrls != null && widget.previewUrls!.isNotEmpty) ...[
            SizedBox(height: 12.h),
            SizedBox(
              height: 60.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.previewUrls!.length,
                separatorBuilder: (_, __) => SizedBox(width: 8.w),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.network(
                      widget.previewUrls![index],
                      width: 60.h,
                      height: 60.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(width: 60.h, color: Colors.grey.shade200),
                    ),
                  );
                },
              ),
            ),
          ],

          // 3. แสดงจำนวนหน้า (Page Count)
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "จำนวนหน้า:",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: 'Prompt',
                  color: Colors.black87,
                ),
              ),
              Text(
                widget.pageCount != null ? "${widget.pageCount}" : "-",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontFamily: 'Prompt',
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildEmptyState() {
    String displayTitle = '';
    String displayLimit = '';
    if (widget.fileType == 'image') {
      displayTitle = 'รูปภาพ';
      displayLimit = 'Limit: 200MB (.jpg, .jpeg, .png)';
    } else if (widget.fileType == 'pdf') {
      displayTitle = 'PDF';
      displayLimit = 'Limit: 200MB (.pdf)';
    } else if (widget.fileType == 'pptx') {
      displayTitle = 'PPTX';
      displayLimit = 'Limit: 200MB (.pptx)';
    } else {
      displayTitle = widget.fileType.toUpperCase();
      displayLimit = 'Limit: 200MB';
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
      decoration: _commonDecoration, // ใช้ Decoration กลาง
      child: Row(
        children: [
          Icon(
            Icons.cloud_upload_outlined,
            color: const Color(0xFF555555),
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayTitle,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF333333),
                    fontFamily: 'Prompt',
                  ),
                ),
                Text(
                  displayLimit,
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF888888),
                    fontFamily: 'Prompt',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          ElevatedButton(
            onPressed: _pickFiles,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00B0FF),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              minimumSize: Size(0, 36.h),
            ),
            child: Text(
              'อัปโหลด',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'Prompt',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h),
      decoration: _commonDecoration, // ใช้ Decoration กลาง
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24.w,
            height: 24.w,
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(height: 12.h),
          Text(
            "กำลังอัปโหลด...",
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'Prompt',
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            "ไฟล์ขนาดใหญ่ใช้เวลาอัปโหลด 1–2 นาที",
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: 'Prompt',
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: _commonDecoration, // ใช้ Decoration กลาง
      child: Row(
        children: [
          Icon(Icons.description_outlined, color: Colors.black54, size: 20.sp),
          SizedBox(width: 8.w),
          Text(
            "${_selectedFiles.length} ไฟล์ที่เลือก",
            style: TextStyle(
                fontSize: 14.sp, fontFamily: 'Prompt', color: Colors.black87),
          ),
          SizedBox(width: 12.w),
          if (widget.fileType == 'image')
            InkWell(
              onTap: _pickFiles,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF00B0FF)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "เพิ่มรูป",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF00B0FF),
                    fontFamily: 'Prompt',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          const Spacer(),
          IconButton(
            onPressed: _clearAll,
            icon: Icon(Icons.delete_outline, color: Colors.grey, size: 20.sp),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "จำนวน${widget.fileType == 'image' ? 'รูป' : 'ไฟล์'}:",
          style: TextStyle(
              fontSize: 16.sp, fontFamily: 'Prompt', color: Colors.black87),
        ),
        Text(
          "${_selectedFiles.length}",
          style: TextStyle(
            fontSize: 16.sp,
            fontFamily: 'Prompt',
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
