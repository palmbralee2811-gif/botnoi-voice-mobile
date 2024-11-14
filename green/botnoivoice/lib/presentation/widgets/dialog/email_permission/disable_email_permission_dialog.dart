// import 'package:botnoivoice/presentation/constants/color.dart';
// import 'package:botnoivoice/presentation/widgets/gradient/gradient_close_button.dart';
// import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';

// /// Alert Modal for displaying messages
// class DisableEmailPermissionDialog extends StatelessWidget {
//   const DisableEmailPermissionDialog({
//     super.key,
//     required this.onConfirm,
//     required this.onCancel,
//   });

//   final VoidCallback onConfirm;
//   final VoidCallback onCancel;

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20.r),
//       ),
//       child: SizedBox(
//         width: 288.w,
//         height: 400.h,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.all(16.w),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SvgPicture.asset(
//                   'assets/images/icon/question-mark.svg',
//                   width: 54.w,
//                   height: 54.h,
//                 ),
//                 SizedBox(height: 16.h),
//                 Text(
//                   'ปิดใช้งานการเข้าถึงข้อมูลอีเมล',
//                   style: GoogleFonts.prompt(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                     color: kDark,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 12.h),
//                 Text(
//                   'หากปิดใช้งานการเข้าถึงข้อมูลอีเมลอาจทำให้ไม่สามารถใช้งานฟีเจอร์การกู้คืนรหัสผ่านหรือรับการแจ้งเตือนข้อมูลข่าวสารที่สำคัญที่เกี่ยวข้องกับการใช้งานแอปของคุณได้',
//                   style: GoogleFonts.prompt(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w400,
//                     color: kGray,
//                   ),
//                   textAlign: TextAlign.left,
//                 ),
//                 SizedBox(height: 12.h),
//                 Text(
//                   'คุณต้องการที่จะปิดใช้งานหรือไม่',
//                   style: GoogleFonts.prompt(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w400,
//                     color: kDark,
//                   ),
//                   textAlign: TextAlign.left,
//                 ),
//                 SizedBox(height: 24.h),
//                 GradientTextButton(
//                   text: 'ต้องการ',
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     onConfirm();
//                   },
//                 ),
//                 SizedBox(height: 12.h),
//                 GradientCloseButton(
//                   text: 'ไม่ต้องการ',
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     onCancel();
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
