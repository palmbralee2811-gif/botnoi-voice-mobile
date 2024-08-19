import 'package:botnoi_voice_mobile/Screens/AllWorkspaceScreen/all_workspace_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkspaceNavbar extends StatelessWidget {
  const WorkspaceNavbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      color:Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 12.sp,
              color: const Color(0xFF323130),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllWorkspaceScreen(),
                ),
              );
            },
          ),
          SizedBox(width: 8.w),
          Text(
            'ดูทั้งหมด',
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF323130),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
