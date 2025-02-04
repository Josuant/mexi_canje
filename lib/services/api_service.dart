import 'package:mexi_canje/models/notification.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

class ApiService {
  // Get a reference your Supabase client
  final supabase = Supabase.instance.client;

  Future<List<Product>> getProducts(String searchTerm,
      [String? category]) async {
    final List<dynamic>? data = await supabase
        .rpc('buscar_empresas_relacionadas', params: {
      'search_term': searchTerm,
      if (category != null) 'category_filter': category
    });
    final List<Map<String, dynamic>>? dataS =
        data?.cast<Map<String, dynamic>>();
    if (dataS == null) {
      return [];
    }
    return dataS.map((json) => Product.fromJson(json)).toList();
  }

  Future<List<String>> getCategories() async {
    final dataS = await supabase.rpc('obtener_todas_categorias');
    return List<String>.from(dataS);
  }

  Future<List<NotificationApp>> getNotifications() async {
    final data = await supabase.from('app_updates').select();
    return data.map((json) => NotificationApp.fromJson(json)).toList();
  }
}
