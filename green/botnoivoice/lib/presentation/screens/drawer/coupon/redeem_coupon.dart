import 'package:botnoivoice/presentation/providers/coupon/coupon_provider.dart';
import 'package:botnoivoice/presentation/providers/credits/call_load_credits_api.dart';
import 'package:botnoivoice/presentation/screens/drawer/coupon/time_helper.dart';
import 'package:botnoivoice/presentation/screens/responsive/orientation_helper.dart';
import 'package:botnoivoice/presentation/widgets/dialog/notification/notification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:botnoivoice/presentation/widgets/button/coupon_redeem_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class RedeemCoupon extends StatefulWidget {
  const RedeemCoupon({super.key});

  @override
  State<RedeemCoupon> createState() => _RedeemCouponState();
}

class _RedeemCouponState extends State<RedeemCoupon> {
  String? currentDate;
  String? hoursUntilMidnight;

  @override
  void initState() {
    super.initState();
    updateCurrentDate();
    updateHoursUntilMidnight();
  }

  void updateCurrentDate() {
    final currentDateInBangkok = getCurrentBangkokDate();
    setState(() {
      currentDate = currentDateInBangkok;
    });
  }

  void updateHoursUntilMidnight() {
    final durationUntilMidnight = getTimeUntilMidnightInBangkok();
    setState(() {
      hoursUntilMidnight = durationUntilMidnight.inHours.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width > 600;
    final bool isLandscape = OrientationHelper.isLandscape;

    return Scaffold(
      appBar: AppBar(
        //TODO: empty string
        title: const Text(""),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'redeem.daily_coupon_title'
                    .tr(namedArgs: {'thaiDate': currentDate ?? 'N/A'}),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: isTablet ? (isLandscape ? 48 : 40) : 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                //TODO: empty string
                "",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: isTablet ? (isLandscape ? 28 : 30) : 16,
                ),
              ),
              const SizedBox(height: 40),
              CouponRedeemButton(
                text: 'redeem.get_points'.tr(namedArgs: {'points': '100'}),
                text2: 'redeem.click_here'.tr(), 
                text3: 'redeem.time_remaining'.tr(
                  namedArgs: {
                    'Timeout': hoursUntilMidnight.toString(),
                  },
                ),
                textColor: Colors.black,
                textColor2: Colors.blue[700]!,
                textColor3: Colors.red,
                points: "100",
                onTap: () {
                  _handleCouponRedemption100(context);
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
                text: 'redeem.welcome_bonus'.tr(), 
                text2: 'redeem.get_now_1000'.tr(), 
                text3: '',
                textColor: Colors.black,
                textColor2: Colors.green,
                textColor3: Colors.red,
                points: "1,000",
                onTap: () {
                  _handleCouponRedemption1K(context);
                },
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleCouponRedemption100(BuildContext context) async {
    final couponProvider = Provider.of<CouponProvider>(context, listen: false);

    try {
      await couponProvider.checkCoupon100(context);

      if (couponProvider.errorMessage == null) {
        NotificationDialog(
          context: context,
          text: 'redeem.redeem_success'.tr(), //เติมคูปองสำเร็จแล้ว
          onPressed: () {
            callLoadCreditsApi(context);
          },
        ).showCheckmarkModalWithAction(context);
      } else {
        NotificationDialog(
          context: context,
          text: couponProvider.errorMessage!,
          onPressed: () {},
        ).showErrorModal(context);
      }
    } catch (e) {
      NotificationDialog(
        context: context,
        text: "${'has_error'.tr()} $e",
        onPressed: () {},
      ).showErrorModal(context);
    } finally {
      callLoadCreditsApi(context);
    }
  }

  Future<void> _handleCouponRedemption1K(BuildContext context) async {
    final couponProvider = Provider.of<CouponProvider>(context, listen: false);

    try {
      await couponProvider.checkCoupon1K(context);

      if (couponProvider.errorMessage == null) {
        NotificationDialog(
          context: context,
          text: 'redeem.redeem_success'.tr(), //เติมคูปองสำเร็จแล้ว
          onPressed: () {
            callLoadCreditsApi(context);
          },
        ).showCheckmarkModalWithAction(context);
      } else {
        NotificationDialog(
          context: context,
          text: couponProvider.errorMessage!,
          onPressed: () {},
        ).showErrorModal(context);
      }
    } catch (e) {
      NotificationDialog(
        context: context,
        text: "${'has_error'.tr()} $e", //เกิดข้อผิดพลาด
        onPressed: () {},
      ).showErrorModal(context);
    } finally {
      callLoadCreditsApi(context);
    }
  }
}
