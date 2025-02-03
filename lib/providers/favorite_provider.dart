import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/local_storage.dart';

class FavoriteProvider with ChangeNotifier {
  List<Product> _favorites = [];

  List<Product> get favorites => _favorites;

  Future<void> loadFavorites() async {
    _favorites = await LocalStorage.getFavorites() ?? [];
    notifyListeners();
  }

  void toggleFavorite(Product product) {
    if (_favorites.any((p) => p.id == product.id)) {
      _favorites.removeWhere((p) => p.id == product.id);
    } else {
      _favorites.add(product);
    }
    LocalStorage.saveFavorites(_favorites);
    notifyListeners();
  }
}
