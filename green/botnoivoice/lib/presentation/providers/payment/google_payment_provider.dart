import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:logger/logger.dart';

class GooglePaymentProvider with ChangeNotifier {
  final Logger _logger = Logger();
  String? _errorMessage;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> handlePurchaseOffering(String offeringIdentifier) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final offerings = await Purchases.getOfferings();

      if (offerings.current != null) {
        final package = offerings.current!.getPackage("mobile_100");

        if (package != null) {
          _logger.i("Found package: ${package.identifier}");

          // เริ่มการซื้อ
          final customerInfo = await Purchases.purchasePackage(package);

          _logger.i("Purchase successful. Customer info: $customerInfo");

          // ตรวจสอบ Entitlements หลังการซื้อ
          if (customerInfo.entitlements.active.containsKey("mobile_100")) {
            _logger.i("Entitlement 'mobile_100' unlocked.");
            // ดำเนินการเพิ่มพ้อยต์ให้ผู้ใช้
            // เช่น บันทึกข้อมูลในเซิร์ฟเวอร์ของคุณ
          } else {
            _logger.w("Purchase successful but no entitlements unlocked.");
          }
        } else {
          _logger.e("Package 'mobile_100' not found in offerings.");
        }
      } else {
        _logger.e("No offerings available.");
      }
    } catch (e) {
      if (e is PlatformException &&
          e.code == PurchasesErrorCode.purchaseCancelledError) {
        _logger.w("Purchase cancelled by user.");
      } else {
        _logger.e("Error during purchase: $e");
      }
    }
  }
}
