import 'package:botnoivoice/presentation/widgets/button/social_login_button.dart';
import 'package:flutter/material.dart';

class AppleLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  const AppleLoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SocialLoginButton(
      onPressed: onPressed,
      backgroundColor: Colors.black, //  พื้นหลังสีดำ
      textColor: Colors.white, //  ข้อความสีขาว
      iconPath: 'assets/images/auth_screen/apple-icon.svg', //  ไอคอน Apple
      buttonText: 'auth.sign_in_with_apple',
      borderColor: Colors.transparent, //  ไม่มีเส้นขอบ
      iconColor: Colors.white, //  ทำให้ไอคอนเป็นสีขาว (เฉพาะ Apple)
    );
  }
}
