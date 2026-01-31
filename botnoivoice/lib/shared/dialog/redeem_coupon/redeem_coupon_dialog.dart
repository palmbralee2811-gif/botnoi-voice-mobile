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

/// Alert Modal for displaying messages
class RedeemCouponDialog {
  RedeemCouponDialog({
    required this.context,
    required this.ref, // Receive ref from the parent widget
    required this.text,
    this.onPressed,
  });

  final String text;
  final BuildContext context;
  final WidgetRef ref;
  final VoidCallback? onPressed;

  /// Controller for the coupon input field
  final TextEditingController _couponInputController = TextEditingController();

  /// Function to show the modal UI
  void _showModal({
    required BuildContext context,
    required bool barrierDismissible,
    VoidCallback? onPressed,
  }) {
    // Correct way to access the Notifier method in Riverpod
    // Reset error message before showing the dialog
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(redeemCouponServiceProvider.notifier).resetErrorMessage();
    });

    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        // Use Consumer to listen to provider changes within the Dialog
        return Consumer(
          builder: (context, ref, child) {
            // Watch the State (for isLoading, errorMessage)
            final redeemCouponState = ref.watch(redeemCouponServiceProvider);
            // Read the Notifier (for calling functions)
            final redeemCouponNotifier = ref.read(redeemCouponServiceProvider.notifier);

            Widget content = Column(
              mainAxisSize: MainAxisSize.min,
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
                    // Use isLoading from Riverpod state
                    enabled: !redeemCouponState.isLoading,
                    labelText: 'redeem_coupon_dialog.input'.tr(),
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
                        color: Colors.grey,
                        width: 1.0,
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
                      return 'redeem_coupon_dialog.input'.tr();
                    }
                    return null;
                  },
                ),
                // Display error message from Riverpod state
                if (redeemCouponState.errorMessage != null) ...[
                  SizedBox(height: 8.h),
                  Text(
                    redeemCouponState.errorMessage!,
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
                    text: 'redeem_coupon_dialog.use'.tr(),
                    // Bind isLoading directly to the service state
                    isLoading: redeemCouponState.isLoading,
                    onPressed: () async {
                      // Call the function via Notifier
                      final result = await redeemCouponNotifier.redeemCoupon(
                        context,
                        _couponInputController.text,
                        ref,
                      );

                      if (result == null) {
                        // Success case: Reload tokens/credits
                        await loadAllTokensIfLoggedIn(ref);

                        // Close the dialog
                        if (context.mounted) {
                          context.pop();
                        }

                        // Show Success Dialog
                        if (context.mounted) {
                          RedeemSuccessDialog(
                            context: context,
                            text: 'redeem_coupon_dialog.success'.tr(
                                namedArgs: {
                                  'coupon_name': _couponInputController.text
                                }),
                            couponName: _couponInputController.text,
                          ).showCheckmarkModal(context);
                        }
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
                      : screenWidth * 0.9,
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

  /// Modal Show
  void showModal(BuildContext context) {
    _showModal(
      context: context,
      barrierDismissible: true,
      onPressed: onPressed,
    );
  }
}