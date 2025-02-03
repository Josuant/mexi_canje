import 'package:flutter/material.dart';
import 'package:mexi_canje/providers/favorite_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  String _selectedCategory = 'Todos';
  final TextEditingController _searchController = TextEditingController();
  final FavoriteProvider _favoriteProvider = FavoriteProvider();

  final List<String> _categories = [
    'Todos',
    'Alimentos',
    'Bebidas',
    'Ropa',
    'Tecnología',
    'Hogar'
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await _apiService.getProducts();
    _favoriteProvider.loadFavorites();
    setState(() {
      _products = products;
      _filteredProducts = products;
      updateFavorites();
    });
  }

  void _filterProducts(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == 'Todos') {
        _filteredProducts = _products;
      } else {
        _filteredProducts =
            _products.where((product) => product.category == category).toList();
      }
      updateFavorites();
    });
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir la URL: $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _favoriteProvider.addListener(() {
      setState(() {
        updateFavorites();
      });
    });
    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: Color(0xFFF7F7F7),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.primary),
          onPressed: () {},
        ),
        title: const Center(
          child: Text(
            'MexiCanje',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Barra de búsqueda
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar productos...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                searchProduct(value);
              },
            ),
            const SizedBox(height: 16),

            // Filtros de categoría
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(_categories[index]),
                      selected: _selectedCategory == _categories[index],
                      selectedColor: AppColors.primary,
                      showCheckmark: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      labelStyle: TextStyle(
                        color: _selectedCategory == _categories[index]
                            ? Colors.white
                            : Colors.black,
                      ),
                      onSelected: (selected) {
                        _filterProducts(_categories[index]);
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Grid de productos
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: 0.75,
                ),
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: _filteredProducts[index],
                    onMapPressed: () {
                      _showMap(_filteredProducts[index]);
                    },
                    onWebPressed: () =>
                        _launchURL(_filteredProducts[index].website),
                    onFavPressed: () => _favoriteProvider.toggleFavorite(
                      _filteredProducts[index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void searchProduct(String value) {
    setState(() {
      _filteredProducts = _products
          .where((product) =>
              product.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
      updateFavorites();
    });
  }

  void updateFavorites() {
    _filteredProducts = _filteredProducts.map((product) {
      final isFavorite =
          _favoriteProvider.favorites.any((p) => p.id == product.id);
      return product.copyWith(isFavorite: isFavorite);
    }).toList();
  }

  void _showMap(Product filteredProduct) async {
    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=${filteredProduct.name}';
    final Uri uri = Uri.parse(googleMapsUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('No se pudo abrir el mapa para: ${filteredProduct.name}')),
      );
    }
  }
}
