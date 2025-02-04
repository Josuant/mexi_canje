class Product {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> categories;
  final String website;
  final bool? isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.categories,
    required this.website,
    required this.isFavorite,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id_empresa'].toString(),
      name: json['nombre_empresa'],
      imageUrl: json['url_imagen_empresa'] ?? '',
      categories: List<String>.from(json['categorias']),
      website: json['sitio_web_empresa'] ?? '',
      isFavorite: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_empresa': id,
      'nombre_empresa': name,
      'url_imagen_empresa': imageUrl,
      'categorias': categories,
      'sitio_web_empresa': website,
    };
  }

  Product copyWith({bool? isFavorite}) {
    return Product(
      id: id,
      name: name,
      categories: categories,
      website: website,
      isFavorite: isFavorite ?? this.isFavorite,
      imageUrl: imageUrl,
    );
  }
}
