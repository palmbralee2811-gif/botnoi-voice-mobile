import 'package:botnoivoice/presentation/constants/color.dart';
import 'package:botnoivoice/presentation/screens/drawer/account/confirm_delete_account_screen.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_align.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'app_drawer.delete_account'.tr(), //ลบบัญชี
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: kDark,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: kDark,
            size: 24.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientTextAlign(
              'app_drawer.please_read'.tr(), //โปรดอ่าน
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF9340FF),
                  Color(0xFF34BDFA),
                ],
              ),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22.sp,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 8.h),
            GradientTextAlign(
              'app_drawer.account_deletion_warning'.tr(), //การลบบัญชีเป็นการกระทำที่ไม่สามารถย้อนกลับได้ คุณจะไม่สามารถใช้บัญชีนี้กับผลิตภัณฑ์และบริการ พ้อยท์คงเหลือหรือแพ็คเกจที่สมัคร สิทธิพิเศษและโปรโมชั่นที่ได้รับอีกต่อไป โปรดระมัดระวัง
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF9340FF),
                  Color(0xFF34BDFA),
                ],
              ),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 16.h),
            const Spacer(),
            Center(
              child: Column(
                children: [
                  GradientTextAlign(
                    'หากยืนยันที่จะลบบัญชีต่อ กรุณากดปุ่ม', //หากยืนยันที่จะลบบัญชีต่อ กรุณากดปุ่ม
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF9340FF),
                        Color(0xFF34BDFA),
                      ],
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  GradientTextAlign(
                    '"ยืนยันลบบัญชี" ด้านล่าง', //"ยืนยันลบบัญชี" ด้านล่าง
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF9340FF),
                        Color(0xFF34BDFA),
                      ],
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            GradientTextButton(
              text: 'ยกเลิก',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConfirmDeleteAccountScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  side: const BorderSide(color: Color(0xFFCCCCCC)),
                ),
                elevation: 0,
              ),
              child: Center(
                child: Text(
                  'ยืนยันลบบัญชี',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: kDark,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
