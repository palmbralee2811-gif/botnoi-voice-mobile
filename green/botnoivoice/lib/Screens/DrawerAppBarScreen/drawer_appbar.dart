import 'package:botnoivoice/Authentication/authentication_provider.dart';
import 'package:botnoivoice/Screens/DrawerAppBarScreen/account_screen.dart';
import 'package:botnoivoice/Screens/GradientScreen/gradient_icon.dart';
import 'package:botnoivoice/Screens/GradientScreen/gradient_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DrawerAppbar extends StatelessWidget {
  const DrawerAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Authentication>(context, listen: false);
    User? user = FirebaseAuth.instance.currentUser;
    String? email = auth.getUserEmail(user);

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
                      backgroundImage: user?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : const AssetImage(
                                  'assets/app_icon/icon-foreground-432x432.png')
                              as ImageProvider<Object>,
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
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.displayName ?? 'No Name',
                            style: GoogleFonts.prompt(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF323130),
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            email ?? 'No email found',
                            style: GoogleFonts.prompt(
                              fontSize: 14.sp,
                              color: const Color(0xFF323130),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left: 30.w, top: 30.h),
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
            contentPadding: EdgeInsets.only(left: 30.w, top: 15.h),
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
            onTap: () async {
              const url = 'https://voice.botnoi.ai/payment';
              await launchUrlString(url, mode: LaunchMode.platformDefault);
            },
          ),
        ],
      ),
    );
  }
}
