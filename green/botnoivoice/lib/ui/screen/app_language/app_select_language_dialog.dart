// import 'package:botnoivoice/ui/widget/gradient/gradient_close_button.dart';
// import 'package:botnoivoice/ui/widget/gradient/gradient_text_button.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// /// Alert Modal for displaying messages
// class AppSelectLanguageDialog extends StatelessWidget {
//   const AppSelectLanguageDialog({super.key, required this.onPressed});

//   final VoidCallback onPressed;

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20.r),
//       ),
//       child: SizedBox(
//         width: 288.w,
//         height: 145.h,
//         child: Padding(
//           padding: EdgeInsets.all(16.w),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               GradientTextButton(
//                 text: 'email_permission_dialog.agree'.tr(), //ยินยอม
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   onPressed();
//                 },
//               ),
//               SizedBox(height: 12.h),
//               GradientCloseButton(
//                 text: 'email_permission_dialog.disagree'.tr(), //ไม่ยินยอม
//                 onPressed: () {
//                   // DO
//                   // context.pop(); or context.go(/home);

//                   // DO NOT
//                   // Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
