import 'package:botnoivoice/presentation/providers/email/email_token_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

/// Email & Password Provider and interface for authentication
class EmailLoginProvider with ChangeNotifier {
  User? userEmail;
  String? _errorMessage;
  final Logger _logger = Logger(); // For debugging

  /// Check if the user is logged in
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool get isAuthenticated {
    return currentUser?.uid != null && userEmail?.providerData[0].providerId == 'password';
  }

  EmailLoginProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? userEmail) async {
      this.userEmail = userEmail;
      _logger.i("User email: $userEmail");
      _isLoggedIn = userEmail !=
          null; // Set's true if a user is logged in, or false if not.
      notifyListeners(); // Update UI
    });
  }

  /// Login user with email and password
  Future<void> loginWithEmailPassword(String email, String password) async {
    try {

      //TODO: query email from api
      //TODO: call email from backend
      //TODO: username from backend
      //TODO: change username with call api

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      _errorMessage = null;

      // Check if email is verified
      if (!userCredential.user!.emailVerified) {
        _errorMessage = "กรุณายืนยันอีเมลก่อนเข้าสู่ระบบ.";
        _logger.w("User email is not verified: $email");
        // Send verification email
        //TODO: ถ้ายังไม่ยืนยันอีเมล แล้ว Login จะส่งจดหมายให้ยืนยันก่อน
        //TODO: คลิกปุ่ม Login ครั้งแรก จะส่งจดหมาย แต่ถ้า คลิกปุ่มครั้งที่สอง ติดต่อกัน จะโดนบล็อค
        await userCredential.user?.sendEmailVerification();
        _errorMessage = "ส่งอีเมลยืนยันไปที่: $email";
        _logger.i("Verification email sent to: $email");
        notifyListeners();
        return;
      }

      // ตั้งค่า user หลังจาก login สำเร็จ
      userEmail = userCredential.user;
      _logger.i("User logged in successfully with email: $email");
      _isLoggedIn = true;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      _logger
          .e("Error logging in user with email: $email, Error: ${e.message}");
      notifyListeners();
    }
  }

  /// Register user with email and password, and send verification email
  Future<void> registerWithEmailPassword(
      String email, String password, String confirmPassword) async {
    if (password != confirmPassword) {
      _errorMessage = "Passwords do not match.";
      _logger.w("Passwords do not match for email: $email");
      notifyListeners();
      return;
    }

    try {
      // Register user
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _errorMessage = null;
      _logger.i("User registered successfully with email: $email");

      // Send verification email
      await userCredential.user?.sendEmailVerification();
      _logger.i("Verification email sent to: $email");
      _errorMessage = "Verification email sent to: $email";

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      _logger
          .e("Error registering user with email: $email, Error: ${e.message}");
      notifyListeners();
    }
  }

  /// Send password reset email
  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _errorMessage = null;
      _logger.i("Password reset email sent to: $email");
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      _logger.e("Error sending password reset email to $email: ${e.message}");
      notifyListeners();
    }
  }

  /// Confirm password reset with the code from the email
  Future<void> confirmPasswordReset(String code, String newPassword) async {
    try {
      await FirebaseAuth.instance
          .confirmPasswordReset(code: code, newPassword: newPassword);
      _errorMessage = null;
      _logger.i("Password has been reset successfully.");
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      _logger
          .e("Error resetting password with code: $code, Error: ${e.message}");
      notifyListeners();
    }
  }

  /// Sign out
  Future<void> signOut(BuildContext context) async {
    try {
      Provider.of<EmailTokenProvider>(context, listen: false).clearTokens();
      await FirebaseAuth.instance.signOut();
      _isLoggedIn = false;
      _logger.i("User signed out successfully");
    } catch (e) {
      _logger.e("Error signing out: $e");
    }
    notifyListeners(); // Update UI
  }

  /// Getter for current user
  User? get currentUser => FirebaseAuth.instance.currentUser;

  /// Getter for error message
  String? get errorMessage => _errorMessage;
}
