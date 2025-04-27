// import 'package:botnoivoice/function/app_language_function.dart';
// import 'package:botnoivoice/ui/screen/responsive/responsive_design_orientation.dart';
// import 'package:botnoivoice/ui/screen/app_language/app_language_button.dart';
// import 'package:botnoivoice/ui/widget/gradient/gradient_text.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';

// class AppLanguageSelectionScreen extends StatefulWidget {
//   const AppLanguageSelectionScreen({super.key});

//   @override
//   State<AppLanguageSelectionScreen> createState() =>
//       _AppLanguageSelectionScreenState();
// }

// class _AppLanguageSelectionScreenState
//     extends State<AppLanguageSelectionScreen> {
//   String selectedLanguage = ''; // ตัวแปรสำหรับเก็บภาษาที่เลือก

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(
//                 'assets/images/splash_screen/background-320x684.png'),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // GradientText: ข้อความ "Languages"
//                 Container(
//                   width: ResponsiveDesignOrientation.isLandscape
//                       ? 300.w
//                       : 256.w, // ปรับตาม orientation
//                   height: ResponsiveDesignOrientation.isLandscape ? 90.h : 56.h,
//                   alignment: Alignment.center,
//                   child: GradientText(
//                     text: 'Languages',
//                     gradient: const LinearGradient(
//                       colors: [
//                         Color(0xFF9340FF),
//                         Color(0xFF34BDFA),
//                       ],
//                     ),
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600, // กึ่งหนา
//                       fontSize: ResponsiveDesignOrientation.isLandscape
//                           ? 16.sp
//                           : 22.sp, // ปรับขนาดฟอนต์
//                       decoration: TextDecoration.none,
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                     height: ResponsiveDesignOrientation.isLandscape
//                         ? 40.h
//                         : 20.h), // ปรับระยะห่าง
//                 // ปุ่มสำหรับเลือกภาษา English
//                 AppLanguageButton(
//                   flagAsset: 'assets/images/national_flag/english.png',
//                   language: 'English',
//                   width:
//                       ResponsiveDesignOrientation.isLandscape ? 300.w : 256.w,
//                   height: ResponsiveDesignOrientation.isLandscape ? 70.h : 48.h,
//                   fontSize:
//                       ResponsiveDesignOrientation.isLandscape ? 12.sp : 16.sp,
//                   flagWidth: ResponsiveDesignOrientation.isLandscape
//                       ? 30.w
//                       : 30.w, // กำหนดขนาดของธงตาม orientation
//                   flagHeight: ResponsiveDesignOrientation.isLandscape
//                       ? 40.h
//                       : 20.h, // กำหนดขนาดของธงตาม orientation
//                   isSelected: selectedLanguage == 'English',
//                   onTap: () async {
//                     await saveSelectedLanguage('en');
//                     context.setLocale(const Locale('en'));

//                     // Redirect to AuthChecker
//                     context.go('/auth');
//                   },
//                 ),
//                 SizedBox(
//                     height:
//                         ResponsiveDesignOrientation.isLandscape ? 15.h : 10.h),
//                 // ปุ่มสำหรับเลือกภาษาไทย
//                 AppLanguageButton(
//                   flagAsset: 'assets/images/national_flag/thai.png',
//                   language: 'ไทย',
//                   width:
//                       ResponsiveDesignOrientation.isLandscape ? 300.w : 256.w,
//                   height: ResponsiveDesignOrientation.isLandscape ? 70.h : 48.h,
//                   fontSize:
//                       ResponsiveDesignOrientation.isLandscape ? 12.sp : 16.sp,
//                   flagWidth: ResponsiveDesignOrientation.isLandscape
//                       ? 30.w
//                       : 30.w, // กำหนดขนาดของธงตาม orientation
//                   flagHeight: ResponsiveDesignOrientation.isLandscape
//                       ? 40.h
//                       : 20.h, // กำหนดขนาดของธงตาม orientation
//                   isSelected: selectedLanguage == 'ไทย',
//                   onTap: () async {
//                     await saveSelectedLanguage('th');
//                     context.setLocale(const Locale('th'));

//                     // Redirect to AuthChecker
//                     context.go('/auth');
//                   },
//                 ),
//                 SizedBox(
//                     height:
//                         ResponsiveDesignOrientation.isLandscape ? 15.h : 10.h),
//                 // ปุ่มสำหรับเลือกภาษาอินโดนีเซีย
//                 AppLanguageButton(
//                   flagAsset: 'assets/images/national_flag/indonesian.png',
//                   language: 'Indonesian',
//                   width:
//                       ResponsiveDesignOrientation.isLandscape ? 300.w : 256.w,
//                   height: ResponsiveDesignOrientation.isLandscape ? 70.h : 48.h,
//                   fontSize:
//                       ResponsiveDesignOrientation.isLandscape ? 12.sp : 16.sp,
//                   flagWidth: ResponsiveDesignOrientation.isLandscape
//                       ? 30.w
//                       : 30.w, // กำหนดขนาดของธงตาม orientation
//                   flagHeight: ResponsiveDesignOrientation.isLandscape
//                       ? 40.h
//                       : 20.h, // กำหนดขนาดของธงตาม orientation
//                   isSelected: selectedLanguage == 'Indonesian',
//                   onTap: () async {
//                     await saveSelectedLanguage('id');
//                     context.setLocale(const Locale('id'));

//                     // Redirect to AuthChecker
//                     context.go('/auth');
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


