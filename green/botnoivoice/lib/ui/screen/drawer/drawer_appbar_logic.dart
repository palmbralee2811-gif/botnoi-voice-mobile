import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/service/token/apple_token.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/service/token/email_token.dart';
import 'package:botnoivoice/service/email/email_username_api.dart';
import 'package:botnoivoice/service/login/google_login.dart';
import 'package:botnoivoice/service/token/google_token.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:botnoivoice/service/token/line_token.dart';
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
    var appleProvider = Provider.of<AppleLogin>(context, listen: false);
    var googleProvider = Provider.of<GoogleLogin>(context, listen: false);
    var lineProvider = Provider.of<LineLogin>(context, listen: false);
    var emailProvider = Provider.of<EmailLogin>(context, listen: false);

    /// Fetch user data from Database (API)
    var appleTokenProvider = Provider.of<AppleToken>(context, listen: false);
    var googleTokenProvider = Provider.of<GoogleToken>(context, listen: false);
    var lineTokenProvider = Provider.of<LineToken>(context, listen: false);
    var emailTokenProvider = Provider.of<EmailToken>(context, listen: false);

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
      displayName =
          Provider.of<EmailUsernameApi>(context, listen: false).getUsername ??
              "Email User";
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
