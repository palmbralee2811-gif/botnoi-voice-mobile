import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_username_api_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/screens/drawer/account/account_screen.dart';
import 'package:botnoivoice/presentation/screens/drawer/email_permission/email_permission_screen.dart';
import 'package:botnoivoice/presentation/screens/drawer/payment/payment_screen.dart';
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
        context.setLocale(Locale('th', 'TH'));
      } else if (_selectedLanguage == 'en') {
        context.setLocale(Locale('en', 'US'));
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
              'ข้อมูลส่วนตัว',
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
              'ราคาและโปรโมชั่น',
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
                  builder: (context) => const PaymentScreen(),
                ),
              );
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
              'ความปลอดภัย',
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
                'language'
                    .tr(), // You can replace this with any text you prefer
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

  // Function to show a bottom sheet for language selection
  void _showLanguageBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close Button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context); // Close the bottom sheet
                  },
                ),
              ),
              // Language Options
              ListTile(
                leading: Image.asset(
                  'assets/images/national_flag/english.png',
                  width: 24, // Flag size
                  height: 24,
                ),
                title: Text(
                  'English',
                  style: GoogleFonts.prompt(
                    fontSize: 18.sp,
                    fontWeight: _selectedLanguage == 'en'
                        ? FontWeight.w600
                        : FontWeight
                            .w400, // Apply bold weight for selected language
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'en';
                  });
                  context.setLocale(Locale('en', 'US'));
                  _saveLanguage('en');
                  Navigator.pop(
                      context); // Close the bottom sheet after selection
                },
              ),
              ListTile(
                leading: Image.asset(
                  'assets/images/national_flag/thai.png',
                  width: 24, // Flag size
                  height: 24,
                ),
                title: Text(
                  'ไทย',
                  style: GoogleFonts.prompt(
                    fontSize: 18.sp,
                    fontWeight: _selectedLanguage == 'th'
                        ? FontWeight.w600
                        : FontWeight
                            .w400, // Apply bold weight for selected language
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'th';
                  });
                  context.setLocale(Locale('th', 'TH'));
                  _saveLanguage('th');
                  Navigator.pop(
                      context); // Close the bottom sheet after selection
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
