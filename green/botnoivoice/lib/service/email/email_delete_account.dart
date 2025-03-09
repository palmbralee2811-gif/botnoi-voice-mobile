import 'package:botnoivoice/config/api_url_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

/// ***DO NOT DELETE THIS TEXT FOR ANY REASON***
///
/// 3 Steps to Delete Account:
/// - 1. Verify the User Password.
/// - 2. Delete User Account Data in Database (MongoDB).
/// - 3. Delete User Account Data in Firebase (Staging and Production).
///
/// ***WARNING***
/// - When you delete the user account in Firebase,
/// it will delete the user account in both staging and production environments.
class EmailDeleteAccount with ChangeNotifier {
  String? _errorMessage;
  final Logger _logger = Logger(); // For debugging

  /// Getter for error message
  String? get errorMessage => _errorMessage;

  /// Helper function to check if user is logged in with password provider
  bool isPasswordProviderUser(User? user) {
    return user != null &&
        user.providerData.any((info) => info.providerId == 'password');
  }

  /// ฟังก์ชันตรวจสอบรหัสผ่าน
  Future<bool> verifyPassword(String password) async {
    final user = FirebaseAuth.instance.currentUser;
    if (isPasswordProviderUser(user)) {
      try {
        final credential = EmailAuthProvider.credential(
          email: user!.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
        _errorMessage = null;
        notifyListeners();
        return true;
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case 'wrong-password':
            _errorMessage = 'delete_account_provider.incorrect_password'
                .tr(); //รหัสผ่านไม่ถูกต้อง
            break;
          default:
            _errorMessage = 'delete_account_provider.error_confirming_password'
                .tr(); //เกิดข้อผิดพลาดในการยืนยันรหัสผ่าน
            break;
        }
        _logger.e(
            "Password verification failed. \nMessage: ${error.message} \nCode: ${error.code}");
        notifyListeners();
        return false;
      }
    } else {
      _errorMessage =
          'delete_account_provider.not_logged_in_with_username_and_password'
              .tr(); //ไม่ได้เข้าสู่ระบบด้วยชื่อผู้ใช้งานและรหัสผ่าน
      _logger.e("Cannot verify Google account password");
      notifyListeners();
      return false;
    }
  }

  /// ฟังก์ชันลบข้อมูลในฐานข้อมูล
  Future<void> deleteUserAccountWithDatabase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (isPasswordProviderUser(user)) {
      String userId = user!.uid;
      String url = '$apiUrl/db/dashboard/users/$userId';
      Map<String, String> headers = {'Content-Type': 'application/json'};

      try {
        final response = await http.delete(Uri.parse(url), headers: headers);
        if (response.statusCode == 200) {
          _errorMessage = null;
          _logger.d(
              "User Account deleted successfully with Database \nUser ID: $userId \nEmail: ${user.email}");
        } else {
          _errorMessage =
              '${'delete_account_provider.unable_to_delete_account_status_code'.tr()} ${response.statusCode}'; //ไม่สามารถลบบัญชีผู้ใช้ได้ รหัสสถานะ:
          _logger.e(
              "Failed to delete user account. Status Code: ${response.statusCode}");
          notifyListeners();
        }
      } catch (error) {
        _errorMessage =
            "${'delete_account_provider.error_deleting_account'.tr()} $error"; //เกิดข้อผิดพลาดในการลบบัญชี
        _logger.e("Error deleting user account: $error");
        notifyListeners();
      }
    } else {
      _errorMessage =
          'delete_account_provider.not_logged_in_with_user_and_password'
              .tr(); //ไม่ได้เข้าสู่ระบบด้วยผู้ใช้และรหัสผ่าน
      _logger.w("No user is currently signed in.");
      notifyListeners();
    }
  }

  /// ฟังก์ชันลบข้อมูลใน Firebase
  Future<void> deleteUserAccountWithFirebase(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (isPasswordProviderUser(user)) {
      try {
        await user!.delete();
        _errorMessage = null;
        _logger.i(
            "User Account deleted successfully from Firebase \nEmail: ${user.email} \nUser ID: ${user.uid}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'delete_account_provider.account_deleted_successfully'
                      .tr())), //ลบบัญชีสำเร็จ
        );
      } catch (error) {
        _errorMessage =
            "${'delete_account_provider.error_deleting_account'.tr()} $error"; //เกิดข้อผิดพลาดในการลบบัญชี
        _logger.e("Error deleting account: $error");
        notifyListeners();
      }
    } else {
      _errorMessage =
          'delete_account_provider.not_logged_in_with_user_and_password'
              .tr(); //ไม่ได้เข้าสู่ระบบด้วยผู้ใช้งานและรหัสผ่าน
      _logger.e("No user logged in or invalid provider for Firebase deletion");
      notifyListeners();
    }
  }
}
