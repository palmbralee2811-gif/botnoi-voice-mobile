import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/service/login/google_login.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:botnoivoice/service/token/apple_token.dart';
import 'package:botnoivoice/service/token/google_token.dart';
import 'package:botnoivoice/service/token/line_token.dart';
import 'package:botnoivoice/service/token/email_token.dart';
import 'package:botnoivoice/shared/function/call_reload_data.dart';
import 'package:botnoivoice/service/payment/payment_service.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/shared/dialog/notification/notification_dialog.dart';
import 'package:botnoivoice/shared/widget/gradient/gradient_text_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void showPaymentDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (context) {
      return SafeArea(
        child: const _PaymentBottomSheetContent(),
      );
    },
  );
}

class _PaymentBottomSheetContent extends StatelessWidget {
  const _PaymentBottomSheetContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paymentProvider = context.watch<PaymentService>();
    
    // Calculate Credits based on active login provider
    final Map<String, int> currentPoints = _getCurrentPoints(context);
    final int normalCredits = currentPoints['normal'] ?? 0;
    final int monthlyPoints = currentPoints['monthly'] ?? 0;

    return paymentProvider.isLoading
        ? Container(
            height: 300.h, // Fixed height to prevent collapse during loading
            color: Colors.white, // Ensure visibility
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Padding(
            padding: EdgeInsets.all(
                ResponsiveDesignOrientation.isLandscape ? 8.w : 16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // --- Header ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'payment.buy_points'.tr(),
                      style: TextStyle(
                        fontSize: ResponsiveDesignOrientation.isLandscape
                            ? 12.sp
                            : 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(
                      onTap: () => context.pop(),
                      child: Icon(
                        Icons.close,
                        size: ResponsiveDesignOrientation.isLandscape
                            ? 16.sp
                            : 24.sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                
                // --- Current Credits Display ---
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPointRow('payment.normal_points'.tr(), normalCredits),
                      SizedBox(height: 4.h),
                      _buildPointRow('payment.monthly_points'.tr(), monthlyPoints),
                    ],
                  ),
                ),
                
                SizedBox(height: 10.h),
                
                // --- Price Display ---
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "${'payment.price'.tr()} ${'payment.currency'.tr()}", 
                      // TODO: Replace with dynamic price e.g. "${product.price}"
                      style: TextStyle(
                        fontSize: ResponsiveDesignOrientation.isLandscape
                            ? 25.sp
                            : 45.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                
                // --- Package Details ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/logo/credit-icon.svg',
                      width: ResponsiveDesignOrientation.isLandscape ? 44.w : 24.w,
                      height: ResponsiveDesignOrientation.isLandscape ? 44.h : 24.h,
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'payment.get_points'.tr(namedArgs: {
                            'productTitle': '5,000' // TODO: dynamic value
                          }), 
                          style: TextStyle(
                            fontSize: ResponsiveDesignOrientation.isLandscape
                                ? 13.sp
                                : 22.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                
                // --- Action Button ---
                GradientTextButton(
                  text: 'payment.buy_now'.tr(),
                  onPressed: () async {
                    await _handlePurchase(context);
                  },
                ),
                SizedBox(
                    height: ResponsiveDesignOrientation.isLandscape ? 10.h : 20.h),
              ],
            ),
          );
  }

  /// Helper widget for Point Rows to reduce duplication
  Widget _buildPointRow(String label, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveDesignOrientation.isLandscape ? 11.sp : 15.sp,
          ),
        ),
        Text(
          NumberFormat('#,###').format(value), // Added number formatting
          style: TextStyle(
            fontSize: ResponsiveDesignOrientation.isLandscape ? 11.sp : 15.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Extracts current points based on the active login provider
  Map<String, int> _getCurrentPoints(BuildContext context) {
    final appleProvider = context.read<AppleLogin>();
    final googleProvider = context.read<GoogleLogin>();
    final lineProvider = context.read<LineLogin>();
    final emailProvider = context.read<EmailLogin>();

    // Note: Using read() inside the logic function, but the build method 
    // should watch the specific token providers if you want real-time updates 
    // when the balance changes without reopening the modal.
    // Assuming context.watch was done correctly in the parent or providers notify listeners.
    
    int normal = 0;
    int monthly = 0;

    if (appleProvider.isLoggedIn) {
      final token = context.watch<AppleToken>();
      normal = token.getRemainingNormalCredits ?? 0;
      monthly = token.getRemainingMonthlyPoints ?? 0;
    } else if (googleProvider.isLoggedIn) {
      final token = context.watch<GoogleToken>();
      normal = token.getRemainingNormalCredits ?? 0;
      monthly = token.getRemainingMonthlyPoints ?? 0;
    } else if (lineProvider.isLoggedIn) {
      final token = context.watch<LineToken>();
      normal = token.getRemainingNormalCredits ?? 0;
      monthly = token.getRemainingMonthlyPoints ?? 0;
    } else if (emailProvider.isLoggedIn) {
      final token = context.watch<EmailToken>();
      normal = token.getRemainingNormalCredits ?? 0;
      monthly = token.getRemainingMonthlyPoints ?? 0;
    }

    return {'normal': normal, 'monthly': monthly};
  }

  Future<void> _handlePurchase(BuildContext context) async {
    final paymentProvider = context.read<PaymentService>();
    final creditsProvider = context.read<CallReloadData>();

    try {
      await paymentProvider.handlePurchase();

      if (paymentProvider.errorMessage == null) {
        // Success Logic
        await creditsProvider.callLoadCreditsApi(context);
        
        if (context.mounted) {
           NotificationDialog(
            context: context,
            text: 'payment.received_points'.tr(namedArgs: {
              'pointsTitle': '5,000'
            }), 
            onPressed: () async {
              if(context.mounted) {
                await creditsProvider.callLoadCreditsApi(context);
                context.pop(); // Close dialog on success confirmation
              }
            },
          ).showCheckmarkModalWithAction(context);
        }
      } else {
        // Error Logic (Business Logic Error)
        if (context.mounted) {
          NotificationDialog(
            context: context,
            text: paymentProvider.errorMessage!,
            onPressed: () {},
          ).showErrorModal(context);
        }
      }
    } catch (e) {
      // Exception Logic
      if (context.mounted) {
        NotificationDialog(
          context: context,
          text: "${'payment.error_occurred'.tr()} $e",
          onPressed: () {},
        ).showErrorModal(context);
      }
    } finally {
      // Ensure data is consistent
      if(context.mounted) {
        await creditsProvider.callLoadCreditsApi(context);
      }
    }
  }
}