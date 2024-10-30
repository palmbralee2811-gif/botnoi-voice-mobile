import 'package:botnoivoice/presentation/constants/url.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class EmailDeleteAccountProvider with ChangeNotifier {
  String? _errorMessage;
  final Logger _logger = Logger(); // For debugging

  /// Getter for error message
  String? get errorMessage => _errorMessage;

  /// Helper function to check if user is logged in with password provider
  bool isPasswordProviderUser(User? user) {
    return user != null && user.providerData.any((info) => info.providerId == 'password');
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
        return true;
      } catch (error) {
        _errorMessage = "รหัสผ่านไม่ถูกต้อง";
        _logger.e("Password verification failed: $error");
        notifyListeners();
        return false;
      }
    } else {
      _errorMessage = "ไม่ได้เข้าสู่ระบบด้วยผู้ใช้และรหัสผ่าน";
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
      String url = '$urlDomain/db/dashboard/users/$userId';
      Map<String, String> headers = {'Content-Type': 'application/json'};

      try {
        final response = await http.delete(Uri.parse(url), headers: headers);
        if (response.statusCode == 200) {
          _errorMessage = null;
          _logger.d("User Account deleted successfully with Database. \nUser ID: $userId. \nEmail: ${user.email}");
        } else {
          _errorMessage = 'ไม่สามารถลบบัญชีผู้ใช้ได้ รหัสสถานะ: ${response.statusCode}';
          _logger.e("Failed to delete user account. Status Code: ${response.statusCode}");
          notifyListeners();
        }
      } catch (error) {
        _errorMessage = "เกิดข้อผิดพลาดในการลบบัญชี: $error";
        _logger.e("Error deleting user account: $error");
        notifyListeners();
      }
    } else {
      _errorMessage = "ไม่ได้เข้าสู่ระบบด้วยผู้ใช้และรหัสผ่าน";
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
        _logger.i("User Account deleted successfully from Firebase. \nEmail: ${user.email}. \nUser ID: ${user.uid}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ลบบัญชีสำเร็จ')),
        );
      } catch (error) {
        _errorMessage = "เกิดข้อผิดพลาดในการลบบัญชี: $error";
        _logger.e("Error deleting account: $error");
        notifyListeners();
      }
    } else {
      _errorMessage = "ไม่ได้เข้าสู่ระบบด้วยผู้ใช้งานและรหัสผ่าน";
      _logger.e("No user logged in or invalid provider for Firebase deletion");
      notifyListeners();
    }
  }
}
