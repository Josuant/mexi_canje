import 'dart:convert';

import 'package:mexi_canje/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const key = 'favorites';

  static Future<void> saveFavorites(List<Product> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonList =
        favorites.map((product) => jsonEncode(product.toJson())).toList();
    await prefs.setStringList(key, jsonList);
  }

  static Future<List<Product>?> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList(key) ?? [];
    return favorites.map((json) => Product.fromJson(jsonDecode(json))).toList();
  }

  static Future<void> removeFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
