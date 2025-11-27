// import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
// import 'package:botnoivoice/service/redeem_coupon/redeem_coupon_service.dart';
// import 'package:botnoivoice/shared/dialog/redeem_coupon/redeem_success_dialog.dart';
// import 'package:botnoivoice/shared/function/call_reload_data.dart';
// import 'package:botnoivoice/shared/widget/gradient/gradient_loading_button.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';

// /// Alert Modal for displaying messages
// class RedeemCouponDialog {
//   RedeemCouponDialog({
//     required this.context,
//     required this.ref,
//     required this.text,
//     this.onPressed, // กำหนด onPressed เป็น optional
//   });

//   final String text;
//   final BuildContext context;
//   final WidgetRef ref;
//   final VoidCallback? onPressed;

//   /// Loading state
//   bool _isLoading = false;

//   /// Controller for the coupon input field
//   final TextEditingController _couponInputController = TextEditingController();

//   /// ฟังก์ชันที่ใช้สร้าง UI ของ modal
//   void _showModal({
//     required BuildContext context,
//     required bool barrierDismissible,
//     VoidCallback? onPressed,
//   }) {
//     // Defer reset until after build
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final redeemServiceProvider = context.read<RedeemCouponService>();
//       redeemServiceProvider.resetErrorMessage();
//     });

//     showDialog(
//       context: context,
//       barrierDismissible: barrierDismissible,
//       builder: (BuildContext context) {
//         // Get data from provider
//         final redeemServiceProvider = context.watch<RedeemCouponService>();
//         final creditsProvider = context.read<CallReloadData>();

//         return StatefulBuilder(
//           builder: (BuildContext context, StateSetter setState) {
//             Widget content = Column(
//               mainAxisSize: MainAxisSize
//                   .min, // Ensures the column takes only the space it needs
//               children: [
//                 Text(
//                   'redeem_coupon_dialog.title'.tr(),
//                   style: TextStyle(
//                     fontSize:
//                         ResponsiveDesignOrientation.isLandscape ? 16.sp : 20.sp,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 16.h),
//                 TextFormField(
//                   controller: _couponInputController,
//                   style: TextStyle(
//                     fontSize:
//                         ResponsiveDesignOrientation.isLandscape ? 11.sp : 16.sp,
//                     fontWeight: FontWeight.w400,
//                   ),
//                   decoration: InputDecoration(
//                     enabled: _isLoading ? false : true,
//                     labelText: 'redeem_coupon_dialog.input'
//                         .tr(), // ชื่อผู้ใช้งานหรืออีเมล
//                     labelStyle: TextStyle(
//                       fontSize: ResponsiveDesignOrientation.isLandscape
//                           ? 11.sp
//                           : 16.sp,
//                       fontWeight: FontWeight.w400,
//                     ),
//                     fillColor: Colors.white,
//                     filled: true,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12.r),
//                       borderSide: const BorderSide(
//                         color: Colors.grey, // สีของเส้นขอบ
//                         width: 1.0, // ความหนาของเส้นขอบ
//                       ),
//                     ),
//                     errorStyle: TextStyle(
//                       fontSize: ResponsiveDesignOrientation.isLandscape
//                           ? 10.sp
//                           : 14.sp,
//                     ),
//                     errorMaxLines: 5,
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         null,
//                         size: ResponsiveDesignOrientation.isLandscape
//                             ? 16.w
//                             : 24.w,
//                       ),
//                       onPressed: null,
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'redeem_coupon_dialog.input'.tr(); // กรอก coupon
//                     }
//                     return null;
//                   },
//                 ),
//                 if (redeemServiceProvider.errorMessage != null) ...[
//                   SizedBox(height: 8.h),
//                   Text(
//                     redeemServiceProvider.errorMessage!,
//                     style: TextStyle(
//                       fontSize: ResponsiveDesignOrientation.isLandscape
//                           ? 8.sp
//                           : 12.sp,
//                       color: Colors.red,
//                     ),
//                     textAlign: TextAlign.left,
//                   ),
//                 ],
//                 SizedBox(
//                     height:
//                         ResponsiveDesignOrientation.isLandscape ? 56.h : 20.h),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 30.w),
//                   child: GradientLoadingButton(
//                     text: 'redeem_coupon_dialog.use'.tr(), // ใช้ Coupon
//                     isLoading: _isLoading,
//                     onPressed: () async {
//                       setState(() {
//                         _isLoading = true;
//                       });
//                       final result = await redeemServiceProvider.redeemCoupon(
//                         context,
//                         _couponInputController.text,
//                         ref,
//                       );
//                       if (result == null) {
//                         await creditsProvider.callLoadCreditsApi(context);
//                       }
//                       setState(() {
//                         _isLoading = false;
//                       });
//                       if (result == null) {
//                         // Close This Notification Dialog
//                         context.pop();

//                         //Notify success
//                         RedeemSuccessDialog(
//                                 context: context,
//                                 text: 'redeem_coupon_dialog.success'.tr(
//                                     namedArgs: {
//                                       'coupon_name': _couponInputController.text
//                                     }),
//                                 couponName: _couponInputController.text)
//                             .showCheckmarkModal(context);
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             );

//             // Get screen width
//             final screenWidth = MediaQuery.of(context).size.width;

