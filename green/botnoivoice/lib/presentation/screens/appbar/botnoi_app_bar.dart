import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:botnoivoice/presentation/screens/responsive/orientation_helper.dart';

class BotnoiAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackPressed;
  final String? title; 

  const BotnoiAppBar({Key? key, this.onBackPressed, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF323130)), 
        iconSize: OrientationHelper.isLandscape ? 10.sp : 16.sp,
        onPressed: onBackPressed ?? () {
          Navigator.pop(context);
        },
      ),
      title: title != null && title!.isNotEmpty 
          ? Text(
              title!,
              style: TextStyle(
                color: const Color(0xFF323130), 
                fontSize: OrientationHelper.isLandscape ? 14.sp : 18.sp,
                fontWeight: FontWeight.bold,
              ),
            )
          : null, 
      centerTitle: true, 
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
