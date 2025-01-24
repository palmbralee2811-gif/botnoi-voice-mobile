import 'package:botnoivoice/presentation/screens/responsive/orientation_helper.dart';
// import 'package:botnoivoice/presentation/widgets/button/reusable_coupon_container.dart';
import 'package:flutter/material.dart';
import 'package:botnoivoice/presentation/widgets/button/coupon_redeem_button.dart';
import 'package:easy_localization/easy_localization.dart';

class TestCoupon extends StatefulWidget {
  const TestCoupon({super.key});

  @override
  State<TestCoupon> createState() => _TestCouponState();
}

class _TestCouponState extends State<TestCoupon> {
  @override
  Widget build(BuildContext context) {
    String thaiDate = '01 มกราคม 2564';
    String currentDate = '01 January 2021';
    int points = 100;
    int timeout = 12;

    final bool isTablet = MediaQuery.of(context).size.width > 600;
    final bool isLandscape = OrientationHelper.isLandscape;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Coupon Redeem'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'redeem.daily_coupon_title'.tr(namedArgs: {'thaiDate': thaiDate}),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: isTablet ? (isLandscape ? 48 : 40) : 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'redeem.time'.tr(namedArgs: {'currentDate': currentDate}),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: isTablet ? (isLandscape ? 28 : 30) : 16,
                ),
              ),
              const SizedBox(height: 40),
              CouponRedeemButton(
                text:  'redeem.get_points'.tr(namedArgs: {'points': points.toString()}),
                text2: 'Click Here',
                text3: 'redeem.time_remaining'.tr(namedArgs: {'Timeout': timeout.toString()}),
                textColor: Colors.black,
                textColor2: Colors.blue[700]!,
                textColor3: Colors.red,
                points: points,
                timeout: timeout,
                onTap: () {
                  // Handle tap action
                  print('Coupon 1 tapped');
                },
              ),
              const SizedBox(height: 20),
              const Divider(
              color: Colors.grey, // Set the color of the divider
              thickness: 1, // Set the thickness of the divider
              indent: 20, // Set the left indent
              endIndent: 20, // Set the right indent
            ),
              const SizedBox(height: 20),
              CouponRedeemButton(
                text: 'Welcome Mobile Bonus',
                text2: 'รับเลย 1000 พอยท์',
                text3: 'redeem.time_remaining'.tr(namedArgs: {'Timeout': timeout.toString()}),
                textColor: Colors.black,
                textColor2: Colors.green,
                textColor3: Colors.red,
                points: points,
                timeout: timeout,
                onTap: () {
                  // Handle tap action
                  print('Coupon 2 tapped');
                },
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
