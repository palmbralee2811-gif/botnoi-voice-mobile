import 'package:botnoivoice/service/reward/reward_service.dart';
import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:botnoivoice/screen/appbar/appbar_template.dart';
import 'package:botnoivoice/screen/drawer/reward/function/time_zone_function.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/shared/dialog/notification/notification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:botnoivoice/screen/drawer/reward/widget/reward_card_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class RewardScreen extends ConsumerStatefulWidget {
  const RewardScreen({super.key});

  @override
  ConsumerState<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends ConsumerState<RewardScreen> {
  String? currentDate;
  String? hoursUntilMidnight;
  bool isRedeemed100 = true;
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
    final rewardService = ref.watch(rewardServiceProvider);
    final bool isTablet = MediaQuery.of(context).size.width > 600;
    final bool isLandscape = ResponsiveDesignOrientation.isLandscape;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // พื้นหลัง Off-white สบายตา
      appBar: AppBarTemplate(
        title: 'reward_screen.appbar_title'.tr(),
        onPressed: () => context.pop(),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isTablet ? 600 : double.infinity),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // --- Date & Info Card ---
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'reward_screen.text_header'.tr(), // "Get Free Points"
                              style: GoogleFonts.prompt(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              currentDate ?? "",
                              style: GoogleFonts.prompt(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 32.h),

                      // --- Reward Cards ---
                      // Daily Reward
                      RewardCard(
                        iconUrl: 'assets/images/logo/credit-icon.svg',
                        title: 'reward_screen.widget_title01'.tr(),
                        description: 'reward_screen.widget_text01'.tr(),
                        buttonText: isRedeemed100
                            ? 'reward_screen.widget_display_points'.tr(namedArgs: {'points': '100'})
                            : 'reward_screen.widget_text_button01'.tr(namedArgs: {
                                'Timeout': hoursUntilMidnight ?? '24',
                              }),
                        onTap: () => _handleCouponRedemption100(ref),
                        isTablet: isTablet,
                        isLandscape: isLandscape,
                        isRedeemed: isRedeemed100,
                      ),

                      SizedBox(height: 20.h),

                      // Welcome Bonus
                      RewardCard(
                        iconUrl: 'assets/images/logo/credit-icon.svg',
                        title: 'reward_screen.widget_title02'.tr(),
                        description: 'reward_screen.widget_text02'.tr(),
                        buttonText: isRedeemed1k
                            ? 'reward_screen.widget_display_points'.tr(namedArgs: {'points': '1,000'})
                            : 'reward_screen.widget_text_button02'.tr(),
                        onTap: () => _handleCouponRedemption1K(ref),
                        isTablet: isTablet,
                        isLandscape: isLandscape,
                        isRedeemed: isRedeemed1k,
                      ),
                      
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // --- Modern Loading Overlay ---
          if (rewardService.isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.white.withOpacity(0.7), // พื้นหลังขาวจางๆ
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(24.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: const CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ... (Logic functions ยังคงเดิม) ...
  Future<void> _handleCouponRedemption100(WidgetRef ref) async {
    final couponProvider = ref.read(rewardServiceProvider);
    
    // ignore: unused_local_variable
    final creditsProvider = loadAllTokensIfLoggedIn(ref);

    try {
      await couponProvider.checkCoupon100(ref);

      if (couponProvider.errorMessage == null) {
        setState(() {
          isRedeemed100 = false;
        });

        if(mounted) {
           NotificationDialog(
            context: context,
            text: 'reward_screen.notification_dialog_success'.tr(),
            onPressed: () {
              loadAllTokensIfLoggedIn(ref); // Call api refresh token
            },
          ).showCheckmarkModalWithAction(context);
        }
       
      } else {
        setState(() {
          isRedeemed100 = false;
        });
        if(mounted) {
           NotificationDialog(
            context: context,
            text: couponProvider.errorMessage!,
            onPressed: () {},
          ).showErrorModal(context);
        }
      }
    } catch (e) {
      if(mounted) {
        NotificationDialog(
          context: context,
          text: "${'reward_screen.notification_dialog_error'.tr()} $e",
          onPressed: () {},
        ).showErrorModal(context);
      }
    }
  }

  Future<void> _handleCouponRedemption1K(WidgetRef ref) async {
    final couponProvider = ref.read(rewardServiceProvider);
    
    // ignore: unused_local_variable
    final creditsProvider = loadAllTokensIfLoggedIn(ref);

    try {
      await couponProvider.checkCoupon1K(ref);

      if (couponProvider.errorMessage == null) {
        setState(() {
          isRedeemed1k = false;
        });

        if(mounted) {
          NotificationDialog(
            context: context,
            text: 'reward_screen.notification_dialog_success'.tr(),
            onPressed: () {
               loadAllTokensIfLoggedIn(ref);
            },
          ).showCheckmarkModalWithAction(context);
        }
      } else {
        setState(() {
          isRedeemed1k = false;
        });

        if(mounted) {
          NotificationDialog(
            context: context,
            text: couponProvider.errorMessage!,
            onPressed: () {},
          ).showErrorModal(context);
        }
      }
    } catch (e) {
      if(mounted) {
        NotificationDialog(
          context: context,
          text: "${'reward_screen.notification_dialog_error'.tr()} $e",
          onPressed: () {},
        ).showErrorModal(context);
      }
    }
  }
}