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

  /// ***DO NOT DLETE THIS TEXT FOR ANY REASON***
  ///
  /// 2 Steps to Delete Account:
  /// - 1. Delete User Account Data in Database (MongoDB).
  /// - 2. Delete User Account Data in Firebase (Staging and Production).
  ///
  /// ***WARNING***
  /// - When you delete user account in Firebase,
  /// it will delete user account in staging and production too.
  Future<void> deleteUserAccountWithDatabase() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;

      String url = '$urlDomain/db/dashboard/users/$userId';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      try {
        final response = await http.delete(Uri.parse(url), headers: headers);

        if (response.statusCode == 200) {
          _errorMessage = null;
          _logger.d("User Account deleted successfully with Database. \nUser ID: $userId. \nEmail: ${user.email}");
        } else {
          _errorMessage =
              'Failed to delete user account. Status Code: ${response.statusCode}';
          _logger.e(_errorMessage);
          notifyListeners();
        }
      } catch (e) {
        _errorMessage = "Error deleting user account: $e";
        _logger.e(_errorMessage);
        notifyListeners();
      }
    } else {
      _errorMessage = "No user is currently signed in.";
      _logger.w(_errorMessage);
      notifyListeners();
    }
  }

  //TODO: /*แล้วก็ลง firebase แต่แนะนำ
  // เปลี่ยนเป็นของเราก่อน
  // อย่าพึ่งลองของจริง เผื่อพลาดไปลบของลูกค้าอันตราย
  // ให้สร้าง firebase ใหม่ เป็นของตัวทดลอง แล้วทดสอบในนั้น
  // ใช่ทดสอบแค่ฟังก์ลับ user เฉยๆ ว่าลบได้จริงมั้ย
  // ถ้าลบได้เทสสักสองสาม email
  // ค่อยมาต่อกับของ บริษัท
  // เพราะ firebase นี้มันรวมทั้ง staging และ production */

  // // ฟังก์ชันลบบัญชีจาก Firebase
  // Future<void> deleteUserAccountWithFirebase() async {
  //   try {
  //     await FirebaseAuth.instance.currentUser?.delete();
  //     _logger.d("User account deleted successfully from Firebase.");
  //   } catch (error) {
  //     _errorMessage = "Error deleting user account: $error";
  //     _logger.e(_errorMessage);
  //     notifyListeners();
  //   }
  // }

  Future<void> deleteUserAccountWithFirebase(
      BuildContext context, String password) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null &&
          user.providerData.any((info) => info.providerId == 'password')) {
        // Re-authenticate the user
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
        // Now delete the user
        await user.delete();
        _errorMessage = null;
        _logger.i("User Account deleted successfully with Firebase. \nEmail: ${user.email}. \nUser ID: ${user.uid}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ลบบัญชีสำเร็จ')),
        );
      } else {
        _errorMessage = "บัญชีที่เข้าสู่ระบบด้วย Google ไม่สามารถลบผ่านแอปได้. โปรดไปที่ Google Account เพื่อดำเนินการ";
        _logger.e("Cannot delete Google account");
      }
    } catch (error) {
      _errorMessage = "เกิดข้อผิดพลาดในการลบบัญชี: $error";
      _logger.e("Error deleting account: $error");
      notifyListeners();
    }
  }
}
