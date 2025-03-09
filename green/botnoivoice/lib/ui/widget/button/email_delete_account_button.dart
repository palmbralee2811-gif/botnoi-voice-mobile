import 'package:botnoivoice/ui/screen/drawer/account/delete_account_screen.dart';
import 'package:botnoivoice/ui/screen/responsive/responsive_design_orientation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailDeleteAccountButton extends StatefulWidget {
  const EmailDeleteAccountButton({super.key});

  @override
  State<EmailDeleteAccountButton> createState() =>
      _EmailDeleteAccountButtonState();
}

class _EmailDeleteAccountButtonState extends State<EmailDeleteAccountButton> {
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
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => const DeleteAccountScreen()),
          );
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
