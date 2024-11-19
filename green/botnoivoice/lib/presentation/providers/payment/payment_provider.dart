import 'package:botnoivoice/domain/entities/apple_product_entity.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:logger/logger.dart';

class PaymentProvider with ChangeNotifier {
  final Logger _logger = Logger();
  String? _errorMessage;
  bool isLoading = false;

  String? get errorMessage => _errorMessage;

  Future<void> handlePurchase(AppleProduct product) async {
    isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _logger.i("Fetching product for ID: ${product.productId}");
      final products = await Purchases.getProducts([product.productId]);

      if (products.isNotEmpty) {
        _logger.i("Purchasing product: ${products.first.identifier}");
        final purchaseResult = await Purchases.purchaseStoreProduct(products.first);

        _logger.i("Purchase successful: $purchaseResult");
      } else {
        _logger.w("No product found for ID: ${product.productId}");
        _errorMessage = "Product not found.";
      }
    } catch (e) {
      _logger.e("Error during purchase: $e");
      _errorMessage = "Purchase failed: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
