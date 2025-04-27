import 'package:botnoivoice/shared/widget/button/social_login_button.dart';
import 'package:flutter/material.dart';
import 'package:botnoivoice/shared/style/style.dart';

/// ปุ่มล็อกอิน Google ใช้ SocialLoginButton
class GoogleLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  const GoogleLoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SocialLoginButton(
      onPressed: onPressed,
      backgroundColor: Colors.white, // สีพื้นหลังของปุ่ม Google
      textColor: kDark, // สีข้อความดำ
      iconPath: 'assets/images/auth_screen/google-icon.svg', // ไอคอน Google
      buttonText: 'auth.sign_in_with_google', // ข้อความ
      borderColor: Colors.grey.shade400, // เส้นขอบสีเทาอ่อน
    );
  }
}
