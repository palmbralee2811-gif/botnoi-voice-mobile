import 'package:botnoivoice/data/entities/product_entity.dart';

class ProductModel {
  static List<Product> getAppleProductData() {
    return [
      Product(
        id: 1,
        title: '5,000',
        productId: 'mobile_100',
        price: '100',
      ),
    ];
  }
}
