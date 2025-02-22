// models/aviso.dart
import 'package:hive/hive.dart';
import 'dart:convert';

part 'aviso.g.dart';

@HiveType(typeId: 1)
class Aviso {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final String updateType;
  @HiveField(3)
  final String category;
  @HiveField(4)
  final int importance;
  @HiveField(5)
  final String platform;
  @HiveField(6)
  final String details;
  @HiveField(7)
  final String urlImagen;

  Aviso({
    required this.title,
    required this.description,
    required this.updateType,
    required this.category,
    required this.importance,
    required this.platform,
    required this.details,
    required this.urlImagen,
  });

  factory Aviso.fromJson(Map<String, dynamic> json) {
    return Aviso(
      title: json['title'],
      description: json['description'] ?? '',
      updateType: json['update_type'] ?? '',
      category: json['category'] ?? '',
      importance: json['importance'] ?? '',
      platform: json['platform'] ?? '',
      details: jsonEncode(json['details']),
      urlImagen: json['url_imagen'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'update_type': updateType,
      'category': category,
      'importance': importance,
      'platform': platform,
      'details': details,
      'url_imagen': urlImagen,
    };
  }
}
