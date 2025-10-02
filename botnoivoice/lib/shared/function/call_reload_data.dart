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

final _logger = Logger();

class CallReloadData with ChangeNotifier {
  String? _remainingCredits;

  // Getter สำหรับเครดิตคงเหลือ
  String? get remainingCredits => _remainingCredits;

  // เซ็ตค่าและ notifyListeners เพื่อให้ UI อัปเดต
  void setRemainingCredits(String? credits) {
    _remainingCredits = credits;
    notifyListeners();
  }

  // ฟังก์ชันโหลดเครดิตหลักแบบปลอดภัย
  Future<void> callLoadCreditsApi(BuildContext context) async {
    // อ่าน provider ทุกตัวให้เรียบร้อยก่อน await ใดๆ
    final appleProvider = context.read<AppleLogin>();
    final googleProvider = context.read<GoogleLogin>();
    final lineProvider = context.read<LineLogin>();
    final emailProvider = context.read<EmailLogin>();

    final appleToken = context.read<AppleToken>();
    final googleToken = context.read<GoogleToken>();
    final lineToken = context.read<LineToken>();
    final emailToken = context.read<EmailToken>();

    try {
      // เรียกโหลดเครดิตตาม provider ที่ล็อกอินอยู่
      if (appleProvider.isLoggedIn &&
          appleProvider.user?.providerData[0].providerId == 'apple.com') {
        await appleToken.loadRemainingCredits();
      }

      if (googleProvider.isLoggedIn &&
          googleProvider.user?.providerData[0].providerId == 'google.com') {
        await googleToken.loadRemainingCredits();
      }

      if (lineProvider.isLoggedIn) {
        await lineToken.loadRemainingCredits();
      }

      if (emailProvider.isLoggedIn &&
          emailProvider.user?.providerData[0].providerId == 'password') {
        await emailToken.loadRemainingCredits();
      }

      // เรียก get ค่าเครดิตและโควต้าดาวน์โหลดแบบปลอดภัย
      final credits = await _getRemainingCreditsFromToken(
        appleProvider,
        googleProvider,
        lineProvider,
        emailProvider,
        appleToken,
        googleToken,
        lineToken,
        emailToken,
      );

      // อัปเดตสถานะใน state provider นี้
      setRemainingCredits(credits);
    } catch (e) {
      _logger.e('Failed to load credits: $e');
    }
  }

  // ดึงเครดิตจาก provider ที่ล็อกอินอยู่
  Future<String?> _getRemainingCreditsFromToken(
    AppleLogin appleProvider,
    GoogleLogin googleProvider,
    LineLogin lineProvider,
    EmailLogin emailProvider,
    AppleToken appleToken,
    GoogleToken googleToken,
    LineToken lineToken,
    EmailToken emailToken,
  ) async {
    try {
      if (appleProvider.isLoggedIn &&
          appleProvider.user?.providerData[0].providerId == 'apple.com') {
        _logger.d('User logged in with Apple');
        return appleToken.getRemainingCredits;
      }

      if (googleProvider.isLoggedIn &&
          googleProvider.user?.providerData[0].providerId == 'google.com') {
        _logger.d('User logged in with Google');
        return googleToken.getRemainingCredits;
      }

      if (lineProvider.isLoggedIn) {
        _logger.d('User logged in with LINE');
        return lineToken.getRemainingCredits;
      }

      if (emailProvider.isLoggedIn &&
          emailProvider.user?.providerData[0].providerId == 'password') {
        _logger.d('User logged in with Email');
        return emailToken.getRemainingCredits;
      }

      _logger.w('No valid login provider found');
      return "N/A";
    } catch (e) {
      _logger.e('Failed to get remaining credits', error: e);
      return "N/A";
    }
  }
}
