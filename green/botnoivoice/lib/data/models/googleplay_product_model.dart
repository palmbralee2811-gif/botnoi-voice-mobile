import 'package:botnoivoice/data/entities/googleplay_product_entity.dart';

class GoogleplayProductModel {
  static List<GooglePlayProduct> getGooglePlayProductData() {
    return [
      GooglePlayProduct(
        id: 1,
        title: '5,000',
        productId: 'mobile_100',
        price: '100',
      ),
    ];
  }
}


