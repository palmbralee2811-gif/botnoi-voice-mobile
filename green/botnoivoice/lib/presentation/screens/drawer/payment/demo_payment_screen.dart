import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:logger/logger.dart';

class DemoPaymentScreen extends StatelessWidget {
  const DemoPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // สร้าง logger
    final logger = Logger();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Simple Button Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              // เรียกฟังก์ชัน handlePurchase
              await handlePurchase(
                context: context,
                productId: 'botnoivoice_4100_credits',
                logger: logger,
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Buy Credits',
              style: TextStyle(fontSize: 18.sp),
            ),
          ),
        ),
      ),
    );
  }

  /// ฟังก์ชันสำหรับจัดการการซื้อสินค้า
  Future<void> handlePurchase({
    required BuildContext context,
    required String productId,
    required Logger logger,
  }) async {
    logger.i("Purchase process started for product: $productId");

    try {
      // ดึงรายการสินค้า
      final product = await fetchProduct(productId, logger);

      if (product != null) {
        // เริ่มการซื้อสินค้า
        logger.i("Attempting to purchase product: ${product.identifier}");
        final purchaseResult = await Purchases.purchaseStoreProduct(product);

        // แสดงข้อความเมื่อซื้อสำเร็จ
        logger.i("Purchase successful: $purchaseResult");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Purchase successful!')),
        );
      } else {
        // หากไม่มีสินค้า
        logger.w("Product not found for ID: $productId");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product not found!')),
        );
      }
    } catch (e) {
      // จัดการข้อผิดพลาด
      logger.e("Error occurred during purchase: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  /// ฟังก์ชันสำหรับดึงข้อมูลสินค้า
  Future<StoreProduct?> fetchProduct(String productId, Logger logger) async {
    try {
      logger.i("Fetching product list for ID: $productId");
      final products = await Purchases.getProducts([productId]);
      if (products.isNotEmpty) {
        logger.i("Product fetched successfully: ${products.first.identifier}");
        return products.first;
      } else {
        logger.w("No products found for ID: $productId");
        return null;
      }
    } catch (e) {
      logger.e("Error fetching product: $e");
      return null;
    }
  }
}
