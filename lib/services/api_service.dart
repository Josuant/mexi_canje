import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

class ApiService {
  // Get a reference your Supabase client
  final supabase = Supabase.instance.client;

  Future<List<Product>> getProducts() async {
    final PostgrestList dataS = await supabase.from('product').select();
    return dataS.map((json) => Product.fromJson(json)).toList();

    // Cargar datos desde un JSON local (luego reemplazar por API real)
    final String response =
        await rootBundle.loadString('assets/mock_products.json');
    final List<dynamic> data = json.decode(response)['products'];
    return data.map((json) => Product.fromJson(json)).toList();
  }
}