//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16.r),
//               ),
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(
//                   maxWidth: screenWidth > 600
//                       ? 235.sp
//                       : screenWidth *
//                           0.9, // Use 90% of screen width if less than 600
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.all(24.r),
//                   child: SingleChildScrollView(
//                     child: content,
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   /// Modal  Show
//   void showModal(BuildContext context) {
//     _showModal(
//       context: context,
//       barrierDismissible: true,
//       onPressed: onPressed,
//     );
//   }
// }



















import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/service/redeem_coupon/redeem_coupon_service.dart';
import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:botnoivoice/shared/dialog/redeem_coupon/redeem_success_dialog.dart';
import 'package:botnoivoice/shared/widget/gradient/gradient_loading_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Alert Modal for displaying messages
class RedeemCouponDialog {
  RedeemCouponDialog({
    required this.context,
    required this.ref,
    required this.text,
    this.onPressed, // กำหนด onPressed เป็น optional
  });

  final String text;
  final BuildContext context;
  final WidgetRef ref;
  final VoidCallback? onPressed;

  /// Loading state
  bool _isLoading = false;

  /// Controller for the coupon input field
  final TextEditingController _couponInputController = TextEditingController();

  /// ฟังก์ชันที่ใช้สร้าง UI ของ modal
  void _showModal({
    required BuildContext context,
    required bool barrierDismissible,
    VoidCallback? onPressed,
  }) {
    // Defer reset until after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final redeemServiceProvider = context.read<RedeemCouponService>();
      redeemServiceProvider.resetErrorMessage();
    });

    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        // Get data from provider
        // final redeemServiceProvider = context.watch<RedeemCouponService>();
        final redeemServiceProvider = ref.watch(redeemCouponServiceProvider);
        final redeemServiceNotifier = ref.watch(redeemCouponServiceProvider.notifier);

        final creditsProvider = loadAllTokensIfLoggedIn(ref);

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            Widget content = Column(
              mainAxisSize: MainAxisSize
                  .min, // Ensures the column takes only the space it needs
              children: [
                Text(
                  'redeem_coupon_dialog.title'.tr(),
                  style: TextStyle(
                    fontSize:
                        ResponsiveDesignOrientation.isLandscape ? 16.sp : 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: _couponInputController,
                  style: TextStyle(
                    fontSize:
                        ResponsiveDesignOrientation.isLandscape ? 11.sp : 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    enabled: _isLoading ? false : true,
                    labelText: 'redeem_coupon_dialog.input'
                        .tr(), // ชื่อผู้ใช้งานหรืออีเมล
                    labelStyle: TextStyle(
                      fontSize: ResponsiveDesignOrientation.isLandscape
                          ? 11.sp
                          : 16.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(
                        color: Colors.grey, // สีของเส้นขอบ
                        width: 1.0, // ความหนาของเส้นขอบ
                      ),
                    ),
                    errorStyle: TextStyle(
                      fontSize: ResponsiveDesignOrientation.isLandscape
                          ? 10.sp
                          : 14.sp,
                    ),
                    errorMaxLines: 5,
                    suffixIcon: IconButton(
                      icon: Icon(
                        null,
                        size: ResponsiveDesignOrientation.isLandscape
                            ? 16.w
                            : 24.w,
                      ),
                      onPressed: null,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'redeem_coupon_dialog.input'.tr(); // กรอก coupon
                    }
                    return null;
                  },
                ),
                if (redeemServiceProvider.errorMessage != null) ...[
                  SizedBox(height: 8.h),
                  Text(
                    redeemServiceProvider.errorMessage!,
                    style: TextStyle(
                      fontSize: ResponsiveDesignOrientation.isLandscape
                          ? 8.sp
                          : 12.sp,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
                SizedBox(
                    height:
                        ResponsiveDesignOrientation.isLandscape ? 56.h : 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: GradientLoadingButton(
                    text: 'redeem_coupon_dialog.use'.tr(), // ใช้ Coupon
                    isLoading: _isLoading,
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      final result = await redeemServiceNotifier.redeemCoupon(
                        context,
                        _couponInputController.text,
                        ref,
                      );
                      if (result == null) {
                        await creditsProvider;
                      }
                      setState(() {
                        _isLoading = false;
                      });
                      if (result == null) {
                        // Close This Notification Dialog
                        context.pop();

                        //Notify success
                        RedeemSuccessDialog(
                                context: context,
                                text: 'redeem_coupon_dialog.success'.tr(
                                    namedArgs: {
                                      'coupon_name': _couponInputController.text
                                    }),
                                couponName: _couponInputController.text)
                            .showCheckmarkModal(context);
                      }
                    },
                  ),
                ),
              ],
            );

            // Get screen width
            final screenWidth = MediaQuery.of(context).size.width;

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: screenWidth > 600
                      ? 235.sp
                      : screenWidth *
                          0.9, // Use 90% of screen width if less than 600
                ),
                child: Padding(
                  padding: EdgeInsets.all(24.r),
                  child: SingleChildScrollView(
                    child: content,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Modal  Show
  void showModal(BuildContext context) {
    _showModal(
      context: context,
      barrierDismissible: true,
      onPressed: onPressed,
    );
  }
}
