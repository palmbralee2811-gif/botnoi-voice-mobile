// import 'package:botnoivoice/config/api_url_config.dart';
// import 'package:botnoivoice/shared/function/get_user_id.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:logger/logger.dart';

// /// Class to check user show email
// class CheckUserIsShowEmail with ChangeNotifier {
//   final Dio _dio = Dio();
//   final Logger _logger = Logger();

//   String? _errorMessage;
//   bool _isShowEmail = false;

//   bool get isShowEmail => _isShowEmail;
//   String? get errorMessage => _errorMessage;

//   /// Fetch user information
//   Future<void> getUserInfoShowMail(BuildContext context) async {
//     try {
//       final userId = await getUserIdEmail(context);
//       final response = await _dio
//           .get('$apiUrl/api/dashboard/get_user_info_un_auth?user_id=$userId');

//       if (response.statusCode == 200) {
//         _isShowEmail = response.data['data']?['show_mail'];
//         _logger.i("show_mail: $_isShowEmail");
//         _clearError();
//       } else {
//         throw Exception(
//             "Failed to fetch user info. Status code: ${response.statusCode}");
//       }
//     } catch (error) {
//       _setError("Error fetching user info: $error");
//     }
//   }

//   /// Update Email Permission
//   Future<void> updateUserInfoShowMail(
//       BuildContext context, bool showEmail) async {
//     try {
//       final userId = await getUserIdEmail(context);
//       // DO NOT CHANGE THIS METHOD, GET IS CORRECT!!!
//       final response = await _dio.get(
//           '$apiUrl/api/dashboard/users_info_show_email?user_id=$userId&show_email=$showEmail');

//       if (response.statusCode == 200) {
//         _isShowEmail = showEmail; // Update the value
//         _logger.i(
//             "show_email updated successfully. \nUser ID: $userId \nshow_email: $showEmail");
//         notifyListeners(); // Notify the listeners to update the UI
//         _clearError();
//       } else {
//         throw Exception(
//             "Failed to update show_email. Status code: ${response.statusCode}");
//       }
//     } catch (error) {
//       _setError("Error updating show_email: $error");
//     }
//   }

//   /// Set error message and notify listeners
//   void _setError(String message) {
//     _errorMessage = message;
//     _logger.e(message);
//     notifyListeners();
//   }

//   /// Clear error message and notify listeners
//   void _clearError() {
//     _errorMessage = null;
//     notifyListeners();
//   }
// }

// lib/service/email/check_user_is_show_email.dart
import 'package:botnoivoice/config/api_url_config.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

// State Class
class CheckUserIsShowEmailState {
  final String? errorMessage;
  final bool isShowEmail;

  CheckUserIsShowEmailState({this.errorMessage, this.isShowEmail = false});

  CheckUserIsShowEmailState copyWith({
    String? errorMessage,
    bool? isShowEmail,
  }) {
    return CheckUserIsShowEmailState(
      errorMessage: errorMessage,
      isShowEmail: isShowEmail ?? this.isShowEmail,
    );
  }
}

/// Class to check user show email
class CheckUserIsShowEmailNotifier extends StateNotifier<CheckUserIsShowEmailState> {
  final Ref _ref;
  final Dio _dio = Dio();
  final Logger _logger = Logger();

  CheckUserIsShowEmailNotifier(this._ref) : super(CheckUserIsShowEmailState());

  /// Fetch user information
  Future<void> getUserInfoShowMail() async {
    // ต้องเข้าถึง getUserIdEmail ผ่าน ref หรือเปลี่ยน logic ให้เข้ากับ Riverpod
    // สมมติว่ามี provider สำหรับดึง User ID ที่สามารถเข้าถึงได้ผ่าน ref
    // ในโค้ดเดิมใช้ BuildContext ซึ่งไม่เหมาะกับ Riverpod StateNotifier
    // ต้องแปลง getUserIdEmail ให้เป็น function ธรรมดาที่รับ Ref หรือใช้ Provider

    // **NOTE:** การใช้ getUserIdEmail(context) ต้องถูกแปลงเป็นการดึงค่าจาก Riverpod
    // ในตัวอย่างนี้ เราจะใช้ logic การดึง user ID ที่กำลัง login อยู่จาก EmailLoginNotifier
    // (แต่หากต้องการให้โค้ดทำงานเหมือนเดิม ต้องแปลง get_user_id.dart ก่อน)

    final currentUserId = _ref.read(emailLoginNotifierProvider).user?.uid;
    if (currentUserId == null) {
      _setError("User ID is null. Cannot fetch user info.");
      return;
    }
    
    try {
      final response = await _dio
          .get('$apiUrl/api/dashboard/get_user_info_un_auth?user_id=$currentUserId');

      if (response.statusCode == 200) {
        final isShowEmail = response.data['data']?['show_mail'] as bool? ?? false;
        state = state.copyWith(isShowEmail: isShowEmail, errorMessage: null);
        _logger.i("show_mail: $isShowEmail");
      } else {
        throw Exception(
            "Failed to fetch user info. Status code: ${response.statusCode}");
      }
    } catch (error) {
      _setError("Error fetching user info: $error");
    }
  }

  /// Update Email Permission
  Future<void> updateUserInfoShowMail(bool showEmail) async {
    final currentUserId = _ref.read(emailLoginNotifierProvider).user?.uid;
    if (currentUserId == null) {
      _setError("User ID is null. Cannot update show_email.");
      return;
    }

    try {
      // DO NOT CHANGE THIS METHOD, GET IS CORRECT!!!
      final response = await _dio.get(
          '$apiUrl/api/dashboard/users_info_show_email?user_id=$currentUserId&show_email=$showEmail');

      if (response.statusCode == 200) {
        state = state.copyWith(isShowEmail: showEmail, errorMessage: null);
        _logger.i(
            "show_email updated successfully. \nUser ID: $currentUserId \nshow_email: $showEmail");
      } else {
        throw Exception(
            "Failed to update show_email. Status code: ${response.statusCode}");
      }
    } catch (error) {
      _setError("Error updating show_email: $error");
    }
  }

  /// Set error message
  void _setError(String message) {
    state = state.copyWith(errorMessage: message);
    _logger.e(message);
  }
}

/// Riverpod provider for CheckUserIsShowEmailNotifier.
final checkUserIsShowEmailNotifierProvider = 
    StateNotifierProvider<CheckUserIsShowEmailNotifier, CheckUserIsShowEmailState>((ref) {
  return CheckUserIsShowEmailNotifier(ref);
});