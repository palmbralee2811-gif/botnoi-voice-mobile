import 'package:botnoivoice/presentation/providers/apple/apple_login_provider.dart';
import 'package:botnoivoice/presentation/providers/apple/apple_token_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_forget_password_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_token_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_username_api_provider.dart';
import 'package:botnoivoice/presentation/providers/google/get_user_email.dart';
import 'package:botnoivoice/presentation/providers/google/google_login_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_token_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_login_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_token_provider.dart';
import 'package:botnoivoice/presentation/providers/user/user_info_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/// ฟังก์ชันสำหรับโหลดข้อมูลผู้ใช้
Future<void> loadUserInfo(
    BuildContext context,
    ValueNotifier<String> displayNameNotifier,
    ValueNotifier<String> userIdNotifier,
    ValueNotifier<String> emailNotifier,
    ValueNotifier<bool> isLineLoggedInNotifier,
    ValueNotifier<bool> isAppleLoggedInNotifier,
    ValueNotifier<bool> isGoogleLoggedInNotifier,
    ValueNotifier<bool> isEmailLoggedInNotifier) async {
  // Fetch user data from Firebase
  var appleProvider = Provider.of<AppleLoginProvider>(context, listen: false);
  var googleProvider = Provider.of<GoogleLoginProvider>(context, listen: false);
  var lineProvider = Provider.of<LineLoginProvider>(context, listen: false);
  var emailProvider = Provider.of<EmailLoginProvider>(context, listen: false);
  var userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);

  // Fetch user data from Database (API)
  var appleTokenProvider =
      Provider.of<AppleTokenProvider>(context, listen: false);
  var googleTokenProvider =
      Provider.of<GoogleTokenProvider>(context, listen: false);
  var lineTokenProvider =
      Provider.of<LineTokenProvider>(context, listen: false);
  var emailTokenProvider =
      Provider.of<EmailTokenProvider>(context, listen: false);

  if (lineProvider.isLoggedIn) {
    displayNameNotifier.value = lineProvider.getDisplayName ?? "Line User";
    userIdNotifier.value = lineTokenProvider.getUserID ?? "No UID";
    emailNotifier.value = lineProvider.getLineEmail ?? "No email found";
    isLineLoggedInNotifier.value = true;
  } else if (appleProvider.isLoggedIn &&
      appleProvider.user?.providerData[0].providerId == 'apple.com') {
    displayNameNotifier.value = appleProvider.user?.displayName ?? 'Apple User';
    userIdNotifier.value = appleTokenProvider.getUserID ?? 'No UID';
    emailNotifier.value =
        getUserEmail(FirebaseAuth.instance.currentUser) ?? 'No email found';
    isAppleLoggedInNotifier.value = true;
  } else if (googleProvider.isLoggedIn &&
      googleProvider.user?.providerData[0].providerId == 'google.com') {
    displayNameNotifier.value =
        googleProvider.user?.displayName ?? 'Google User';
    userIdNotifier.value = googleTokenProvider.getUserID ?? 'No UID';
    emailNotifier.value =
        getUserEmail(FirebaseAuth.instance.currentUser) ?? 'No email found';
    isGoogleLoggedInNotifier.value = true;
  } else if (emailProvider.isLoggedIn &&
      emailProvider.user?.providerData[0].providerId == 'password') {
    userIdNotifier.value = emailTokenProvider.getUserID ?? "No UID";
    displayNameNotifier.value =
        Provider.of<EmailUsernameApiProvider>(context, listen: false)
                .getUsername ??
            "Email/Username User";

    // ตรวจสอบการอนุญาตในการแสดงอีเมล
    if (userInfoProvider.isShowEmail) {
      emailNotifier.value = emailProvider.user?.email ?? "No email found";
    } else {
      emailNotifier.value = "Email Permission is Disabled.";
    }
    isEmailLoggedInNotifier.value = true;
  }

  if (context.mounted) {
    // Ensure the widget is still mounted before calling setState
    (context as Element).markNeedsBuild();
  }
}

/// ฟังก์ชันสำหรับตัด UID ให้แสดง 15 ตัวอักษรแรก
String getDisplayUID(String uid) {
  if (uid.length > 15) {
    return '${uid.substring(0, 15)}...'; // แสดงเฉพาะ 15 ตัวอักษรแรก
  }
  return uid; // แสดง UID ปกติหากไม่เกิน 15 ตัวอักษร
}

/// ฟังก์ชันสำหรับซ่อนอีเมล
String getMaskedEmail(bool isEmailHidden, String email) {
  if (isEmailHidden) {
    var atIndex = email.indexOf('@'); // หาตำแหน่งของ '@'
    if (atIndex > 0) {
      // ซ่อนทุกตัวอักษรก่อน '@' โดยใช้จำนวน '*' เท่ากับจำนวนตัวอักษรใน username
      return '*' * atIndex + email.substring(atIndex);
    } else {
      return "********"; // กรณีที่ไม่สามารถหาตำแหน่ง '@' ได้
    }
  }
  return email; // เปิดเผยอีเมลเต็มเมื่อ isEmailHidden เป็น false
}

/// ฟังก์ชันคัดลอก UID
void copyUID(BuildContext context, String userId) {
  Clipboard.setData(ClipboardData(text: userId));
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        content:
            Text('account.uid_copy_success'.tr())), //UID คัดลอกเรียบร้อยแล้ว
  );
}

/// Function to check if the user has permission to view the email
Future<bool> checkEmailPermission(BuildContext context) async {
  final emailForgetPassword =
      Provider.of<EmailForgetPasswordProvider>(context, listen: false);

  final hasEmailPermission = await emailForgetPassword.checkShowEmail(context);
  return hasEmailPermission; // Return TRUE or FALSE
}
