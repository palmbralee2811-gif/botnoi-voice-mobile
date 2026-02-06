import 'dart:io';

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
    String? imagePath,
  }) async {
    final token = ref.watch(currentUserTokenStateProvider).jwtToken;

    if (token == null || token.isEmpty) {
      throw Exception("ไม่พบข้อมูลผู้ใช้งาน (Token is null)");
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
        imageFile: imagePath != null ? File(imagePath) : null,
      );

      _logger.i("API Response => $res");
      return res;
    } catch (e, stack) {
      _logger.e("API Error", error: e, stackTrace: stack);
      rethrow;
    }
  }
}
