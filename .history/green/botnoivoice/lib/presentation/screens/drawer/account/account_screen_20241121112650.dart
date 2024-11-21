import 'package:botnoivoice/domain/repositories/auth_checker.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_username_api_provider.dart';
import 'package:botnoivoice/presentation/providers/google/get_user_email.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/screens/drawer/account/change_email_username_screen.dart';
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
    var googleProvider =
        Provider.of<GoogleLoginProvider>(context, listen: false);
    var lineProvider = Provider.of<LineLoginProvider>(context, listen: false);
    var emailProvider = Provider.of<EmailLoginProvider>(context, listen: false);

    if (lineProvider.isLoggedIn) {
      displayName = lineProvider.getDisplayName ?? "No Name";
      userId = lineProvider.getLineUserId ?? "No UID";
      email = lineProvider.getLineEmail ?? "No email found";
      isLineLoggedIn = true;
    } else if (googleProvider.isLoggedIn &&
        googleProvider.user?.providerData[0].providerId == 'google.com') {
      displayName = googleProvider.user?.displayName ?? 'No email found';
      userId = googleProvider.user?.uid ?? 'No UID';
      email =
          getUserEmail(FirebaseAuth.instance.currentUser) ?? 'No email found';
      isGoogleLoggedIn = true;
    } else if (emailProvider.isLoggedIn &&
        emailProvider.user?.providerData[0].providerId == 'password') {
      userId = emailProvider.user?.uid ?? "No UID";
      displayName =
          Provider.of<EmailUsernameApiProvider>(context, listen: false)
                  .getUsername ??
              "Unknown";
      email = emailProvider.user?.email ?? "No email found";
      isEmailLoggedIn = true;
    }

    setState(() {}); // อัพเดต UI เมื่อข้อมูลถูกโหลดเสร็จสิ้น
  }

  /// ฟังก์ชันสำหรับการออกจากระบบ
  Future<void> _signOut(BuildContext context) async {
    final googleProvider =
        Provider.of<GoogleLoginProvider>(context, listen: false);
    final lineProvider = Provider.of<LineLoginProvider>(context, listen: false);
    final emailProvider =
        Provider.of<EmailLoginProvider>(context, listen: false);

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
  String getDisplayUID(String uid) {
    if (uid.length > 15) {
      return '${uid.substring(0, 15)}...'; // แสดงเฉพาะ 15 ตัวอักษรแรก
    }
    return uid; // แสดง UID ปกติหากไม่เกิน 15 ตัวอักษร
  }

  /// ฟังก์ชันคัดลอก UID
  void _copyUID() {
    Clipboard.setData(ClipboardData(text: userId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('app_drawer.uid_copy_success'.tr())), //UID คัดลอกเรียบร้อยแล้ว
    );
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
          'app_drawer.profile'.tr(), //ข้อมูลส่วนตัว
          style: GoogleFonts.prompt(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF323130)),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: const Color(0xFF323130),
            size: 24.sp,
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
            SizedBox(height: 20.h),
            Row(
              // จัดข้อความและไอคอนให้อยู่ในแนวเดียวกัน
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'app_drawer.login_with'.tr(), //เข้าสู่ระบบด้วย
                  style: GoogleFonts.prompt(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF323130),
                  ),
                ),
                SizedBox(width: 50.w), // ระยะห่างระหว่างข้อความและไอคอน
                SvgPicture.asset(
                  'assets/images/auth_screen/email-icon.svg',
                  width: 20.w,
                  height: 20.h,
                  colorFilter: isEmailLoggedIn
                      ? null
                      : const ColorFilter.mode(
                          kGray, BlendMode.srcIn), // ใช้ colorFilter แทน color
                ),
                SizedBox(width: 10.w),
                Container(
                  width: 32.w,
                  height: 32.h,
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
                      width: 24.w, // ปรับขนาดไอคอนให้เล็กลง
                      height: 24.h, // ปรับขนาดไอคอนให้เล็กลง
                      fit: BoxFit
                          .contain, // ทำให้ไอคอนถูกย่อให้พอดีกับพื้นที่ที่กำหนด
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                SvgPicture.asset(
                  'assets/images/auth_screen/google-icon.svg',
                  width: 32.w,
                  height: 32.h,
                  colorFilter: isGoogleLoggedIn
                      ? null
                      : const ColorFilter.mode(
                          kGray, BlendMode.srcIn), // ใช้ colorFilter แทน color
                ),
              ],
            ),
            SizedBox(height: 24.h), // ปรับระยะห่างระหว่างแถวให้เหมาะสม
            UserInfoRow(
              title: 'UID',
              value: getDisplayUID(userId),
              icon: Icons.copy,
              onIconPressed: _copyUID,
              isValueOverflow: true, // จัดการข้อความยาวให้แสดง ...
            ),
            SizedBox(height: 16.h),
            UserInfoRow(
              title: 'app_drawer.email'.tr(), //อีเมล
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
                    title: 'app_drawer.username'.tr(), //ชื่อผู้ใช้
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
                    title: 'app_drawer.username'.tr(), //ชื่อผู้ใช้
                    value: displayName,
                  ),
            const Spacer(),
            GradientTextButton(
              text: 'app_drawer.logout'.tr(), //ออกจากระบบ
              onPressed: () async {
                await _signOut(context);
              },
            ),
            SizedBox(height: 16.h),
            if (emailProvider.isLoggedIn &&
                emailProvider.user?.providerData[0].providerId == 'password')
              const EmailDeleteAccountButton(),
            SizedBox(height: 16.h),
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
              fontSize: 14.sp,
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
                      fontSize: 14.sp,
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
                    icon: Icon(icon, size: 18.sp),
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