import 'package:botnoivoice/service/reward/reward_service.dart';
import 'package:botnoivoice/shared/function/call_reload_data.dart';
import 'package:botnoivoice/screen/appbar/appbar_template.dart';
import 'package:botnoivoice/screen/drawer/reward/function/time_zone_function.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/shared/dialog/notification/notification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:botnoivoice/screen/drawer/reward/widget/reward_card_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RewardScreen extends StatefulWidget {
  const RewardScreen({super.key});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  String? currentDate;
  String? hoursUntilMidnight;
  bool isRedeemed100 = true; //เอาไว้เช็คว่ารับพอยต์ไปแล้วหรือยัง
  bool isRedeemed1k = true;
  bool isRedeemedEducation = true;

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
    final rewardServiceProvider = context.watch<RewardService>();

    final bool isTablet = MediaQuery.of(context).size.width > 600;
    final bool isLandscape = ResponsiveDesignOrientation.isLandscape;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarTemplate(
        title: 'reward_screen.appbar_title'.tr(),
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
                                height: 4.h,
                              ),
                              // Subtitle
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "${'reward_screen.text_header'.tr()} \n\n$currentDate",
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
                                height: 4.h,
                              ),
                              // Reward cards section
                              Container(
                                margin: EdgeInsets.only(top: 24.h),
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    // ADDED: Education Subscription Card
                                    RewardCard(
                                      iconUrl:
                                          'assets/images/logo/credit-icon.svg', // Placeholder icon
                                      title:
                                          'Education Subscription', // Placeholder
                                      description:
                                          'Get access to exclusive educational content and features.', // Placeholder
                                      buttonText:
                                          'Get Subscription', // Placeholder
                                      onTap: () =>
                                          _handleEducationSubscription(context),
                                      isTablet: isTablet,
                                      isLandscape: isLandscape,
                                      isRedeemed: isRedeemedEducation,
                                    ),

                                    SizedBox(height: 12.h),
                                    // Daily reward card
                                    RewardCard(
                                      iconUrl:
                                          'assets/images/logo/credit-icon.svg',
                                      title:
                                          'reward_screen.widget_title01'.tr(),
                                      description:
                                          'reward_screen.widget_text01'.tr(),
                                      buttonText: isRedeemed100
                                          ? 'reward_screen.widget_display_points'
                                              .tr(namedArgs: {'points': '100'})
                                          : 'reward_screen.widget_text_button01'
                                              .tr(
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

                                    SizedBox(height: 12.h),

                                    // Welcome bonus card
                                    RewardCard(
                                      iconUrl:
                                          'assets/images/logo/credit-icon.svg',
                                      title:
                                          'reward_screen.widget_title02'.tr(),
                                      description:
                                          'reward_screen.widget_text02'.tr(),
                                      buttonText: isRedeemed1k
                                          ? 'reward_screen.widget_display_points'
                                              .tr(namedArgs: {
                                              'points': '1,000'
                                            })
                                          : 'reward_screen.widget_text_button02'
                                              .tr(),
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
          if (rewardServiceProvider.isLoading)
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
    final couponProvider = context.read<RewardService>();
    final creditsProvider = context.read<CallReloadData>();

    try {
      await couponProvider.checkCoupon100(context);

      if (couponProvider.errorMessage == null) {
        setState(() {
          isRedeemed100 = false;
        });

        NotificationDialog(
          context: context,
          text: 'reward_screen.notification_dialog_success'
              .tr(), //เติมคูปองสำเร็จแล้ว
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
        text:
            "${'reward_screen.notification_dialog_error'.tr()} $e", //เกิดข้อผิดพลาด
        onPressed: () {},
      ).showErrorModal(context);
    } finally {
      creditsProvider.callLoadCreditsApi(context);
    }
  }

  Future<void> _handleCouponRedemption1K(BuildContext context) async {
    final couponProvider = context.read<RewardService>();
    final creditsProvider = context.read<CallReloadData>();

    try {
      await couponProvider.checkCoupon1K(context);

      if (couponProvider.errorMessage == null) {
        setState(() {
          isRedeemed1k = false;
        });

        NotificationDialog(
          context: context,
          text: 'reward_screen.notification_dialog_success'
              .tr(), //เติมคูปองสำเร็จแล้ว
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
        text:
            "${'reward_screen.notification_dialog_error'.tr()} $e", //เกิดข้อผิดพลาด
        onPressed: () {},
      ).showErrorModal(context);
    } finally {
      creditsProvider.callLoadCreditsApi(context);
    }
  }

  // ADDED: Handler for Education Subscription
  Future<void> _handleEducationSubscription(BuildContext context) async {
    final rewardProvider = context.read<RewardService>();

    try {
      await rewardProvider.getEducationSubscription(context);

      if (rewardProvider.errorMessage == null) {
        setState(() {
          isRedeemedEducation = false; // Disable button after success
        });

        NotificationDialog(
          context: context,
          text: "Subscription activated successfully!", // Placeholder text
          onPressed: () {},
        ).showCheckmarkModalWithAction(context);
      } else {
        NotificationDialog(
          context: context,
          text: rewardProvider.errorMessage!,
          onPressed: () {},
        ).showErrorModal(context);
      }
    } catch (e) {
      NotificationDialog(
        context: context,
        text: "An error occurred: $e", // Placeholder text
        onPressed: () {},
      ).showErrorModal(context);
    }
  }
}
