class AppleProduct {
  final int id;
  final String title;
  final String productId;
  final String type;
  final String price;
  final String originalPrice;

  AppleProduct({
    required this.id,
    required this.title,
    required this.productId,
    required this.type,
    required this.price,
    required this.originalPrice,
  });

  factory AppleProduct.fromMap(Map<String, dynamic> map) {
    return AppleProduct(
      id: map['id'],
      title: map['title'],
      productId: map['productId'],
      type: map['type'],
      price: map['price'],
      originalPrice: map['originalPrice'],
    );
  }
}
