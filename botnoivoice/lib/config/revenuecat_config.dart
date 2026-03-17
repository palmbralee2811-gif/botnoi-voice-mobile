import 'dart:io';
import 'package:botnoivoice/config/api_key_config.dart';
import 'package:botnoivoice/shared/function/get_user_id.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

final _logger = Logger();

/// Configure RevenueCat with the current user ID
Future<void> configureRevenueCat(WidgetRef ref) async {
  if (kIsWeb) {
    _logger.d("RevenueCat not supported on web, skipping configuration");
    return;
  }

  await Purchases.setLogLevel(LogLevel.debug);

  try {
    final userId = await getUserIdAll(ref);

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
  if (kIsWeb) throw UnsupportedError('RevenueCat not supported on web');
  if (Platform.isIOS) return appleRevenueCatApiKey;
  if (Platform.isAndroid) return googleRevenueCatApiKey;
  throw UnsupportedError('Unsupported platform');
}
