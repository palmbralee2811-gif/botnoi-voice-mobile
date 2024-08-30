// import 'package:botnoivoice/Authentication/authentication_provider.dart';
// import 'package:botnoivoice/Screens/AppBarScreen/credits_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher_string.dart';

// class AppbarScreen extends StatefulWidget {
//   const AppbarScreen({
//     super.key,
//   });

//   @override
//   State<AppbarScreen> createState() => _AppbarScreenState();
// }

// class _AppbarScreenState extends State<AppbarScreen> {
//   String? credits;

//   @override
//   void initState() {
//     super.initState();
//     final creditsProvider =
//         Provider.of<CreditsProvider>(context, listen: false);
//     final auth = Provider.of<Authentication>(context, listen: false);
//     creditsProvider.fetchCredits(auth);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final credits = Provider.of<CreditsProvider>(context).credits;

//     return SizedBox(
//       height: 80.h,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Padding(
//             padding: EdgeInsets.only(left: 88.w, top: 5.h),
//             child: CircleAvatar(
//               backgroundColor: Colors.white,
//               child: SvgPicture.asset(
//                 'assets/images/logo/appbar-icon.svg',
//                 width: 30.w,
//                 height: 30.h,
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(right: 5.w),
//             child: Container(
//               decoration: BoxDecoration(
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Color.fromARGB(255, 224, 221, 221),
//                     blurRadius: 3.0,
//                   ),
//                 ],
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(50),
//               ),
//               child: InkWell(
//                 onTap: () async {
//                   const url = 'https://voice.botnoi.ai/payment';
//                   await launchUrlString(url, mode: LaunchMode.platformDefault);
//                 },
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(width: 5.w),
//                     SizedBox(
//                       height: 30.h,
//                       width: 30.h,
//                       child: Padding(
//                         padding: const EdgeInsets.all(2),
//                         child: SvgPicture.asset(
//                           'assets/images/logo/credit-icon.svg',
//                           width: 25.w,
//                           height: 25.h,
//                         ),
//                       ),
//                     ),
//                     Text(
//                       ' ${credits ?? " N/A"}',
//                       style: GoogleFonts.prompt(
//                         fontSize: 12.sp,
//                         fontWeight: FontWeight.w600,
//                         color: const Color(0xFF323130),
//                       ),
//                     ),
//                     SizedBox(width: 5.w),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
