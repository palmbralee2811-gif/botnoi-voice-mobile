import 'package:botnoivoice/presentation/constants/styles.dart';
import 'package:botnoivoice/presentation/providers/apple/apple_login_provider.dart';
import 'package:botnoivoice/presentation/providers/apple/apple_token_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_token_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_username_api_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_token_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_token_provider.dart';
import 'package:botnoivoice/presentation/screens/drawer/account/account_screen.dart';
import 'package:botnoivoice/presentation/screens/drawer/coupon/redeem_coupon.dart';
import 'package:botnoivoice/presentation/screens/drawer/email_permission/email_permission_screen.dart';
import 'package:botnoivoice/presentation/screens/responsive/orientation_helper.dart';
import 'package:botnoivoice/presentation/widgets/dialog/payment/payment_dialog.dart';
import 'package:botnoivoice/presentation/widgets/language/language_selection_drawer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerAppbar extends StatefulWidget {
  const DrawerAppbar({super.key});

  @override
  State<DrawerAppbar> createState() => _DrawerAppbarState();
}

class _DrawerAppbarState extends State<DrawerAppbar> {
  String displayName = "Loading...";
  String uid = "Loading...";
  String profilePictureUrl = "";
  String selectedLanguage = 'th'; // ภาษาดั้งเดิมคือ ไทย

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await _loadUserInfo());
  }

  // บันทึกภาษาที่เลือกไว้ไปยัง SharedPreferences
  _saveLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', language);
  }

  Future<void> _loadUserInfo() async {
    // Fetch user data from Firebase
    var appleProvider = Provider.of<AppleLoginProvider>(context, listen: false);
    var googleProvider =
        Provider.of<GoogleLoginProvider>(context, listen: false);
    var lineProvider = Provider.of<LineLoginProvider>(context, listen: false);
    var emailProvider = Provider.of<EmailLoginProvider>(context, listen: false);

    // Fetch user data from Database (API)
    var appleTokenProvider =
        Provider.of<AppleTokenProvider>(context, listen: false);
    var googleTokenProvider =
        Provider.of<GoogleTokenProvider>(context, listen: false);
    var lineTokenProvider =
        Provider.of<LineTokenProvider>(context, listen: false);
    var emailTokenProvider =
        Provider.of<EmailTokenProvider>(context, listen: false);

    if (lineProvider.isLoggedIn) {
      String? lineDisplayName = lineProvider.getDisplayName;
      String? lineUid = lineTokenProvider.getUserID;
      String? lineProfilePictureUrl = lineProvider.getProfilePictureUrl;

      setState(() {
        displayName = lineDisplayName ?? 'No Name';
        uid = lineUid ?? 'No uid found';
        profilePictureUrl = lineProfilePictureUrl ?? '';
      });
    } else if (appleProvider.isLoggedIn &&
        appleProvider.user?.providerData[0].providerId == 'apple.com') {
      setState(() {
        displayName = appleProvider.user?.displayName ?? 'Apple User';
        uid = appleTokenProvider.getUserID ?? 'No uid found';
        profilePictureUrl = appleProvider.user?.photoURL ?? '';
      });
    } else if (googleProvider.isLoggedIn &&
        googleProvider.user?.providerData[0].providerId == 'google.com') {
      setState(() {
        displayName = googleProvider.user?.displayName ?? 'No Name';
        uid = googleTokenProvider.getUserID ?? 'No uid found';
        profilePictureUrl = googleProvider.user?.photoURL ?? '';
      });
    } else if (emailProvider.isLoggedIn &&
        emailProvider.user?.providerData[0].providerId == 'password') {
      setState(() {
        displayName =
            Provider.of<EmailUsernameApiProvider>(context, listen: false)
                    .getUsername ??
                "Unknown";
        uid = emailTokenProvider.getUserID ?? "No UID";
        profilePictureUrl = emailProvider.user?.photoURL ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailProvider =
        Provider.of<EmailLoginProvider>(context, listen: false);

    return Drawer(
      width: 257.w,
      elevation: 16,
      backgroundColor: Colors.white,
      shadowColor: Colors.black,
      child: ListView(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.only(
                left: OrientationHelper.isLandscape ? 20.w : 30.w,
                top: 15.w,
                right: 30.w),
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: OrientationHelper.isLandscape ? 22.w : 56.w,
                      height: OrientationHelper.isLandscape ? 76.h : 56.h,
                      child: CircleAvatar(
                        backgroundImage: profilePictureUrl.isNotEmpty
                            ? NetworkImage(profilePictureUrl)
                            : const AssetImage(
                                    'assets/images/default-profile-picture.jpg')
                                as ImageProvider<Object>,
                        backgroundColor: Colors.black,
                        radius: OrientationHelper.isLandscape ? 15.0.r : 20.0.r,
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
                        Icons.menu_sharp,
                        color: kDark,
                        size: OrientationHelper.isLandscape ? 22.sp : 32.sp,
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
                              fontSize:
                                  OrientationHelper.isLandscape ? 16.sp : 24.sp,
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
                              fontSize:
                                  OrientationHelper.isLandscape ? 8.sp : 14.sp,
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
                left: OrientationHelper.isLandscape ? 20.w : 30.w,
                top: OrientationHelper.isLandscape ? 10.h : 30.h),
            leading: Icon(
              Icons.account_circle_outlined,
              size: OrientationHelper.isLandscape ? 16.sp : 24.sp,
              color: kDark,
            ),
            title: Text(
              'app_drawer.profile'.tr(), //ข้อมูลส่วนตัว
              style: GoogleFonts.prompt(
                fontSize: OrientationHelper.isLandscape ? 13.sp : 20.sp,
                fontWeight: FontWeight.w600,
                color: kDark,
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
          SizedBox(height: 10.h),
          ListTile(
            contentPadding: EdgeInsets.only(
                left: OrientationHelper.isLandscape ? 20.w : 30.w),
            leading: Icon(
              Icons.card_giftcard_outlined,
              size: OrientationHelper.isLandscape ? 16.sp : 24.sp,
              color: kDark,
            ),
            title: Text(
              'app_drawer.redeem'.tr(), //รับพอยต์ฟรี
              style: GoogleFonts.prompt(
                fontSize: OrientationHelper.isLandscape ? 13.sp : 20.sp,
                fontWeight: FontWeight.w600,
                color: kDark,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RedeemCoupon(),
                ),
              );
            },
          ),
          SizedBox(height: 10.h),
          ListTile(
            contentPadding: EdgeInsets.only(
                left: OrientationHelper.isLandscape ? 20.w : 30.w),
            leading: Icon(
              Icons.credit_card,
              size: OrientationHelper.isLandscape ? 16.sp : 24.sp,
              color: kDark,
            ),
            title: Text(
              'app_drawer.buy_points'.tr(), //ซื้อพ้อยท์
              style: GoogleFonts.prompt(
                fontSize: OrientationHelper.isLandscape ? 13.sp : 20.sp,
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
                  left: OrientationHelper.isLandscape ? 20.w : 30.w),
              leading: Icon(
                Icons.security_outlined,
                size: OrientationHelper.isLandscape ? 16.sp : 24.sp,
                color: kDark,
              ),
              title: Text(
                'app_drawer.security'.tr(), //ความปลอดภัย
                style: GoogleFonts.prompt(
                  fontSize: OrientationHelper.isLandscape ? 13.sp : 20.sp,
                  fontWeight: FontWeight.w600,
                  color: kDark,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmailPermissionScreen(),
                  ),
                );
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
                  _saveLanguage(language); // Save the language if needed
                },
              );
            },
            child: ListTile(
              contentPadding: EdgeInsets.only(
                  left: OrientationHelper.isLandscape ? 20.w : 30.w),
              leading: Icon(
                Icons.language,
                size: OrientationHelper.isLandscape ? 16.sp : 24.sp,
                color: kDark,
              ),
              title: Text(
                'language'.tr(),
                style: GoogleFonts.prompt(
                  fontSize: OrientationHelper.isLandscape ? 13.sp : 20.sp,
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
