import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_username_api_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/screens/drawer/account/account_screen.dart';
import 'package:botnoivoice/presentation/screens/drawer/email_permission/email_permission_screen.dart';
import 'package:botnoivoice/presentation/widgets/dialog/payment/payment_dialog.dart';
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
  String _selectedLanguage = 'th'; // Default language (Thai)

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await _loadUserInfo());
  }

  // Load saved language from SharedPreferences
  _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLanguage = prefs.getString('selected_language');
    if (savedLanguage != null) {
      setState(() {
        _selectedLanguage = savedLanguage; // Set the selected language
      });
      // Set the locale based on the saved language
      if (_selectedLanguage == 'th') {
        context.setLocale(const Locale('th', 'TH'));
      } else if (_selectedLanguage == 'en') {
        context.setLocale(const Locale('en', 'US'));
      }
    }
  }

  // Save selected language to SharedPreferences
  _saveLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', language);
  }

  Future<void> _loadUserInfo() async {
    var googleProvider =
        Provider.of<GoogleLoginProvider>(context, listen: false);
    var lineProvider = Provider.of<LineLoginProvider>(context, listen: false);
    var emailProvider = Provider.of<EmailLoginProvider>(context, listen: false);

    if (lineProvider.isLoggedIn) {
      String? lineDisplayName = lineProvider.getDisplayName;
      String? lineUid = lineProvider.getLineUserId;
      String? lineProfilePictureUrl = lineProvider.getProfilePictureUrl;

      setState(() {
        displayName = lineDisplayName ?? 'No Name';
        uid = lineUid ?? 'No uid found';
        profilePictureUrl = lineProfilePictureUrl ?? '';
      });
    } else if (googleProvider.isLoggedIn &&
        googleProvider.user?.providerData[0].providerId == 'google.com') {
      setState(() {
        displayName = googleProvider.user?.displayName ?? 'No email found';
        uid = googleProvider.user?.uid ?? 'No uid found';
        profilePictureUrl = googleProvider.user?.photoURL ?? 'No email found';
      });
    } else if (emailProvider.isLoggedIn &&
        emailProvider.user?.providerData[0].providerId == 'password') {
      setState(() {
        displayName =
            Provider.of<EmailUsernameApiProvider>(context, listen: false)
                    .getUsername ??
                "Unknown";
        uid = emailProvider.user?.uid ?? "No UID";
        profilePictureUrl = emailProvider.user?.photoURL ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 257.w,
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
                    SizedBox(
                      width: 56.w,
                      height: 56.h,
                      child: CircleAvatar(
                        backgroundImage: profilePictureUrl.isNotEmpty
                            ? NetworkImage(profilePictureUrl)
                            : const AssetImage(
                                    'assets/images/default-profile-picture.jpg')
                                as ImageProvider<Object>,
                        backgroundColor: Colors.black,
                        radius: 20.0.r,
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
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF323130),
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'UID: $uid',
                            style: GoogleFonts.prompt(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
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
              'app_drawer.profile'.tr(), //ข้อมูลส่วนตัว
              style: GoogleFonts.prompt(
                fontSize: 20.sp,
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
          SizedBox(height: 10.h),
          ListTile(
            contentPadding: EdgeInsets.only(left: 30.w),
            leading: Icon(
              Icons.credit_card,
              size: 24.sp,
              color: const Color(0xFF323130),
            ),
            title: Text(
              'app_drawer.buy_points'.tr(), //ซื้อพ้อยท์
              style: GoogleFonts.prompt(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF323130),
              ),
            ),
            onTap: () {
              showPaymentDialog(context);
            },
          ),
          SizedBox(height: 10.h),
          ListTile(
            contentPadding: EdgeInsets.only(left: 30.w),
            leading: Icon(
              Icons.security_outlined,
              size: 24.sp,
              color: const Color(0xFF323130),
            ),
            title: Text(
              'app_drawer.security'.tr(), //ความปลอดภัย
              style: GoogleFonts.prompt(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF323130),
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
          SizedBox(height: 10.h),
          InkWell(
            onTap: () {
              // Show bottom sheet to select language
              _showLanguageBottomSheet();
            },
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 30.w),
              leading: Icon(
                Icons.language,
                size: 24.sp,
                color: const Color(0xFF323130),
              ),
              title: Text(
                'language'.tr(),
                style: GoogleFonts.prompt(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF323130),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

ฝ
}
