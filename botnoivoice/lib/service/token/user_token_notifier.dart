// lib/service/token/user_token_notifier.dart
import 'dart:convert';
import 'package:botnoivoice/config/api_url_config.dart';
import 'package:botnoivoice/service/login/apple_login.dart'; // ใช้สำหรับการเรียก appleLoginNotifierProvider
import 'package:botnoivoice/service/login/email_login.dart'; // ใช้สำหรับการเรียก emailLoginNotifierProvider
import 'package:botnoivoice/service/login/google_login.dart'; // ใช้สำหรับการเรียก googleLoginNotifierProvider
import 'package:botnoivoice/service/login/line_login.dart'; // ใช้สำหรับการเรียก lineLoginNotifierProvider
import 'package:botnoivoice/service/token/user_token_state.dart';
import 'package:botnoivoice/service/token/login_provider_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

/// Class สำหรับจัดการ Token, User Profile และ Credentials สำหรับทุกผู้ให้บริการ
class UserTokenNotifier extends StateNotifier<UserTokenState> {
  final Ref _ref;
  final LoginProviderType _providerType;
  final Logger _logger = Logger();

  UserTokenNotifier(this._ref, this._providerType) : super(UserTokenState());

  /// Helper function: Get the FirebaseAuth User or Line's idTokenRaw
  /// ขึ้นอยู่กับประเภทผู้ให้บริการ
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
        // สำหรับ LINE, idTokenRaw อยู่ใน LineLoginState
        return _ref.read(lineLoginNotifierProvider).idTokenRaw;
    }
  }

  /// Helper function: Get the API URL and Headers for loading JWT Token
  /// ขึ้นอยู่กับประเภทผู้ให้บริการ
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
          // Logic พิเศษสำหรับ LINE
          var message = data['message'] as String? ?? '';
          var tokenIndex = message.indexOf('token=');
          if (tokenIndex != -1) {
            jwtToken = message.substring(tokenIndex + 'token='.length);
          }
        } else {
          // Logic ทั่วไปสำหรับ Apple, Email, Google
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

        int normalCredits = 0;
        int monthlyPoints = 0;
        String totalCredits = '';

        normalCredits = data['data']['credits']?.toInt() ?? 0;
        monthlyPoints = data['data']['monthly_point']?.toInt() ?? 0;
        totalCredits = (normalCredits + monthlyPoints).toString();

        state = state.copyWith(
          userID: data['data']['uid'].toString(),
          userName: data['data']['username'].toString(),
          remainingNormalCredits: normalCredits,
          remainingMonthlyPoints: monthlyPoints,
          remainingCredits: totalCredits,
          isSubscription: data['data']['subscription']?.toString() == 'Pro',
        );

        _logger.i('Remaining credits successfully loaded for $_providerType: ${state.remainingCredits}');
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

// Providers สำหรับผู้ให้บริการแต่ละประเภท
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

// Provider สำหรับการตรวจสอบสถานะการ Login
// ใช้เพื่อตรวจสอบว่าผู้ใช้กำลัง Login ด้วยผู้ให้บริการรายใด
final isLoggedInProvider = Provider<bool>((ref) {
  // Check for Apple Login
  if (ref.watch(appleLoginNotifierProvider).isLoggedIn) return true;
  // Check for Email Login
  if (ref.watch(emailLoginNotifierProvider).isLoggedIn) return true;
  // Check for Google Login
  if (ref.watch(googleLoginNotifierProvider).isLoggedIn) return true;
  // Check for Line Login
  if (ref.watch(lineLoginNotifierProvider).isLoggedIn) return true;
  
  return false;
});

// Provider สำหรับดึง UserTokenState ของผู้ใช้ที่กำลัง Login อยู่
// สามารถใช้ในการเช็คและเรียกโหลด Token/Credits
final currentUserTokenStateProvider = Provider<UserTokenState>((ref) {
  // ใช้ .isLoggedIn จาก Login Notifier แต่ละตัวเพื่อตรวจสอบสถานะ
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
  // หากไม่มีใคร Login
  return UserTokenState();
});

// Provider สำหรับดึง UserTokenNotifier (StateNotifier) ของผู้ใช้ที่กำลัง Login อยู่
final currentUserTokenNotifierProvider = Provider<UserTokenNotifier?>((ref) {
  // ใช้ .isLoggedIn จาก Login Notifier แต่ละตัวเพื่อตรวจสอบสถานะ
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

// ฟังก์ชันสำหรับเรียกใช้ loadJwtToken, loadRemainingCredits, loadCredentials
Future<void> loadAllTokensIfLoggedIn(WidgetRef ref) async {
  final notifier = ref.read(currentUserTokenNotifierProvider);
  if (notifier != null) {
    await notifier.loadJwtToken();
    await notifier.loadRemainingCredits();
    await notifier.loadCredentials();
  }
}