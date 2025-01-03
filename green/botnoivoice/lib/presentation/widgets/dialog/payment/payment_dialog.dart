import 'package:botnoivoice/data/models/apple_product_model.dart';
import 'package:botnoivoice/data/entities/apple_product_entity.dart';
import 'package:botnoivoice/presentation/providers/apple/apple_login_provider.dart';
import 'package:botnoivoice/presentation/providers/apple/apple_token_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_token_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_token_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_token_provider.dart';
import 'package:botnoivoice/presentation/providers/payment/payment_provider.dart';
import 'package:botnoivoice/presentation/screens/responsive/orientation_helper.dart';
import 'package:botnoivoice/presentation/widgets/dialog/notification_dialog.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

void showPaymentDialog(BuildContext context) {
  final appleProducts = AppleProductModel.getAppleProductData();
  final product = appleProducts.first;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (context) {
      return _PaymentBottomSheetContent(product: product);
    },
  );
}

class _PaymentBottomSheetContent extends StatelessWidget {
  final AppleProduct product;

  const _PaymentBottomSheetContent({required this.product});

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(context);

    return paymentProvider.isLoading
        ? Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Padding(
            padding: EdgeInsets.all(16.w),
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
                    fontSize: OrientationHelper.isLandscape ? 35.sp : 45.sp,
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
                      width: 24.w,
                      height: 24.h,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'payment.get_points'.tr(namedArgs: {
                        'productTitle': product.title
                      }), //ได้ ${product.title} พ้อยท์
                      style: TextStyle(
                        fontSize: 24.sp,
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
                    await _handlePurchase(context, product.title);
                  },
                ),
                SizedBox(height: 20.h),
              ],
            ),
          );
  }

  Future<void> _handlePurchase(BuildContext context, String title) async {
    final paymentProvider =
        Provider.of<PaymentProvider>(context, listen: false);

    try {
      await paymentProvider.handlePurchase(product);

      if (paymentProvider.errorMessage == null) {
        await _loadRemainingCredits(context);
        NotificationDialog(
          context: context,
          text: 'payment.received_points'.tr(namedArgs: {
            'pointsTitle': title
          }), //ได้รับพ้อยท์จำนวน $title พ้อยท์
          onPressed: () async {
            /// Refresh Points After In-App Purchase: IAP
            await _loadRemainingCredits(context);
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
      await _loadRemainingCredits(context);
    }
  }

  Future<void> _loadRemainingCredits(BuildContext context) async {
    final appleProvider =
        Provider.of<AppleLoginProvider>(context, listen: false);
    final googleProvider =
        Provider.of<GoogleLoginProvider>(context, listen: false);
    final lineProvider = Provider.of<LineLoginProvider>(context, listen: false);
    final emailProvider =
        Provider.of<EmailLoginProvider>(context, listen: false);

    if (appleProvider.isLoggedIn &&
        appleProvider.user?.providerData[0].providerId == 'apple.com') {
      await Provider.of<AppleTokenProvider>(context, listen: false)
          .loadRemainingCredits();
    }

    if (googleProvider.isLoggedIn &&
        googleProvider.user?.providerData[0].providerId == 'google.com') {
      await Provider.of<GoogleTokenProvider>(context, listen: false)
          .loadRemainingCredits();
    }

    if (lineProvider.isLoggedIn) {
      await Provider.of<LineTokenProvider>(context, listen: false)
          .loadRemainingCredits();
    }

    if (emailProvider.isLoggedIn &&
        emailProvider.user?.providerData[0].providerId == 'password') {
      await Provider.of<EmailTokenProvider>(context, listen: false)
          .loadRemainingCredits();
    }
  }
}