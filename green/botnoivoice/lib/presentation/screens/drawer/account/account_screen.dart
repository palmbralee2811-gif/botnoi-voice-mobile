import 'package:botnoivoice/data/authentication/auth_checker.dart';
import 'package:botnoivoice/presentation/providers/apple/apple_login_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_forget_password_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_token_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_username_api_provider.dart';
import 'package:botnoivoice/presentation/providers/google/get_user_email.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/providers/user/user_info_provider.dart';
import 'package:botnoivoice/presentation/screens/drawer/account/change_email_username_screen.dart';
import 'package:botnoivoice/presentation/screens/email/forget_password/forget_password_screen.dart';
import 'package:botnoivoice/presentation/screens/responsive/orientation_helper.dart';
import 'package:botnoivoice/presentation/widgets/button/email_delete_account_button.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await _loadUserInfo());
  }

  /// ฟังก์ชันสำหรับโหลดข้อมูลผู้ใช้
  Future<void> _loadUserInfo() async {
    // Fetch user data from Firebase
    var appleProvider = Provider.of<AppleLoginProvider>(context, listen: false);
    var googleProvider = Provider.of<GoogleLoginProvider>(context, listen: false);
    var lineProvider = Provider.of<LineLoginProvider>(context, listen: false);
    var emailProvider = Provider.of<EmailLoginProvider>(context, listen: false);
    var userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);

    // Fetch user data from Database (API)
    var emailTokenProvider = Provider.of<EmailTokenProvider>(context, listen: false);

    if (lineProvider.isLoggedIn) {
      displayName = lineProvider.getDisplayName ?? "Line User";
      userId = lineProvider.getLineUserId ?? "No UID";
      email = lineProvider.getLineEmail ?? "No email found";
      isLineLoggedIn = true;
    } else if (appleProvider.isLoggedIn &&
        appleProvider.user?.providerData[0].providerId == 'apple.com') {
      displayName = appleProvider.user?.displayName ?? 'Apple User';
      userId = appleProvider.user?.uid ?? 'No UID';
      email =
          getUserEmail(FirebaseAuth.instance.currentUser) ?? 'No email found';
      isAppleLoggedIn = true;
    } else if (googleProvider.isLoggedIn &&
        googleProvider.user?.providerData[0].providerId == 'google.com') {
      displayName = googleProvider.user?.displayName ?? 'Google User';
      userId = googleProvider.user?.uid ?? 'No UID';
      email =
          getUserEmail(FirebaseAuth.instance.currentUser) ?? 'No email found';
      isGoogleLoggedIn = true;
    } else if (emailProvider.isLoggedIn && emailProvider.user?.providerData[0].providerId == 'password') {
      userId = emailTokenProvider.getUserID ?? "No UID";
      displayName = Provider.of<EmailUsernameApiProvider>(context, listen: false).getUsername ?? "Email/Username User";

      // ตรวจสอบการอนุญาตในการแสดงอีเมล
      if (userInfoProvider.isShowEmail) {
        email = emailProvider.user?.email ?? "No email found";
      } else {
        email = "Email Permission is Disabled.";
      }
      isEmailLoggedIn = true;
    }

    setState(() {}); // อัพเดต UI เมื่อข้อมูลถูกโหลดเสร็จสิ้น
  }

  /// ฟังก์ชันสำหรับการออกจากระบบ
  Future<void> _signOut(BuildContext context) async {
    final appleProvider =
        Provider.of<AppleLoginProvider>(context, listen: false);
    final googleProvider =
        Provider.of<GoogleLoginProvider>(context, listen: false);
    final lineProvider = Provider.of<LineLoginProvider>(context, listen: false);
    final emailProvider =
        Provider.of<EmailLoginProvider>(context, listen: false);

    if (appleProvider.isLoggedIn &&
        appleProvider.user?.providerData[0].providerId == 'apple.com') {
      await appleProvider.signOutWithApple(context);
    }

    if (googleProvider.isLoggedIn &&
        googleProvider.user?.providerData[0].providerId == 'google.com') {
      await googleProvider.signOutWithGoogle(context);
    }

    if (lineProvider.isLoggedIn) {
      await lineProvider.signOutWithLine(context);
    }

    if (emailProvider.isLoggedIn &&
        emailProvider.user?.providerData[0].providerId == 'password') {
      await emailProvider.signOutWithEmail(context);
    }

    // Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => AuthChecker(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  /// ฟังก์ชันสำหรับซ่อนอีเมล
  String getMaskedEmail() {
    if (isEmailHidden) {
      var atIndex = email.indexOf('@'); // หาตำแหน่งของ '@'
      if (atIndex > 0) {
        // ซ่อนทุกตัวอักษรก่อน '@' โดยใช้จำนวน '*' เท่ากับจำนวนตัวอักษรใน username
        return '*' * atIndex + email.substring(atIndex);
      } else {
        return "********"; // กรณีที่ไม่สามารถหาตำแหน่ง '@' ได้
      }
    }
    return email; // เปิดเผยอีเมลเต็มเมื่อ isEmailHidden เป็น false
  }

  /// ฟังก์ชันสำหรับตัด UID ให้แสดง 15 ตัวอักษรแรก
  // String getDisplayUID(String uid) {
  //   if (uid.length > 15) {
  //     return '${uid.substring(0, 15)}...'; // แสดงเฉพาะ 15 ตัวอักษรแรก
  //   }
  //   return uid; // แสดง UID ปกติหากไม่เกิน 15 ตัวอักษร
  // }

  /// ฟังก์ชันคัดลอก UID
  void _copyUID() {
    Clipboard.setData(ClipboardData(text: userId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('account.uid_copy_success'.tr())), //UID คัดลอกเรียบร้อยแล้ว
    );
  }

  /// Function to check if the user has permission to view the email
  Future<bool> _checkEmailPermission() async {
    final emailForgetPassword =
        Provider.of<EmailForgetPasswordProvider>(context, listen: false);

    final hasEmailPermission =
        await emailForgetPassword.checkShowEmail(context);
    return hasEmailPermission; // Return TRUE or FALSE
  }

  @override
  Widget build(BuildContext context) {
    final emailProvider =
        Provider.of<EmailLoginProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'account.profile'.tr(), //ข้อมูลส่วนตัว
          style: GoogleFonts.prompt(
              fontSize: OrientationHelper.isLandscape ? 12.sp : 12.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF323130)),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: const Color(0xFF323130),
            size: OrientationHelper.isLandscape ? 10.sp : 24.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                    color: const Color(0xFF323130),
                  ),
                ),
                SizedBox(width: OrientationHelper.isLandscape ? 90.w : 30.w), // ระยะห่างระหว่างข้อความและไอคอน
                SvgPicture.asset(
                  'assets/images/auth_screen/email-icon.svg',
                  width: OrientationHelper.isLandscape ? 40.w : 20.w,
                  height: OrientationHelper.isLandscape ? 40.h : 20.h,
                  colorFilter: isEmailLoggedIn
                      ? null
                      : const ColorFilter.mode(
                          kGray, BlendMode.srcIn), // ใช้ colorFilter แทน color
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
                      width: OrientationHelper.isLandscape ? 34.w : 24.w, // ปรับขนาดไอคอนให้เล็กลง
                      height: OrientationHelper.isLandscape ? 34.h : 24.h, // ปรับขนาดไอคอนให้เล็กลง
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
                      : const ColorFilter.mode(
                          kGray, BlendMode.srcIn), // ใช้ colorFilter แทน color
                ),
                SizedBox(width: OrientationHelper.isLandscape ? 10.w : 10.w),
                SvgPicture.asset(
                  'assets/images/auth_screen/apple-icon.svg', 
                  width: OrientationHelper.isLandscape ? 52.w : 32.w,
                  height: OrientationHelper.isLandscape ? 52.h : 32.h,
                  colorFilter: isAppleLoggedIn
                      ? null
                      : const ColorFilter.mode(
                          kGray, BlendMode.srcIn), // ใช้ colorFilter แทน color
                ),
              ],
            ),
            SizedBox(height: 24.h), // ปรับระยะห่างระหว่างแถวให้เหมาะสม
            UserInfoRow(
              title: 'UID',

              // value: getDisplayUID(userId),
              value: userId,

              icon: Icons.copy,
              onIconPressed: _copyUID,
              isValueOverflow: true, // จัดการข้อความยาวให้แสดง ...
            ),
            SizedBox(height: 16.h),
            UserInfoRow(
              title: 'account.email'.tr(), //อีเมล
              value: getMaskedEmail(),
              icon: isEmailHidden ? Icons.visibility_off : Icons.visibility,
              onIconPressed: () {
                setState(() {
                  isEmailHidden = !isEmailHidden;
                });
              },
            ),
            SizedBox(height: 16.h),
            emailProvider.isLoggedIn &&
                    emailProvider.user?.providerData[0].providerId == 'password'
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
                    emailProvider.user?.providerData[0].providerId == 'password'
                ? UserInfoRow(
                    title: 'account.password'.tr(), //รหัสผ่าน
                    value: '********',
                    icon: Icons.edit_rounded,
                    onIconPressed: () async {
                      final hasPermission = await _checkEmailPermission();
                      if (hasPermission) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgetPasswordScreen(),
                          ),
                        );
                      }
                    },
                  )
                : const UserInfoRow(
                    title: '', //ชื่อผู้ใช้
                    value: '',
                  ),
            const Spacer(),
            GradientTextButton(
              text: 'account.logout'.tr(), //ออกจากระบบ
              onPressed: () async {
                await _signOut(context);
              },
            ),
            SizedBox(height: OrientationHelper.isLandscape ? 6.h : 16.h),
            if (emailProvider.isLoggedIn &&
                emailProvider.user?.providerData[0].providerId == 'password')
              const EmailDeleteAccountButton(),
            SizedBox(height: OrientationHelper.isLandscape ? 8.h : 16.h),
          ],
        ),
      ),
    );
  }
}

class UserInfoRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final VoidCallback? onIconPressed;
  final bool isValueOverflow;

  const UserInfoRow({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.onIconPressed,
    this.isValueOverflow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.prompt(
              fontSize: OrientationHelper.isLandscape ? 10.sp : 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF323130),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(width: 24.w),
                Expanded(
                  child: Text(
                    value,
                    style: GoogleFonts.prompt(
                      fontSize: OrientationHelper.isLandscape ? 10.sp : 14.sp,
                      color: const Color(0xFFBBBFC4),
                    ),
                    overflow: isValueOverflow ? TextOverflow.ellipsis : null,
                    maxLines: value.length > 15 ? 5 : 1,
                    textAlign: TextAlign.right,
                  ),
                ),
                if (icon != null) ...[
                  SizedBox(width: 8.w),
                  IconButton(
                    icon: Icon(icon, size: OrientationHelper.isLandscape ? 12.sp : 18.sp),
                    onPressed: onIconPressed,
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
