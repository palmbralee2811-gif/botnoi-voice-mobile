import 'package:botnoivoice/auth/auth_checker.dart';
import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/service/token/apple_token.dart';
import 'package:botnoivoice/service/email/email_forget_password.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/service/token/email_token.dart';
import 'package:botnoivoice/service/email/email_username_api.dart';
import 'package:botnoivoice/ui/screen/drawer/account/get_user_email.dart';
import 'package:botnoivoice/service/login/google_login.dart';
import 'package:botnoivoice/service/token/google_token.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:botnoivoice/service/token/line_token.dart';
import 'package:botnoivoice/service/email/check_user_is_show_email.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AccountScreenLogic {
  Future<void> loadUserInfo({
    required BuildContext context,
    required Function(
            String displayName,
            String userId,
            String email,
            bool isEmailLoggedIn,
            bool isAppleLoggedIn,
            bool isGoogleLoggedIn,
            bool isLineLoggedIn)
        onUpdateState,
  }) async {
    /// Fetch user data from Firebase
    var appleProvider = Provider.of<AppleLogin>(context, listen: false);
    var googleProvider = Provider.of<GoogleLogin>(context, listen: false);
    var lineProvider = Provider.of<LineLogin>(context, listen: false);
    var emailProvider = Provider.of<EmailLogin>(context, listen: false);
    var userInfoProvider =
        Provider.of<CheckUserIsShowEmail>(context, listen: false);

    /// Fetch user data from Database (API)
    var appleTokenProvider = Provider.of<AppleToken>(context, listen: false);
    var googleTokenProvider = Provider.of<GoogleToken>(context, listen: false);
    var lineTokenProvider = Provider.of<LineToken>(context, listen: false);
    var emailTokenProvider = Provider.of<EmailToken>(context, listen: false);

    String displayName = "Loading...";
    String userId = "Loading...";
    String email = "Loading...";
    bool isEmailLoggedIn = false;
    bool isAppleLoggedIn = false;
    bool isGoogleLoggedIn = false;
    bool isLineLoggedIn = false;

    if (lineProvider.isLoggedIn) {
      displayName = lineProvider.getDisplayName ?? "Line User";
      userId = lineTokenProvider.getUserID ?? "No UID";
      email = lineProvider.getLineEmail ?? "No email found";
      isLineLoggedIn = true;
    } else if (appleProvider.isLoggedIn) {
      displayName = appleProvider.user?.displayName ?? 'Apple User';
      userId = appleTokenProvider.getUserID ?? 'No UID';
      email =
          getUserEmail(FirebaseAuth.instance.currentUser) ?? 'No email found';
      isAppleLoggedIn = true;
    } else if (googleProvider.isLoggedIn) {
      displayName = googleProvider.user?.displayName ?? 'Google User';
      userId = googleTokenProvider.getUserID ?? 'No UID';
      email =
          getUserEmail(FirebaseAuth.instance.currentUser) ?? 'No email found';
      isGoogleLoggedIn = true;
    } else if (emailProvider.isLoggedIn) {
      userId = emailTokenProvider.getUserID ?? "No UID";
      displayName =
          Provider.of<EmailUsernameApi>(context, listen: false).getUsername ??
              "Email User";
      email = userInfoProvider.isShowEmail
          ? (emailProvider.user?.email ?? "No email found")
          : "Email Permission is Disabled.";
      isEmailLoggedIn = true;
    }

    onUpdateState(displayName, userId, email, isEmailLoggedIn, isAppleLoggedIn,
        isGoogleLoggedIn, isLineLoggedIn);
  }

  Future<void> signOut(BuildContext context) async {
    final appleProvider = Provider.of<AppleLogin>(context, listen: false);
    final googleProvider = Provider.of<GoogleLogin>(context, listen: false);
    final lineProvider = Provider.of<LineLogin>(context, listen: false);
    final emailProvider = Provider.of<EmailLogin>(context, listen: false);

    if (appleProvider.isLoggedIn) await appleProvider.signOutWithApple(context);
    if (googleProvider.isLoggedIn) await googleProvider.signOutWithGoogle(context);
    if (lineProvider.isLoggedIn) await lineProvider.signOutWithLine(context);
    if (emailProvider.isLoggedIn) await emailProvider.signOutWithEmail(context);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AuthChecker()),
      (route) => false,
    );
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

  /// ฟังก์ชันสำหรับตัด UID ให้แสดง 15 ตัวอักษรแรก
  String getDisplayUID(String uid) {
    if (uid.length > 15) {
      return '${uid.substring(0, 15)}...'; // แสดงเฉพาะ 15 ตัวอักษรแรก
    }
    return uid; // แสดง UID ปกติหากไม่เกิน 15 ตัวอักษร
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
        Provider.of<EmailForgetPassword>(context, listen: false);

    final hasEmailPermission =
        await emailForgetPassword.checkShowEmail(context);
    return hasEmailPermission; // Return TRUE or FALSE
  }
}
