import 'package:botnoivoice/presentation/providers/email/email_username_token_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class EmailForgetPasswordProvider with ChangeNotifier {
  String? _errorMessage;
  final Logger _logger = Logger(); // For debugging

  /// Getter for error message
  String? get errorMessage => _errorMessage;

  /// ***WANRING***
  /// 
  /// ตรวจสอบอีเมลที่ลูกค้าส่งเข้ามา ว่าได้สมัครสมาชิกหรือมีข้อมูลในระบบแล้วหรือยัง? 
  /// เช็คด้วย username ถ้ามี username ในระบบ ถือว่าสมัครสมาชิกแล้วเรียบเรียบ
  /// เพื่อป้องกัน อีเมลที่ยังไม่ได้สมัครสมาชิก แล้วส่งคำขอลืมรหัสผ่าน พอเปลี่ยนรหัสผ่านเสร็จ 
  /// จะสามารถเข้าสู่ระบบได้ โดยยังไม่ได้สมัครสมาชิก !!!
  /// 
  /// Send password reset email if username exists
  Future<void> sendPasswordResetEmail(context, String email) async {
    //TODO: ทดสอบฟังก์ชันลืมรหัสผ่าน
    final emailUsernameProvider = Provider.of<EmailUsernameTokenProvider>(context, listen: false);
    await emailUsernameProvider.getUsernameByEmail(email);
    final result = emailUsernameProvider.result;
    
    if (result != 'No username found in response.') {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        _errorMessage = null;
        _logger.i("Password reset email sent to: $email");
      } on FirebaseAuthException catch (e) {
        _errorMessage = e.message;
        _logger.e("Error sending password reset email to $email: ${e.message}");
      }
    } else {
      _errorMessage = 'อีเมลนี้ยังไม่ได้สมัครสมาชิก';
      _logger.w('No user found for this email: $email');
    }

    notifyListeners();
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
}
