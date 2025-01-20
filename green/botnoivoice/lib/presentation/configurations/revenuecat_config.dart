import 'dart:io';
import 'package:botnoivoice/presentation/configurations/api_key_config.dart';
import 'package:botnoivoice/presentation/providers/apple/apple_login_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

final _logger = Logger();

/// Configure RevenueCat with the current user ID
Future<void> configureRevenueCat(BuildContext context) async {
  //TODO: Deubgging
  await Purchases.setLogLevel(LogLevel.debug);
  // await Purchases.setLogLevel(LogLevel.info);

  try {
    final userId = await getUserId(context);

    await Purchases.configure(
      PurchasesConfiguration(getRevenueCatApiKey())..appUserID = userId,
    );

    _logger.d("RevenueCat configured with user ID: $userId");
  } catch (error) {
    _logger.e("Error configuring RevenueCat", error: error);
  }
}

/// Get the RevenueCat API key based on the platform
String getRevenueCatApiKey() {
  if (Platform.isIOS) return appleRevenueCatApiKey;
  if (Platform.isAndroid) return googleRevenueCatApiKey;
  throw UnsupportedError('Unsupported platform');
}

/// Get the current user ID from Firebase
Future<String> getUserId(BuildContext context) async {
  try {
    // Try LINE login provider
    final lineProvider = Provider.of<LineLoginProvider>(context, listen: false);
    if (lineProvider.isLoggedIn) {
      final userId = lineProvider.getLineUserId!;
      return userId;
    }

    // Try Apple login provider
    final appleProvider =
        Provider.of<AppleLoginProvider>(context, listen: false);
    if (appleProvider.isLoggedIn &&
        appleProvider.user?.providerData[0].providerId == 'apple.com') {
      final userId = appleProvider.user!.uid;
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
