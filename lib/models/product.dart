class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int? minAge;
  final int? maxAge;
  final String? imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.minAge,
    this.maxAge,
    this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      minAge: json['min_age'],
      maxAge: json['max_age'],
      imageUrl: json['image'],
    );
  }
}