import 'package:botnoivoice/ui/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:botnoivoice/ui/screen/responsive/responsive_design_orientation.dart';

class AppBarTemplate extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onPressed;
  final String? title;

  const AppBarTemplate({super.key, this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF323130)),
        iconSize: ResponsiveDesignOrientation.isLandscape ? 10.sp : 16.sp,
        onPressed: onPressed,
      ),
      title: title != null && title!.isNotEmpty
          ? Text(
              title!,
              style: TextStyle(
                color: kDark,
                fontSize:
                    ResponsiveDesignOrientation.isLandscape ? 12.sp : 16.sp,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
