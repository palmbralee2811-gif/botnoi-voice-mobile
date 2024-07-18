// import 'dart:ffi';
import 'package:botnoivoice/Authentication/authentication_provider.dart';
// import 'package:botnoivoice/Screens/HomeScreen/home.dart';
import 'package:botnoivoice/Screens/SignInScreen/sign_in.dart';
import 'package:botnoivoice/filters/languagedrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'gradient_icon_home.dart';
import 'gradient_text_home.dart';

class DrawerAppBar extends StatelessWidget {
  const DrawerAppBar({
    super.key,
    required this.auth,
    required this.email,
    required this.screenSizeheight,
  });

  final Authentication auth;
  final String? email;
  final double screenSizeheight;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 16,
      backgroundColor: Colors.white,
      shadowColor: Colors.black,
      child: ListView(
        children: <Widget>[
          ListTile(
            contentPadding:
                EdgeInsets.only(left: 30.w, top: 15.w, right: 30.w),
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(auth.user!.photoURL!),
                      backgroundColor: Colors.black,
                      radius: 20.0.r,
                      child: SvgPicture.asset(
                        'assets/logo/logo.svg',
                        width: 40.0.w,
                        height: 40.0.h,
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(fontSize: 10.sp),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.menu_rounded,
                        color: const Color(0xFF323130),
                        size: 32.sp,
                      ),
                    ),
                  ],
                ),
                Text(
                  // user.displayName!,
                  '${auth.user!.displayName}',
                  style: GoogleFonts.prompt(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF323130),
                  ),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  maxLines: 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        // user.email!,
                        ' ${email ?? 'No email found'}',
                        style: GoogleFonts.prompt(
                          fontSize: 14.sp,
                          color: const Color(0xFF323130),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            onTap: () {},
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left: 30.w, top: 30.w),
            leading: GradientIconHome(
              icon: Icons.account_circle_outlined,
              size: 24.sp,
              gradient: const LinearGradient(
                colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            title: GradientTextHome(
              text: 'ข้อมูลส่วนตัว',
              style: GoogleFonts.prompt(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFA19F9D),
              ),
              gradient: const LinearGradient(
                colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left: 30.w, top: 15.w),
            leading: Icon(
              Icons.credit_card_rounded,
              size: 24.sp,
              color: const Color(0xFF323130),
            ),
            title: Text(
              'แพ็คเกจ',
              style: GoogleFonts.prompt(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF323130),
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left: 30.w, top: 15.w),
            leading: Icon(
              Icons.question_mark_outlined,
              size: 24.sp,
              color: const Color(0xFF323130),
            ),
            title: Text(
              'FAQ',
              style: GoogleFonts.prompt(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF323130),
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left: 30.w, top: 15.w),
            leading: Icon(
              Icons.email_outlined,
              size: 24.sp,
              color: const Color(0xFF323130),
            ),
            title: Text(
              'ข้อเสนอแนะ',
              style: GoogleFonts.prompt(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF323130),
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left: 30.w, top: 15.w),
            leading: Icon(
              Icons.credit_card_sharp,
              size: 24.sp,
              color: const Color(0xFF323130),
            ),
            title: Text(
              'เกี่ยวกับเรา',
              style: GoogleFonts.prompt(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF323130),
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left: 30.w, top: 15.w),
            leading: Icon(
              Icons.logout,
              size: 24.sp,
              color: const Color(0xFF323130),
            ),
            title: Text(
              'ออกจากระบบ',
              style: GoogleFonts.prompt(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF323130),
              ),
            ),
            onTap: () async {
              await auth.signOut();
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
          ),
          SizedBox(height: 10.h),
          Expanded(
              child: Opacity(
            opacity: 0.5, // 50% opacity
            child: Container(
              width: 200.w,
              height: screenSizeheight * 0.05.h,
              color: Colors.transparent,
            ),
          )),
          const Languagedrawer(),
          SizedBox(height: 69.h),
          // ElevatedButton.icon(
          //   style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
          //   onPressed: () {
          //     Navigator.pushAndRemoveUntil(
          //         context,
          //         MaterialPageRoute(builder: (context) => const LoginPage()),
          //         (Route<dynamic> route) => false);
          //   },
          //   label: Text(
          //     'ออกจากระบบ',
          //     style: GoogleFonts.prompt(
          //       color: const Color(0xFF323130),
          //       fontSize: 16.sp,
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          //   // icon: Icon(Icons.logout,
          //   //     color: const Color(0xFF323130), size: 20.sp)
          // ),
        ],
      ),
    );
  }
}
