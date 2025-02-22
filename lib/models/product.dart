// models/product.dart
import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 0)
class Product {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String imageUrl;
  @HiveField(3)
  final List<String> categories;
  @HiveField(4)
  final String website;
  @HiveField(5)
  final bool? isFavorite;
  @HiveField(6)
  final String mexicanidad;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.categories,
    required this.website,
    required this.isFavorite,
    required this.mexicanidad,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id_empresa'].toString(),
      name: json['nombre_empresa'],
      imageUrl: json['url_imagen_empresa'] ?? '',
      categories: List<String>.from(json['categorias']),
      website: json['sitio_web_empresa'] ?? '',
      mexicanidad: json['mexicanidad'] ?? '',
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
      'mexicanidad': mexicanidad,
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
      mexicanidad: mexicanidad,
    );
  }
}
