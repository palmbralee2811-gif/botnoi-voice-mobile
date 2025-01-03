import 'package:botnoivoice/presentation/screens/responsive/orientation_helper.dart';
import 'package:botnoivoice/presentation/screens/speaker/filter_widgets/speaker_modal_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';



// buildFilterButton: ปุ่มเลือกตัวกรอง (สไตล์หรือหมวดหมู่) (อยู่ในแถวที่สองของหน้าจอ)
// ใช้สำหรับเปิด Modal ให้ผู้ใช้เลือกสไตล์เสียงหรือหมวดหมู่เสียงที่ต้องการ
Widget buildFilterButton(
  BuildContext context, {
  required String title,
  required List<String> items,
  required Set<String> selectedItems,
  required ValueChanged<Set<String>> onConfirm,
}) {
  bool isExpanded = false; // Local state for the dropdown

  return StatefulBuilder(
    builder: (context, setState) {
      void toggleExpanded() {
        setState(() {
          isExpanded = !isExpanded; // Toggle the expanded state
        });
      }

      return InkWell(
        onTap: () {
          toggleExpanded(); // Open or close the dropdown

          // Open the Modal Selection
          showModalSelection(
            context: context,
            title: title,
            items: items,
            selectedItems: selectedItems,
            onConfirm: (newSelected) {
              onConfirm(newSelected); // Update selection
              toggleExpanded(); // Close the dropdown
            },
          ).whenComplete(() {
            // Reset the state when the modal is dismissed
            setState(() {
              isExpanded = false;
            });
          });
        },
        child: Container(
          width: 150.w,
          height: OrientationHelper.isLandscape ? 55.h : 35.h,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: const BorderRadius.all(
              Radius.circular(4),
            ),
            border: Border.all(
              color: const Color(0xFFE2E3E9),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: GoogleFonts.prompt(fontSize: OrientationHelper.isLandscape ? 10.sp : 14.sp),
              ),
              SizedBox(width: 6.w),
              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up_sharp // ^ when expanded
                    : Icons.keyboard_arrow_down_sharp, // v when collapsed
                size: OrientationHelper.isLandscape ? 30 : 20,
                color: const Color(0xFF323130),
              ),
            ],
          ),
        ),
      );
    },
  );
}
