import 'package:botnoivoice/domain/repositories/auth_checker.dart';
import 'package:botnoivoice/presentation/constants/color.dart';
import 'package:botnoivoice/presentation/providers/email/email_delete_account_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_username_token_provider.dart';
import 'package:botnoivoice/presentation/widgets/dialog/alert_notification_dialog.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_align.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_button.dart';
import 'package:botnoivoice/presentation/widgets/modal/alert_message_modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  Future<String?> _showPasswordDialog() async {
    String? password;
    bool isPasswordVisible = false; // To track the visibility of the password

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('กรุณาใส่รหัสผ่านของคุณ'),
              content: TextField(
                obscureText: !isPasswordVisible, // Toggles password visibility
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(
                  hintText: 'รหัสผ่าน',
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('ยกเลิก'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    password = null;
                  },
                ),
                TextButton(
                  child: const Text('ยืนยัน'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
    return password;
  }

  Future<void> _deleteAccount() async {
    final emailDeleteAccountProvider =
        Provider.of<EmailDeleteAccountProvider>(context, listen: false);
    final emailProvider =
        Provider.of<EmailLoginProvider>(context, listen: false);

    if (!emailProvider.isLoggedIn ||
        emailProvider.user == null ||
        emailProvider.user?.providerData[0].providerId != 'password') {
      AlertMessageModal(
        context: context,
        text: 'ไม่สามารถลบบัญชีได้. คุณไม่ได้เข้าสู่ระบบด้วยอีเมล',
      ).showErrorModal(context);
      return;
    }

    // Prompt for password
    String? password = await _showPasswordDialog();

    if (password == null || password.isEmpty) {
      // User canceled or didn't enter a password
      return;
    }

    try {
      await emailDeleteAccountProvider.deleteUserAccountWithDatabase();
      final errorMessage = emailDeleteAccountProvider.errorMessage;

      if (errorMessage != null && errorMessage.isNotEmpty) {
        AlertMessageModal(
          context: context,
          text: errorMessage,
        ).showErrorModal(context);
      } else {
        await emailDeleteAccountProvider.deleteUserAccountWithFirebase(
            context, password);
        final errorMessage = emailDeleteAccountProvider.errorMessage;
        if (errorMessage != null && errorMessage.isNotEmpty) {
          AlertMessageModal(
            context: context,
            text: errorMessage,
          ).showErrorModal(context);
        } else {
          await FirebaseAuth.instance.signOut();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => AuthChecker(),
            ),
            (Route<dynamic> route) => false,
          );
        }
      }
    } catch (error) {
      AlertNotificationDialog(
        context: context,
        text: 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง. $error',
      ).showAsError();
    }
  }

  @override
  Widget build(BuildContext context) {
    /* //TODO: Delete User Account Testing
    String displayName =
        Provider.of<EmailUsernameTokenProvider>(context, listen: false)
                .getUsername ??
            "Unknown";
    final user = FirebaseAuth.instance.currentUser;
    String loginMethod = 'ไม่สามารถระบุได้';
    String uid = '';
    String email = '';
    String providerId = '';

    // ตรวจสอบผู้ให้บริการที่ใช้ในการล็อกอิน
    bool canDeleteAccount = false; // ใช้เพื่อตรวจสอบว่าจะแสดงปุ่มลบหรือไม่
    if (user != null) {
      uid = user.uid; // ดึง uid ของผู้ใช้
      email = user.email ?? 'ไม่มีอีเมล'; // ดึงอีเมลของผู้ใช้ (ถ้ามี)

      // วนลูปผ่าน providerData เพื่อตรวจสอบ providerId
      for (var info in user.providerData) {
        providerId = info.providerId;
        if (info.providerId == 'google.com') {
          loginMethod = 'เข้าสู่ระบบด้วย Google';
          canDeleteAccount = false; // ไม่ให้ลบได้เมื่อใช้ Google
        } else if (info.providerId == 'password') {
          loginMethod = 'เข้าสู่ระบบด้วย Email/Password';
          canDeleteAccount = true; // สามารถลบได้เมื่อใช้ Email/Password
        }
      }
    }
    */

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'ลบบัญชี',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: kDark,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: kDark,
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
            SizedBox(height: 24.h),
            GradientTextAlign(
              'โปรดอ่าน',
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF9340FF),
                  Color(0xFF34BDFA),
                ],
              ),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22.sp,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 8.h),
            GradientTextAlign(
              'การลบบัญชีเป็นการกระทำที่ไม่สามารถย้อนกลับได้ คุณจะไม่สามารถใช้บัญชีนี้กับผลิตภัณฑ์และบริการ พ้อยท์คงเหลือหรือแพ็คเกจที่สมัคร สิทธิพิเศษและโปรโมชั่นที่ได้รับอีกต่อไป โปรดระมัดระวัง',
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF9340FF),
                  Color(0xFF34BDFA),
                ],
              ),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 16.h),
            const Spacer(),
            Center(
              child: Column(
                children: [
                  GradientTextAlign(
                    'หากยืนยันที่จะลบบัญชีต่อ กรุณากดปุ่ม',
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF9340FF),
                        Color(0xFF34BDFA),
                      ],
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  GradientTextAlign(
                    '"ยืนยันลบบัญชี" ด้านล่าง',
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF9340FF),
                        Color(0xFF34BDFA),
                      ],
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            GradientTextButton(
              text: 'ยกเลิก',
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 16.h),
            /* //TODO: Delete User Account Testing
            Text('Username: $displayName'),
            Text('UID: $uid'),
            Text('Email: $email'),
            Text('Provider ID: $providerId'),
            Text('วิธีการเข้าสู่ระบบ: $loginMethod'),
            Text("Can delete account: $canDeleteAccount"),
            */
            ElevatedButton(
              onPressed: () {
                _deleteAccount();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  side: const BorderSide(color: Color(0xFFCCCCCC)),
                ),
                elevation: 0,
              ),
              child: Center(
                child: Text(
                  'ยืนยันลบบัญชี',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: kDark,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
