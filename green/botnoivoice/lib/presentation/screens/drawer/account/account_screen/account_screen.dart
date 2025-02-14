import 'package:botnoivoice/presentation/constants/styles.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/screens/appbar/appbar_template.dart';
import 'package:botnoivoice/presentation/screens/drawer/account/account_screen/account_screen_helpers.dart';
import 'package:botnoivoice/presentation/screens/drawer/account/account_screen/user_info_row.dart';
import 'package:botnoivoice/presentation/screens/drawer/account/change_email_username_screen.dart';
import 'package:botnoivoice/presentation/screens/email/forget_password/forget_password_screen.dart';
import 'package:botnoivoice/presentation/screens/responsive/orientation_helper.dart';
import 'package:botnoivoice/presentation/widgets/button/email_delete_account_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String displayName = "Loading...";
  String userId = "Loading...";
  String email = "Loading...";
  bool isEmailHidden = true;
  static const kGreen = Color(0xFF00B900);
  static const kGray = Colors.grey;

  bool isEmailLoggedIn = false;
  bool isAppleLoggedIn = false;
  bool isGoogleLoggedIn = false;
  bool isLineLoggedIn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async =>
        await loadUserInfo(context, displayName, userId, email, isLineLoggedIn,
            isAppleLoggedIn, isGoogleLoggedIn, isEmailLoggedIn));
  }

  @override
  Widget build(BuildContext context) {
    final emailProvider =
        Provider.of<EmailLoginProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarTemplate(title: 'app_drawer.profile'.tr()),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w), //Frank แก้ไข
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: OrientationHelper.isLandscape ? 40.h : 20.h),
              Row(
                // จัดข้อความและไอคอนให้อยู่ในแนวเดียวกัน
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'account.login_with'.tr(), //เข้าสู่ระบบด้วย
                    style: GoogleFonts.prompt(
                      fontSize: OrientationHelper.isLandscape ? 10.sp : 14.sp,
                      fontWeight: FontWeight.w600,
                      color: kDark,
                    ),
                  ),
                  SizedBox(
                      width: OrientationHelper.isLandscape
                          ? 50.w
                          : 30.w), // ระยะห่างระหว่างข้อความและไอคอน
                  SvgPicture.asset(
                    'assets/images/auth_screen/email-icon.svg',
                    width: OrientationHelper.isLandscape ? 40.w : 20.w,
                    height: OrientationHelper.isLandscape ? 40.h : 20.h,
                    colorFilter: isEmailLoggedIn
                        ? null
                        : const ColorFilter.mode(kGray,
                            BlendMode.srcIn), // ใช้ colorFilter แทน color
                  ),
                  SizedBox(width: OrientationHelper.isLandscape ? 10.w : 10.w),
                  Container(
                    width: OrientationHelper.isLandscape ? 42.w : 32.w,
                    height: OrientationHelper.isLandscape ? 42.h : 32.h,
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
                        width: OrientationHelper.isLandscape
                            ? 34.w
                            : 24.w, // ปรับขนาดไอคอนให้เล็กลง
                        height: OrientationHelper.isLandscape
                            ? 34.h
                            : 24.h, // ปรับขนาดไอคอนให้เล็กลง
                        fit: BoxFit
                            .contain, // ทำให้ไอคอนถูกย่อให้พอดีกับพื้นที่ที่กำหนด
                      ),
                    ),
                  ),
                  SizedBox(width: OrientationHelper.isLandscape ? 10.w : 10.w),
                  SvgPicture.asset(
                    'assets/images/auth_screen/google-icon.svg',
                    width: OrientationHelper.isLandscape ? 42.w : 32.w,
                    height: OrientationHelper.isLandscape ? 42.h : 32.h,
                    colorFilter: isGoogleLoggedIn
                        ? null
                        : const ColorFilter.mode(kGray,
                            BlendMode.srcIn), // ใช้ colorFilter แทน color
                  ),
                  SizedBox(width: OrientationHelper.isLandscape ? 10.w : 10.w),
                  SvgPicture.asset(
                    'assets/images/auth_screen/apple-icon.svg',
                    width: OrientationHelper.isLandscape ? 52.w : 32.w,
                    height: OrientationHelper.isLandscape ? 52.h : 32.h,
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
                value: getDisplayUID(userId),
                icon: Icons.copy,
                onIconPressed: () {
                  copyUID(context, userId);
                },
                isValueOverflow: true, // จัดการข้อความยาวให้แสดง ...
              ),
              SizedBox(height: 16.h),
              UserInfoRow(
                title: 'account.email'.tr(), //อีเมล
                value: getMaskedEmail(isEmailHidden, email),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ChangeEmailUsernameScreen(),
                          ),
                        );
                      },
                    )
                  : UserInfoRow(
                      title: 'account.username'.tr(), //ชื่อผู้ใช้
                      value: displayName,
                    ),
              emailProvider.isLoggedIn &&
                      emailProvider.user?.providerData[0].providerId ==
                          'password'
                  ? UserInfoRow(
                      title: 'account.password'.tr(), //รหัสผ่าน
                      value: '********',
                      icon: Icons.edit_rounded,
                      onIconPressed: () async {
                        final hasPermission =
                            await checkEmailPermission(context);
                        if (hasPermission) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ForgetPasswordScreen(),
                            ),
                          );
                        }
                      },
                    )
                  : const UserInfoRow(
                      title: '', //ชื่อผู้ใช้
                      value: '',
                    ),
              SizedBox(height: OrientationHelper.isLandscape ? 24.h : 245.h),
              if (emailProvider.isLoggedIn &&
                  emailProvider.user?.providerData[0].providerId == 'password')
                const EmailDeleteAccountButton(),
              SizedBox(height: OrientationHelper.isLandscape ? 8.h : 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
