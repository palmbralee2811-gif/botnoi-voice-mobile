import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/service/token/apple_token.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/service/token/email_token.dart';
import 'package:botnoivoice/service/login/google_login.dart';
import 'package:botnoivoice/service/token/google_token.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:botnoivoice/service/token/line_token.dart';

/*
TODO: Fix the following error:

flutter: \^[[38;5;196m┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────<…>
flutter: \^[[38;5;196m│ #0   CallReloadData.callLoadCreditsApi (package:botnoivoice/service/get/call_reload_data.dart:66:15)<…>
flutter: \^[[38;5;196m│ #1   <asynchronous suspension><…>
flutter: \^[[38;5;196m├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄<…>
flutter: \^[[38;5;196m│ ⛔ Failed to load credits: Looking up a deactivated widget's ancestor is unsafe.<…>
flutter: \^[[38;5;196m│ ⛔ At this point the state of the widget's element tree is no longer stable.<…>
flutter: \^[[38;5;196m│ ⛔ To safely refer to a widget's ancestor in its dispose() method, save a reference to the ancestor by calling dependOnInheritedWidgetOfExactType() in the widget's didChangeDependencies() method.<…>
flutter: \^[[38;5;196m└───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

*/

final _logger = Logger();

class CallReloadData with ChangeNotifier {
  String? _remainingCredits;
  String? _remainingQuotaDownload;

  /// Get the remaining credits
  String? get remainingCredits => _remainingCredits;

  /// Get the remaining download quota for generating voice daily (10/10)
  String? get remainingQuotaDownload => _remainingQuotaDownload;

  void setRemainingCredits(String? credits, String? quotaDownload) {
    _remainingCredits = credits;
    _remainingQuotaDownload = quotaDownload;
    notifyListeners();
  }

  Future<void> callLoadCreditsApi(BuildContext context) async {
    final appleProvider = Provider.of<AppleLogin>(context, listen: false);
    final googleProvider = Provider.of<GoogleLogin>(context, listen: false);
    final lineProvider = Provider.of<LineLogin>(context, listen: false);
    final emailProvider = Provider.of<EmailLogin>(context, listen: false);

    try {
      if (appleProvider.isLoggedIn &&
          appleProvider.user?.providerData[0].providerId == 'apple.com') {
        await Provider.of<AppleToken>(context, listen: false)
            .loadRemainingCredits();
      }

      if (googleProvider.isLoggedIn &&
          googleProvider.user?.providerData[0].providerId == 'google.com') {
        await Provider.of<GoogleToken>(context, listen: false)
            .loadRemainingCredits();
      }

      if (lineProvider.isLoggedIn) {
        await Provider.of<LineToken>(context, listen: false)
            .loadRemainingCredits();
      }

      if (emailProvider.isLoggedIn &&
          emailProvider.user?.providerData[0].providerId == 'password') {
        await Provider.of<EmailToken>(context, listen: false)
            .loadRemainingCredits();
      }

      // After getting the credits, update the CreditsProvider
      final credits = await _getRemainingCredits(context);
      final quotaDownload = await _getRemainingQuotaDownload(context);
      setRemainingCredits(credits, quotaDownload);
    } catch (e) {
      _logger.e('Failed to load credits: $e');
    }
  }

  Future<String?> _getRemainingCredits(BuildContext context) async {
    final appleProvider = Provider.of<AppleLogin>(context, listen: false);
    final googleProvider = Provider.of<GoogleLogin>(context, listen: false);
    final lineProvider = Provider.of<LineLogin>(context, listen: false);
    final emailProvider = Provider.of<EmailLogin>(context, listen: false);

    try {
      if (appleProvider.isLoggedIn &&
          appleProvider.user?.providerData[0].providerId == 'apple.com') {
        _logger.d('User logged in with Apple');
        return Provider.of<AppleToken>(context, listen: false)
            .getRemainingCredits;
      }

      if (googleProvider.isLoggedIn &&
          googleProvider.user?.providerData[0].providerId == 'google.com') {
        _logger.d('User logged in with Google');
        return Provider.of<GoogleToken>(context, listen: false)
            .getRemainingCredits;
      }

      if (lineProvider.isLoggedIn) {
        _logger.d('User logged in with LINE');
        return Provider.of<LineToken>(context, listen: false)
            .getRemainingCredits;
      }

      if (emailProvider.isLoggedIn &&
          emailProvider.user?.providerData[0].providerId == 'password') {
        _logger.d('User logged in with Email');
        return Provider.of<EmailToken>(context, listen: false)
            .getRemainingCredits;
      }

      _logger.w('No valid login provider found');
      return "N/A";
    } catch (e) {
      _logger.e('Failed to get remaining credits', error: e);
      return "N/A";
    }
  }

  Future<String?> _getRemainingQuotaDownload(BuildContext context) async {
    final appleProvider = Provider.of<AppleLogin>(context, listen: false);
    final googleProvider = Provider.of<GoogleLogin>(context, listen: false);
    final lineProvider = Provider.of<LineLogin>(context, listen: false);
    final emailProvider = Provider.of<EmailLogin>(context, listen: false);

    try {
      if (appleProvider.isLoggedIn &&
          appleProvider.user?.providerData[0].providerId == 'apple.com') {
        _logger.d('User logged in with Apple');
        return Provider.of<AppleToken>(context, listen: false).getQuotaDownload;
      }

      if (googleProvider.isLoggedIn &&
          googleProvider.user?.providerData[0].providerId == 'google.com') {
        _logger.d('User logged in with Google');
        return Provider.of<GoogleToken>(context, listen: false)
            .getQuotaDownload;
      }

      if (lineProvider.isLoggedIn) {
        _logger.d('User logged in with LINE');
        return Provider.of<LineToken>(context, listen: false).getQuotaDownload;
      }

      if (emailProvider.isLoggedIn &&
          emailProvider.user?.providerData[0].providerId == 'password') {
        _logger.d('User logged in with Email');
        return Provider.of<EmailToken>(context, listen: false).getQuotaDownload;
      }

      _logger.w('No valid login provider found');
      return "N/A";
    } catch (e) {
      _logger.e('Failed to get remaining quota download', error: e);
      return "N/A";
    }
  }
}
