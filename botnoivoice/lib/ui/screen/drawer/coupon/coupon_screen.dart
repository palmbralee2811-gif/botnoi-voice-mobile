import 'package:botnoivoice/service/coupon/coupon_service.dart';
import 'package:botnoivoice/function/call_reload_data.dart';
import 'package:botnoivoice/ui/screen/appbar/appbar_template.dart';
import 'package:botnoivoice/function/time_zone_function.dart';
import 'package:botnoivoice/ui/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/ui/dialog/notification/notification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:botnoivoice/ui/screen/drawer/coupon/widget/reward_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  String? currentDate;
  String? hoursUntilMidnight;
  bool isRedeemed100 = true; //เอาไว้เช็คว่ารับพอยต์ไปแล้วหรือยัง
  bool isRedeemed1k = true;

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
    // Get data from provider
    final couponProvider = Provider.of<CouponService>(context);

    final bool isTablet = MediaQuery.of(context).size.width > 600;
    final bool isLandscape = ResponsiveDesignOrientation.isLandscape;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarTemplate(
        title: 'redeem.reward'.tr(),
        onPressed: () {
          // Redirect to HomeScreen
          context.pop();
        },
      ),
      body: Stack(
        children: [
          // Main content
          Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth:
                    isTablet ? (isLandscape ? 900 : 720) : double.infinity,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? (isLandscape ? 20.w : 12.w) : 8.w,
                ),
                child: Column(
                  children: [
                    // Header section

                    // Content section
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(
                            left: 16.w,
                            right: 16.w,
                            top: 16.h,
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20.h,
                              ),
                              // Subtitle
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "${'redeem.coupon_header'.tr()} \n\n$currentDate",
                                        style: TextStyle(
                                          fontSize: isLandscape ? 14.sp : 16.sp,
                                          color: const Color(0xFF6D6D6D),
                                          fontWeight: FontWeight.w300,
                                          letterSpacing: 0.25,
                                          height: 1,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              // Reward cards section
                              Container(
                                margin: EdgeInsets.only(top: 24.h),
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    // Daily reward card
                                    RewardCard(
                                      iconUrl:
                                          'assets/images/logo/credit-icon.svg',
                                      title: 'redeem.coupon_title01'.tr(),
                                      description: 'redeem.coupon_text01'.tr(),
                                      buttonText: isRedeemed100
                                          ? 'redeem.get_points'
                                              .tr(namedArgs: {'points': '100'})
                                          : 'redeem.coupon_text_button01'.tr(
                                              namedArgs: {
                                                'Timeout':
                                                    hoursUntilMidnight ?? '24',
                                              },
                                            ),
                                      onTap: () =>
                                          _handleCouponRedemption100(context),
                                      isTablet: isTablet,
                                      isLandscape: isLandscape,
                                      isRedeemed: isRedeemed100,
                                    ),

                                    SizedBox(height: 32.h),

                                    // Welcome bonus card
                                    RewardCard(
                                      iconUrl:
                                          'assets/images/logo/credit-icon.svg',
                                      title: 'redeem.coupon_title02'.tr(),
                                      description: 'redeem.coupon_text02'.tr(),
                                      buttonText: isRedeemed1k
                                          ? 'redeem.get_points'.tr(
                                              namedArgs: {'points': '1,000'})
                                          : 'redeem.coupon_text_button02'.tr(),
                                      onTap: () =>
                                          _handleCouponRedemption1K(context),
                                      isTablet: isTablet,
                                      isLandscape: isLandscape,
                                      isRedeemed: isRedeemed1k,
                                    ),
                                  ],
                                ),
                              ),

                              // Bottom spacing
                              SizedBox(height: 40.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // วงกลมโหลด (Fullscreen Loading Overlay)
          if (couponProvider.isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5), // พื้นหลังมืดโปร่งแสง
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white), // สีของ Loading
                    strokeWidth: 4.0, // ขนาดเส้นวงกลม
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleCouponRedemption100(BuildContext context) async {
    final couponProvider = Provider.of<CouponService>(context, listen: false);
    final creditsProvider = Provider.of<CallReloadData>(context, listen: false);

    try {
      await couponProvider.checkCoupon100(context);

      if (couponProvider.errorMessage == null) {
        setState(() {
          isRedeemed100 = false;
        });

        NotificationDialog(
          context: context,
          text: 'redeem.redeem_success'.tr(), //เติมคูปองสำเร็จแล้ว
          onPressed: () {
            creditsProvider.callLoadCreditsApi(context);
          },
        ).showCheckmarkModalWithAction(context);
      } else {
        setState(() {
          isRedeemed100 = false;
        });
        NotificationDialog(
          context: context,
          text: couponProvider.errorMessage!,
          onPressed: () {},
        ).showErrorModal(context);
      }
    } catch (e) {
      NotificationDialog(
        context: context,
        text: "${'redeem.has_error'.tr()} $e", //เกิดข้อผิดพลาด
        onPressed: () {},
      ).showErrorModal(context);
    } finally {
      creditsProvider.callLoadCreditsApi(context);
    }
  }

  Future<void> _handleCouponRedemption1K(BuildContext context) async {
    final couponProvider = Provider.of<CouponService>(context, listen: false);
    final creditsProvider = Provider.of<CallReloadData>(context, listen: false);

    try {
      await couponProvider.checkCoupon1K(context);

      if (couponProvider.errorMessage == null) {
        setState(() {
          isRedeemed1k = false;
        });

        NotificationDialog(
          context: context,
          text: 'redeem.redeem_success'.tr(), //เติมคูปองสำเร็จแล้ว
          onPressed: () {
            creditsProvider.callLoadCreditsApi(context);
          },
        ).showCheckmarkModalWithAction(context);
      } else {
        setState(() {
          isRedeemed1k = false;
        });

        NotificationDialog(
          context: context,
          text: couponProvider.errorMessage!,
          onPressed: () {},
        ).showErrorModal(context);
      }
    } catch (e) {
      NotificationDialog(
        context: context,
        text: "${'redeem.has_error'.tr()} $e", //เกิดข้อผิดพลาด
        onPressed: () {},
      ).showErrorModal(context);
    } finally {
      creditsProvider.callLoadCreditsApi(context);
    }
  }
}
