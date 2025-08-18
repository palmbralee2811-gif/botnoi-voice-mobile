import 'package:botnoivoice/shared/function/app_language_function.dart';
import 'package:botnoivoice/shared/style/style.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/screen/drawer/drawer_appbar_logic.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/shared/dialog/payment/payment_dialog.dart';
import 'package:botnoivoice/screen/drawer/app_language_selection/app_language_selection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DrawerAppbar extends StatefulWidget {
  const DrawerAppbar({super.key});

  @override
  State<DrawerAppbar> createState() => _DrawerAppbarState();
}

class _DrawerAppbarState extends State<DrawerAppbar> {
  final DrawerAppbarLogic _logic = DrawerAppbarLogic();
  String displayName = "Loading...";
  String uid = "Loading...";
  String profilePictureUrl = "";
  String selectedLanguage = 'th'; // Default language

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _logic.loadUserInfo(
        context: context,
        onUpdateState: (String newDisplayName, String newUid,
            String newProfilePictureUrl) {
          setState(() {
            displayName = newDisplayName;
            uid = newUid;
            profilePictureUrl = newProfilePictureUrl;
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final emailProvider = context.read<EmailLogin>();

    return Drawer(
      width: 257.w,
      elevation: 16,
      backgroundColor: Colors.white,
      shadowColor: Colors.black,
      child: ListView(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.only(
                left: ResponsiveDesignOrientation.isLandscape ? 20.w : 30.w,
                top: 15.w,
                right: 30.w),
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width:
                          ResponsiveDesignOrientation.isLandscape ? 22.w : 56.w,
                      height:
                          ResponsiveDesignOrientation.isLandscape ? 76.h : 56.h,
                      child: CircleAvatar(
                        backgroundImage: profilePictureUrl.isNotEmpty
                            ? NetworkImage(profilePictureUrl)
                            : const AssetImage(
                                    'assets/images/default-profile-picture.jpg')
                                as ImageProvider<Object>,
                        backgroundColor: Colors.black,
                        radius: ResponsiveDesignOrientation.isLandscape
                            ? 15.0.r
                            : 20.0.r,
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(fontSize: 10.sp),
                      ),
                      onPressed: () {
                        // Close Drawer
                        context.pop();
                      },
                      child: Icon(
                        Icons.menu_sharp,
                        color: kDark,
                        size: ResponsiveDesignOrientation.isLandscape
                            ? 22.sp
                            : 32.sp,
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
                              fontSize: ResponsiveDesignOrientation.isLandscape
                                  ? 16.sp
                                  : 24.sp,
                              fontWeight: FontWeight.w600,
                              color: kDark,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'UID: $uid',
                            style: GoogleFonts.prompt(
                              fontSize: ResponsiveDesignOrientation.isLandscape
                                  ? 8.sp
                                  : 14.sp,
                              fontWeight: FontWeight.w400,
                              color: kDark,
                            ),
                            maxLines: 5,
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
            contentPadding: EdgeInsets.only(
                left: ResponsiveDesignOrientation.isLandscape ? 20.w : 30.w,
                top: ResponsiveDesignOrientation.isLandscape ? 10.h : 30.h),
            leading: Icon(
              Icons.account_circle_outlined,
              size: ResponsiveDesignOrientation.isLandscape ? 16.sp : 24.sp,
              color: kDark,
            ),
            title: Text(
              'app_drawer.profile'.tr(), //ข้อมูลส่วนตัว
              style: GoogleFonts.prompt(
                fontSize:
                    ResponsiveDesignOrientation.isLandscape ? 13.sp : 20.sp,
                fontWeight: FontWeight.w600,
                color: kDark,
              ),
            ),
            onTap: () {
              context.push('/account');
            },
          ),
          SizedBox(height: 10.h),
          ListTile(
            contentPadding: EdgeInsets.only(
                left: ResponsiveDesignOrientation.isLandscape ? 20.w : 30.w),
            leading: Icon(
              Icons.card_giftcard_outlined,
              size: ResponsiveDesignOrientation.isLandscape ? 16.sp : 24.sp,
              color: kDark,
            ),
            title: Text(
              'app_drawer.reward'.tr(), //รับพอยต์ฟรี
              style: GoogleFonts.prompt(
                fontSize:
                    ResponsiveDesignOrientation.isLandscape ? 13.sp : 20.sp,
                fontWeight: FontWeight.w600,
                color: kDark,
              ),
            ),
            onTap: () {
              context.push('/reward');
            },
          ),
          SizedBox(height: 10.h),

           //Education Section
          ListTile(
            contentPadding: EdgeInsets.only(
                left: ResponsiveDesignOrientation.isLandscape ? 20.w : 30.w),
            leading: Icon(
              Icons.school_outlined, // ไอคอนหมวกรับปริญญา
              size: ResponsiveDesignOrientation.isLandscape ? 16.sp : 24.sp,
              color: kDark,
            ),
            title: Text(
              'app_drawer.education'.tr(), // Education
              style: GoogleFonts.prompt(
                fontSize:
                    ResponsiveDesignOrientation.isLandscape ? 13.sp : 20.sp,
                fontWeight: FontWeight.w600,
                color: kDark,
              ),
            ),
            onTap: () {
              context.push('/education');
            },
          ),
          SizedBox(height: 10.h),

          ListTile(
            contentPadding: EdgeInsets.only(
                left: ResponsiveDesignOrientation.isLandscape ? 20.w : 30.w),
            leading: Icon(
              Icons.credit_card,
              size: ResponsiveDesignOrientation.isLandscape ? 16.sp : 24.sp,
              color: kDark,
            ),
            title: Text(
              'app_drawer.buy_points'.tr(), //ซื้อพ้อยท์
              style: GoogleFonts.prompt(
                fontSize:
                    ResponsiveDesignOrientation.isLandscape ? 13.sp : 20.sp,
                fontWeight: FontWeight.w600,
                color: kDark,
              ),
            ),
            onTap: () {
              showPaymentDialog(context);
            },
          ),
          SizedBox(height: 10.h),
          if (emailProvider.isLoggedIn &&
              emailProvider.user?.providerData[0].providerId == 'password')
            ListTile(
              contentPadding: EdgeInsets.only(
                  left: ResponsiveDesignOrientation.isLandscape ? 20.w : 30.w),
              leading: Icon(
                Icons.security_outlined,
                size: ResponsiveDesignOrientation.isLandscape ? 16.sp : 24.sp,
                color: kDark,
              ),
              title: Text(
                'app_drawer.security'.tr(), //ความปลอดภัย
                style: GoogleFonts.prompt(
                  fontSize:
                      ResponsiveDesignOrientation.isLandscape ? 13.sp : 20.sp,
                  fontWeight: FontWeight.w600,
                  color: kDark,
                ),
              ),
              onTap: () {
                // Redirect EmailPermissionScreen
                context.push('/email-permission');
              },
            ),
          if (emailProvider.isLoggedIn &&
              emailProvider.user?.providerData[0].providerId == 'password')
            SizedBox(height: 10.h),
          InkWell(
            onTap: () {
              // Show the reusable bottom sheet for language selection
              showLanguageBottomSheet(
                context: context,
                onLanguageSelected: (language) {
                  setState(() {
                    selectedLanguage = language; // Update the selected language
                  });
                  saveSelectedLanguage(language); // Save the selected language
                },
              );
            },
            child: ListTile(
              contentPadding: EdgeInsets.only(
                  left: ResponsiveDesignOrientation.isLandscape ? 20.w : 30.w),
              leading: Icon(
                Icons.language,
                size: ResponsiveDesignOrientation.isLandscape ? 16.sp : 24.sp,
                color: kDark,
              ),
              title: Text(
                'language'.tr(),
                style: GoogleFonts.prompt(
                  fontSize:
                      ResponsiveDesignOrientation.isLandscape ? 13.sp : 20.sp,
                  fontWeight: FontWeight.w600,
                  color: kDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
