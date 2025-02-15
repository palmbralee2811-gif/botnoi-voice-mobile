import 'package:botnoivoice/presentation/providers/apple/apple_login_provider.dart';
import 'package:botnoivoice/presentation/providers/apple/apple_token_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_token_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_username_api_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_token_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_token_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerAppbarLogic {
  Future<void> loadUserInfo({
    required BuildContext context,
    required Function(String displayName, String uid, String profilePictureUrl)
        onUpdateState,
  }) async {

    /// Fetch user data from Firebase 
    var appleProvider = Provider.of<AppleLoginProvider>(context, listen: false);
    var googleProvider = Provider.of<GoogleLoginProvider>(context, listen: false);
    var lineProvider = Provider.of<LineLoginProvider>(context, listen: false);
    var emailProvider = Provider.of<EmailLoginProvider>(context, listen: false);
    
    /// Fetch user data from Database (API)
    var appleTokenProvider = Provider.of<AppleTokenProvider>(context, listen: false);
    var googleTokenProvider = Provider.of<GoogleTokenProvider>(context, listen: false);
    var lineTokenProvider = Provider.of<LineTokenProvider>(context, listen: false);
    var emailTokenProvider = Provider.of<EmailTokenProvider>(context, listen: false);

    String displayName = "Loading...";
    String uid = "Loading...";
    String profilePictureUrl = "";

    if (lineProvider.isLoggedIn) {
      displayName = lineProvider.getDisplayName ?? 'No Name';
      uid = lineTokenProvider.getUserID ?? 'No uid found';
      profilePictureUrl = lineProvider.getProfilePictureUrl ?? '';
    } else if (appleProvider.isLoggedIn) {
      displayName = appleProvider.user?.displayName ?? 'Apple User';
      uid = appleTokenProvider.getUserID ?? 'No uid found';
      profilePictureUrl = appleProvider.user?.photoURL ?? '';
    } else if (googleProvider.isLoggedIn) {
      displayName = googleProvider.user?.displayName ?? 'Google User';
      uid = googleTokenProvider.getUserID ?? 'No uid found';
      profilePictureUrl = googleProvider.user?.photoURL ?? '';
    } else if (emailProvider.isLoggedIn) {
      displayName = Provider.of<EmailUsernameApiProvider>(context, listen: false).getUsername ?? "Email User";
      uid = emailTokenProvider.getUserID ?? 'No uid found';
      profilePictureUrl = emailProvider.user?.photoURL ?? '';
    }

    onUpdateState(displayName, uid, profilePictureUrl);
  }

  Future<void> saveLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', language);
  }
}
