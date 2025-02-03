import 'package:flutter/src/widgets/framework.dart';

class Product {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final String website;
  final bool? isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.website,
    required this.isFavorite,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      category: json['category'],
      website: json['website'],
      isFavorite: null,
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

  Product copyWith({bool? isFavorite}) {
    return Product(
      id: id,
      name: name,
      category: category,
      website: website,
      isFavorite: isFavorite ?? this.isFavorite,
      imageUrl: imageUrl,
    );
  }
}
