import 'package:botnoivoice/shared/style/style.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterOption extends StatelessWidget {
  final String imagePath;
  final String text;
  final bool isSelected;

  const FilterOption({
    super.key,
    required this.imagePath,
    required this.text,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: ResponsiveDesignOrientation.isLandscape ? 0.w : 10.w,
      ),
      height: ResponsiveDesignOrientation.isLandscape ? 82.h : 42.h,
      width: 320.w,
      color: kWhite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          imagePath.endsWith('.svg')
              ? SvgPicture.asset(
                  imagePath,
                  width: ResponsiveDesignOrientation.isLandscape ? 13.w : 23.w,
                  height: ResponsiveDesignOrientation.isLandscape ? 43.h : 23.h,
                )
              : Image.asset(
                  imagePath,
                  width: ResponsiveDesignOrientation.isLandscape ? 13.w : 23.w,
                  height: ResponsiveDesignOrientation.isLandscape ? 43.h : 23.h,
                ),
          SizedBox(
              width: ResponsiveDesignOrientation.isLandscape ? 10.w : 20.w),
          
          // --- แก้ไขตรงนี้ ---
          Expanded( // 1. ใช้ Expanded ครอบ เพื่อให้ Text กินพื้นที่เท่าที่เหลือ
            child: Text(
              text,
              style: GoogleFonts.prompt(
                fontSize:
                    ResponsiveDesignOrientation.isLandscape ? 10.sp : 14.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              maxLines: 1, // 2. (Optional) บังคับบรรทัดเดียว ป้องกัน UI เพี้ยนแนวตั้ง
              overflow: TextOverflow.ellipsis, // 3. ถ้าข้อความยาวเกิน ให้ขึ้น ...
            ),
          ),
          // ----------------
        ],
      ),
    );
  }
}