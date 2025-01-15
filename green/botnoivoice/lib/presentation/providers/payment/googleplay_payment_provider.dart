import 'package:botnoivoice/data/models/googleplay_product_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:botnoivoice/data/entities/googleplay_product_entity.dart';

class GooglePlayPaymentProvider with ChangeNotifier {
  final Logger _logger = Logger();
  String? _errorMessage;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> purchaseProduct(GooglePlayProduct googleProduct,
      {String? customTitle}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _logger.i(
          "Fetching product for ID: ${googleProduct.productId}, Custom Title: $customTitle");

      final products = await Purchases.getProducts([googleProduct.productId]);
      final googleProducts = GoogleplayProductModel.getGooglePlayProductData();
      if (googleProducts.isNotEmpty) {
        final googleProduct = googleProducts.first;
        print("Product: ${googleProduct.title}, Price: ${googleProduct.price}");
      }

      if (products.isNotEmpty) {
        _logger.i("Product found: ${products.first.identifier}");

        final purchaseResult =
            await Purchases.purchaseStoreProduct(products.first);

        _logger.i("Purchase successful: $purchaseResult");
      } else {
        _logger.w("No product found for ID: ${googleProduct.productId}");
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
