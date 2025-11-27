// lib/service/token/user_token_notifier.dart
import 'dart:convert';
import 'package:botnoivoice/config/api_url_config.dart';
import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/service/login/google_login.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:botnoivoice/service/token/user_token_state.dart';
import 'package:botnoivoice/service/token/login_provider_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

/// Class for managing Token, User Profile, and Credentials for all providers
class UserTokenNotifier extends StateNotifier<UserTokenState> {
  final Ref _ref;
  final LoginProviderType _providerType;
  final Logger _logger = Logger();

  UserTokenNotifier(this._ref, this._providerType) : super(UserTokenState());

  /// Helper function: Get the FirebaseAuth User or Line's idTokenRaw
  Future<String?> _getAuthToken() async {
    switch (_providerType) {
      case LoginProviderType.apple:
        final appleLoginNotifier = _ref.read(appleLoginNotifierProvider.notifier);
        return await appleLoginNotifier.user?.getIdToken();
      case LoginProviderType.email:
        final emailLoginNotifier = _ref.read(emailLoginNotifierProvider.notifier);
        return await emailLoginNotifier.user?.getIdToken();
      case LoginProviderType.google:
        final googleLoginNotifier = _ref.read(googleLoginNotifierProvider.notifier);
        return await googleLoginNotifier.user?.getIdToken();
      case LoginProviderType.line:
        return _ref.read(lineLoginNotifierProvider).idTokenRaw;
    }
  }

  /// Helper function: Get the API URL and Headers for loading JWT Token
  Map<String, dynamic> _getJwtTokenApiConfig(String idToken) {
    String url;
    Map<String, String> headers;
    
    switch (_providerType) {
      case LoginProviderType.email:
        url = '$apiUrl/api/dashboard/sign_in';
        headers = {
          'firebase-token': 'Bearer $idToken',
          'Content-Type': 'application/json'
        };
        break;
      case LoginProviderType.apple:
      case LoginProviderType.google:
        url = '$apiUrl/api/dashboard/firebase_auth';
        headers = {
          'Botnoi-Token': 'Bearer $idToken',
          'Content-Type': 'application/json'
        };
        break;
      case LoginProviderType.line:
        url = '$apiUrl/api/dashboard/liff';
        headers = {
          'Botnoi-Token': 'Bearer $idToken',
          'Content-Type': 'application/json'
        };
        break;
    }
    return {'url': url, 'headers': headers};
  }

  /// Clear all the tokens
  void clearTokens() {
    state = UserTokenState(); // Reset state to initial values
    _logger.i("Tokens cleared for $_providerType.");
  }

  /// Get the _jwtToken from the backend API
  Future<void> loadJwtToken() async {
    final idToken = await _getAuthToken();

    if (idToken == null) {
      _logger.e("Error: $_providerType idToken is null");
      return;
    }

    final config = _getJwtTokenApiConfig(idToken);
    final url = config['url'] as String;
    final headers = config['headers'] as Map<String, String>;

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String? jwtToken;

        if (_providerType == LoginProviderType.line) {
          // Logic for LINE
          var message = data['message'] as String? ?? '';
          var tokenIndex = message.indexOf('token=');
          if (tokenIndex != -1) {
            jwtToken = message.substring(tokenIndex + 'token='.length);
          }
        } else {
          // Logic for Apple, Email, Google
          if (data['data'] != null && data['data']['token'] != null) {
            jwtToken = data['data']['token'] as String;
          }
        }
        
        if (jwtToken != null) {
          state = state.copyWith(jwtToken: jwtToken);
          _logger.i('JWT Token successfully loaded for $_providerType.');
        } else {
          _logger.w('Token not found in response data for $_providerType.');
        }
      } else {
        _logger.e('Failed to load JWT Token for $_providerType: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Error fetching JWT Token for $_providerType: $e');
    }
  }

  /// Get the remaining credits using _jwtToken
  Future<void> loadRemainingCredits() async {
    if (state.jwtToken == null) return;

    String url = '$apiUrl/api/dashboard/get_profile';
    Map<String, String> headers = {
      'Authorization': 'Bearer ${state.jwtToken}',
      'Content-Type': 'application/json'
    };
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var data = json.decode(utf8.decode(response.bodyBytes));
        _logger.i('Get Profile Data for $_providerType: $data');

        // Extract credits and monthly points safely
        // Casting to 'num?' allows handling both int and double values from API
        int normalCredits = (data['data']['credits'] as num?)?.toInt() ?? 0;
        int monthlyPoints = (data['data']['monthly_point'] as num?)?.toInt() ?? 0;
        
        // Calculate total remaining credits
        String totalCredits = (normalCredits + monthlyPoints).toString();

        state = state.copyWith(
          userID: data['data']['uid'].toString(),
          userName: data['data']['username'].toString(),
          remainingNormalCredits: normalCredits,
          remainingMonthlyPoints: monthlyPoints,
          remainingCredits: totalCredits, // Set the combined total here
          isSubscription: data['data']['subscription']?.toString() == 'Pro',
        );

        _logger.i('Remaining credits successfully loaded for $_providerType: ${state.remainingCredits} (Normal: $normalCredits + Monthly: $monthlyPoints)');
      } else {
        _logger.e("Failed to retrieve remaining credits for $_providerType: ${response.statusCode}");
      }
    } catch (e) {
      _logger.e('Error fetching remaining credits for $_providerType: $e');
    }
  }

  /// Get the credentials token using _jwtToken
  Future<void> loadCredentials() async {
    if (state.jwtToken == null) return;

    String url = '$apiUrl/api/service/get_token';
    Map<String, dynamic> payload = {};
    Map<String, String> headers = {
      'Authorization': 'Bearer ${state.jwtToken}',
      'Content-Type': 'application/json'
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        state = state.copyWith(credentialsToken: data['data'][0]['token'].toString());
        _logger.i('Credentials token successfully loaded for $_providerType.');
      } else {
        _logger.e('Failed to load Credentials-Token for $_providerType: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Error fetching Credentials-Token for $_providerType: $e');
    }
  }
}

