import 'package:botnoivoice/presentation/providers/email/email_token_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

/// Email & Password Provider and interface for authentication
class EmailLoginProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Logger _logger = Logger(); // For debugging
  String? _errorMessage;
  String? _idToken;
  bool _isLoggedIn = false;

  /// Register user with email and password
  Future<void> registerWithEmailPassword(
      String email, String password, String confirmPassword) async {
    if (password != confirmPassword) {
      _errorMessage = "Passwords do not match.";
      _logger.w("Passwords do not match for email: $email");
      notifyListeners();
      return;
    }

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _errorMessage = null;
      _logger.i("User registered successfully with email: $email");
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      _logger
          .e("Error registering user with email: $email, Error: ${e.message}");
      notifyListeners();
    }
  }

  /// Login user with email and password
  Future<void> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _errorMessage = null;

      // Get ID Token from user
      String? token = await userCredential.user?.getIdToken();
      _idToken = token;

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

  /// Reset password by sending a password reset email
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
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
      // Confirm the password reset with the provided code and new password
      await _auth.confirmPasswordReset(code: code, newPassword: newPassword);
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

  /// Check if user is currently signed in
  User? get currentUser {
    _logger.d("Checking current user: ${_auth.currentUser?.email}");
    return _auth.currentUser;
  }

  /// Sign out
  Future<void> signOut(BuildContext context) async {
    try {
      Provider.of<EmailTokenProvider>(context, listen: false).clearTokens();
      await _auth.signOut();
      _isLoggedIn = false;
      _logger.i("User signed out successfully");
    } catch (e) {
      _logger.e("Error signing out: $e");
    }
    notifyListeners(); // Update UI
  }

  /// Getter for error message
  String? get errorMessage => _errorMessage;

  /// Getter for ID Token
  String? get idToken => _idToken;

  /// Check if the user is logged in
  bool get isLoggedIn => _isLoggedIn;
}
