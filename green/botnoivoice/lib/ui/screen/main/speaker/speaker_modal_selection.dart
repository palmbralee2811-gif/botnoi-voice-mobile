import 'package:botnoivoice/ui/screen/responsive/responsive_design_orientation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

// แสดง Modal สำหรับเลือกตัวกรอง (สไตล์หรือหมวดหมู่) โดยมีรายการตัวเลือก
// และปุ่ม "ตกลง" หรือ "ยกเลิก"
// เมื่อเปิด Modal ตัวกรองใหม่จะล้างค่าที่เลือกไว้
Future<void> showModalSelection({
  required BuildContext context,
  required String title,
  required List<String> items,
  required Set<String> selectedItems,
  required ValueChanged<Set<String>> onConfirm,
}) async {
  // สร้างตัวแปรใหม่สำหรับเก็บการเลือกชั่วคราว
  Set<String> tempSelectedItems = Set.from(selectedItems);

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.8,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // หัวข้อและปุ่มปิด
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.prompt(
                      fontSize: ResponsiveDesignOrientation.isLandscape
                          ? 12.sp
                          : 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: ResponsiveDesignOrientation.isLandscape
                          ? 16.sp
                          : 24.sp, // กำหนดขนาดไอคอน
                      color: Colors.black, // กำหนดสีไอคอน
                    ),
                    onPressed: () => Navigator.pop(context), // ปิด Modal
                  ),
                ],
              ),
              const SizedBox(height: 20), // เพิ่มระยะห่าง 20px
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = tempSelectedItems.contains(item);
                    return GestureDetector(
                      onTap: () {
                        if (isSelected) {
                          tempSelectedItems.remove(item);
                        } else {
                          tempSelectedItems.add(item);
                        }
                        (context as Element).markNeedsBuild();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          // ใช้ Gradient เมื่อถูกเลือก
                          gradient: isSelected
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF9340FF), // สีแรกของ Gradient
                                    Color(0xFF34BDFA), // สีที่สองของ Gradient
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                )
                              : null, // ไม่ใช้ Gradient หากไม่ได้เลือก
                          // ใช้สีพื้นหลังธรรมดาเมื่อไม่ได้เลือก
                          color: isSelected ? null : Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent // ไม่มีขอบเมื่อเลือก
                                : const Color(
                                    0xFFE2E3E9), // ขอบสีเทาอ่อนเมื่อไม่ได้เลือก
                          ),
                          borderRadius: BorderRadius.circular(8), // มุมโค้ง
                        ),
                        child: Center(
                          child: Text(
                            item,
                            style: GoogleFonts.prompt(
                              fontSize: ResponsiveDesignOrientation.isLandscape
                                  ? 7.sp
                                  : 12.sp,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.black, // เปลี่ยนสีข้อความตามสถานะ
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  // ปุ่ม "รีเซ็ท"
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        tempSelectedItems.clear(); // รีเซ็ตค่าทั้งหมด
                        (context as Element)
                            .markNeedsBuild(); // รีเฟรช UI แต่ไม่ปิด Modal
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey, // สีเทาสำหรับ Border
                            width: 1, // ความหนาของ Border
                          ),
                          borderRadius:
                              BorderRadius.circular(8), // มุมโค้งของ Border
                          color: Colors.white, // พื้นหลังสีขาว
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        alignment: Alignment.center,
                        child: Text(
                          'reset'.tr(), // รีเซ็ท
                          style: GoogleFonts.prompt(
                            fontSize: ResponsiveDesignOrientation.isLandscape
                                ? 10.sp
                                : 12.sp,
                            color: Colors.black, // ข้อความสีดำ
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // ปุ่ม "ตกลง"
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        onConfirm(
                            tempSelectedItems); // ส่งค่าที่เลือกไปที่ onConfirm
                        Navigator.pop(context); // ปิด Modal
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF9340FF), // สีแรกของ Gradient
                              Color(0xFF34BDFA), // สีที่สองของ Gradient
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius:
                              BorderRadius.circular(8), // ทำให้มุมโค้ง
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        alignment: Alignment.center,
                        child: Text(
                          'confirm'.tr(), // ตกลง
                          style: GoogleFonts.prompt(
                            fontSize: ResponsiveDesignOrientation.isLandscape
                                ? 10.sp
                                : 12.sp,
                            color: Colors.white, // ข้อความสีขาว
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
