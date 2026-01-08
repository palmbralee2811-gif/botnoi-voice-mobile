import 'package:botnoivoice/screen/drawer/marads/widgets/service/prompt_service.dart';
import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class MarAdsAdvancedLogic {
  final PromptService _promptService;
  final Logger _logger = Logger();

  MarAdsAdvancedLogic(this._promptService);

  Future<dynamic> createAdvancedPromptAds({
    required WidgetRef ref,
    required BuildContext context,

    // --- ข้อมูลพื้นฐาน ---
    required String productName,
    required String brandName,
    required String price,

    // --- คุณสมบัติสินค้า ---
    String? size,
    String? model,
    String? material,
    String? color,

    // --- สไตล์ ---
    required String salesCharacter,
    required String contentStyle,

    // --- โปรโมชั่น (Optional) ---
    String? promotion,
    String? targetCustomers,
    String? sellingPoint,
    String? whyBuy,

    // --- การตั้งค่า ---
    required String contentLengthLabel,
    String? additionalInfo,
  }) async {
    //  Token จาก Riverpod
    final token = ref.watch(currentUserTokenStateProvider).jwtToken;

    if (token == null || token.isEmpty) {
      throw Exception("ไม่พบข้อมูลผู้ใช้งาน (Token is null)");
    }

    String lengthValue;
    switch (contentLengthLabel) {
      case '~30 วิ':
        lengthValue = 'กลาง';
        break;
      case '~60 วิ':
        lengthValue = 'ยาว';
        break;
      default:
        lengthValue = 'กลาง';
    }

    // สร้าง Payload สำหรับ Advanced Mode
    final payload = {
      "mode": "advanced",
      "language": "th",
      "product_name": productName,
      "product_brand": brandName,
      "price": price,

      // Advanced Fields
      "size": size ?? "",
      "model": model ?? "",
      "specific": material ?? "",
      "color": (color == 'ไม่ระบุ') ? "" : (color ?? ""),

      "sales_character": salesCharacter,
      "content_style": contentStyle,

      "promotion_price": promotion ?? "",
      "target_customer": targetCustomers ?? "",
      "advantage": sellingPoint ?? "",
      "reason_to_buy": whyBuy ?? "",

      "content_length": lengthValue,
      "additional_info": additionalInfo ?? "",
    };

    _logger.i("Advanced Payload => $payload");

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