// Providers for each service type
final appleTokenNotifierProvider = StateNotifierProvider<UserTokenNotifier, UserTokenState>((ref) {
  return UserTokenNotifier(ref, LoginProviderType.apple);
});

final emailTokenNotifierProvider = StateNotifierProvider<UserTokenNotifier, UserTokenState>((ref) {
  return UserTokenNotifier(ref, LoginProviderType.email);
});

final googleTokenNotifierProvider = StateNotifierProvider<UserTokenNotifier, UserTokenState>((ref) {
  return UserTokenNotifier(ref, LoginProviderType.google);
});

final lineTokenNotifierProvider = StateNotifierProvider<UserTokenNotifier, UserTokenState>((ref) {
  return UserTokenNotifier(ref, LoginProviderType.line);
});

// Provider to check login status
final isLoggedInProvider = Provider<bool>((ref) {
  if (ref.watch(appleLoginNotifierProvider).isLoggedIn) return true;
  if (ref.watch(emailLoginNotifierProvider).isLoggedIn) return true;
  if (ref.watch(googleLoginNotifierProvider).isLoggedIn) return true;
  if (ref.watch(lineLoginNotifierProvider).isLoggedIn) return true;
  return false;
});

// Provider to get the UserTokenState of the currently logged-in user
final currentUserTokenStateProvider = Provider<UserTokenState>((ref) {
  if (ref.watch(appleLoginNotifierProvider).isLoggedIn) {
    return ref.watch(appleTokenNotifierProvider);
  }
  if (ref.watch(emailLoginNotifierProvider).isLoggedIn) {
    return ref.watch(emailTokenNotifierProvider);
  }
  if (ref.watch(googleLoginNotifierProvider).isLoggedIn) {
    return ref.watch(googleTokenNotifierProvider);
  }
  if (ref.watch(lineLoginNotifierProvider).isLoggedIn) {
    return ref.watch(lineTokenNotifierProvider);
  }
  return UserTokenState();
});

// Provider to get the UserTokenNotifier of the currently logged-in user
final currentUserTokenNotifierProvider = Provider<UserTokenNotifier?>((ref) {
  if (ref.watch(appleLoginNotifierProvider).isLoggedIn) {
    return ref.read(appleTokenNotifierProvider.notifier);
  }
  if (ref.watch(emailLoginNotifierProvider).isLoggedIn) {
    return ref.read(emailTokenNotifierProvider.notifier);
  }
  if (ref.watch(googleLoginNotifierProvider).isLoggedIn) {
    return ref.read(googleTokenNotifierProvider.notifier);
  }
  if (ref.watch(lineLoginNotifierProvider).isLoggedIn) {
    return ref.read(lineTokenNotifierProvider.notifier);
  }
  return null;
});

// Function to trigger loading all tokens
Future<void> loadAllTokensIfLoggedIn(WidgetRef ref) async {
  final notifier = ref.read(currentUserTokenNotifierProvider);
  if (notifier != null) {
    await notifier.loadJwtToken();
    await notifier.loadRemainingCredits();
    await notifier.loadCredentials();
  }
}