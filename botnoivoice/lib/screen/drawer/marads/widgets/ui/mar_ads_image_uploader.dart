import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';

class MarAdsImageUploader extends StatefulWidget {
  final Function(String? path, String? name) onImageSelected;
  final String? initialPath;
  final String? initialName;

  const MarAdsImageUploader({
    super.key,
    required this.onImageSelected,
    this.initialPath,
    this.initialName,
  });

  @override
  State<MarAdsImageUploader> createState() => _MarAdsImageUploaderState();
}

class _MarAdsImageUploaderState extends State<MarAdsImageUploader> {
  String? _selectedImagePath;
  String? _selectedImageName;
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    _selectedImagePath = widget.initialPath;
    _selectedImageName = widget.initialName;
  }

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        final file = result.files.single;

        if (file.size > 10 * 1024 * 1024) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('marads_basic.error_file_size'.tr()),
                  backgroundColor: Colors.red),
            );
          }
          return;
        }

        setState(() {
          _selectedImagePath = file.path;
          _selectedImageName = file.name;
        });
        widget.onImageSelected(_selectedImagePath, _selectedImageName);
      }
    } catch (e) {
      _logger.e("Error picking image: $e");
    }
  }

  void _clearImage() {
    setState(() {
      _selectedImagePath = null;
      _selectedImageName = null;
    });
    widget.onImageSelected(null, null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFDBDBDB),
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          _selectedImagePath != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.file(
                    File(_selectedImagePath!),
                    width: 48.w,
                    height: 48.w,
                    fit: BoxFit.cover,
                  ),
                )
              : Icon(
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
                  _selectedImageName ?? 'marads_basic.upload_image'.tr(),
                  style: GoogleFonts.prompt(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF00B0FF),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _selectedImagePath != null
                      ? 'marads_basic.upload_ready'.tr()
                      : 'marads_basic.upload_hint'.tr(),
                  style: GoogleFonts.prompt(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF888888),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          if (_selectedImagePath != null)
            IconButton(
              onPressed: _clearImage,
              icon: Icon(Icons.close, color: Colors.red, size: 20.sp),
            )
          else
            ElevatedButton(
              onPressed: _pickImage,
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
                'marads_basic.btn_upload'.tr(),
                style: GoogleFonts.prompt(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
