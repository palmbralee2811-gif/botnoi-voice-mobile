import 'package:botnoivoice/service/coupon/coupon_service.dart';
import 'package:botnoivoice/function/call_reload_data.dart';
import 'package:botnoivoice/ui/screen/appbar/appbar_template.dart';
import 'package:botnoivoice/function/time_zone_function.dart';
import 'package:botnoivoice/ui/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/ui/dialog/notification/notification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:botnoivoice/ui/widget/button/coupon_redeem_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:botnoivoice/ui/widget/card/reward_card.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
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
          context.go('/home');
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
                  horizontal: isTablet ? (isLandscape ? 20 : 12) : 8,
                ),
                child: Column(
                  children: [
                    // Header section

                    // Content section
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16,
                          ),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              // Subtitle
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        'redeem.claim_exclusive_reward'.tr(),
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 14,
                                          color: Color(0xFF6D6D6D),
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
                              const SizedBox(height: 20,),
                              // Reward cards section
                              Container(
                                margin: const EdgeInsets.only(top: 24),
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    // Daily reward card
                                    RewardCard(
                                      iconUrl:
                                          'assets/images/logo/credit-icon.svg',
                                      title: 'redeem.get_free_daily_points'.tr(),
                                      description: 'redeem.claim_free_daily_points'.tr(
                                     
                                      ),
                                      buttonText: 'redeem.get_points'
                                          .tr(namedArgs: {'points': '100'}),
                                      onTap: () =>
                                          _handleCouponRedemption100(context),
                                      isTablet: isTablet,
                                      isLandscape: isLandscape,
                                    ),

                                    const SizedBox(height: 32),

                                    // Welcome bonus card
                                    RewardCard(
                                      iconUrl:
                                          'assets/images/logo/credit-icon.svg',
                                      title: 'redeem.welcome_bonus'.tr(),
                                      description:
                                          'redeem.get_1000_for_new_user'.tr(),
                                      buttonText: 'redeem.get_points'
                                          .tr(namedArgs: {'points': '1,000'}),
                                      onTap: () =>
                                          _handleCouponRedemption1K(context),
                                      isTablet: isTablet,
                                      isLandscape: isLandscape,
                                    ),
                                  ],
                                ),
                              ),

                              // Bottom spacing
                              const SizedBox(height: 40),
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
        NotificationDialog(
          context: context,
          text: 'redeem.redeem_success'.tr(), //เติมคูปองสำเร็จแล้ว
          onPressed: () {
            creditsProvider.callLoadCreditsApi(context);
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
        NotificationDialog(
          context: context,
          text: 'redeem.redeem_success'.tr(), //เติมคูปองสำเร็จแล้ว
          onPressed: () {
            creditsProvider.callLoadCreditsApi(context);
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
        text: "${'redeem.has_error'.tr()} $e", //เกิดข้อผิดพลาด
        onPressed: () {},
      ).showErrorModal(context);
    } finally {
      creditsProvider.callLoadCreditsApi(context);
    }
  }
}
