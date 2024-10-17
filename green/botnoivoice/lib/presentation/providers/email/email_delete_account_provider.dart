import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailDeleteAccountProvider with ChangeNotifier {
  
  //TODO: ต้องขึ้น modal ยกเลิก หรือ ตกลง เพื่อถามผู้ใช้ก่อนลบบัญชี
  Future<void> deleteUserAccount(String uid) async {
    try {
      // await FirebaseAuth.instance.deleteUser(uid);
      await FirebaseAuth.instance.currentUser?.delete();
      print("User account deleted successfully.");
    } catch (error) {
      print("Error deleting user account: $error");
    }
  }

  //TODO: /* ผู้ใช้ต้องทำการล็อกอินใหม่ (re-authenticate) ก่อนลบบัญชี
  // หากเวลาผ่านไปนานเกินจากการล็อกอินครั้งล่าสุด โดยคุณสามารถใช้
  // reauthenticateWithCredential เพื่อทำการล็อกอินใหม่ */
  Future<void> reauthenticateAndDelete(String email, String password) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      // ทำการ reauthenticate ผู้ใช้ก่อนลบบัญชี
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);
      await user?.reauthenticateWithCredential(credential);

      // ลบบัญชีผู้ใช้
      await user?.delete();
      print("บัญชีผู้ใช้ถูกลบสำเร็จ");
    } catch (e) {
      print("เกิดข้อผิดพลาดในการลบบัญชี: $e");
    }
  }
}
