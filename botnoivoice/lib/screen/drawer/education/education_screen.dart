// education_screen.dart (New File)

import 'package:botnoivoice/service/reward/reward_service.dart';
import 'package:botnoivoice/shared/dialog/notification/notification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:botnoivoice/screen/drawer/reward/widget/reward_card_widget.dart'; // ตรวจสอบ Path ให้ถูกต้อง
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/screen/appbar/appbar_template.dart';
import 'package:go_router/go_router.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  //--- MOVED from reward_screen.dart ---
  bool isRedeemedEducation = true;

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width > 600;
    final bool isLandscape = ResponsiveDesignOrientation.isLandscape;
    final rewardServiceProvider = context.watch<RewardService>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarTemplate(
        title:
            'Education', // สามารถเปลี่ยนเป็น 'education_screen.title'.tr() ได้
        onPressed: () {
          context.pop();
        },
      ),
      body: Stack(
        // เพิ่ม Stack เพื่อรองรับ Loading indicator
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
            child: SingleChildScrollView(
              // ใช้ SingleChildScrollView เผื่อมีเนื้อหาเพิ่มในอนาคต
              child: Column(
                children: [
                  //--- MOVED from reward_screen.dart ---
                  RewardCard(
                    iconUrl: 'assets/images/logo/credit-icon.svg',
                    title: 'Education Subscription',
                    description:
                        'Get access to exclusive educational content and features.',
                    buttonText: 'Get Subscription',
                    onTap: () => _handleEducationSubscription(context),
                    isTablet: isTablet,
                    isLandscape: isLandscape,
                    isRedeemed: isRedeemedEducation,
                  ),

                  // สามารถเพิ่ม Widget อื่นๆ ที่เกี่ยวกับ Education ได้ที่นี่
                ],
              ),
            ),
          ),
          // --- Loading Indicator COPIED from reward_screen.dart ---
          if (rewardServiceProvider.isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 4.0,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  //--- MOVED from reward_screen.dart ---
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
          text: '"Subscription activated successfully!"', // ควรใช้ localization
          onPressed: () {},
        ).showCheckmarkModalWithAction(context);
      } else {
        NotificationDialog(
          paddingHeight: 60.h,
          context: context,
          text: rewardProvider.errorMessage!,
          onPressed: () {},
        ).showErrorModal(context);
      }
    } catch (e) {
      NotificationDialog(
        context: context,
        text: "An error occurred: $e", // ควรใช้ localization
        onPressed: () {},
      ).showErrorModal(context);
    }
  }
}
