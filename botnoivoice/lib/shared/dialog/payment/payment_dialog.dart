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

import 'package:botnoivoice/service/token/email_token.dart';

void showPaymentDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (context) {
      return _PaymentBottomSheetContent();
    },
  );
}

class _PaymentBottomSheetContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final paymentProvider = context.watch<PaymentService>();

    final emailToken = context.watch<EmailToken>();
    final normalCredits = emailToken.getRemainingNormalCredits ?? 0;
    final monthlyPoints = emailToken.getRemainingMonthlyPoints ?? 0;

    return paymentProvider.isLoading
        ? Container(
            color: Colors.black54,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'payment.buy_points'.tr(), //ซื้อพ้อยท์
                      style: TextStyle(
                        fontSize: ResponsiveDesignOrientation.isLandscape
                            ? 12.sp
                            : 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Close Payment Dialog
                        context.pop();
                      },
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
                            'payment.normal_points'.tr(), // "เครดิตปกติ"
                            style: TextStyle(
                                fontSize:
                                    ResponsiveDesignOrientation.isLandscape
                                        ? 11.sp
                                        : 15.sp),
                          ),
                          Text(
                            normalCredits.toString(),
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
                            'payment.monthly_points'.tr(), // "เครดิตรายเดือน"
                            style: TextStyle(
                                fontSize:
                                    ResponsiveDesignOrientation.isLandscape
                                        ? 11.sp
                                        : 15.sp),
                          ),
                          Text(
                            monthlyPoints.toString(),
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
                      "${'payment.price'.tr()} ${'payment.currency'.tr()}", //บาท , ${product.price}
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
                          'payment.get_points'.tr(namedArgs: {
                            'productTitle': '5,000'
                          }), //ได้ ${product.title} พ้อยท์
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
                  text: 'payment.buy_now'.tr(), //ซื้อตอนนี้
                  onPressed: () async {
                    await _handlePurchase(context);
                  },
                ),
                SizedBox(
                    height:
                        ResponsiveDesignOrientation.isLandscape ? 10.h : 20.h),
              ],
            ),
          );
  }

  Future<void> _handlePurchase(BuildContext context) async {
    final paymentProvider = context.read<PaymentService>();

    final creditsProvider = context.read<CallReloadData>();

    try {
      await paymentProvider.handlePurchase();

      if (paymentProvider.errorMessage == null) {
        await creditsProvider.callLoadCreditsApi(context);
        NotificationDialog(
          context: context,
          text: 'payment.received_points'.tr(namedArgs: {
            'pointsTitle': '5,000'
          }), //ได้รับพ้อยท์จำนวน $title พ้อยท์
          onPressed: () async {
            /// Refresh Points After In-App Purchase: IAP
            await creditsProvider.callLoadCreditsApi(context);
          },
        ).showCheckmarkModalWithAction(context);
      } else {
        NotificationDialog(
          context: context,
          text: paymentProvider.errorMessage!,
          onPressed: () {},
        ).showErrorModal(context);
      }
    } catch (e) {
      NotificationDialog(
        context: context,
        text: "${'payment.error_occurred'.tr()} $e", //เกิดข้อผิดพลาด
        onPressed: () {},
      ).showErrorModal(context);
    } finally {
      await creditsProvider.callLoadCreditsApi(context);
    }
  }
}