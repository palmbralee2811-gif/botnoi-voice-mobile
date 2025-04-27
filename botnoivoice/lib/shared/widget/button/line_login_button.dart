import 'package:botnoivoice/shared/widget/button/social_login_button.dart';
import 'package:flutter/material.dart';
import 'package:botnoivoice/shared/style/style.dart';

/// ปุ่มล็อกอินด้วย Line ใช้ SocialLoginButton
class LineLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  const LineLoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SocialLoginButton(
      onPressed: onPressed,
      backgroundColor: kGreen, // สีพื้นหลังสีเขียวของ Line
      textColor: Colors.white, // สีข้อความขาว
      iconPath: 'assets/images/auth_screen/line-icon.svg', // ไอคอน Line
      buttonText: 'auth.sign_in_with_line', // ข้อความ
    );
  }
}
