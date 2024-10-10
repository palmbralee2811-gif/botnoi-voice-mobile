import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class EmailRegisterProvider with ChangeNotifier {
  String? _userId;
  String? _errorMessage;
  final Logger _logger = Logger(); // For debugging

  /// Getter for user ID
  String? get userId => _userId;

  /// Getter for error message
  String? get errorMessage => _errorMessage;

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
      _userId = userCredential.user?.uid;
      _logger.i(
          "User registered successfully with email: $email, User ID: $_userId");

      // Send verification email
      try {
        await userCredential.user?.sendEmailVerification();
        _errorMessage = "Verification email sent to: $email";
        _logger.i("Verification email sent to: $email");
      } catch (e) {
        _logger.e("Failed to send verification email: $e");
      }

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      _logger
          .e("Error registering user with email: $email, Error: ${e.message}");
      notifyListeners();
    }
  }
}
