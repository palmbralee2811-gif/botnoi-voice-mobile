import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.ishover,
  });

  final bool ishover;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35.w, // ขนาดที่เหมาะสมกับปุ่มอื่นๆ
      height: 35.h, // ขนาดที่เหมาะสมกับปุ่มอื่นๆ
      decoration: BoxDecoration(
        gradient: ishover
            ? const LinearGradient(
                colors: [Color(0xFF9A96F5), Color(0xFF00E0FF)],
              )
            : null,
        borderRadius: BorderRadius.all(
          Radius.circular(4.r),
        ),
        border: Border.all(
          color: const Color(0xFFE2E3E9),
          width: 1.w,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ishover
                  ? Icon(
                      Icons.favorite,
                      size: ResponsiveDesignOrientation.isLandscape
                          ? 12.sp
                          : 16.sp, // ขนาดของไอคอนให้เหมาะสม
                      color: Colors.white,
                    )
                  : Icon(
                      Icons.favorite_border,
                      size: ResponsiveDesignOrientation.isLandscape
                          ? 12.sp
                          : 16.sp, // ขนาดของไอคอนให้เหมาะสม
                      color: Colors.black,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
