import 'package:flutter/material.dart';
import 'package:mexi_canje/models/notification.dart';
import 'package:mexi_canje/models/product.dart';
import 'package:mexi_canje/services/api_service.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];
  List<String> _categories = [];
  List<NotificationApp> _notifications = [];

  final ApiService _apiService = ApiService();

  List<Product> get items {
    return [..._items];
  }

  List<String> get categories {
    return [..._categories];
  }

  List<NotificationApp> get notifications {
    return [..._notifications];
  }

  Future<void> getProducts(String searchTerm, [String? category]) async {
    _items = await _apiService.getProducts(searchTerm, category);
    notifyListeners();
  }

  Future<void> getCategories() async {
    _categories = await _apiService.getCategories();
    notifyListeners();
  }

  Future<void> getNotifications() async {
    _notifications = await _apiService.getNotifications();
    notifyListeners();
  }

  void notifyChanges() {
    notifyListeners();
  }
}
