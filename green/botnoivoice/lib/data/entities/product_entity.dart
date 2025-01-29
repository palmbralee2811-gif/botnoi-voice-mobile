class Product {
  final int id;
  final String title;
  final String productId;
  final String price;

  Product({
    required this.id,
    required this.title,
    required this.productId,
    required this.price,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      title: map['title'],
      productId: map['productId'],
      price: map['price'],
    );
  }
}
