import 'package:mexi_canje/models/aviso.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

class ApiService {
  // Get a reference your Supabase client
  final supabase = Supabase.instance.client;

  Future<List<Product>> getProducts(String searchTerm,
      [String? category]) async {
    if (category == 'Todos') {
      category = null;
    }

    final List<dynamic>? data = await supabase
        .rpc('buscar_empresas_por_etiqueta_json', params: {
      'keyword': searchTerm,
      if (category != null) 'categoria_nombre': category
    });
    final List<Map<String, dynamic>>? dataS =
        data?.cast<Map<String, dynamic>>();
    if (dataS == null) {
      return [];
    }
    return dataS.map((json) => Product.fromJson(json)).toList();
  }

  Future<List<Map<String, String>>> getCategories() async {
    final dataS = await supabase.rpc('obtener_todas_categorias');

    if (dataS == null) {
      return []; // Return empty list if data is null to avoid errors
    }

    if (dataS is List) {
      // Check if dataS is a List
      return dataS
          .cast<Map<String, dynamic>>()
          .map<Map<String, String>>((category) {
        return {
          'nombre_categoria': category['nombre_categoria'] as String? ??
              '', // Handle potential null values
          'url_imagen_categoria': category['url_imagen_categoria'] as String? ??
              '', // Handle potential null values
        };
      }).toList();
    } else {
      return []; // Return empty list in case of unexpected format
    }
  }

  Future<List<Aviso>> getNotifications() async {
    final data = await supabase.from('app_updates').select();
    return data.map((json) => Aviso.fromJson(json)).toList();
  }
}
