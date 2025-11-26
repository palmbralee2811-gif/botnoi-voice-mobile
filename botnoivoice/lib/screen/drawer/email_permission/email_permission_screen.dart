// import 'package:botnoivoice/shared/style/style.dart';
// import 'package:botnoivoice/service/email/check_user_is_show_email.dart';
// import 'package:botnoivoice/screen/appbar/appbar_template.dart';
// import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
// import 'package:botnoivoice/shared/dialog/email_permission/disable_email_permission_dialog.dart';
// import 'package:botnoivoice/shared/dialog/email_permission/enable_email_permission_dialog.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';

// class EmailPermissionScreen extends StatelessWidget {
//   const EmailPermissionScreen({super.key});

//   void _showDialog(BuildContext context, bool showMail) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         if (showMail) {
//           return DisableEmailPermissionDialog(
//             onConfirm: () async {
//               await context
//                   .read<CheckUserIsShowEmail>()
//                   .updateUserInfoShowMail(context, false);
//             },
//             onCancel: () {},
//           );
//         } else {
//           return const EnableEmailPermissionDialog();
//         }
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBarTemplate(
//         title: 'app_drawer.security'.tr(),
//         onPressed: () {
//           // Redirect to HomeScreen
//           context.pop();
//         },
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20.w),
//         child: Consumer<CheckUserIsShowEmail>(
//           builder: (_, userInfoProvider, __) => Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 20.h),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     tr('email_permission.email_access'),
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: ResponsiveDesignOrientation.isLandscape
//                           ? 12.sp
//                           : 16.sp,
//                       color: kDark,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Text(
//                         userInfoProvider.isShowEmail
//                             ? tr('email_permission.on')
//                             : tr('email_permission.off'),
//                         style: TextStyle(
//                           fontWeight: FontWeight.w400,
//                           fontSize: ResponsiveDesignOrientation.isLandscape
//                               ? 10.sp
//                               : 14.sp,
//                           color: kDark,
//                         ),
//                       ),
//                       SizedBox(width: 8.w),
//                       GestureDetector(
//                         onTap: () {
//                           _showDialog(context, userInfoProvider.isShowEmail);
//                         },
//                         child: Container(
//                           width: ResponsiveDesignOrientation.isLandscape
//                               ? 30.w
//                               : 50.w,
//                           height: ResponsiveDesignOrientation.isLandscape
//                               ? 45.h
//                               : 30.h,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(
//                                 ResponsiveDesignOrientation.isLandscape
//                                     ? 35.r
//                                     : 20.r),
//                             gradient: LinearGradient(
//                               colors: userInfoProvider.isShowEmail
//                                   ? [
//                                       const Color(0xFF9340FF),
//                                       const Color(0xFF34BDFA)
//                                     ]
//                                   : [
//                                       Colors.grey.shade400,
//                                       Colors.grey.shade600,
//                                     ],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             ),
//                           ),
//                           child: Align(
//                             alignment: userInfoProvider.isShowEmail
//                                 ? Alignment.centerRight
//                                 : Alignment.centerLeft,
//                             child: Padding(
//                               padding: EdgeInsets.all(2.w),
//                               child: Container(
//                                 width: ResponsiveDesignOrientation.isLandscape
//                                     ? 10.w
//                                     : 24.w,
//                                 height: ResponsiveDesignOrientation.isLandscape
//                                     ? 34.h
//                                     : 24.h,
//                                 decoration: const BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(height: 8.h),
//               Text(
//                 tr('email_permission.email_access_description'),
//                 style: TextStyle(
//                   fontWeight: FontWeight.w400,
//                   fontSize:
//                       ResponsiveDesignOrientation.isLandscape ? 8.sp : 12.sp,
//                   color: kDark,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }










import 'package:botnoivoice/shared/style/style.dart';
import 'package:botnoivoice/service/email/check_user_is_show_email.dart';
import 'package:botnoivoice/screen/appbar/appbar_template.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/shared/dialog/email_permission/disable_email_permission_dialog.dart';
import 'package:botnoivoice/shared/dialog/email_permission/enable_email_permission_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart'; // **ลบออก**
import 'package:flutter_riverpod/flutter_riverpod.dart'; // **เพิ่ม Riverpod**

// class EmailPermissionScreen extends StatelessWidget { // **เปลี่ยนเป็น ConsumerWidget**
class EmailPermissionScreen extends ConsumerWidget {
  const EmailPermissionScreen({super.key});

  // เพิ่ม Ref เป็นพารามิเตอร์เพื่อให้เข้าถึง Riverpod ได้
  void _showDialog(BuildContext context, WidgetRef ref, bool showMail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (showMail) {
          return DisableEmailPermissionDialog(
            onConfirm: () async {
              // ใช้ ref.read เพื่อเข้าถึง Notifier และเรียกเมธอด
              await ref
                  .read(checkUserIsShowEmailNotifierProvider.notifier)
                  .updateUserInfoShowMail(false);
                  // ไม่จำเป็นต้องส่ง context ไปที่ service/notifier อีกต่อไป
                  // ถ้าต้องการทำ navigation หรือแสดง snackbar ให้ทำใน screen นี้
            },
            onCancel: () {},
          );
        } else {
          // หาก Enable Email Permission Dialog มีการเรียกใช้ Notifier
          // คุณจะต้องส่ง ref ไปให้ หรือแปลงเป็น ConsumerWidget/HookWidget เช่นกัน
          // ในตัวอย่างนี้จะถือว่ามันเป็นเพียง UI ธรรมดา
          return const EnableEmailPermissionDialog();
        }
      },
    );
  }

  @override
  // เพิ่ม WidgetRef ref เป็นพารามิเตอร์
  Widget build(BuildContext context, WidgetRef ref) {
    // ใช้ ref.watch เพื่อติดตามสถานะ (state) ของ Notifier
    final userInfoState = ref.watch(checkUserIsShowEmailNotifierProvider);
    final isShowEmail = userInfoState.isShowEmail; // ดึงค่า isShowEmail ออกมา

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarTemplate(
        title: 'app_drawer.security'.tr(),
        onPressed: () {
          // Redirect to HomeScreen
          context.pop();
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        // **ลบ Consumer ออก และใช้ค่าที่ watch จาก Riverpod แทน**
        // child: Consumer<CheckUserIsShowEmail>(
        //   builder: (_, userInfoProvider, __) => Column(
        child: Column(
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
                      // ใช้ isShowEmail ที่ได้จาก Riverpod state
                      isShowEmail
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
                        // ส่ง ref เข้าไปใน _showDialog
                        _showDialog(context, ref, isShowEmail);
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
                            // ใช้ isShowEmail ที่ได้จาก Riverpod state
                            colors: isShowEmail
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
                          // ใช้ isShowEmail ที่ได้จาก Riverpod state
                          alignment: isShowEmail
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
    );
  }
}