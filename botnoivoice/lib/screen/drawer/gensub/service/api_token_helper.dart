// api_token_helper.dart

import 'package:botnoivoice/config/api_url_config.dart';
import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ฟังก์ชันดึง Token หลัก (Credentials Token/JWT) ตามลำดับความสำคัญ
// Note: ฟังก์ชันนี้ทำงานถูกต้องแล้ว และไม่ต้องแก้ไข

String getSelectedBotnoiToken(WidgetRef ref) {
  final userTokenState = ref.watch(currentUserTokenStateProvider).credentialsToken;
  return userTokenState ?? '';
}

/// Headers สำหรับ JSON Requests (ใช้ Botnoi-Token และใช้ 'token' ที่ถูกส่งมา)
Map<String, String> getJsonHeadersWithAuth(String token) => {
  "Content-Type": "application/json",
  "Authorization": "Bearer $token", //  ใช้ token ที่รับเข้ามาใน Argument
  "Referer": apiUrl,
};

/// Headers สำหรับ Multipart Form Data Requests (ใช้ Botnoi-Token และใช้ 'token' ที่ถูกส่งมา)
Map<String, String> getMultipartHeadersWithAuth(String token) => {
  "Authorization": "Bearer $token", //  ใช้ token ที่รับเข้ามาใน Argument
  "Referer": apiUrl,
};