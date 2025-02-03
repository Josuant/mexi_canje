class Product {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final String website;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.website,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      category: json['category'],
      website: json['website'],
    );
  }

  Map<String, String> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'category': category,
      'website': website,
    };
  }
}
