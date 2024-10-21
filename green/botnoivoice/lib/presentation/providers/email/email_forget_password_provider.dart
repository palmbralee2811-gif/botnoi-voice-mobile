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
      _errorMessage =
          "Error sending password reset email to $email: ${e.message}";
      _logger.e("Error sending password reset email to $email: ${e.message}");
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
