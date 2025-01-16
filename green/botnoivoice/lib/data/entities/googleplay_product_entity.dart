class GoogleProduct {
  final int id;
  final String title;
  final String productId;
  final String price;

  GoogleProduct({
    required this.id,
    required this.title,
    required this.productId,
    required this.price,
  });

  factory GoogleProduct.fromMap(Map<String, dynamic> map) {
    return GoogleProduct(
      id: map['id'],
      title: map['title'],
      productId: map['productId'],
      price: map['price'],
    );
  }
}