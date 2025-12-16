import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:botnoivoice/service/payment/payment_service.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/shared/dialog/notification/notification_dialog.dart';
import 'package:botnoivoice/shared/widget/gradient/gradient_text_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // 1. เพิ่ม import intl

void showPaymentDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (context) {
      return SafeArea(
        child: _PaymentBottomSheetContent(),
      );
    },
  );
}

class _PaymentBottomSheetContent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Read PaymentState from paymentServiceProvider
    final paymentState = ref.watch(paymentServiceProvider);

    // 2. Read UserTokenState
    final userTokenState = ref.watch(currentUserTokenStateProvider);

    final normalCredits = userTokenState.remainingNormalCredits ?? 0;
    final monthlyPoints = userTokenState.remainingMonthlyPoints ?? 0;

    // 2. สร้าง Formatter สำหรับตัวเลข
    final formatter = NumberFormat('#,###');

    return paymentState.isLoading
        ? Container(
            height: 300.h,
            width: double.infinity,
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  SizedBox(height: 16.h),
                  Text(
                    "Processing Payment & Updating Points...",
                    style: TextStyle(
                      fontSize: ResponsiveDesignOrientation.isLandscape ? 10.sp : 14.sp,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Padding(
            padding: EdgeInsets.all(
                ResponsiveDesignOrientation.isLandscape ? 8.w : 16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'payment.normal_points'.tr(),
                            style: TextStyle(
                                fontSize:
                                    ResponsiveDesignOrientation.isLandscape
                                        ? 11.sp
                                        : 15.sp),
                          ),
                          // 3. ใช้ formatter.format()
                          Text(
                            formatter.format(normalCredits), 
                            style: TextStyle(
                                fontSize:
                                    ResponsiveDesignOrientation.isLandscape
                                        ? 11.sp
                                        : 15.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'payment.monthly_points'.tr(),
                            style: TextStyle(
                                fontSize:
                                    ResponsiveDesignOrientation.isLandscape
                                        ? 11.sp
                                        : 15.sp),
                          ),
                          // 3. ใช้ formatter.format()
                          Text(
                            formatter.format(monthlyPoints),
                            style: TextStyle(
                                fontSize:
                                    ResponsiveDesignOrientation.isLandscape
                                        ? 11.sp
                                        : 15.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "${'payment.price'.tr()} ${'payment.currency'.tr()}",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/logo/credit-icon.svg',
                      width:
                          ResponsiveDesignOrientation.isLandscape ? 44.w : 24.w,
                      height:
                          ResponsiveDesignOrientation.isLandscape ? 44.h : 24.h,
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'payment.get_points'
                              .tr(namedArgs: {'productTitle': '5,000'}),
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
                GradientTextButton(
                  text: 'payment.buy_now'.tr(),
                  onPressed: () async {
                    await _handlePurchase(context, ref);
                  },
                ),
                SizedBox(
                    height:
                        ResponsiveDesignOrientation.isLandscape ? 10.h : 20.h),
              ],
            ),
          );
  }

  Future<void> _handlePurchase(BuildContext context, WidgetRef ref) async {
    final paymentServiceNotifier = ref.read(paymentServiceProvider.notifier);

    // 1. Reset previous error status before starting
    paymentServiceNotifier.resetStatus();

    // 2. Snapshot current points before purchase
    final initialTokenState = ref.read(currentUserTokenStateProvider);
    final int initialTotalPoints = (initialTokenState.remainingNormalCredits ?? 0) +
        (initialTokenState.remainingMonthlyPoints ?? 0);

    try {
      // 3. Call purchase method (Service will keep isLoading = true if successful)
      await paymentServiceNotifier.handlePurchase();

      // 4. Check result
      final resultState = ref.read(paymentServiceProvider);

      if (resultState.errorMessage == null) {
        // --- Success Case ---
        
        // Polling loop to wait for points update
        int retryCount = 0;
        const int maxRetries = 20; // Try for approx 40 seconds
        const int delaySeconds = 2;

        while (retryCount < maxRetries) {
          // Reload tokens
          await loadAllTokensIfLoggedIn(ref);

          // Check new points
          final currentTokenState = ref.read(currentUserTokenStateProvider);
          final int currentTotalPoints = (currentTokenState.remainingNormalCredits ?? 0) +
              (currentTokenState.remainingMonthlyPoints ?? 0);

          // Break if points have increased
          if (currentTotalPoints > initialTotalPoints) {
            break;
          }

          retryCount++;
          if (retryCount < maxRetries) {
            await Future.delayed(const Duration(seconds: delaySeconds));
          }
        }

        // 5. Stop loading manually
        paymentServiceNotifier.setLoading(false);

        if (context.mounted) {
          // 6. Show Success Dialog
          NotificationDialog(
            context: context,
            text: 'payment.received_points'
                .tr(namedArgs: {'pointsTitle': '5,000'}),
            onPressed: () {
               context.pop(); // Close the payment sheet
            },
          ).showCheckmarkModalWithAction(context);
        }
      } else {
        // --- Error Case (Purchase Failed / Cancelled) ---
        // Service sets isLoading = false automatically on error
        
        if (context.mounted) {
          NotificationDialog(
            context: context,
            text: resultState.errorMessage!,
            onPressed: () {
               // Clear error status when closing dialog
               ref.read(paymentServiceProvider.notifier).resetStatus();
            },
          ).showErrorModal(context);
        }
      }
    } catch (e) {
      // General Exception
      paymentServiceNotifier.setLoading(false);
      
      if (context.mounted) {
        NotificationDialog(
          context: context,
          text: "${'payment.error_occurred'.tr()} $e",
          onPressed: () {
             // Clear error status when closing dialog
             ref.read(paymentServiceProvider.notifier).resetStatus();
          },
        ).showErrorModal(context);
      }
    }
  }
}