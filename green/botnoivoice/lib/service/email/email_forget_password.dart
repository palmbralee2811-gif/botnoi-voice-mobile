import 'package:botnoivoice/service/email/check_user_is_show_email.dart';
import 'package:botnoivoice/ui/dialog/email_permission/offline_email_permission_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

// Email Forget Password
class EmailForgetPassword with ChangeNotifier {
  String? _errorMessage;
  final Logger _logger = Logger(); // For debugging

  /// Getter for error message
  String? get errorMessage => _errorMessage;

  /// Check if the user has permission to show email
  Future<bool> checkShowEmail(BuildContext context) async {
    try {
      final userInfoProvider =
          Provider.of<CheckUserIsShowEmail>(context, listen: false);
      await userInfoProvider.getUserInfoShowMail(context);

      if (userInfoProvider.isShowEmail == true) {
        _logger.d("Email permission is enabled.");
        return true;
      } else {
        _logger.e("Email permission is disabled. Showing dialog.");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const OfflineEmailPermissionDialog();
          },
        );
        return false;
      }
    } catch (error) {
      _logger.e("Error checking email permission: $error");
      return false;
    }
  }

  /// Send password reset email if username exists
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _errorMessage = null;
      _logger.i("Password reset email sent to: $email");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          _errorMessage = 'forget_password_provider.no_account_found'
              .tr(); //ไม่พบบัญชีผู้ใช้ที่ตรงกับอีเมลนี้
          break;
        case 'invalid-email':
          _errorMessage = 'forget_password_provider.invalid_email_format'
              .tr(); //รูปแบบอีเมลไม่ถูกต้อง
          break;
        default:
          _errorMessage = 'forget_password_provider.error_sending_reset_email'
              .tr(); //เกิดข้อผิดพลาดในการส่งอีเมลรีเซ็ตรหัสผ่าน
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
          _errorMessage = 'forget_password_provider.link_expired'
              .tr(); //ลิงค์นี้หมดอายุแล้ว
          break;
        case 'invalid-action-code':
          _errorMessage = 'forget_password_provider.code_incorrect_or_used'
              .tr(); //โค้ดไม่ถูกต้องหรือถูกใช้ไปแล้ว
          break;
        case 'weak-password':
          _errorMessage = 'forget_password_provider.weak_new_password'
              .tr(); //รหัสผ่านใหม่ไม่แข็งแรงพอ
          break;
        default:
          _errorMessage = 'forget_password_provider.error_resetting_password'
              .tr(); //เกิดข้อผิดพลาดในการรีเซ็ตรหัสผ่าน
      }
      _logger.e(
          "Error resetting password with code: $code \nMessage: ${e.message} \nCode: ${e.code}");
      notifyListeners();
    }
  }
}
