class GooglePlayProduct {
  final int id;
  final String title;
  final String productId;
  final String price;

  GooglePlayProduct({
    required this.id,
    required this.title,
    required this.productId,
    required this.price,
  });

    factory GooglePlayProduct.fromMap(Map<String, dynamic> map) {
    return GooglePlayProduct(
      id: map['id'],
      title: map['title'],
      productId: map['productId'],
      price: map['price'],
    );
  }
}
