import 'package:botnoivoice/data/entities/apple_product_entity.dart';

class AppleProductModel {
  static List<AppleProduct> getAppleProductData() {
    return [
      AppleProduct(
        id: 1,
        title: '5,000',
        productId: 'mobile_100',
        price: '100',
      ),
    ];
  }
}
