// api_token_helper.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:botnoivoice/service/login/line_login.dart'; 
import 'package:botnoivoice/service/token/apple_token.dart';
import 'package:botnoivoice/service/token/email_token.dart';
import 'package:botnoivoice/service/token/google_token.dart';
import 'package:botnoivoice/service/token/line_token.dart';

/// Referer URL 
const String projectApiReferer = "https://api-voice.botnoi.ai";

/// ฟังก์ชันดึง Token หลัก (Credentials Token/JWT) ตามลำดับความสำคัญ
// Note: ฟังก์ชันนี้ทำงานถูกต้องแล้ว และไม่ต้องแก้ไข


String getSelectedBotnoiToken(BuildContext context) {
  String? appleCredentialsToken = context.read<AppleToken>().getCredentialsToken;
  String? googleCredentialsToken = context.read<GoogleToken>().getCredentialsToken;
  String? lineCredentialsToken = context.read<LineToken>().getCredentialsToken;
  String? emailCredentialsToken = context.read<EmailToken>().getCredentialsToken;

  String? selectedToken;
  
  // ลำดับการเลือก Token
  if (context.read<LineLogin>().isLoggedIn) {
    selectedToken = lineCredentialsToken;
  } else if (appleCredentialsToken != null && appleCredentialsToken.isNotEmpty) {
    selectedToken = appleCredentialsToken;
  } else if (googleCredentialsToken != null && googleCredentialsToken.isNotEmpty) {
    selectedToken = googleCredentialsToken;
  } else if (emailCredentialsToken != null && emailCredentialsToken.isNotEmpty) {
    selectedToken = emailCredentialsToken;
  } else {
    selectedToken = ''; // Default/Fallback
  }

  return selectedToken ?? '';
}

/// Headers สำหรับ JSON Requests (ใช้ Botnoi-Token และใช้ 'token' ที่ถูกส่งมา)
Map<String, String> getJsonHeadersWithAuth(String token) => {
  "Content-Type": "application/json",
  "Authorization": "Bearer $token", //  ใช้ token ที่รับเข้ามาใน Argument
  "Referer": projectApiReferer,
};

/// Headers สำหรับ Multipart Form Data Requests (ใช้ Botnoi-Token และใช้ 'token' ที่ถูกส่งมา)
Map<String, String> getMultipartHeadersWithAuth(String token) => {
  "Authorization": "Bearer $token", //  ใช้ token ที่รับเข้ามาใน Argument
  "Referer": projectApiReferer,
};