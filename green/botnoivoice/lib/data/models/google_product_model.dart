import 'package:botnoivoice/data/entities/googleplay_product_entity.dart';

class GoogleProductModel {
  static List<GoogleProduct> getGoogleProductData() {
    return [
      GoogleProduct(
        id: 1,
        title: '5,000',
        productId: 'mobile_100',
        price: '100',
      ),
    ];
  }
}