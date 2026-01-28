import 'package:botnoivoice/screen/drawer/marads/widgets/ui/marads_ui_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MarAdsResultTextBox extends StatelessWidget {
  final TextEditingController controller;
  final String mode; // 'Result' or 'Edit'
  final VoidCallback onClear;

  const MarAdsResultTextBox({
    super.key,
    required this.controller,
    required this.mode,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
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
              // ใช้ ValueListenableBuilder เพื่อลดการ Rebuild ทั้งก้อน
              child: TextField(
                // เพิ่ม Key เพื่อช่วยให้ Framework แยกแยะ State ได้แม่นยำขึ้น
                key: const ValueKey('marads_result_textfield'),
                controller: controller,
                maxLines: null, 
                expands: true,
                readOnly: mode == 'Result',
                textAlignVertical: TextAlignVertical.top,
                
                // ป้องกันการ Crash จากการลากเลือกข้อความ (Selection)
                // ถ้ายัง Crash อยู่ ให้เปลี่ยนเป็น false (แต่จะเลือกข้อความไม่ได้)
                enableInteractiveSelection: true,

                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF262626),
                  height: 1.43,
                  letterSpacing: 0.25,
                ),
                
                // ใช้ ClampingScrollPhysics เพื่อป้องกันการแย่ง Scroll กับ ListView แม่
                scrollPhysics: const ClampingScrollPhysics(),
                
                // เพิ่ม onTapOutside: 
                // ทำให้ TextField หุบคีย์บอร์ดเองได้เมื่อจิ้มข้างนอก 
                // *คุณจึงสามารถไปลบ GestureDetector ที่หน้าจอแม่ (Parent) ออกได้เลย*
                // ซึ่งจะช่วยแก้ปัญหา Gesture ตีกันจน Crash ได้ถาวร
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
                final isOverLimit = textLength >= 1000;

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
                                      controller.clear(); 
                                      onClear();
                                    },
                                    child: Icon(Icons.close,
                                        size: 24.sp, color: const Color(0xFF4F4F4F)),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Text(
                          '$textLength ตัวอักษร',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: isOverLimit
                                ? Colors.red
                                : const Color(0xFF888888),
                          ),
                        ),
                      ],
                    ),
                    if (isOverLimit)
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            "ข้อความเกิน 1,000 ตัว ไม่สามารถสร้างเสียงได้",
                            style: GoogleFonts.prompt(
                              fontSize: 12.sp,
                              color: Colors.red,
                            ),
                          ),
                        ),
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