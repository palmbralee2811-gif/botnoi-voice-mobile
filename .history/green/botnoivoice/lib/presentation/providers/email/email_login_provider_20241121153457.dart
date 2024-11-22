import 'package:botnoivoice/presentation/providers/email/email_token_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_username_api_provider.dart';

class EmailLoginProvider with ChangeNotifier {
  User? user;
  String? _errorMessage;
  final Logger _logger = Logger(); // สำหรับ debug
  bool _isLoggedIn = false;

  /// Getter สำหรับการตรวจสอบว่าเข้าสู่ระบบแล้วหรือไม่
  bool get isLoggedIn => _isLoggedIn;

  /// Getter สำหรับการตรวจสอบการยืนยันตัวตน
  bool get isAuthenticated {
    return FirebaseAuth.instance.currentUser?.uid != null &&
        user?.providerData.isNotEmpty == true &&
        user?.providerData[0].providerId == 'password';
  }

  /// Getter สำหรับอีเมล
  String? get getUserEmail => user?.email;

  /// Getter สำหรับ error message
  String? get errorMessage => _errorMessage;

  EmailLoginProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user?.providerData[0].providerId == 'password') {
        this.user = user;
        _logger.i("Login with Email: $user");
        _isLoggedIn = true;
      }
      notifyListeners(); // Update UI
    });
  }

  /// เข้าสู่ระบบด้วย `username` และ `password` พร้อมกับเรียก `get email by username`
  Future<void> loginWithUsernamePassword(
      String username, String password, BuildContext context) async {
    final emailUsernameProvider =
        Provider.of<EmailUsernameApiProvider>(context, listen: false);

    try {
      // เรียกใช้ฟังก์ชัน get email by username เพื่อดึง email จาก username
      await emailUsernameProvider.getEmailByUsername(username);
      final email = emailUsernameProvider.result; // รับค่า email จาก result

      if (email == 'email not found') {
        _errorMessage = 'ชื่อผู้ใช้งานไม่ถูกต้อง'; //ชื่อผู้ใช้งานไม่ถูกต้อง
        _logger.e("No email found for username: $username");
        notifyListeners();
        return;
      }

      // ทำการเข้าสู่ระบบโดยใช้ email และ password ที่ได้จาก username
      await loginWithEmailPassword(email, password);
    } catch (e) {
      _errorMessage = "เกิดข้อผิดพลาดในการเข้าสู่ระบบ: $e"; //
      _logger.e("Error logging in with username: $e");
      notifyListeners();
    }
  }

  /// เข้าสู่ระบบด้วยอีเมลและรหัสผ่าน
  Future<void> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      _errorMessage = null;

      // ตรวจสอบว่าผู้ใช้อีเมลได้รับการยืนยันหรือไม่
      if (!userCredential.user!.emailVerified) {
        _errorMessage = "กรุณายืนยันอีเมลก่อนเข้าสู่ระบบ.";
        _logger.w("User email is not verified: $email");

        // ส่งอีเมลยืนยันหากยังไม่ได้รับการยืนยัน
        try {
          await userCredential.user?.sendEmailVerification();
          _errorMessage = "กรุณายืนยันอีเมล: $email";
          _logger.i("Verification email sent to: $email");
        } on FirebaseAuthException catch (e) {
          _errorMessage = e.message;
          _logger.e("Failed to send verification email: $e");
        }

        // ทำการ sign out เพื่อป้องกันการเข้าถึงโดยไม่ยืนยันอีเมล
        await FirebaseAuth.instance.signOut();
        _isLoggedIn = false;
        notifyListeners();
        return;
      }

      // หากยืนยันอีเมลแล้ว อนุญาตให้เข้าสู่ระบบ
      user = userCredential.user;
      _isLoggedIn = true;
      _logger.i(
          "User logged in successfully with email: $email, Email User ID: ${user?.uid}");
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          _errorMessage = "อีเมลไม่ถูกต้อง";
          break;
        case 'wrong-password':
          _errorMessage = "รหัสผ่านไม่ถูกต้อง";
          break;
        case 'user-disabled':
          _errorMessage = "บัญชีนี้ถูกระงับการใช้งาน";
          break;
        default:
          _errorMessage = "ชื่อผู้ใช้งานหรือรหัสผ่านไม่ถูกต้อง";
          break;
      }
      _logger.e(
          "Error logging in with email. \nMessage: ${e.message} \nCode: ${e.code}");
      notifyListeners();
    }
  }

  /// Sign out for Login with Email and Password
  Future<void> signOutWithEmail(BuildContext context) async {
    try {
      Provider.of<EmailTokenProvider>(context, listen: false).clearTokens();
      await FirebaseAuth.instance.signOut();
      _isLoggedIn = false;
      _logger.i("User signed out successfully");
    } catch (e) {
      _logger.e("Error signing out: $e");
    }

    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
