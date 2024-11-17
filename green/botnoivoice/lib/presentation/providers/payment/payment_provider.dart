import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:logger/logger.dart';

class PaymentProvider with ChangeNotifier {
  final Logger _logger = Logger();
  List<StoreProduct>? _products;
  String? _errorMessage;

  Future<void> fetchProducts(List<String> productIds) async {
    try {
      _products = await Purchases.getProducts(productIds);
      notifyListeners();
    } catch (e) {
      _logger.e("Error fetching products: $e");
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> purchaseProduct(StoreProduct product) async {
    try {
      final purchaseInfo = await Purchases.purchaseStoreProduct(product);
      _logger.i("Purchase successful: ${purchaseInfo.entitlements.active}");
      notifyListeners();
    } catch (e) {
      _logger.e("Purchase failed: $e");
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  List<StoreProduct>? get products => _products;
  String? get errorMessage => _errorMessage;
}
