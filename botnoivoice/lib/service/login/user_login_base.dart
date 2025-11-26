// lib/service/login/user_login_base.dart (ไฟล์ใหม่)
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

/// Base State Class for Firebase Authentication Providers
class UserLoginBaseState {
  final User? user;
  final bool isLoggedIn;
  final String? errorMessage;

  UserLoginBaseState({this.user, this.isLoggedIn = false, this.errorMessage});

  // NOTE: copyWith จะถูก implement ใน State ของแต่ละ Provider
}

/// Base Notifier Class for Firebase Authentication Providers
abstract class UserLoginBaseNotifier<T extends UserLoginBaseState>
    extends StateNotifier<T> {
  final String _providerId;
  final Logger _logger = Logger();

  UserLoginBaseNotifier(super.initialState, this._providerId) {
    // Listen for Firebase authentication state changes.
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user?.providerData.isNotEmpty == true &&
          user?.providerData[0].providerId == _providerId) {
        _logger.d("$_providerId Firebase User UID: ${user?.uid}");
        _updateState(
          user: user,
          isLoggedIn: true,
          errorMessage: null,
        );
      } else {
        // Handle case where user logs out or switches provider
        if (state.isLoggedIn && user == null) {
          _logger.i("Logout detected for $_providerId");
          _updateState(
            user: null,
            isLoggedIn: false,
            errorMessage: null,
          ); // Reset state on logout
        }
      }
    });
  }

  // Abstract method ที่ต้องให้ Subclass Implement เพื่อใช้ copyWith()
  void _updateState({
    User? user,
    bool? isLoggedIn,
    String? errorMessage,
  });

  // Getter สำหรับการตรวจสอบการยืนยันตัวตน (ใช้ใน AuthChecker)
  bool get isAuthenticated {
    final currentUser = FirebaseAuth.instance.currentUser;
    // ตรวจสอบว่า user ใน state ตรงกับ user ใน session ปัจจุบันหรือไม่ (เพื่อป้องกันการใช้ token ของ provider อื่น)
    return currentUser?.uid != null &&
        currentUser?.providerData.isNotEmpty == true &&
        currentUser?.providerData[0].providerId == _providerId &&
        state.isLoggedIn; // เช็คสถานะภายใน Notifier ด้วย
  }
}
