// import 'dart:convert';
// import 'package:botnoivoice/config/api_url_config.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http;
// import 'package:logger/logger.dart';
// import 'package:botnoivoice/shared/function/get_jwt_token.dart';

// class RedeemCouponService with ChangeNotifier {
//   final _logger = Logger();
//   String? errorMessage; // ตัวแปรเก็บ error message
//   bool isLoading = false; // ตัวแปรเช็คสถานะกำลังโหลด

//   /// ฟังก์ชันเซ็ตค่า `isLoading` และแจ้งให้ UI อัปเดต
//   void _setLoading(bool value) {
//     isLoading = value;
//     notifyListeners();
//   }

//   // Add this method to reset errorMessage
//   void resetErrorMessage() {
//     errorMessage = null;
//     notifyListeners();
//   }

//   /// ฟังก์ชันดึง JWT Token
//   Future<String?> _fetchJwtToken(
//     BuildContext context,
//     WidgetRef ref,
//   ) async {
//     try {
//       final jwtToken = await getJwtTokenAll(ref);
//       if (jwtToken == null) {
//         errorMessage = 'Failed to fetch ID token';
//         _logger.e(errorMessage);
//       }
//       return jwtToken;
//     } catch (e) {
//       errorMessage = 'Exception occurred while fetching ID token: $e';
//       _logger.e(errorMessage);
//       return null;
//     }
//   }

//   /// ฟังก์ชันตรวจสอบและใช้คูปอง
//   Future<String?> _callCheckCouponApi(
//       String jwtToken, String couponName) async {
//     try {
//       String url = '$apiUrl/api/coupon/check_coupon';

//       _logger.d('Sending POST request to $url with couponCode: $couponName');

//       final response = await http.post(
//         Uri.parse(url),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': "Bearer $jwtToken",
//         },
//         body: jsonEncode({'coupon_name': couponName}),
//       );

//       _logger.d('Received response with status code: ${response.statusCode}');

//       if (response.statusCode == 200) {
//         final responseBody = jsonDecode(response.body);
//         final message = responseBody['message'];
//         _logger.d('Response body: $responseBody');

//         if (message.toString().toLowerCase() == 'use coupon success') {
//           errorMessage = null;
//           _logger.d('Coupon redeemed successfully $couponName');
//           return null;
//         } else if (message.toString().toLowerCase() == 'already in use') {
//           //คูปองของคุณถูกใช้งานแล้ว
//           errorMessage = 'redeem_coupon_service.coupon_already_used'
//               .tr(namedArgs: {'coupon_name': couponName});
//           _logger.e(errorMessage);
//           return errorMessage;
//         } else if (message.toString().toLowerCase() == 'incorrect coupon') {
//           //ไม่พบคูปองนี้ คูปองอาจจะไม่สามารถใช้งานได้แล้วหรือคูปองที่คุณเพิ่มไม่ถูกต้อง
//           errorMessage = 'redeem_coupon_service.coupon_not_found'
//               .tr(namedArgs: {'coupon_name': couponName});
//           _logger.e(errorMessage);

//           return errorMessage;
//         } else {
//           //ไม่พบคูปองในระบบ หรือคูปองหมดอายุไปแล้ว
//           errorMessage = 'redeem_coupon_service.coupon_expired_or_not_found'
//               .tr(namedArgs: {'coupon_name': couponName});
//           _logger.e(errorMessage);

//           return errorMessage;
//         }
//       } else {
//         //เกิดข้อผิดพลาดในการเรียก API:
//         errorMessage =
//             '${'redeem_coupon_service.api_call_error'.tr()} ${response.statusCode}';
//         _logger.e(errorMessage);

//         return errorMessage;
//       }
//     } catch (e) {
//       errorMessage = 'Exception occurred: $e';
//       _logger.e(errorMessage);

//       return 'redeem_coupon_service.error_message'.tr();
//     } finally {}
//   }

//   /// ใช้คูปอง ถ้า return string คือมี error
//   Future<String?> redeemCoupon(
//     BuildContext context,
//     String couponCode,
//     WidgetRef ref,
//   ) async {
//     _setLoading(true);
//     try {
//       _logger.d('Starting redeemCoupon');

//       if (couponCode.trim().isEmpty) {
//         errorMessage = 'redeem_coupon_service.coupon_code_empty'.tr();
//         _logger.e(errorMessage);
//         return errorMessage;
//       }

//       final jwtToken = await _fetchJwtToken(context, ref);
//       if (jwtToken == null) return 'redeem_coupon_service.not_session'.tr();

//       // Set the coupon code to redeem
//       _logger.d('Calling _callCheckCouponApi with couponCode: $couponCode');

//       final result = await _callCheckCouponApi(jwtToken, couponCode);

//       return result;
//     } catch (e) {
//       errorMessage = '${'redeem_coupon_service.error_message'.tr()} $e';
//       _logger.e(errorMessage);

//       return 'redeem_coupon_service.error_message'.tr();
//     } finally {
//       _setLoading(false);
//     }
//   }
// }





import 'dart:convert';
import 'package:botnoivoice/config/api_url_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:botnoivoice/shared/function/get_jwt_token.dart';

/// Represents the immutable state of the RedeemCouponService.
class RedeemCouponState {
  /// Variable to store error messages. (ตัวแปรเก็บ error message)
  final String? errorMessage;
  /// Variable to check the loading status. (ตัวแปรเช็คสถานะกำลังโหลด)
  final bool isLoading;

  const RedeemCouponState({
    this.errorMessage,
    this.isLoading = false,
  });

