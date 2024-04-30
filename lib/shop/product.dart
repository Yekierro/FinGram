class Product {
  final String id;
  final String name;
  final String imageUrl;
  final int price;
  bool isPurchased;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.isPurchased = false,
  });

  factory Product.fromMap(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      name: data['name'],
      imageUrl: data['imageUrl'],
      price: data['price'],
      isPurchased: data['isPurchased'] ?? false,
    );
  }
}
