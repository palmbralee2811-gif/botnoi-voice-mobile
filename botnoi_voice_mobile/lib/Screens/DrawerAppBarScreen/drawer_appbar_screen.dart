import 'package:botnoi_voice_mobile/Authentication/authentication_provider.dart';
import 'package:botnoi_voice_mobile/Screens/DrawerAppBarScreen/about_us_screen.dart';
import 'package:botnoi_voice_mobile/Screens/DrawerAppBarScreen/account_screen.dart';
import 'package:botnoi_voice_mobile/Screens/DrawerAppBarScreen/faq_screen.dart';
import 'package:botnoi_voice_mobile/Screens/DrawerAppBarScreen/review_screen.dart';
import 'package:botnoi_voice_mobile/Screens/SharedWidgets/gradient_icon.dart';
import 'package:botnoi_voice_mobile/Screens/SharedWidgets/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DrawerAppbar extends StatelessWidget {
  const DrawerAppbar({
    super.key,
    required this.screenSizeheight,
  });

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
            contentPadding: EdgeInsets.only(left: 30.w, top: 15.w, right: 30.w),
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        Provider.of<Authentication>(context).user!.photoURL!,
                      ),
                      backgroundColor: Colors.black,
                      radius: 20.0.r,
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
                  ' ${Provider.of<Authentication>(context).user!.displayName}',
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
                        ' ${Provider.of<Authentication>(context).user?.email ?? ' No email found'}',
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
            leading: GradientIcon(
              icon: Icons.account_circle_outlined,
              size: 24.sp,
              gradient: const LinearGradient(
                colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            title: GradientText(
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountScreen(),
                ),
              );
            },
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FaqScreen(),
                ),
              );
            },
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReviewScreen(),
                ),
              );
            },
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutUsScreen(),
                ),
              );
            },
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
              await Provider.of<Authentication>(context).signOut(context);
            },
          ),
          SizedBox(height: 10.h),
          Opacity(
            opacity: 0.5, // 50% opacity
            child: Container(
              width: 200.w,
              height: screenSizeheight * 0.05.h,
              color: Colors.transparent,
            ),
          ),
          //TODO: const Languagedrawer(),
          SizedBox(height: 69.h),
        ],
      ),
    );
  }
}
