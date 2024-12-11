import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


// showModalSelection: แสดง Modal สำหรับเลือกตัวกรอง (สไตล์หรือหมวดหมู่) โดยมีรายการตัวเลือก
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
        heightFactor: 0.6,
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
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
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
                          color: isSelected
                              ? const Color(0xFF01BFFB)
                              : Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF01BFFB)
                                : const Color(0xFFE2E3E9),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            item,
                            style: GoogleFonts.prompt(
                              fontSize: 12.sp,
                              color: isSelected ? Colors.white : Colors.black,
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
                  // ปุ่ม "รีเซ็ทและตกลง" ที่จะทำทั้งสองอย่างในปุ่มเดียว
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: Size(double.infinity, 50.h),
                      ),
                      onPressed: () {
                        tempSelectedItems.clear(); // รีเซ็ตค่าทั้งหมด
                        (context as Element).markNeedsBuild();  // รีเฟรช UI แต่ไม่ปิด Modal
                      },
                      child: Text(
                        'reset'.tr(), //รีเซ็ท
                        style: GoogleFonts.prompt(
                          fontSize: 12.sp,
                          color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // ปุ่ม "ตกลง" เพื่อยืนยันการเลือก
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF01BFFB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: Size(double.infinity, 50.h),
                      ),
                      onPressed: () {
                        onConfirm(tempSelectedItems); // ส่งค่าที่เลือกไปที่ onConfirm
                        Navigator.pop(context); // ปิด Modal
                      },
                      child: Text(
                        'confirm'.tr(), //ตกลง
                        style: GoogleFonts.prompt(
                          fontSize: 12.sp,
                          color: Colors.white),
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
