import 'package:botnoivoice/data/entities/apple_product_entity.dart';

class GoogleplayProductModel {
  static List<AppleProduct> getGooglePlayProductData() {
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
