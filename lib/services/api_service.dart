import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/product.dart';

class ApiService {
  Future<List<Product>> getProducts() async {
    // Cargar datos desde un JSON local (luego reemplazar por API real)
    final String response =
        await rootBundle.loadString('assets/mock_products.json');
    final List<dynamic> data = json.decode(response)['products'];
    return data.map((json) => Product.fromJson(json)).toList();
  }
}
