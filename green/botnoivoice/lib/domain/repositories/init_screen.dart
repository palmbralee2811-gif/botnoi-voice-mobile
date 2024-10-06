import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_token_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_token_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_token_provider.dart';
import 'package:botnoivoice/presentation/screens/home/home_screen.dart';
import 'package:botnoivoice/presentation/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// ตรวจสอบว่าผู้ใช้เข้าสู่ระบบด้วยวิธีไหน (Google, LINE หรือ Email)
class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  bool _initialized = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => initApp());
    super.initState();
  }

  /// ฟังก์ชันสำหรับการเช็คว่า ผู้ใช้เข้าสู่ระบบด้วยวิธีไหน และโหลดข้อมูลที่จำเป็น
  Future<void> initApp() async {
    // ตรวจสอบการเข้าสู่ระบบด้วย LINE
    final isLineLogin = Provider.of<LineLoginProvider>(context, listen: false).isLoggedIn;
    if (isLineLogin) {
      await Provider.of<LineTokenProvider>(context, listen: false)
          .loadJwtToken(context);
      await Provider.of<LineTokenProvider>(context, listen: false)
          .loadCredentials();
      await Provider.of<LineTokenProvider>(context, listen: false)
          .loadRemainingCredits();
    }

    // ตรวจสอบการเข้าสู่ระบบด้วย Google
    final isGoogleLogin = Provider.of<GoogleLoginProvider>(context, listen: false).isLoggedIn;
    if (isGoogleLogin) {
      await Provider.of<GoogleTokenProvider>(context, listen: false)
          .loadJwtToken(context);
      await Provider.of<GoogleTokenProvider>(context, listen: false)
          .loadCredentials();
      await Provider.of<GoogleTokenProvider>(context, listen: false)
          .loadRemainingCredits();
    }

    // ตรวจสอบการเข้าสู่ระบบด้วย Email
    final isEmailLogin = Provider.of<EmailLoginProvider>(context, listen: false).isLoggedIn;
    if (isEmailLogin) {
      await Provider.of<EmailTokenProvider>(context, listen: false)
          .loadJwtToken(context);
      await Provider.of<EmailTokenProvider>(context, listen: false)
          .loadCredentials();
      await Provider.of<EmailTokenProvider>(context, listen: false)
          .loadRemainingCredits();
    }

    setState(() {
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_initialized) {
      return const Scaffold(
        body: HomeScreen(), // ไปยังหน้าหลักเมื่อข้อมูลโหลดเสร็จแล้ว
      );
    } else {
      return const SplashScreen(); // แสดงหน้ารอโหลดข้อมูลก่อน
    }
  }
}
