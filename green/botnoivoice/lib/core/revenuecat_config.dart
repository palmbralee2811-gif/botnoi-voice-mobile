import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:provider/provider.dart';

//TODO: Testing all functions in this provider!!!
/// Configure RevenueCat with the current user ID
Future<void> configureRevenueCat(BuildContext context) async {
  final userId = await getUserId(context);

  await Purchases.configure(
    PurchasesConfiguration("appl_hHLMxSjhEDXVqqqazXdGQsozLmb")
      ..appUserID = userId,
  ).then((_) {
    debugPrint("RevenueCat configured with user ID: $userId");
  }).catchError((error) {
    debugPrint("Error configuring RevenueCat: $error");
  });
}

/// Get the current user ID from available providers
Future<String> getUserId(BuildContext context) async {
  try {
    // Try LINE login provider
    final lineProvider = Provider.of<LineLoginProvider>(context, listen: false);
    if (lineProvider.isLoggedIn) {
      return lineProvider.getIdTokenRaw!;
    }

    // Try Google login provider
    final googleProvider =
        Provider.of<GoogleLoginProvider>(context, listen: false);
    if (googleProvider.isLoggedIn &&
        googleProvider.user?.providerData[0].providerId == 'google.com') {
      return googleProvider.user!.uid;
    }

    // Try Email login provider
    final emailProvider =
        Provider.of<EmailLoginProvider>(context, listen: false);
    if (emailProvider.isLoggedIn &&
        emailProvider.user?.providerData[0].providerId == 'password') {
      return emailProvider.user!.uid;
    }

    throw Exception("User is not logged in.");
  } catch (error) {
    debugPrint("Error fetching user ID: $error");
    throw Exception("Failed to fetch user ID.");
  }
}
