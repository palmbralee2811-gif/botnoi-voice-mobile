// // import 'dart:ffi';

// import 'package:botnoivoice/Authentication/authentication_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// class Appbar extends StatelessWidget {
//   const Appbar({super.key});

//   @override
//   Widget build(BuildContext context) {

//     final auth = Provider.of<Authentication>(context);
    
//     return SafeArea(
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(left: 86.w),
//                 child: ClipOval(
//                   child: Image.asset(
//                     'assets/logo/App_Icon.png',
//                     width: 35.w,
//                     height: 35.h,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(right: 5.w),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         IntrinsicWidth(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               boxShadow: const [
//                                 BoxShadow(
//                                   color: Color.fromARGB(255, 224, 221, 221),
//                                   blurRadius: 3.0,
//                                 ),
//                               ],
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(50),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 SizedBox(width: 5.w),
//                                 SizedBox(
//                                   height: 25.h,
//                                   width: 20.h,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(2),
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Image.asset(
//                                           'assets/logo/point.png',
//                                           width: 20.w,
//                                           height: 20.h,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 Column(
//                                   children: [
//                                     Text(
//                                       // ' 10,000,000,000',
//                                       // ต้องเวนช่องว่างหน้าข้อความไว้ ไม่งั้น Error
//                                       ' ${auth.credits ?? " N/A"}',
//                                       style: GoogleFonts.prompt(
//                                         fontSize: 12.sp,
//                                         fontWeight: FontWeight.w600,
//                                         color: const Color(0xFF323130),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(width: 5.w),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }


/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:botnoivoice/Authentication/authentication_provider.dart';

class Appbar extends StatelessWidget {
  const Appbar({Key? key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Authentication>(context);

    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: ClipOval(
                  child: Image.asset(
                    'assets/logo/App_Icon.png',
                    width: 35.w,
                    height: 35.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(255, 224, 221, 221),
                                blurRadius: 3.0,
                              ),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 5.w),
                              SizedBox(
                                height: 25.h,
                                width: 20.h,
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/logo/point.png',
                                        width: 20.w,
                                        height: 20.h,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    ' ${auth.credits ?? " N/A"}',
                                    style: GoogleFonts.prompt(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF323130),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 5.w),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

*/
