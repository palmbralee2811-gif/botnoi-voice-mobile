import 'package:botnoivoice/presentation/constants/styles.dart';
import 'package:botnoivoice/presentation/screens/drawer/account/confirm_delete_account_screen.dart';
import 'package:botnoivoice/presentation/screens/responsive/orientation_helper.dart';
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
          'delete_account.delete_account'.tr(), //ลบบัญชี
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: OrientationHelper.isLandscape ? 12.sp : 16.sp,
            color: kDark,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: kDark,
            size: OrientationHelper.isLandscape ? 10.sp : 24.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GradientTextAlign(
                'delete_account.please_read'.tr(), //โปรดอ่าน
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF9340FF),
                    Color(0xFF34BDFA),
                  ],
                ),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: OrientationHelper.isLandscape ? 16.sp : 22.sp,
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 8.h),
              GradientTextAlign(
                'delete_account.account_deletion_warning'.tr(), //การลบบัญชีเป็นการกระทำที่ไม่สามารถย้อนกลับได้ คุณจะไม่สามารถใช้บัญชีนี้กับผลิตภัณฑ์และบริการ พ้อยท์คงเหลือหรือแพ็คเกจที่สมัคร สิทธิพิเศษและโปรโมชั่นที่ได้รับอีกต่อไป โปรดระมัดระวัง
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF9340FF),
                    Color(0xFF34BDFA),
                  ],
                ),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: OrientationHelper.isLandscape ? 10.sp : 14.sp,
                  decoration: TextDecoration.none,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 16.h),
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              Center(
                child: Column(
                  children: [
                    GradientTextAlign(
                      'delete_account.confirm_account_deletion'.tr(), //หากยืนยันที่จะลบบัญชีต่อ กรุณากดปุ่ม
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF9340FF),
                          Color(0xFF34BDFA),
                        ],
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: OrientationHelper.isLandscape ? 10.sp : 14.sp,
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    GradientTextAlign(
                      'delete_account.confirm_account_deletion_below'.tr(), //"ยืนยันลบบัญชี" ด้านล่าง
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF9340FF),
                          Color(0xFF34BDFA),
                        ],
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: OrientationHelper.isLandscape ? 10.sp : 14.sp,
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: OrientationHelper.isLandscape ? 16.h : 16.h),
              GradientTextButton(
                text: 'delete_account.cancel'.tr(), //ยกเลิก
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: OrientationHelper.isLandscape ? 16.h : 16.h),
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
                  padding: EdgeInsets.symmetric(vertical: OrientationHelper.isLandscape ? 6.h : 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    side: const BorderSide(color: Color(0xFFCCCCCC)),
                  ),
                  elevation: 0,
                ),
                child: Center(
                  child: Text(
                    'delete_account.confirm_account_deletion_button'.tr(),
                    style: TextStyle(
                      fontSize: OrientationHelper.isLandscape ? 13.sp : 16.sp,
                      fontWeight: FontWeight.w600,
                      color: kDark,
                    ),
                  ),
                ),
              ),
              SizedBox(height: OrientationHelper.isLandscape ? 40.h : 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
