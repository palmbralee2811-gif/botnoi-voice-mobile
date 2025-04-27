import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// Delete Account Button for Email/Password and Apple Sign In
class DeleteAccountButton extends StatefulWidget {
  const DeleteAccountButton({super.key});

  @override
  State<DeleteAccountButton> createState() => _DeleteAccountButtonState();
}

class _DeleteAccountButtonState extends State<DeleteAccountButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: ResponsiveDesignOrientation.isLandscape ? 75.h : 50.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, Colors.white],
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: () {
          // Redirect to Delete Account Screen
          context.push('/delete-account');
        },
        child: Text("auth.delete_account_button".tr(), //"ลบบัญชี"
            style: GoogleFonts.prompt(
                color: Colors.red,
                fontSize:
                    ResponsiveDesignOrientation.isLandscape ? 13.sp : 16.sp,
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}
