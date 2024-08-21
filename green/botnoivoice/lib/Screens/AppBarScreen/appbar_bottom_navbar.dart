import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppbarBottomNavbar extends StatelessWidget {
  const AppbarBottomNavbar({
    super.key,
    required this.imagePath,
    required this.languageIconPath,
    required this.onChangePressed,
  });

  final String imagePath;
  final String languageIconPath;
  final VoidCallback onChangePressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'เสียง',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF323130),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 8.w),
              CircleAvatar(
                radius: 14.r,
                backgroundImage: AssetImage(imagePath),
              ),
              SizedBox(width: 4.w),
              Text(
                'เอวา',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF323130),
                  fontFamily: 'Prompt',
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 4.w,
                height: 4.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(width: 8.w),
              CircleAvatar(
                radius: 7.r,
                backgroundImage: AssetImage(languageIconPath),
              ),
              SizedBox(width: 8.w),
              Text(
                'ไทย',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: const Color(0xFF323130),
                  fontFamily: 'Prompt',
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onChangePressed,
            child: Text(
              'เปลี่ยน',
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF007AFF),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
