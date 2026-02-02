import 'package:botnoivoice/screen/drawer/marads/widgets/ui/marads_ui_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MarAdsResultTextBox extends ConsumerWidget {
  final TextEditingController controller;
  final String mode; // 'Result' or 'Edit'
  final VoidCallback onClear;

  const MarAdsResultTextBox({
    super.key,
    required this.controller,
    required this.mode,
    required this.onClear,
  });

  void _handleClearText(BuildContext context) {
    if (controller.text.isEmpty) return;

    controller.clear();
    onClear();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: MarAdsUIStyle.cyanPurpleGradient,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9747FF).withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300.h,
              child: TextField(
                key: const ValueKey('marads_result_textfield'),
                controller: controller,
                maxLines: null,
                expands: true,
                readOnly: mode == 'Result',
                textAlignVertical: TextAlignVertical.top,
                enableInteractiveSelection: true,
                textInputAction: TextInputAction.done, // Enable "Done" button
                onSubmitted: (_) {
                  FocusManager.instance.primaryFocus?.unfocus(); // Close the keyboard with the "Done" button
                },

                inputFormatters: [
                  LengthLimitingTextInputFormatter(1000),
                ],
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF262626),
                  height: 1.43,
                  letterSpacing: 0.25,
                ),
                scrollPhysics: const ClampingScrollPhysics(),
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // ValueListenableBuilder สำหรับตัวนับคำ
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, child) {
                final textLength = value.text.length;
                final isLimitReached = textLength >= 1000;

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              if (mode == 'Edit')
                                Padding(
                                  padding: EdgeInsets.only(right: 8.w),
                                  child: GestureDetector(
                                    onTap: () {
                                      _handleClearText(context);
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: 24.sp,
                                      color: const Color(0xFF4F4F4F),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Text(
                          '$textLength',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: isLimitReached
                                ? Colors.deepOrange
                                : const Color(0xFF888888),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}