import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class EmailForgetPasswordProvider with ChangeNotifier {
  String? _errorMessage;
  final Logger _logger = Logger(); // For debugging

  /// Getter for error message
  String? get errorMessage => _errorMessage;

  /// Send password reset email if username exists
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _errorMessage = null;
      _logger.i("Password reset email sent to: $email");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          _errorMessage = "ไม่พบบัญชีผู้ใช้ที่ตรงกับอีเมลนี้";
          break;
        case 'invalid-email':
          _errorMessage = "รูปแบบอีเมลไม่ถูกต้อง";
          break;
        default:
          _errorMessage = "เกิดข้อผิดพลาดในการส่งอีเมลรีเซ็ตรหัสผ่าน";
          break;
      }
      _logger.e(
          "Error sending password reset email to $email \nMessage: ${e.message} \nCode: ${e.code}");
    }
    notifyListeners();
  }

  /// Confirm password reset with the code from the email
  Future<void> confirmPasswordReset(String code, String newPassword) async {
    try {
      await FirebaseAuth.instance.confirmPasswordReset(
        code: code,
        newPassword: newPassword,
      );
      _errorMessage = null;
      _logger.i("Password has been reset successfully.");
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'expired-action-code':
          _errorMessage = "ลิงค์นี้หมดอายุแล้ว";
          break;
        case 'invalid-action-code':
          _errorMessage = "โค้ดไม่ถูกต้องหรือถูกใช้ไปแล้ว";
          break;
        case 'weak-password':
          _errorMessage = "รหัสผ่านใหม่ไม่แข็งแรงพอ";
          break;
        default:
          _errorMessage = "เกิดข้อผิดพลาดในการรีเซ็ตรหัสผ่าน";
      }
      _logger
          .e("Error resetting password with code: $code \nMessage: ${e.message} \nCode: ${e.code}");
      notifyListeners();
    }
  }
}
