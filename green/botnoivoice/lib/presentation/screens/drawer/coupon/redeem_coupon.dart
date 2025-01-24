import 'package:botnoivoice/presentation/providers/credits/call_load_credits_api.dart';
import 'package:botnoivoice/presentation/screens/drawer/coupon/time_helper.dart';
import 'package:botnoivoice/presentation/screens/responsive/orientation_helper.dart';
import 'package:botnoivoice/presentation/widgets/dialog/notification/notification_dialog.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:botnoivoice/presentation/providers/coupon/coupon_provider.dart';

class RedeemCoupon extends StatefulWidget {
  const RedeemCoupon({super.key});

  @override
  _RedeemCouponState createState() => _RedeemCouponState();
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
    int points = 100;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: const Color(0xFF323130),
              size: OrientationHelper.isLandscape ? 10.sp : 24.sp),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(isTablet ? 16 : 16),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.card_giftcard,
                      color: Colors.green,
                      size: isTablet ? (isLandscape ? 100 : 120) : 60,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'redeem.get_points'
                          .tr(namedArgs: {'points': points.toString()}),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: isTablet ? (isLandscape ? 40 : 44) : 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'redeem.time_remaining'
                          .tr(namedArgs: {'Timeout': hoursUntilMidnight.toString()}),
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: isTablet ? (isLandscape ? 28 : 30) : 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: isLandscape ? 80 : (isTablet ? 500 : 295),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: isTablet ? (isLandscape ? 60.w : 20.w) : 10.w,
                    right: isTablet ? (isLandscape ? 60.w : 20.w) : 10.w),
                child: GradientTextButton(
                  text: 'redeem.use_now'.tr(),
                  onPressed: () async {
                    await _handleCouponRedemption(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleCouponRedemption(BuildContext context) async {
    final couponProvider = Provider.of<CouponProvider>(context, listen: false);

    try {
      await couponProvider.checkCoupon(context);

      if (couponProvider.errorMessage == null) {
        NotificationDialog(
          context: context,
          text: "เติมคูปองสำเร็จแล้ว",
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
        text: "${'เกิดข้อผิดพลาด'.tr()} $e",
        onPressed: () {},
      ).showErrorModal(context);
    } finally {
      callLoadCreditsApi(context);
    }
  }
}