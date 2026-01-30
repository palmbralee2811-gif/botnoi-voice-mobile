import 'dart:io';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:logger/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define the state structure for the payment service
class PaymentState {
  // Optional error message to display to the user
  final String? errorMessage;
  // Flag to indicate if an operation is currently in progress
  final bool isLoading;

  // Constructor for PaymentState
  PaymentState({
    this.errorMessage,
    this.isLoading = false,
  });

  // Method to create a new state instance by copying and modifying existing fields
  PaymentState copyWith({
    String? errorMessage,
    bool? isLoading,
  }) {
    return PaymentState(
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// StateNotifier to manage the complex state logic for payment
class PaymentService extends StateNotifier<PaymentState> {
  // Logger instance for logging
  final Logger _logger = Logger();
  // The product ID to be purchased
  final String productId = "mobile_100";

  // Initialize with a default state
  PaymentService() : super(PaymentState());

  // Method to reset state to clean slate (clear errors and loading)
  void resetStatus() {
    state = PaymentState(errorMessage: null, isLoading: false);
  }

  // Public method to manually set loading state from UI
  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  // Public method to handle the payment process based on the platform
  Future<void> handlePurchase() async {
    // Check current platform and call the appropriate payment method
    if (Platform.isAndroid) return await _androidPayment();
    if (Platform.isIOS) return await _iosPayment();
  }

  // Handles the payment flow for Android platform
  Future<void> _androidPayment() async {
    // Update state to loading and clear previous error
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      _logger.i("Fetching offerings");
      // Fetch available offerings from RevenueCat
      final offerings = await Purchases.getOfferings();

      // Get the specific offering based on productId
      final offering = offerings.getOffering(productId);
      if (offering != null && offering.availablePackages.isNotEmpty) {
        _logger.i("Purchasing package from offering: $productId");
        // Purchase the first available package in the offering
        final purchaseResult =
            await Purchases.purchasePackage(offering.availablePackages.first);

        _logger.i("Purchase successful: $purchaseResult");
        // No error, clear any existing error message
        state = state.copyWith(errorMessage: null);
        
        // NOTE: On success, we DO NOT set isLoading = false here.
        // We let the UI handle it after polling for updated points.
      } else {
        _logger.w("No available package found for offering: $productId");
        // Set error message if no package is found
        state = state.copyWith(errorMessage: "No packages available for this offering.");
        // Stop loading on error
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      _handleError(e);
      // Stop loading on error
      state = state.copyWith(isLoading: false);
    }
  }

  // Handles the payment flow for iOS platform
  Future<void> _iosPayment() async {
    // Update state to loading and clear previous error
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      _logger.i("Fetching product for ID: $productId");
      // Fetch store products using the product ID
      final products = await Purchases.getProducts([productId]);

      if (products.isNotEmpty) {
        _logger.i("Purchasing product: ${products.first.identifier}");
        // Purchase the product
        final purchaseResult =
            await Purchases.purchaseStoreProduct(products.first);

        _logger.i("Purchase successful: $purchaseResult");
        // No error, clear any existing error message
        state = state.copyWith(errorMessage: null);
        
        // NOTE: On success, we DO NOT set isLoading = false here.
      } else {
        _logger.w("No product found for ID: $productId");
        // Set error message if the product is not found
        state = state.copyWith(errorMessage: "Product not found.");
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      _handleError(e);
      state = state.copyWith(isLoading: false);
    }
  }

  void _handleError(Object e) {
    String errorMessage;
    // Handle user cancellation specifically
    if (e is PlatformException &&
        (e.details?['readableErrorCode'] == 'PurchaseCancelledError' ||
         e.details?['readableErrorCode'] == 'PURCHASE_CANCELLED')) {
      _logger.e("Purchase cancelled: $e");
      errorMessage = "Purchase Cancelled";
    } else {
      _logger.e("Error during purchase: $e");
      // Set generic error message for other failures
      errorMessage = "Purchase failed: $e";
    }
    // Update state with the error message
    state = state.copyWith(errorMessage: errorMessage);
  }
}

// Global provider to expose the PaymentService instance
final paymentServiceProvider = StateNotifierProvider<PaymentService, PaymentState>(
  (ref) => PaymentService(),
); 