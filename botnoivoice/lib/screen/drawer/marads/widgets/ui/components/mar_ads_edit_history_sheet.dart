import 'package:botnoivoice/screen/drawer/marads/widgets/ui/marads_ui_style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class MarAdsEditHistorySheet extends StatefulWidget {
  final String initialText;
  final Future<void> Function(String) onSave;

  const MarAdsEditHistorySheet({
    super.key,
    required this.initialText,
    required this.onSave,
  });

  @override
  State<MarAdsEditHistorySheet> createState() => _MarAdsEditHistorySheetState();
}

class _MarAdsEditHistorySheetState extends State<MarAdsEditHistorySheet> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return SafeArea(
      top: false,
      bottom: true,
      child: Padding(
        // คำนวณ padding สำหรับ Keyboard
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16.w,
          right: 16.w,
          top: 50.h,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // กล่องข้อความที่มีขอบ Gradient
              Container(
                decoration: BoxDecoration(
                  gradient: MarAdsUIStyle.cyanPurpleGradient,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF9747FF).withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(2.w),
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _controller,
                        maxLines: 20,
                        minLines: 5,
                        maxLength: null,
                        buildCounter: (
                          context, {
                          required currentLength,
                          required isFocused,
                          required maxLength,
                        }) =>
                            null,
                        style: GoogleFonts.prompt(
                          fontSize: 14.sp,
                          color: const Color(0xFF262626),
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (val) {
                          setState(() {});
                        },
                        textInputAction: TextInputAction.done, // Enable "Done" button
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.pop();
                            },
                            child: Icon(
                              Icons.close,
                              color: Colors.black,
                              size: 24.sp,
                            ),
                          ),
                          Text(
                            '${_controller.text.length}',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: _controller.text.length >= 1000
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // ปุ่มบันทึกสีดำ
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: (_controller.text.trim().isNotEmpty &&
                          _controller.text != widget.initialText &&
                          _controller.text.length < 1000)
                      ? () async {
                          await widget.onSave(_controller.text);
                          // การปิด Modal จะจัดการโดย Parent หรือเรียก pop ที่นี่ตาม flow เดิม
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF262626),
                    disabledBackgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                  child: Text(
                    "marads_props.btn_save".tr(),
                    style: GoogleFonts.prompt(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