  /// Creates a new state instance by copying existing values or applying new ones.
  RedeemCouponState copyWith({
    String? errorMessage,
    bool? isLoading,
  }) {
    return RedeemCouponState(
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Defines the StateNotifierProvider for RedeemCouponService.
/// This provider allows UI widgets to listen to the state (RedeemCouponState)
/// and interact with the service (RedeemCouponService).
final redeemCouponServiceProvider = 
    StateNotifierProvider<RedeemCouponService, RedeemCouponState>((ref) {
  return RedeemCouponService();
});


class RedeemCouponService extends StateNotifier<RedeemCouponState> {
  // Initialize the state in the constructor
  RedeemCouponService() : super(const RedeemCouponState());

  final _logger = Logger();
  // State variables (errorMessage, isLoading) are now accessed via `state`

  /// Internal method to update the loading state and notify listeners (via Riverpod state update).
  void _setLoading(bool value) {
    // ฟังก์ชันเซ็ตค่า `isLoading` และแจ้งให้ UI อัปเดต
    state = state.copyWith(isLoading: value);
  }

  /// Resets the error message state.
  void resetErrorMessage() {
    // Add this method to reset errorMessage
    state = state.copyWith(errorMessage: null);
  }

  /// ฟังก์ชันดึง JWT Token
  Future<String?> _fetchJwtToken(
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      final jwtToken = await getJwtTokenAll(ref);
      if (jwtToken == null) {
        state = state.copyWith(errorMessage: 'Failed to fetch ID token');
        _logger.e(state.errorMessage);
      }
      return jwtToken;
    } catch (e) {
      state = state.copyWith(errorMessage: 'Exception occurred while fetching ID token: $e');
      _logger.e(state.errorMessage);
      return null;
    }
  }

  /// ฟังก์ชันตรวจสอบและใช้คูปอง
  Future<String?> _callCheckCouponApi(
      String jwtToken, String couponName) async {
    try {
      String url = '$apiUrl/api/coupon/check_coupon';

      _logger.d('Sending POST request to $url with couponCode: $couponName');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer $jwtToken",
        },
        body: jsonEncode({'coupon_name': couponName}),
      );

      _logger.d('Received response with status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final message = responseBody['message'];
        _logger.d('Response body: $responseBody');

        if (message.toString().toLowerCase() == 'use coupon success') {
          // Success: reset error message
          state = state.copyWith(errorMessage: null);
          _logger.d('Coupon redeemed successfully $couponName');
          return null;
        } else if (message.toString().toLowerCase() == 'already in use') {
          //คูปองของคุณถูกใช้งานแล้ว
          final errorMsg = 'redeem_coupon_service.coupon_already_used'
              .tr(namedArgs: {'coupon_name': couponName});
          state = state.copyWith(errorMessage: errorMsg);
          _logger.e(state.errorMessage);
          return errorMsg;
        } else if (message.toString().toLowerCase() == 'incorrect coupon') {
          //ไม่พบคูปองนี้ คูปองอาจจะไม่สามารถใช้งานได้แล้วหรือคูปองที่คุณเพิ่มไม่ถูกต้อง
          final errorMsg = 'redeem_coupon_service.coupon_not_found'
              .tr(namedArgs: {'coupon_name': couponName});
          state = state.copyWith(errorMessage: errorMsg);
          _logger.e(state.errorMessage);

          return errorMsg;
        } else {
          //ไม่พบคูปองในระบบ หรือคูปองหมดอายุไปแล้ว
          final errorMsg = 'redeem_coupon_service.coupon_expired_or_not_found'
              .tr(namedArgs: {'coupon_name': couponName});
          state = state.copyWith(errorMessage: errorMsg);
          _logger.e(state.errorMessage);

          return errorMsg;
        }
      } else {
        //เกิดข้อผิดพลาดในการเรียก API:
        final errorMsg =
            '${'redeem_coupon_service.api_call_error'.tr()} ${response.statusCode}';
        state = state.copyWith(errorMessage: errorMsg);
        _logger.e(state.errorMessage);

        return errorMsg;
      }
    } catch (e) {
      final errorMsg = 'Exception occurred: $e';
      state = state.copyWith(errorMessage: errorMsg);
      _logger.e(state.errorMessage);

      return 'redeem_coupon_service.error_message'.tr();
    } finally {}
  }

  /// ใช้คูปอง ถ้า return string คือมี error
  Future<String?> redeemCoupon(
    BuildContext context,
    String couponCode,
    WidgetRef ref,
  ) async {
    _setLoading(true);
    try {
      _logger.d('Starting redeemCoupon');

      if (couponCode.trim().isEmpty) {
        final errorMsg = 'redeem_coupon_service.coupon_code_empty'.tr();
        state = state.copyWith(errorMessage: errorMsg);
        _logger.e(state.errorMessage);
        return errorMsg;
      }

      final jwtToken = await _fetchJwtToken(context, ref);
      // _fetchJwtToken updates the error state if token fetching fails.
      if (jwtToken == null) return 'redeem_coupon_service.not_session'.tr();

      // Set the coupon code to redeem
      _logger.d('Calling _callCheckCouponApi with couponCode: $couponCode');

      final result = await _callCheckCouponApi(jwtToken, couponCode);
      // _callCheckCouponApi updates the error state if coupon check fails.

      return result;
    } catch (e) {
      final errorMsg = '${'redeem_coupon_service.error_message'.tr()} $e';
      state = state.copyWith(errorMessage: errorMsg);
      _logger.e(state.errorMessage);

      return 'redeem_coupon_service.error_message'.tr();
    } finally {
      _setLoading(false);
    }
  }
}

