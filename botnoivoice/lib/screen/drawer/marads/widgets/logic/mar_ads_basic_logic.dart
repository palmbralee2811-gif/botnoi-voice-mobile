// // mar_ads_logic.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:provider/provider.dart';
// import 'package:botnoivoice/screen/drawer/marads/widgets/service/prompt_service.dart';
// import 'package:botnoivoice/service/token/apple_token.dart';
// import 'package:botnoivoice/service/token/email_token.dart';
// import 'package:botnoivoice/service/token/google_token.dart';
// import 'package:botnoivoice/service/token/line_token.dart';
// import 'package:logger/logger.dart';

// class MarAdsLogic {
//   final PromptService _promptService;
//   final Logger _logger = Logger();

//   MarAdsLogic(this._promptService);

//   Future<dynamic> createPromptAdsFromForm({
//   required WidgetRef ref,
//   required String productName,
//   required String brandName,
//   required String price,
//   required String contentStyle,
//   required String contentLengthLabel,
//   required String additionalInfo,
// }) async {

//   String? token;

//   final lineToken = context.read<LineToken>().getCredentialsToken;
//   final appleToken = context.read<AppleToken>().getCredentialsToken;
//   final googleToken = context.read<GoogleToken>().getCredentialsToken;
//   final emailToken = context.read<EmailToken>().getCredentialsToken;

//   if (lineToken != null && lineToken.isNotEmpty) {
//     token = lineToken;
//   } else if (appleToken != null && appleToken.isNotEmpty) {
//     token = appleToken;
//   } else if (googleToken != null && googleToken.isNotEmpty) {
//     token = googleToken;
//   } else if (emailToken != null && emailToken.isNotEmpty) {
//     token = emailToken;
//   }

//   if (token == null || token.isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("กรุณาเข้าสู่ระบบก่อนใช้งาน")),
//     );
//     throw Exception("NO_TOKEN");
//   }

//   String lengthValue;
//   switch (contentLengthLabel) {
//     case '~15 วิ': lengthValue = 'สั้น'; break;
//     case '~30 วิ': lengthValue = 'กลาง'; break;
//     case '~60 วิ': lengthValue = 'ยาว'; break;
//     default: lengthValue = 'สั้น';
//   }

//   final payload = {
//     "mode": "basic",
//     "language": "th",
//     "product_name": productName,
//     "product_brand": brandName,
//     "price": price,
//     "content_style": contentStyle,
//     "content_length": lengthValue,
//     "additional_info": additionalInfo,
//   };

//   _logger.i("Payload => $payload");

//   try {
//     final res = await _promptService.createPromptAds(
//       token: token,
//       payload: payload,
//     );

//     _logger.i("API Response => $res");
//     return res;

//   } catch (e, stack) {
//     _logger.e("API Error", error: e, stackTrace: stack);
//     rethrow;
//   }
// }
// }

// mar_ads_logic.dart
import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/service/prompt_service.dart';
import 'package:logger/logger.dart';

class MarAdsLogic {
  final PromptService _promptService;
  final Logger _logger = Logger();

  MarAdsLogic(this._promptService);

  Future<dynamic> createPromptAdsFromForm({
    required WidgetRef ref,
    required BuildContext context,
    required String productName,
    required String brandName,
    required String price,
    required String contentStyle,
    required String contentLengthLabel,
    required String additionalInfo,
  }) async {
    final token = ref.watch(currentUserTokenStateProvider).jwtToken;

    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Something went wrong, Please try again. \n ### createPromptAdsFromForm: $token ###")),
      );
      throw Exception("NO_TOKEN");
    }

    String lengthValue;
    switch (contentLengthLabel) {
      case '~15 วิ':
        lengthValue = 'สั้น';
        break;
      case '~30 วิ':
        lengthValue = 'กลาง';
        break;
      case '~60 วิ':
        lengthValue = 'ยาว';
        break;
      default:
        lengthValue = 'สั้น';
    }

    final payload = {
      "mode": "basic",
      "language": "th",
      "product_name": productName,
      "product_brand": brandName,
      "price": price,
      "content_style": contentStyle,
      "content_length": lengthValue,
      "additional_info": additionalInfo,
    };

    _logger.i("Payload => $payload");

    try {
      final res = await _promptService.createPromptAds(
        context: context,
        token: token,
        payload: payload,
      );

      _logger.i("API Response => $res");
      return res;
    } catch (e, stack) {
      _logger.e("API Error", error: e, stackTrace: stack);
      rethrow;
    }
  }
}
