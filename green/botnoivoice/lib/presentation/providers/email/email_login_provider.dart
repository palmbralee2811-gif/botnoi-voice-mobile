import 'package:botnoivoice/presentation/providers/email/email_token_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

/// Email & Password Provider and interface for authentication
class EmailLoginProvider with ChangeNotifier {
  User? _userEmail;

  String? _errorMessage;
  final Logger _logger = Logger(); // For debugging
  bool _isLoggedIn = false; // Check if the user is logged in

  /// Getter for logged in status
  bool get isLoggedIn => _isLoggedIn;

  /// Getter for authenticated status
  bool get isAuthenticated {
    return currentUser?.uid != null &&
        _userEmail?.providerData.isNotEmpty == true &&
        _userEmail?.providerData[0].providerId == 'password';
  }

  /// Getter for user email
  User? get userEmail => _userEmail;

  /// Getter for current user
  User? get currentUser => FirebaseAuth.instance.currentUser;

  /// Getter for error message
  String? get errorMessage => _errorMessage;

  EmailLoginProvider() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      _userEmail = user;
      _logger.i("User email: $_userEmail");
      _isLoggedIn = _userEmail != null;
      notifyListeners(); // Update UI
    });
  }

  /// Login user with email and password
  Future<void> loginWithEmailPassword(String email, String password) async {
    try {
      // Perform login
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      _errorMessage = null;

      // Check if email is verified
      if (!userCredential.user!.emailVerified) {
        _errorMessage = "กรุณายืนยันอีเมลก่อนเข้าสู่ระบบ.";
        _logger.w("User email is not verified: $email");

        // Send verification email
        try {
          await userCredential.user?.sendEmailVerification();
          _errorMessage = "ส่งอีเมลยืนยันไปที่: $email";
          _logger.i("Verification email sent to: $email");
        } on PlatformException catch (e) {
          _errorMessage = e.message;
          _logger.e("Failed to send verification email: $e");
        }

        notifyListeners();
        return;
      }

      // Set user after successful login
      _userEmail = userCredential.user;
      _isLoggedIn = true;
      _logger.i("User logged in successfully with email: $email");
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      _logger
          .e("Error logging in user with email: $email, Error: ${e.message}");
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
    notifyListeners();
  }
}
