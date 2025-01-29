import 'dart:io';
import 'package:botnoivoice/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:logger/logger.dart';

class PaymentProvider with ChangeNotifier {
  final Logger _logger = Logger();
  String? _errorMessage;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final product = ProductModel.getAppleProductData().first;

  Future<void> handlePurchase() async {
    if (Platform.isAndroid) {
      return await androidPayment();
    } else if (Platform.isIOS) {
      return await iosPayment();
    }
  }

  //TODO: fix error: product not found
  //TODO: Use new method for offering products from TN Frank
  //TODO: เปลี่ยน ท่าใหม่เป็น เรียกใช้ product จาก offering ของน้อง TN
  Future<void> androidPayment( ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _logger.i("Fetching product for ID: ${product.productId}");
      final products = await Purchases.getProducts([product.productId]);

      if (products.isNotEmpty) {
        _logger.i("Purchasing product: ${products.first.identifier}");
        try {
          final purchaseResult =
              await Purchases.purchaseStoreProduct(products.first);

          _logger.i("Purchase successful: $purchaseResult");
        } on PlatformException catch (e) {
          if (PurchasesErrorHelper.getErrorCode(e) ==
              PurchasesErrorCode.purchaseCancelledError) {
            _logger.w("Purchase cancelled by user.");
            _errorMessage = "Purchase cancelled.";
          } else {
            _logger.e("Error during purchase: $e");
            _errorMessage = "Purchase failed: $e";
          }
        }
      } else {
        _logger.w("No product found for ID: ${product.productId}");
        _errorMessage = "Product not found.";
      }
    } catch (e) {
      _logger.e("Error fetching products: $e");
      _errorMessage = "Failed to fetch products: $e";
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
