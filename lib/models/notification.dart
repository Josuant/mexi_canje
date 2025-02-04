/* 
  Example of return:
   '¡Nueva tienda disponible!',
    'Hemos añadido la tienda Aurrera a nuestra lista de establecimientos asociados',
    'feature',
    'stores',
    2,
    'all',
    '{"store_name": "Aurrera", "locations": ["CDMX", "Monterrey", "Guadalajara"]}'
*/

import 'dart:convert';

class NotificationApp {
  final String title;
  final String description;
  final String updateType;
  final String category;
  final int importance;
  final String platform;
  final String details;

  NotificationApp({
    required this.title,
    required this.description,
    required this.updateType,
    required this.category,
    required this.importance,
    required this.platform,
    required this.details,
  });

  factory NotificationApp.fromJson(Map<String, dynamic> json) {
    return NotificationApp(
      title: json['title'],
      description: json['description'],
      updateType: json['update_type'],
      category: json['category'],
      importance: json['importance'],
      platform: json['platform'],
      details: jsonEncode(json['details']),
    );
  }
}
