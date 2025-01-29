import 'package:botnoivoice/presentation/providers/payment/payment_provider.dart';
import 'package:botnoivoice/presentation/providers/credits/call_load_credits_api.dart';
import 'package:botnoivoice/presentation/screens/responsive/orientation_helper.dart';
import 'package:botnoivoice/presentation/widgets/dialog/notification/notification_dialog.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

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
    final applePaymentProvider = Provider.of<PaymentProvider>(context);

    return applePaymentProvider.isLoading
        ? Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Padding(
            padding: EdgeInsets.all(OrientationHelper.isLandscape ? 8.w : 16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'payment.buy_points'.tr(), //ซื้อพ้อยท์
                      style: TextStyle(
                        fontSize: OrientationHelper.isLandscape ? 12.sp : 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        size: OrientationHelper.isLandscape ? 16.sp : 24.sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Text(
                  "${'payment.price'.tr()} ${'payment.currency'.tr()}", //บาท , ${product.price}
                  style: TextStyle(
                    fontSize: OrientationHelper.isLandscape ? 25.sp : 45.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/logo/credit-icon.svg',
                      width: OrientationHelper.isLandscape ? 44.w : 24.w,
                      height: OrientationHelper.isLandscape ? 44.h : 24.h,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'payment.get_points'.tr(namedArgs: {
                        'productTitle': '5,000'
                      }), //ได้ ${product.title} พ้อยท์
                      style: TextStyle(
                        fontSize: OrientationHelper.isLandscape ? 13.sp : 22.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
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
                SizedBox(height: OrientationHelper.isLandscape ? 10.h : 20.h),
              ],
            ),
          );
  }

  Future<void> _handlePurchase(BuildContext context) async {
    final paymentProvider =
        Provider.of<PaymentProvider>(context, listen: false);

    try {
      //TODO: Don't remove this line
      await paymentProvider.handlePurchase();

      if (paymentProvider.errorMessage == null) {
        await callLoadCreditsApi(context);
        NotificationDialog(
          context: context,
          text: 'payment.received_points'.tr(namedArgs: {
            'pointsTitle': '5,000'
          }), //ได้รับพ้อยท์จำนวน $title พ้อยท์
          onPressed: () async {
            /// Refresh Points After In-App Purchase: IAP
            await callLoadCreditsApi(context);
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
      await callLoadCreditsApi(context);
    }
  }
}
