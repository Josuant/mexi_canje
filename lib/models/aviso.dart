import 'dart:convert';

class Aviso {
  final String title;
  final String description;
  final String updateType;
  final String category;
  final int importance;
  final String platform;
  final String details;
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
}
