import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logger/logger.dart';

class PaymentProvider with ChangeNotifier {
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  bool _available = false;
  List<ProductDetails> _products = [];
  final List<PurchaseDetails> _purchases = [];
  String? _errorMessage;
  final Logger _logger = Logger();

  PaymentProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      _available = await _iap.isAvailable();
      if (_available) {
        _subscription = _iap.purchaseStream.listen(
          _listenToPurchaseUpdated,
          onDone: () => _subscription?.cancel(),
          onError: (error) {
            _logger.e('Error in purchase stream: $error');
            _errorMessage = 'Error in purchase stream: $error';
            notifyListeners();
          },
        );
        await _loadProducts();
      }
    } catch (e) {
      _logger.e('Initialization error: $e');
      _errorMessage = 'Initialization error: $e';
      notifyListeners();
    }
  }

  Future<void> _loadProducts() async {
    try {
      const Set<String> productIds = {'com.botnoimobile.botnoivoice.4100credits'};
      final ProductDetailsResponse response =
          await _iap.queryProductDetails(productIds);
      if (response.error != null) {
        throw Exception('Failed to load products: ${response.error}');
      }
      if (response.productDetails.isEmpty) {
        _logger.w('No products found');
      } else {
        _products = response.productDetails;
      }
      notifyListeners();
    } catch (e) {
      _logger.e('Error loading products: $e');
      _errorMessage = 'Error loading products: $e';
      notifyListeners();
    }
  }

  List<ProductDetails> get products => _products;
  String? get errorMessage => _errorMessage;

  Future<void> purchaseProduct(ProductDetails productDetails) async {
    try {
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
      _iap.buyConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      _logger.e('Purchase error: $e');
      _errorMessage = 'Purchase error: $e';
      notifyListeners();
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    _purchases.addAll(purchaseDetailsList);
    for (var purchase in purchaseDetailsList) {
      try {
        if (purchase.status == PurchaseStatus.purchased) {
          // Handle successful purchase
          _iap.completePurchase(purchase);
        } else if (purchase.status == PurchaseStatus.error) {
          _logger.e('Purchase error: ${purchase.error}');
          _errorMessage = 'Purchase error: ${purchase.error}';
          notifyListeners();
        }
      } catch (e) {
        _logger.e('Error in purchase update: $e');
        _errorMessage = 'Error in purchase update: $e';
        notifyListeners();
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
