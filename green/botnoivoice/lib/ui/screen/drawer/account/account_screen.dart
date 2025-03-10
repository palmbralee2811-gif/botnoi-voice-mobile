import 'package:botnoivoice/ui/style/style.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/ui/screen/appbar/appbar_template.dart';
import 'package:botnoivoice/ui/screen/drawer/account/account_screen_logic.dart';
import 'package:botnoivoice/ui/screen/drawer/account/user_info_row.dart';
import 'package:botnoivoice/ui/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/ui/widget/button/email_delete_account_button.dart';
import 'package:botnoivoice/ui/widget/gradient/gradient_text_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AccountScreenLogic _logic = AccountScreenLogic();
  String displayName = "Loading...";
  String userId = "Loading..."; // UID ที่จะแสดงผล
  String email = "Loading...";
  bool isEmailHidden = true; // ตัวแปรเก็บสถานะว่าควรซ่อนอีเมลหรือไม่
  static const kGreen = Color(0xFF00B900); // สีเขียวสำหรับพื้นหลังไอคอน
  static const kGray = Colors.grey; // สีเทาสำหรับไอคอนที่ไม่ได้ล็อกอินด้วย

  bool isEmailLoggedIn = false;
  bool isAppleLoggedIn = false;
  bool isGoogleLoggedIn = false;
  bool isLineLoggedIn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _logic.loadUserInfo(
        context: context,
        onUpdateState: (String newDisplayName,
            String newUserId,
            String newEmail,
            bool emailLoggedIn,
            bool appleLoggedIn,
            bool googleLoggedIn,
            bool lineLoggedIn) {
          setState(() {
            displayName = newDisplayName;
            userId = newUserId;
            email = newEmail;
            isEmailLoggedIn = emailLoggedIn;
            isAppleLoggedIn = appleLoggedIn;
            isGoogleLoggedIn = googleLoggedIn;
            isLineLoggedIn = lineLoggedIn;
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final emailProvider = Provider.of<EmailLogin>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarTemplate(
        title: 'app_drawer.profile'.tr(),
        onPressed: () {
          // Redirect to HomeScreen
          context.go('/home');
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w), //Frank แก้ไข
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height:
                      ResponsiveDesignOrientation.isLandscape ? 40.h : 20.h),
              Row(
                // จัดข้อความและไอคอนให้อยู่ในแนวเดียวกัน
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'account.login_with'.tr(), //เข้าสู่ระบบด้วย
                    style: GoogleFonts.prompt(
                      fontSize: ResponsiveDesignOrientation.isLandscape
                          ? 10.sp
                          : 14.sp,
                      fontWeight: FontWeight.w600,
                      color: kDark,
                    ),
                  ),
                  SizedBox(
                      width: ResponsiveDesignOrientation.isLandscape
                          ? 50.w
                          : 25.w), // ระยะห่างระหว่างข้อความและไอคอน
                  SvgPicture.asset(
                    'assets/images/auth_screen/email-icon.svg',
                    width:
                        ResponsiveDesignOrientation.isLandscape ? 40.w : 20.w,
                    height:
                        ResponsiveDesignOrientation.isLandscape ? 40.h : 20.h,
                    colorFilter: isEmailLoggedIn
                        ? null
                        : const ColorFilter.mode(kGray,
                            BlendMode.srcIn), // ใช้ colorFilter แทน color
                  ),
                  SizedBox(
                      width: ResponsiveDesignOrientation.isLandscape
                          ? 10.w
                          : 10.w),
                  Container(
                    width:
                        ResponsiveDesignOrientation.isLandscape ? 42.w : 32.w,
                    height:
                        ResponsiveDesignOrientation.isLandscape ? 42.h : 32.h,
                    decoration: BoxDecoration(
                      color: isLineLoggedIn
                          ? kGreen
                          : kGray, // เปลี่ยนเป็นสีเทาถ้าไม่ใช่ LINE
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      // ทำให้ไอคอนอยู่ตรงกลาง
                      child: SvgPicture.asset(
                        'assets/images/auth_screen/line-icon.svg',
                        width: ResponsiveDesignOrientation.isLandscape
                            ? 34.w
                            : 24.w, // ปรับขนาดไอคอนให้เล็กลง
                        height: ResponsiveDesignOrientation.isLandscape
                            ? 34.h
                            : 24.h, // ปรับขนาดไอคอนให้เล็กลง
                        fit: BoxFit
                            .contain, // ทำให้ไอคอนถูกย่อให้พอดีกับพื้นที่ที่กำหนด
                      ),
                    ),
                  ),
                  SizedBox(
                      width: ResponsiveDesignOrientation.isLandscape
                          ? 10.w
                          : 10.w),
                  SvgPicture.asset(
                    'assets/images/auth_screen/google-icon.svg',
                    width:
                        ResponsiveDesignOrientation.isLandscape ? 42.w : 32.w,
                    height:
                        ResponsiveDesignOrientation.isLandscape ? 42.h : 32.h,
                    colorFilter: isGoogleLoggedIn
                        ? null
                        : const ColorFilter.mode(kGray,
                            BlendMode.srcIn), // ใช้ colorFilter แทน color
                  ),
                  SizedBox(
                      width: ResponsiveDesignOrientation.isLandscape
                          ? 10.w
                          : 10.w),
                  SvgPicture.asset(
                    'assets/images/auth_screen/apple-icon.svg',
                    width:
                        ResponsiveDesignOrientation.isLandscape ? 52.w : 32.w,
                    height:
                        ResponsiveDesignOrientation.isLandscape ? 52.h : 32.h,
                    colorFilter: isAppleLoggedIn
                        ? null
                        : const ColorFilter.mode(kGray,
                            BlendMode.srcIn), // ใช้ colorFilter แทน color
                  ),
                ],
              ),
              SizedBox(height: 24.h), // ปรับระยะห่างระหว่างแถวให้เหมาะสม
              UserInfoRow(
                title: 'UID',
                value: _logic.getDisplayUID(userId),
                icon: Icons.copy,
                onIconPressed: () {
                  _logic.copyUID(context, userId);
                },
                isValueOverflow: true, // จัดการข้อความยาวให้แสดง ...
              ),
              SizedBox(height: 16.h),
              UserInfoRow(
                title: 'account.email'.tr(), //อีเมล
                value: _logic.getMaskedEmail(isEmailHidden, email),
                icon: isEmailHidden ? Icons.visibility_off : Icons.visibility,
                onIconPressed: () {
                  setState(() {
                    isEmailHidden = !isEmailHidden;
                  });
                },
              ),
              SizedBox(height: 16.h),
              emailProvider.isLoggedIn &&
                      emailProvider.user?.providerData[0].providerId ==
                          'password'
                  ? UserInfoRow(
                      title: 'account.username'.tr(), //ชื่อผู้ใช้
                      value: displayName,
                      icon: Icons.edit_rounded,
                      onIconPressed: () {
                        // Redirect to ChangeEmailUsernameScreen
                        context.go('/change-email-username');
                      },
                    )
                  : UserInfoRow(
                      title: 'account.username'.tr(), //ชื่อผู้ใช้
                      value: displayName,
                    ),
              SizedBox(
                  height:
                      ResponsiveDesignOrientation.isLandscape ? 24.h : 150.h),
              // const Spacer(),
              GradientTextButton(
                text: 'account.logout'.tr(), //ออกจากระบบ
                onPressed: () async {
                  await _logic.signOut(context);
                },
              ),
              SizedBox(
                  height: ResponsiveDesignOrientation.isLandscape ? 6.h : 16.h),
              if (emailProvider.isLoggedIn &&
                  emailProvider.user?.providerData[0].providerId == 'password')
                const EmailDeleteAccountButton(),
              SizedBox(
                  height: ResponsiveDesignOrientation.isLandscape ? 8.h : 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
