// products_provider.dart
import 'package:flutter/material.dart';
import 'package:mexi_canje/models/aviso.dart';
import 'package:mexi_canje/models/product.dart';
import 'package:mexi_canje/services/api_service.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];
  List<Map<String, String>> _categories = [];
  List<Aviso> _notifications = [];
  bool _isLoadingProducts = false;
  bool _isLoadingCategories = false;
  bool _isLoadingNotifications = false;
  String? _productsError;
  String? _categoriesError;
  String? _notificationsError;

  final ApiService _apiService = ApiService();

  List<Product> get items => [..._items];
  List<Map<String, String>> get categories => [..._categories];
  List<Aviso> get notifications => [..._notifications];
  bool get isLoadingProducts => _isLoadingProducts;
  bool get isLoadingCategories => _isLoadingCategories;
  bool get isLoadingNotifications => _isLoadingNotifications;
  String? get productsError => _productsError;
  String? get categoriesError => _categoriesError;
  String? get notificationsError => _notificationsError;

  Future<void> getProducts(String searchTerm, [String? category]) async {
    print(
        "ProductsProvider.getProducts START - searchTerm: $searchTerm, category: $category"); // Debug start

    _isLoadingProducts = true;
    _productsError = null;
    try {
      print(
          "ProductsProvider.getProducts - Calling _apiService.getProducts..."); // Debug before api call
      _items = await _apiService.getProducts(searchTerm, category);
      print(
          "ProductsProvider.getProducts - _apiService.getProducts COMPLETED"); // Debug after api call
    } catch (e) {
      _productsError = 'Failed to load products: $e';
      _items = [];
      print(
          "ProductsProvider.getProducts - ERROR: $e"); // Debug error in provider
    } finally {
      _isLoadingProducts = false;
      notifyListeners();
      print("ProductsProvider.getProducts FINISH"); // Debug finish
    }
  }

  Future<void> getCategories() async {
    _isLoadingCategories = true;
    _categoriesError = null;
    try {
      _categories = (await _apiService.getCategories());
    } catch (e) {
      _categoriesError = 'Failed to load categories: $e';
      _categories = []; // Ensure categories are empty on error
      print("Error loading categories: $e"); // Log the error for debugging
    } finally {
      _isLoadingCategories = false;
      notifyListeners();
    }
  }

  Future<void> getNotifications() async {
    _isLoadingNotifications = true;
    _notificationsError = null;
    try {
      _notifications = await _apiService.getNotifications();
    } catch (e) {
      _notificationsError = 'Failed to load notifications: $e';
      _notifications = []; // Ensure notifications are empty on error
      print("Error loading notifications: $e"); // Log the error for debugging
    } finally {
      _isLoadingNotifications = false;
      notifyListeners();
    }
  }
}
