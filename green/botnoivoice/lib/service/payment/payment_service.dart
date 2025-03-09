import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:logger/logger.dart';

class PaymentService with ChangeNotifier {
  final Logger _logger = Logger();
  String? _errorMessage;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final productId = "mobile_100";

  Future<void> handlePurchase() async {
    if (Platform.isAndroid) return await androidPayment();
    if (Platform.isIOS) return await iosPayment();
  }

  Future<void> androidPayment() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _logger.i("Fetching offerings");
      final offerings = await Purchases.getOfferings();

      final offering = offerings.getOffering(productId);
      if (offering != null && offering.availablePackages.isNotEmpty) {
        _logger.i("Purchasing package from offering: $productId");
        final purchaseResult =
            await Purchases.purchasePackage(offering.availablePackages.first);

        _logger.i("Purchase successful: $purchaseResult");
      } else {
        _logger.w("No available package found for offering: $productId");
        _errorMessage = "No packages available for this offering.";
      }
    } catch (e) {
      if (e is PlatformException &&
          e.details['readableErrorCode'] == 'PurchaseCancelledError') {
        _logger.e("Purchase cancelled: $e");
        _errorMessage = "Purchase Cancelled";
      } else {
        _logger.e("Error during purchase: $e");
        _errorMessage = "Purchase failed: $e";
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> iosPayment() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _logger.i("Fetching product for ID: $productId");
      final products = await Purchases.getProducts([productId]);

      if (products.isNotEmpty) {
        _logger.i("Purchasing product: ${products.first.identifier}");
        final purchaseResult =
            await Purchases.purchaseStoreProduct(products.first);

        _logger.i("Purchase successful: $purchaseResult");
      } else {
        _logger.w("No product found for ID: $productId");
        _errorMessage = "Product not found.";
      }
    } catch (e) {
      if (e is PlatformException &&
          e.details['readableErrorCode'] == 'PURCHASE_CANCELLED') {
        _logger.e("Purchase cancelled: $e");
        _errorMessage = "Purchase Cancelled";
      } else {
        _logger.e("Error during purchase: $e");
        _errorMessage = "Purchase failed: $e";
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
