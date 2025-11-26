// import 'package:botnoivoice/service/login/apple_login.dart';
// import 'package:botnoivoice/service/token/apple_token.dart';
// import 'package:botnoivoice/service/login/email_login.dart';
// import 'package:botnoivoice/service/token/email_token.dart';
// import 'package:botnoivoice/service/login/google_login.dart';
// import 'package:botnoivoice/service/token/google_token.dart';
// import 'package:botnoivoice/service/login/line_login.dart';
// import 'package:botnoivoice/service/token/line_token.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:logger/logger.dart';

// /// DO NOT REMOVE THIS LINE
// /// Get JWT Token from all providers
// /// Using in `reward_service.dart`

// final _logger = Logger();

// Future<String?> _getTokenFromProvider(
//     BuildContext context, dynamic loginProvider, dynamic tokenProvider) async {
//   if (loginProvider.isLoggedIn) {
//     final jwtToken = tokenProvider.getJwtToken;
//     _logger.d('ID Token fetched from ${loginProvider.runtimeType}: $jwtToken');
//     return jwtToken;
//   }
//   return null;
// }

// Future<String?> getJwtTokenAll(BuildContext context) async {
//   try {
//     _logger.d('Attempting to fetch ID Token from all providers.');

//     final lineToken = await _getTokenFromProvider(
//         context, context.read<LineLogin>(), context.read<LineToken>());
//     if (lineToken != null) return lineToken;

//     final googleToken = await _getTokenFromProvider(
//         context, context.read<GoogleLogin>(), context.read<GoogleToken>());
//     if (googleToken != null) return googleToken;

//     final appleToken = await _getTokenFromProvider(
//         context, context.read<AppleLogin>(), context.read<AppleToken>());
//     if (appleToken != null) return appleToken;

//     final emailToken = await _getTokenFromProvider(
//         context, context.read<EmailLogin>(), context.read<EmailToken>());
//     if (emailToken != null) return emailToken;

//     _logger.d('No ID Token fetched from any provider.');
//     return null;
//   } catch (e) {
//     _logger.e('Error fetching ID Token: $e');
//     return null;
//   }
// }











// import 'package:botnoivoice/service/login/apple_login.dart'; // ไม่ใช้ context.read/Provider แล้ว
// import 'package:botnoivoice/service/token/apple_token.dart'; // เปลี่ยนเป็น Notifier
// ... (ลบ import ของ Provider/Token เดิม)

import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/service/login/user_login_base.dart';
import 'package:botnoivoice/service/token/apple_token.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/service/token/email_token.dart';
import 'package:botnoivoice/service/login/google_login.dart';
import 'package:botnoivoice/service/token/google_token.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:botnoivoice/service/token/line_token.dart';
import 'package:botnoivoice/service/token/user_token_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // **NEW IMPORT**
import 'package:logger/logger.dart';

final _logger = Logger();

/// ฟังก์ชันตัวช่วยในการดึง JWT Token จาก Notifier
/// โดยใช้ WidgetRef เพื่ออ่าน State ของ Riverpod
Future<String?> _getTokenFromProviderRiverpod<TLoginState, TTokenState>(
  WidgetRef ref,
  StateNotifierProvider<dynamic, TLoginState> loginProvider,
  StateNotifierProvider<dynamic, TTokenState> tokenProvider,
) async {
  // อ่าน State ของ Login Notifier (ซึ่งมี isLoggedIn อยู่)
  final loginState = ref.read(loginProvider);
  
  // ตรวจสอบว่ามี Field 'isLoggedIn' และเป็น true หรือไม่ (สำหรับ Login Providers อื่นๆ ที่อาจไม่ได้ใช้ BaseState)
  // สำหรับ LINE Login Notifier ซึ่งมี Field `isLoggedIn`
  final bool isLoggedIn;
  if ((loginState is LineLoginState)) {
    isLoggedIn = loginState.isLoggedIn;
  } else {
    isLoggedIn = (loginState is UserLoginBaseState) && (loginState.isLoggedIn == true);
  }

  if (isLoggedIn) {
    // อ่าน State ของ Token Notifier (UserTokenState)
    final tokenState = ref.read(tokenProvider);
    
    // ตรวจสอบว่ามี Field 'jwtToken' หรือไม่ (สำหรับ Token Providers ทั้งหมดที่ใช้ UserTokenState)
    final String? jwtToken = (tokenState is UserTokenState) 
        ? tokenState.jwtToken
        : null;

    if (jwtToken != null) {
        _logger.d('ID Token fetched from ${loginProvider.runtimeType}: $jwtToken');
        return jwtToken;
    }
  }
  return null;
}

/// Get JWT Token from all providers using Riverpod ref.
Future<String?> getJwtTokenAll(WidgetRef ref) async {
  try {
    _logger.d('Attempting to fetch ID Token from all providers using Riverpod.');

    // 1. LINE Login (ใช้ LineLoginState/LineTokenNotifier)
    final lineToken = await _getTokenFromProviderRiverpod<LineLoginState, UserTokenState>(
        ref, lineLoginNotifierProvider, lineTokenNotifierProvider);
    if (lineToken != null) return lineToken;

    // 2. Google Login (ใช้ GoogleLoginState/GoogleTokenNotifier)
    final googleToken = await _getTokenFromProviderRiverpod<GoogleLoginState, UserTokenState>(
        ref, googleLoginNotifierProvider, googleTokenNotifierProvider);
    if (googleToken != null) return googleToken;

    // 3. Apple Login (ใช้ AppleLoginState/AppleTokenNotifier)
    final appleToken = await _getTokenFromProviderRiverpod<AppleLoginState, UserTokenState>(
        ref, appleLoginNotifierProvider, appleTokenNotifierProvider);
    if (appleToken != null) return appleToken;

    // 4. Email Login (ใช้ EmailLoginState/EmailTokenNotifier)
    final emailToken = await _getTokenFromProviderRiverpod<EmailLoginState, UserTokenState>(
        ref, emailLoginNotifierProvider, emailTokenNotifierProvider);
    if (emailToken != null) return emailToken;

    _logger.d('No ID Token fetched from any provider.');
    return null;
  } catch (e) {
    _logger.e('Error fetching ID Token: $e');
    return null;
  }
}

// วิธีเรียกใช้ใน Widget:
/*
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ...
    // ในฟังก์ชันที่ต้องการเรียกใช้
    // final jwtToken = await getJwtTokenAll(ref);
    // ...
  }
}
*/