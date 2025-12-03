// import 'package:botnoivoice/service/reward/reward_service.dart';
// import 'package:botnoivoice/shared/dialog/notification/notification_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:provider/provider.dart';
// import 'package:botnoivoice/screen/drawer/reward/widget/reward_card_widget.dart'; // ตรวจสอบ Path ให้ถูกต้อง
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
// import 'package:botnoivoice/screen/appbar/appbar_template.dart';
// import 'package:go_router/go_router.dart';

// import 'package:easy_localization/easy_localization.dart';

// class EducationScreen extends ConsumerStatefulWidget {
//   const EducationScreen({super.key});

//   @override
//   ConsumerState<EducationScreen> createState() => _EducationScreenState();
// }

// class _EducationScreenState extends ConsumerState<EducationScreen> {
//   bool isRedeemedEducation = true;

//   @override
//   Widget build(BuildContext context) {
//     final bool isTablet = MediaQuery.of(context).size.width > 600;
//     final bool isLandscape = ResponsiveDesignOrientation.isLandscape;
//     final rewardServiceProvider = context.watch<RewardService>();

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBarTemplate(
//         title: 'education_screen.appbar_title'.tr(),
//         onPressed: () {
//           context.pop();
//         },
//       ),
//       body: Stack(
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   RewardCard(
//                     iconUrl: 'assets/images/logo/credit-icon.svg',
//                     title: 'education_screen.text_header'.tr(),
//                     description: 'education_screen.widget_title01'.tr(),
//                     buttonText: 'education_screen.widget_button'.tr(),
//                     onTap: () {
//                       _handleEducationSubscription(ref);
//                     },
//                     isTablet: isTablet,
//                     isLandscape: isLandscape,
//                     isRedeemed: isRedeemedEducation,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (rewardServiceProvider.isLoading)
//             Positioned.fill(
//               child: Container(
//                 color: Colors.black.withOpacity(0.5),
//                 child: const Center(
//                   child: CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                     strokeWidth: 4.0,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   //--- MOVED from reward_screen.dart ---
//   Future<void> _handleEducationSubscription(WidgetRef ref) async {
//     final rewardProvider = context.read<RewardService>();

//     try {
//       await rewardProvider.getEducationSubscription(ref);

//       if (rewardProvider.errorMessage == null) {
//         setState(() {
//           isRedeemedEducation = false; // Disable button after success
//         });

//         NotificationDialog(
//           context: context,
//           text: '"Subscription activated successfully!"',
//           onPressed: () {},
//         ).showCheckmarkModalWithAction(context);
//       } else {
//         NotificationDialog(
//           context: context,
//           text: rewardProvider.errorMessage!,
//           onPressed: () {},
//         ).showErrorModal(context);
//       }
//     } catch (e) {
//       NotificationDialog(
//         context: context,
//         text: "An error occurred: $e",
//         onPressed: () {},
//       ).showErrorModal(context);
//     }
//   }
// }
















import 'package:botnoivoice/service/reward/reward_service.dart';
import 'package:botnoivoice/shared/dialog/notification/notification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:botnoivoice/screen/drawer/reward/widget/reward_card_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/screen/appbar/appbar_template.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

class EducationScreen extends ConsumerStatefulWidget {
  const EducationScreen({super.key});

  @override
  ConsumerState<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends ConsumerState<EducationScreen> {
  bool isRedeemedEducation = true;

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width > 600;
    final bool isLandscape = ResponsiveDesignOrientation.isLandscape;

    // **แก้ไขจุดนี้**: ใช้ ref.watch เพื่อดูสถานะ isLoading โดยตรง
    // เพื่อให้ Widget Rebuild เมื่อมีการโหลด
    final bool isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarTemplate(
        title: 'education_screen.appbar_title'.tr(),
        onPressed: () {
          context.pop();
        },
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  RewardCard(
                    iconUrl: 'assets/images/logo/credit-icon.svg',
                    title: 'education_screen.text_header'.tr(),
                    description: 'education_screen.widget_title01'.tr(),
                    buttonText: 'education_screen.widget_button'.tr(),
                    onTap: () {
                      _handleEducationSubscription(ref);
                    },
                    isTablet: isTablet,
                    isLandscape: isLandscape,
                    isRedeemed: isRedeemedEducation,
                  ),
                ],
              ),
            ),
          ),
          // ใช้ตัวแปร isLoading ที่ watch มาจาก Provider
          if (isLoading)
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

  //--- Logic การกดปุ่ม ---
  Future<void> _handleEducationSubscription(WidgetRef ref) async {
    // **แก้ไขจุดนี้**: ใช้ ref.read เพื่อดึง Service มาใช้งาน (ไม่ต้อง watch)
    final rewardService = ref.read(rewardServiceProvider);

    try {
      // เรียกฟังก์ชันใน Service
      await rewardService.getEducationSubscription(ref);

      // ดึง Error Message ล่าสุดจาก Provider
      final errorMessage = ref.read(errorMessageProvider);

      if (errorMessage == null) {
        setState(() {
          isRedeemedEducation = false; // Disable button after success
        });

        if (mounted) {
          NotificationDialog(
            context: context,
            text: '"Subscription activated successfully!"',
            onPressed: () {},
          ).showCheckmarkModalWithAction(context);
        }
      } else {
        if (mounted) {
          NotificationDialog(
            context: context,
            text: errorMessage,
            onPressed: () {},
          ).showErrorModal(context);
        }
      }
    } catch (e) {
      if (mounted) {
        NotificationDialog(
          context: context,
          text: "An error occurred: $e",
          onPressed: () {},
        ).showErrorModal(context);
      }
    }
  }
}