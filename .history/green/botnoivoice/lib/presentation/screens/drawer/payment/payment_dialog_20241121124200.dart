import 'package:botnoivoice/data/models/apple_product_model.dart';
import 'package:botnoivoice/domain/entities/apple_product_entity.dart';
import 'package:botnoivoice/presentation/providers/payment/payment_provider.dart';
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
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'app_drawer.buy_points'.tr(), //ซื้อพ้อยท์
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.close,
                  size: 24.sp,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            "${product.price} ${'app_drawer.baht'.tr()}", //บาท
            style: TextStyle(
              fontSize: 45.sp,
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
                'app_drawer.get_points'.tr(namedArgs: {'productTitle': product.title}), //ได้ ${product.title} พ้อยท์
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
            text: 'app_drawer.buy_now'.tr(), //ซื้อตอนนี้
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
        NotificationDialog(
          context: context,
          text: 'app_drawer.received_points'.tr(namedArgs: {'pointsTitle': title}), //ได้รับพ้อยท์จำนวน $title พ้อยท์
          onPressed: () {},
        ).showCheckmarkModal(context);
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
        text: "เกิดข้อผิดพลาด: $e", //เกิดข้อผิดพลาด
        onPressed: () {},
      ).showErrorModal(context);
    }
  }
}
