import 'dart:io';
import 'package:botnoivoice/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:logger/logger.dart';

class PaymentProvider with ChangeNotifier {
  final Logger _logger = Logger();
  String? _errorMessage;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final product = ProductModel.getAppleProductData().first;
  final productAndroid = "mobile_100";

  Future<void> handlePurchase() async {
    if (Platform.isAndroid) return await androidPayment();
    if (Platform.isIOS) return await iosPayment();
  }
  
  //TODO: fix error: product not found
  //TODO: Use new method for offering products from TN Frank
  //TODO: เปลี่ยน ท่าใหม่เป็น เรียกใช้ product จาก offering ของน้อง TN
  //TODO: fix error: This version of the application is not configured for billing through Google Play. Check the help center for more information.

  Future<void> androidPayment() async {
        _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _logger.i("Fetching offerings");
      final offerings = await Purchases.getOfferings();

      final offering = offerings.getOffering(productAndroid);
      if (offering != null && offering.availablePackages.isNotEmpty) {
        _logger.i("Purchasing package from offering: $productAndroid");
        final purchaseResult =
            await Purchases.purchasePackage(offering.availablePackages.first);

        _logger.i("Purchase successful: $purchaseResult");
      } else {
        _logger
            .w("No available package found for offering: $productAndroid");
        _errorMessage = "No packages available for this offering.";
      }
    } catch (e) {
      _logger.e("Error during purchase: $e");
      _errorMessage = "Purchase failed: $e";
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
      _logger.i("Fetching product for ID: ${product.productId}");
      final products = await Purchases.getProducts([product.productId]);

      if (products.isNotEmpty) {
        _logger.i("Purchasing product: ${products.first.identifier}");
        final purchaseResult =
            await Purchases.purchaseStoreProduct(products.first);

        _logger.i("Purchase successful: $purchaseResult");
      } else {
        _logger.w("No product found for ID: ${product.productId}");
        _errorMessage = "Product not found.";
      }
    } catch (e) {
      _logger.e("Error during purchase: $e");
      _errorMessage = "Purchase failed: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
