import 'package:botnoivoice/presentation/constants/color.dart';
import 'package:botnoivoice/presentation/widgets/dialog/email_permission/disable_email_permission_dialog.dart';
import 'package:botnoivoice/presentation/widgets/dialog/email_permission/enable_email_permission_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmailPermissionScreen extends StatefulWidget {
  const EmailPermissionScreen({super.key});

  @override
  State<EmailPermissionScreen> createState() => _EmailPermissionScreenState();
}

class _EmailPermissionScreenState extends State<EmailPermissionScreen> {
  bool isEmailAccessEnabled = true; // Initial state for the switch

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return isEmailAccessEnabled
            ? const EnableEmailPermissionDialog()
            : DisableEmailPermissionDialog(
                onConfirm: () {
                  //TODO: Disable Forget Password with Email
                },
                onCancel: () {
                  setState(() {
                    isEmailAccessEnabled = true; // Reset toggle to true
                  });
                },
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'app_drawer.security'.tr(),
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
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'app_drawer.email_access'.tr(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: kDark,
                  ),
                  textAlign: TextAlign.left,
                ),
                Row(
                  children: [
                    Text(
                      isEmailAccessEnabled ? 'app_drawer.on'.tr() : 'app_drawer.off'.tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                        color: kDark,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isEmailAccessEnabled = !isEmailAccessEnabled;
                        });
                        _showDialog(context);
                        //TODO: Call API (UPDATE) method to enable Forget Password with Email
                      },
                      child: Container(
                        width: 50.w,
                        height: 30.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          gradient: isEmailAccessEnabled
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF9340FF),
                                    Color(0xFF34BDFA)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : LinearGradient(
                                  colors: [
                                    Colors.grey.shade400,
                                    Colors.grey.shade600
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                        ),
                        child: Align(
                          alignment: isEmailAccessEnabled
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.all(2.w),
                            child: Container(
                              width: 24.w,
                              height: 24.h,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              'app_drawer.email_access_description'.tr(), 
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                color: kDark,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
