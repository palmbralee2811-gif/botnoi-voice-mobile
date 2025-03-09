import 'package:botnoivoice/ui/style/style.dart';
import 'package:botnoivoice/service/email/check_user_is_show_email.dart';
import 'package:botnoivoice/ui/screen/appbar/appbar_template.dart';
import 'package:botnoivoice/ui/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/ui/dialog/email_permission/disable_email_permission_dialog.dart';
import 'package:botnoivoice/ui/dialog/email_permission/enable_email_permission_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class EmailPermissionScreen extends StatelessWidget {
  const EmailPermissionScreen({super.key});

  void _showDialog(BuildContext context, bool showMail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (showMail) {
          return DisableEmailPermissionDialog(
            onConfirm: () async {
              await Provider.of<CheckUserIsShowEmail>(context, listen: false)
                  .updateUserInfoShowMail(context, false);
            },
            onCancel: () {},
          );
        } else {
          return const EnableEmailPermissionDialog();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarTemplate(title: 'app_drawer.security'.tr()),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Consumer<CheckUserIsShowEmail>(
          builder: (_, userInfoProvider, __) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tr('email_permission.email_access'),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: ResponsiveDesignOrientation.isLandscape
                          ? 12.sp
                          : 16.sp,
                      color: kDark,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        userInfoProvider.isShowEmail
                            ? tr('email_permission.on')
                            : tr('email_permission.off'),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: ResponsiveDesignOrientation.isLandscape
                              ? 10.sp
                              : 14.sp,
                          color: kDark,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: () {
                          _showDialog(context, userInfoProvider.isShowEmail);
                        },
                        child: Container(
                          width: ResponsiveDesignOrientation.isLandscape
                              ? 30.w
                              : 50.w,
                          height: ResponsiveDesignOrientation.isLandscape
                              ? 45.h
                              : 30.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                ResponsiveDesignOrientation.isLandscape
                                    ? 35.r
                                    : 20.r),
                            gradient: LinearGradient(
                              colors: userInfoProvider.isShowEmail
                                  ? [
                                      const Color(0xFF9340FF),
                                      const Color(0xFF34BDFA)
                                    ]
                                  : [
                                      Colors.grey.shade400,
                                      Colors.grey.shade600,
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Align(
                            alignment: userInfoProvider.isShowEmail
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.all(2.w),
                              child: Container(
                                width: ResponsiveDesignOrientation.isLandscape
                                    ? 10.w
                                    : 24.w,
                                height: ResponsiveDesignOrientation.isLandscape
                                    ? 34.h
                                    : 24.h,
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
                tr('email_permission.email_access_description'),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize:
                      ResponsiveDesignOrientation.isLandscape ? 8.sp : 12.sp,
                  color: kDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
