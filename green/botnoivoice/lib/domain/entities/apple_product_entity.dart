class AppleProduct {
  final int id;
  final String title;
  final String productId;
  final String price;

  AppleProduct({
    required this.id,
    required this.title,
    required this.productId,
    required this.price,
  });

  factory AppleProduct.fromMap(Map<String, dynamic> map) {
    return AppleProduct(
      id: map['id'],
      title: map['title'],
      productId: map['productId'],
      price: map['price'],
    );
  }
}
