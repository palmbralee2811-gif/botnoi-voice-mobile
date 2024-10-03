import 'dart:io';

import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/providers/google/get_user_email.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/screens/drawer/account_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DrawerAppbar extends StatefulWidget {
  const DrawerAppbar({super.key});

  @override
  State<DrawerAppbar> createState() => _DrawerAppbarState();
}

class _DrawerAppbarState extends State<DrawerAppbar> {
  User? googleUser = FirebaseAuth.instance.currentUser;
  String displayName = "Loading...";
  String email = "Loading...";
  String profilePictureUrl = "";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await _loadUserInfo());
  }

  Future<void> _loadUserInfo() async {
    var lineProvider = Provider.of<LineLoginProvider>(context, listen: false);
    var emailProvider = Provider.of<EmailLoginProvider>(context, listen: false);

    if (lineProvider.isLoggedIn) {
      String? lineDisplayName = lineProvider.getDisplayName;
      String? lineEmail = lineProvider.getLineEmail;
      String? lineProfilePictureUrl = lineProvider.getProfilePictureUrl;

      setState(() {
        displayName = lineDisplayName ?? 'No Name';
        email = lineEmail ?? 'No email found';
        profilePictureUrl = lineProfilePictureUrl ?? '';
      });
    } else if (googleUser != null) {
      setState(() {
        displayName = googleUser?.displayName ?? 'No Name';
        email = getUserEmail(googleUser) ?? 'No email found';
        profilePictureUrl = googleUser?.photoURL ?? '';
      });
    } else if (emailProvider.isLoggedIn) {
      setState(() {
        displayName = emailProvider.currentUser?.displayName ?? 'No Name';
        email = emailProvider.currentUser?.email ?? 'No email found';
        profilePictureUrl = emailProvider.currentUser?.photoURL ?? '';
      });
    }
  }

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
                      backgroundImage: profilePictureUrl.isNotEmpty
                          ? NetworkImage(profilePictureUrl)
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
                            displayName,
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
                            email,
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
            leading: Icon(
              Icons.account_circle_outlined,
              size: 24.sp,
              color: const Color(0xFF323130),
            ),
            title: Text(
              'ข้อมูลส่วนตัว',
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
              if (Platform.isAndroid) {
                await launchUrlString('https://voice.botnoi.ai/payment',
                    mode: LaunchMode.platformDefault);
              }
            },
          ),
        ],
      ),
    );
  }
}
