// Path: lib/service/reward/reward_service.dart

import 'dart:convert';
import 'package:botnoivoice/config/api_url_config.dart';
import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- Riverpod Providers ---

// A StateProvider to manage the loading state (bool)
final isLoadingProvider = StateProvider<bool>((ref) => false);

// A StateProvider to manage the error message (String?)
final errorMessageProvider = StateProvider<String?>((ref) => null);

// A Provider for the RewardService instance, allowing access to its methods.
// It uses a Ref to interact with other providers.
final rewardServiceProvider = Provider((ref) => RewardService(ref));

// --- RewardService Class ---

// We remove 'with ChangeNotifier' and accept a Ref in the constructor.
class RewardService {
  final Ref _ref;
  final _logger = Logger();

  // Constructor accepts a Ref from Riverpod.
  RewardService(this._ref);

  /// Getter for error message, reading from the StateProvider.
  String? get errorMessage => _ref.read(errorMessageProvider);

  /// Getter for loading status, reading from the StateProvider.
  bool get isLoading => _ref.read(isLoadingProvider);

  /// Function to set the `isLoading` state and notify the UI via StateProvider.
  void _setLoading(bool value) {
    // We use ref.read(...).state or ref.watch/read to access the StateController
    // and then set its state.
    _ref.read(isLoadingProvider.notifier).state = value;
  }

  /// Function to check and redeem the 100-credit coupon.
  /// Note: The original function accepted BuildContext. In Riverpod, for logic
  /// that interacts with UI/other providers, we pass WidgetRef (from a Widget)
  /// or just use the internal Ref, but since this still uses `context.read<CallReloadData>()`
  /// in other methods, we adapt by passing BuildContext (not ideal for pure logic)
  /// or better, passing the necessary Riverpod Ref. We use the internal `_ref`.
  Future<void> checkCoupon100(WidgetRef ref) async {
    _setLoading(true);
    // Reset error message by setting the provider's state to null.
    _ref.read(errorMessageProvider.notifier).state = null;

    try {
      _logger.d('Starting checkCoupon100');
      // We still need BuildContext for `getJwtTokenAll` if it's based on Provider/BuildContext
      final jwtToken = await _fetchJwtToken(ref);
      // If _fetchJwtToken fails, it sets _ref.read(errorMessageProvider) and returns null
      if (jwtToken == null) {
        _logger.e('checkCoupon100: Failed to get JWT token.');
        return;
      }

      final couponCode = await _getCouponNameForToday();

      // --- Important Fix/Logic ---
      if (couponCode == null) {
        // Only set the coupon-specific error if no other error was set during fetching
        if (_ref.read(errorMessageProvider) == null) {
          _ref.read(errorMessageProvider.notifier).state =
              'reward_service.no_daily_coupon_to_redeem'.tr();
          _logger.w(
              'checkCoupon100: No daily coupon code available to redeem (${_ref.read(errorMessageProvider)})');
        } else {
          _logger.e(
              'checkCoupon100: Error occurred while getting coupon name: ${_ref.read(errorMessageProvider)}');
        }
        return;
      }
      // ---------------
      _logger.d('Calling _callCheckCouponApi with couponCode: $couponCode');
      await _callCheckCouponApi(jwtToken, couponCode);
    } catch (e) {
      // Catching any exceptions that might occur outside of handled logic.
      final errorMessage = '${'reward_service.error_message'.tr()} $e';
      _ref.read(errorMessageProvider.notifier).state = errorMessage;
      _logger.e('Exception in checkCoupon100: $errorMessage');
    } finally {
      _setLoading(false); // Always stop loading
    }
  }

  /// Function to check and redeem the 1,000-credit coupon.
  Future<void> checkCoupon1K(WidgetRef ref) async {
    _setLoading(true);
    try {
      _logger.d('Starting checkCoupon1K');
      final jwtToken = await _fetchJwtToken(ref);
      if (jwtToken == null) return;

      // Set the coupon code to redeem
      const couponCode = 'mobile1000';
      _logger.d('Calling _callCheckCouponApi with couponCode: $couponCode');
      await _callCheckCouponApi(jwtToken, couponCode);
    } catch (e) {
      final errorMessage = '${'reward_service.error_message'.tr()} $e';
      _ref.read(errorMessageProvider.notifier).state = errorMessage;
      _logger.e(errorMessage);
    } finally {
      _setLoading(false);
    }
  }

