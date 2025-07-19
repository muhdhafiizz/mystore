class Product {
  final int id;
  final String title;
  final double price;
  final String thumbnail;
  final String category;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.category
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      thumbnail: json['thumbnail'],
      category: json ['category']
    );
  }
}
