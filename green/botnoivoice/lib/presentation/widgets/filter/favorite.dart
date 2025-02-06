import 'package:botnoivoice/presentation/screens/responsive/orientation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Favorite extends StatelessWidget {
  const Favorite({
    super.key,
    required this.ishover,
  });

  final bool ishover;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35.w,  // ขนาดที่เหมาะสมกับปุ่มอื่นๆ
      height: 35.h, // ขนาดที่เหมาะสมกับปุ่มอื่นๆ
      decoration: BoxDecoration(
        gradient: ishover
            ? const LinearGradient(
                colors: [
                  Color(0xFF9A96F5),
                  Color(0xFF00E0FF)
                ],
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
      //TODO: [Bug] UI Overflow in Favorite Button
      /*
════════ Exception caught by rendering library ═════════════════════════════════
A RenderFlex overflowed by 0.541 pixels on the bottom.
The relevant error-causing widget was:
    Column Column:file:///Users/kawin101/Desktop/botnoi-voice-mobile/green/botnoivoice/lib/presentation/widgets/filter/favorite.dart:35:14
════════════════════════════════════════════════════════════════════════════════
      */
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ishover
                  ? Icon(
                      Icons.favorite,
                      size: OrientationHelper.isLandscape ? 12.sp : 16.sp, // ขนาดของไอคอนให้เหมาะสม
                      color: Colors.white,
                    )
                  : Icon(
                      Icons.favorite_border,
                      size: OrientationHelper.isLandscape ? 12.sp : 16.sp, // ขนาดของไอคอนให้เหมาะสม
                      color: Colors.black,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
