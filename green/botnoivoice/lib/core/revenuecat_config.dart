import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

final logger = Logger();

/// Configure RevenueCat with the current user ID
Future<void> configureRevenueCat(BuildContext context) async {
  try {
    final userId = await getUserId(context);
    await Purchases.configure(
      PurchasesConfiguration("appl_hHLMxSjhEDXVqqqazXdGQsozLmb")
        ..appUserID = userId,
    );
    logger.d("RevenueCat configured with user ID: $userId");
  } catch (error) {
    logger.e("Error configuring RevenueCat", error: error);
  }
}

/// Get the current user ID from available providers
Future<String> getUserId(BuildContext context) async {
  try {
    // Try LINE login provider
    final lineProvider = Provider.of<LineLoginProvider>(context, listen: false);
    if (lineProvider.isLoggedIn) {
      //TODO: fix this error by wrong user id
      final userId = lineProvider.getIdTokenRaw!;
      return userId;
    }

    // Try Google login provider
    final googleProvider =
        Provider.of<GoogleLoginProvider>(context, listen: false);
    if (googleProvider.isLoggedIn &&
        googleProvider.user?.providerData[0].providerId == 'google.com') {
      final userId = googleProvider.user!.uid;
      return userId;
    }

    // Try Email login provider
    final emailProvider =
        Provider.of<EmailLoginProvider>(context, listen: false);
    if (emailProvider.isLoggedIn &&
        emailProvider.user?.providerData[0].providerId == 'password') {
      final userId = emailProvider.user!.uid;
      return userId;
    }

    throw Exception("User is not logged in.");
  } catch (error) {
    throw Exception("Failed to fetch user ID.");
  }
}
