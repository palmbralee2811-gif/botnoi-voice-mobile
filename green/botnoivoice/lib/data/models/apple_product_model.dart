import 'package:botnoivoice/domain/entities/apple_product_entity.dart';

class AppleProductModel {
  static List<AppleProduct> getAppleProductData() {
    return [
      AppleProduct(
        id: 1,
        title: '4,100',
        productId: 'com.botnoimobile.botnoivoice.4100credits',
        type: 'Consumable',
        price: '99',
        originalPrice: '',
      ),
      AppleProduct(
        id: 2,
        title: '12,500',
        productId: 'com.botnoimobile.botnoivoice.12500credits',
        type: 'Consumable',
        price: '199',
        originalPrice: '299',
      ),
      AppleProduct(
        id: 3,
        title: '23,500',
        productId: 'com.botnoimobile.botnoivoice.23500credits',
        type: 'Consumable',
        price: '349',
        originalPrice: '499',
      ),
      AppleProduct(
        id: 4,
        title: '30,500',
        productId: 'com.botnoimobile.botnoivoice.30500credits',
        type: 'Consumable',
        price: '400',
        originalPrice: '750',
      ),
      AppleProduct(
        id: 5,
        title: '80,000',
        productId: 'com.botnoimobile.botnoivoice.80000credits',
        type: 'Consumable',
        price: '1,000',
        originalPrice: '2,000',
      ),
      AppleProduct(
        id: 6,
        title: '200,000',
        productId: 'com.botnoimobile.botnoivoice.200000credits',
        type: 'Consumable',
        price: '2,300',
        originalPrice: '5,000',
      ),
    ];
  }
}
