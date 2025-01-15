import 'package:botnoivoice/data/entities/apple_product_entity.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:logger/logger.dart';

class GooglePlayPaymentProvider with ChangeNotifier {
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
      _logger.i("Fetching offerings");
      final offerings = await Purchases.getOfferings();

      final offering = offerings.getOffering(offeringIdentifier);
      if (offering != null && offering.availablePackages.isNotEmpty) {
        _logger.i("Purchasing package from offering: $offeringIdentifier");
        final purchaseResult =
            await Purchases.purchasePackage(offering.availablePackages.first);

        _logger.i("Purchase successful: $purchaseResult");
      } else {
        _logger
            .w("No available package found for offering: $offeringIdentifier");
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
}
