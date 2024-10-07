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
    final googleProvider = Provider.of<GoogleLoginProvider>(context, listen: false);
    final lineProvider = Provider.of<LineLoginProvider>(context, listen: false);
    final emailProvider = Provider.of<EmailLoginProvider>(context, listen: false);

    // ตรวจสอบการเข้าสู่ระบบโดย Google ก่อน
    if (googleProvider.isLoggedIn && googleProvider.user?.providerData[0].providerId == 'google.com') {
      await _loadGoogleCredentials();
      return;
    }

    // ตรวจสอบการเข้าสู่ระบบด้วย LINE
    if (lineProvider.isLoggedIn) {
      await _loadLineCredentials();
      return;
    }

    // ตรวจสอบการเข้าสู่ระบบด้วย Email
    if (emailProvider.isLoggedIn && emailProvider.userEmail?.providerData[0].providerId == 'password') {
      await _loadEmailCredentials();
      return;
    }

    // ถ้าไม่พบการล็อกอินจาก provider ใด ๆ
    setState(() {
      _initialized = true;
    });
  }

  /// โหลดข้อมูลเมื่อเข้าสู่ระบบด้วย Google
  Future<void> _loadGoogleCredentials() async {
    final googleTokenProvider = Provider.of<GoogleTokenProvider>(context, listen: false);
    await googleTokenProvider.loadJwtToken(context);
    await googleTokenProvider.loadCredentials();
    await googleTokenProvider.loadRemainingCredits();

    setState(() {
      _initialized = true;
    });
  }

  /// โหลดข้อมูลเมื่อเข้าสู่ระบบด้วย LINE
  Future<void> _loadLineCredentials() async {
    final lineTokenProvider = Provider.of<LineTokenProvider>(context, listen: false);
    await lineTokenProvider.loadJwtToken(context);
    await lineTokenProvider.loadCredentials();
    await lineTokenProvider.loadRemainingCredits();

    setState(() {
      _initialized = true;
    });
  }

  /// โหลดข้อมูลเมื่อเข้าสู่ระบบด้วย Email
  Future<void> _loadEmailCredentials() async {
    final emailTokenProvider = Provider.of<EmailTokenProvider>(context, listen: false);
    await emailTokenProvider.loadJwtToken(context);
    await emailTokenProvider.loadCredentials();
    await emailTokenProvider.loadRemainingCredits();

    setState(() {
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_initialized) {
      return const HomeScreen(); // ไปยังหน้าหลักเมื่อข้อมูลโหลดเสร็จแล้ว
    } else {
      return const SplashScreen(); // แสดงหน้ารอโหลดข้อมูลก่อน
    }
  }
}
