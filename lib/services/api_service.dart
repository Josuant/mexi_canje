// api_service.dart
import 'package:mexi_canje/models/aviso.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ApiService {
  final supabase = Supabase.instance.client;
  final String productsBoxName = 'productsBox'; // Changed box name
  final String categoriesBoxName = 'categoriesBox'; // Changed box name
  final String notificationsBoxName = 'notificationsBox'; // Changed box name

  Future<List<Product>> getProducts(String searchTerm,
      [String? category]) async {
    print("ApiService.getProducts function CALLED!"); // Add this line
    final String cacheKey = 'products_${searchTerm}_${category ?? 'all'}';
    final productsBox = await Hive.openBox<List<dynamic>>(productsBoxName);

    if (productsBox.containsKey(cacheKey) &&
        productsBox.get(cacheKey) != null) {
      print('Products loaded from cache for key: $cacheKey');
      return (productsBox.get(cacheKey) as List).cast<Product>();
    }

    try {
      if (category == 'Todos') {
        category = null;
      }

      final List<dynamic>? data = await supabase
          .rpc('buscar_empresas_por_etiqueta_json', params: {
        'keyword': searchTerm,
        if (category != null) 'categoria_nombre': category
      });
      print("Raw API Response Data:");
      print(data);
      final List<Map<String, dynamic>>? dataS =
          data?.cast<Map<String, dynamic>>();
      if (dataS == null) {
        return [];
      }
      List<Product> products =
          dataS.map((json) => Product.fromJson(json)).toList();
      await productsBox.put(cacheKey, products);
      print('Products fetched from API and cached for key: $cacheKey');
      return products;
    } catch (e) {
      print("API Error getProducts: $e");
      if (productsBox.containsKey(cacheKey) &&
          productsBox.get(cacheKey) != null) {
        print(
            'Returning stale products from cache due to API error for key: $cacheKey');
        return (productsBox.get(cacheKey) as List).cast<Product>();
      }
      throw Exception('Failed to load products: $e');
    }
  }

  Future<List<Map<String, String>>> getCategories() async {
    final categoriesBox = await Hive.openBox<List<dynamic>>(categoriesBoxName);
    const String cacheKey = 'categories';

    if (categoriesBox.containsKey(cacheKey) &&
        categoriesBox.get(cacheKey) != null) {
      print('Categories loaded from cache');
      final categories = categoriesBox.get(cacheKey) as List<dynamic>;
      // Convert List<dynamic> to List<Map<String, String>>
      final List<Map<String, String>> categoriesM =
          categories.asMap().entries.map((entry) {
        final Map<String, String> category = {};
        entry.value.forEach((key, value) {
          category[key.toString()] = value.toString();
        });
        return category;
      }).toList();

      return categoriesM.cast<Map<String, String>>();
    }

    try {
      final dataS = await supabase.rpc('obtener_todas_categorias');

      if (dataS == null) {
        return [];
      }

      if (dataS is List) {
        List<Map<String, String>> categories =
            (dataS).asMap().entries.map((entry) {
          final Map<String, String> category = {};
          entry.value.forEach((key, value) {
            category[key.toString()] = value.toString();
          });
          return category;
        }).toList();
        await categoriesBox.put(cacheKey, categories);
        print('Categories fetched from API and cached');
        return categories;
      } else {
        return [];
      }
    } catch (e) {
      print("API Error getCategories: $e");
      if (categoriesBox.containsKey(cacheKey) &&
          categoriesBox.get(cacheKey) != null) {
        print('Returning stale categories from cache due to API error');
        return (categoriesBox.get(cacheKey) as List)
            .cast<Map<String, String>>();
      }
      throw Exception('Failed to load categories: $e');
    }
  }

  Future<List<Aviso>> getNotifications() async {
    final notificationsBox =
        await Hive.openBox<List<dynamic>>(notificationsBoxName);
    const String cacheKey = 'notifications';

    if (notificationsBox.containsKey(cacheKey) &&
        notificationsBox.get(cacheKey) != null) {
      print('Notifications loaded from cache');
      return (notificationsBox.get(cacheKey) as List).cast<Aviso>();
    }

    try {
      final data = await supabase.from('app_updates').select();
      List<Aviso> notifications =
          data.map((json) => Aviso.fromJson(json)).toList();
      await notificationsBox.put(cacheKey, notifications);
      print('Notifications fetched from API and cached');
      return notifications;
    } catch (e) {
      print("API Error getNotifications: $e");
      if (notificationsBox.containsKey(cacheKey) &&
          notificationsBox.get(cacheKey) != null) {
        print('Returning stale notifications from cache due to API error');
        return (notificationsBox.get(cacheKey) as List).cast<Aviso>();
      }
      throw Exception('Failed to load notifications: $e');
    }
  }
}
