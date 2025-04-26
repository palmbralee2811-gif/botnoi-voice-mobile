import 'package:botnoivoice/ui/screen/responsive/responsive_design_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ModalHeader extends StatelessWidget {
  final String title;

  const ModalHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.prompt(
            fontSize: ResponsiveDesignOrientation.isLandscape ? 12.sp : 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        InkWell(
          onTap: () {
            context.pop(); // ปิด Modal
          },
          child: Icon(
            Icons.close,
            size: ResponsiveDesignOrientation.isLandscape ? 16.sp : 24.sp,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
