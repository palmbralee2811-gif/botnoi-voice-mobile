import 'package:botnoivoice/Screens/AllSpeakerScreen/all_speaker_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppbarBottomNavbar extends StatefulWidget {
  const AppbarBottomNavbar({
    super.key,
  });

  @override
  State<AppbarBottomNavbar> createState() => _AppbarBottomNavbarState();
}

class _AppbarBottomNavbarState extends State<AppbarBottomNavbar> {
  //TODO: Update selected speaker

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
                //TODO: Update image
                backgroundImage: const AssetImage('assets/square_image/square_ava.webp',
            ),
              ),
              SizedBox(width: 4.w),
              //TODO: Update name
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
                //TODO: Update national flag
                backgroundImage: const AssetImage('assets/images/national_flag/thai.png'),
              ),
              SizedBox(width: 8.w),
              //TODO: Update national flag name
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
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllSpeakerScreen()));
            },
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