  // ADDED: education subscription
  Future<void> getEducationSubscription(WidgetRef ref) async {
    _setLoading(true);
    // Clear previous error message
    _ref.read(errorMessageProvider.notifier).state = null;

    try {
      _logger.d('Starting getEducationSubscription');
      final jwtToken = await _fetchJwtToken(ref);
      if (jwtToken == null) {
        _setLoading(false);
        return;
      }
      // API Endpoint for education subscription
      final url = '$apiUrl/api/stripe/get_education';
      _logger.d('Calling GET request to $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': "Bearer $jwtToken",
        },
      );

      _logger.d('Received response with status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Clear error message on success.
        _ref.read(errorMessageProvider.notifier).state = null;

        // Instead of `context.read<CallReloadData>()`, use Riverpod's ref.read
        // to access the CallReloadData service provider.
        // We assume CallReloadData is now wrapped in a Riverpod Provider.
        final creditsProvider = loadAllTokensIfLoggedIn(ref);

        await creditsProvider;

        _logger.d('Successfully get education subscription.');
      } else {
        // Handle errors
        String? newErrorMessage;
        if (response.statusCode == 403) {
          if (response.body.contains('already have subscription')) {
            newErrorMessage =
                'reward_service.already_subscribed'.tr(); // Already subscribed
          } else if (response.body.contains('invalid sign in provider')) {
            newErrorMessage =
                'reward_service.failure_provider'.tr(); // Invalid provider
          } else if (response.body
              .contains('invalid domain adn whitelist education')) {
            newErrorMessage =
                'reward_service.failcase_whitelist'.tr(); // Not whitelisted
          } else {
            newErrorMessage =
                'reward_service.failure_case'.tr(); // General failure case
          }
        } else {
          // For other errors
          final responseBody = jsonDecode(response.body);
          newErrorMessage = responseBody['detail'] ??
              '${'reward_service.failure_case'.tr()} (Code: ${response.statusCode})';
        }
        // Set the error message in the provider state.
        _ref.read(errorMessageProvider.notifier).state = newErrorMessage;
      }
    } catch (e) {
      final errorMessage = '${'reward_service.error_message'.tr()} $e';
      _ref.read(errorMessageProvider.notifier).state = errorMessage;
      _logger.e(errorMessage);
    } finally {
      _setLoading(false);
    }
  }

  /// Function to fetch the JWT Token.
  Future<String?> _fetchJwtToken(WidgetRef ref) async {
    try {
      // Assuming getJwtTokenAll is a function that still relies on BuildContext/Provider
      final jwtToken = ref.read(currentUserTokenStateProvider).jwtToken;

      if (jwtToken == null) {
        // Set error message in provider state
        _ref.read(errorMessageProvider.notifier).state =
            'Failed to fetch ID token';
        _logger.e(_ref.read(errorMessageProvider));
      }
      return jwtToken;
    } catch (e) {
      final errorMessage = 'Exception occurred while fetching ID token: $e';
      // Set error message in provider state
      _ref.read(errorMessageProvider.notifier).state = errorMessage;
      _logger.e(errorMessage);
      return null;
    }
  }

  /// Function to fetch the daily available coupon name.
  Future<String?> _getCouponNameForToday() async {
    _setLoading(true);
    String?
        localErrorMessageForThisCall; // Local variable for this call's error

    try {
      _logger.d(
          'Fetching daily coupon name from $apiUrl/api/coupon/get_coupon_daily');
      final response =
          await http.get(Uri.parse('$apiUrl/api/coupon/get_coupon_daily'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String? couponName = data['coupon_name'];

        if (couponName != null && couponName.isNotEmpty) {
          _logger.i('Daily coupon name for today: $couponName');
          _ref.read(errorMessageProvider.notifier).state =
              null; // Clear error on success
          return couponName;
        } else {
          _logger.i(
              'No daily coupon name found (API returned 200 OK but no/empty name). This is treated as "no coupon data".');
          _ref.read(errorMessageProvider.notifier).state = null;
          return null;
        }
      } else if (response.statusCode == 404) {
        _logger.i(
            'No daily coupon set for today (API returned 404 Not Found). This is a valid "no coupon" state.');
        _ref.read(errorMessageProvider.notifier).state = null;
        return null;
      } else {
        localErrorMessageForThisCall =
            'Failed to fetch daily coupon name: ${response.statusCode} - ${response.body.substring(0, (response.body.length > 150) ? 150 : response.body.length)}';
        _logger.e(localErrorMessageForThisCall);
        _ref.read(errorMessageProvider.notifier).state =
            localErrorMessageForThisCall; // Set as Service error
        return null;
      }
    } catch (e) {
      // Exception during API call
      localErrorMessageForThisCall = 'Exception fetching daily coupon name: $e';
      _logger.e(localErrorMessageForThisCall);
      _ref.read(errorMessageProvider.notifier).state =
          localErrorMessageForThisCall; // Set as Service error
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Internal function to call the coupon checking API.
  Future<void> _callCheckCouponApi(String jwtToken, String couponName) async {
    _setLoading(true);
    // Clear previous error message
    _ref.read(errorMessageProvider.notifier).state = null;

    try {
      String url = '$apiUrl/api/coupon/check_coupon';

      _logger.d('Sending POST request to $url with couponCode: $couponName');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer $jwtToken",
        },
        body: jsonEncode({'coupon_name': couponName}),
      );

      _logger.d('Received response with status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final message = responseBody['message'];
        _logger.d('Response body: $responseBody');

        if (message == 'Use Coupon Success') {
          _ref.read(errorMessageProvider.notifier).state = null;
          _logger.d('Coupon redeemed successfully $couponName');
        } else if (message == 'already in use') {
          // Coupon has already been used.
          _ref.read(errorMessageProvider.notifier).state =
              'reward_service.coupon_already_used'.tr();
          _logger.e(_ref.read(errorMessageProvider));
        } else if (message == 'Incorrect Coupon') {
          // Coupon not found or no longer usable.
          _ref.read(errorMessageProvider.notifier).state =
              'reward_service.coupon_not_found'.tr();
          _logger.e(_ref.read(errorMessageProvider));
        } else {
          // Coupon not found in the system or has expired.
          _ref.read(errorMessageProvider.notifier).state =
              'reward_service.coupon_expired_or_not_found'.tr();
          _logger.e(_ref.read(errorMessageProvider));
        }
      } else {
        // Error occurred during API call.
        final errorMessage =
            '${'reward_service.api_call_error'.tr()} ${response.statusCode}';
        _ref.read(errorMessageProvider.notifier).state = errorMessage;
        _logger.e(errorMessage);
      }
    } catch (e) {
      final errorMessage = 'Exception occurred: $e';
      _ref.read(errorMessageProvider.notifier).state = errorMessage;
      _logger.e(errorMessage);
    } finally {
      _setLoading(false);
    }
  }
}
