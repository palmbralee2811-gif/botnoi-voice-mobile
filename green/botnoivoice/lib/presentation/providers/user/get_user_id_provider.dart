import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Provider for getting User ID
class GetUserIdProvider with ChangeNotifier {
  late final LineLoginProvider lineProvider;
  late final GoogleLoginProvider googleProvider;
  late final EmailLoginProvider emailProvider;

  GetUserIdProvider(BuildContext context) {
    lineProvider = Provider.of<LineLoginProvider>(context, listen: false);
    googleProvider = Provider.of<GoogleLoginProvider>(context, listen: false);
    emailProvider = Provider.of<EmailLoginProvider>(context, listen: false);
  }

  String? _userId;
  String? get userId => _userId;

  /// Get User ID with LINE
  Future<void> getUserIdWithLine() async {
    if (lineProvider.isLoggedIn) {
      _userId = lineProvider.getIdTokenRaw;
      notifyListeners();
    } else {
      _userId = null;
    }
  }

  /// Get User ID with Google
  Future<void> getUserIdWithGoogle() async {
    if (googleProvider.isLoggedIn &&
        googleProvider.user?.providerData[0].providerId == 'google.com') {
      _userId = googleProvider.user?.uid;
      notifyListeners();
    } else {
      _userId = null;
    }
  }

  /// Get User ID with Email
  Future<void> getUserIdWithEmail() async {
    if (emailProvider.isLoggedIn &&
        emailProvider.user?.providerData[0].providerId == 'password') {
      _userId = emailProvider.user?.uid;
      notifyListeners();
    } else {
      _userId = null;
    }
  }
}
