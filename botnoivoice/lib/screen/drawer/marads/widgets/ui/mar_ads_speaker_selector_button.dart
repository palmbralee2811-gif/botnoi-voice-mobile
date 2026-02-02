// Path: lib/screen/drawer/marads/widgets/ui/mar_ads_speaker_selector_button.dart

import 'package:botnoivoice/screen/main/speaker/entities/speaker_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MarAdsSpeakerSelectorButton extends StatelessWidget {
  final SpeakerEntity? selectedSpeaker;
  final VoidCallback onTap;

  const MarAdsSpeakerSelectorButton({
    super.key,
    required this.selectedSpeaker,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 33.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: const Color(0xFF868688),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // แสดงรูป Speaker
            Container(
              width: 25.w,
              height: 25.h,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.antiAlias,
              child: selectedSpeaker != null &&
                      selectedSpeaker!.squareImage.isNotEmpty
                  ? Image.network(
                      selectedSpeaker!.squareImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: Colors.grey[300]),
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.person, size: 15)),
            ),
            SizedBox(width: 8.w),

            // แสดงชื่อ (ใช้ logic ภาษาตามที่มี หรือ default เป็น name)
            Text(
              selectedSpeaker != null
                  ? (context.locale.languageCode == 'th'
                      ? selectedSpeaker!.thaiName
                      : selectedSpeaker!.engName)
                  : 'marads_result.select_voice'.tr(),
              style: GoogleFonts.prompt(
                fontSize: 12.sp, // ปรับขนาดให้อ่านง่ายขึ้น
                fontWeight: FontWeight.w400,
                color: const Color(0xFF262626),
              ),
            ),
            SizedBox(width: 5.w),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16.sp,
              color: const Color(0xFF262626),
            ),
          ],
        ),
      ),
    );
  }
}
