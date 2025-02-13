import 'package:flutter/material.dart';
import 'package:mexi_canje/models/notification.dart';
import 'package:mexi_canje/providers/favorite_provider.dart';
import 'package:mexi_canje/providers/products_provider.dart';
import 'package:mexi_canje/widgets/category_filter.dart';
import 'package:mexi_canje/widgets/contents/products_content.dart';
import 'package:mexi_canje/widgets/mexi_bottom_bar.dart';
import 'package:mexi_canje/widgets/search_bar.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/product.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  String _selectedCategory = 'Todos';
  final TextEditingController _searchController = TextEditingController();
  final FavoriteProvider _favoriteProvider = FavoriteProvider();
  final ProductsProvider _productsProvider = ProductsProvider();

  List<String> _categories = [];
  List<NotificationApp> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadNotifications();
    _loadProducts('');
  }

  Future<void> _loadCategories() async {
    await _productsProvider.getCategories();
    setState(() {
      _categories = _productsProvider.categories;
      _categories.insert(0, 'Todos');
    });
  }

  Future<void> _loadProducts(String searchTerm, [String? category]) async {
    await _productsProvider.getProducts(searchTerm, category);
    final products = _productsProvider.items;
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
        _loadProducts(_searchController.text).then((_) {
          setState(() {
            _filteredProducts = _products;
          });
        });
      } else {
        _filteredProducts = _products
            .where((product) => product.categories.contains(category))
            .toList();
      }
      _productsProvider.notifyChanges();
      updateFavorites();
    });
  }

  void searchProduct(String value) {
    _loadProducts(value, _selectedCategory);
  }

  void updateFavorites() {
    _filteredProducts = _filteredProducts.map((product) {
      final isFavorite =
          _favoriteProvider.favorites.any((p) => p.id == product.id);
      return product.copyWith(isFavorite: isFavorite);
    }).toList();
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (mounted) {
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
      backgroundColor: AppColors.background,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        toolbarHeight: 0.0,
      ),
      bottomNavigationBar: MexiBottomBar(),
      body: Column(
        verticalDirection: VerticalDirection.up,
        children: [
          // Grid de productos
          ProductsContent(
            productsProvider: _productsProvider,
            filteredProducts: _filteredProducts,
            onShowMap: (String productName) {
              final product =
                  _filteredProducts.firstWhere((p) => p.name == productName);
              _showMap(product);
            },
            onWebPressed: _launchURL,
            onFavPressed: (index) {
              final product = _filteredProducts[index];
              _favoriteProvider.toggleFavorite(product);
            },
          ),
          // Barra de búsqueda
          Container(
            padding:
                const EdgeInsets.only(left: 25, right: 25, top: 25, bottom: 25),
            decoration: BoxDecoration(
              color: AppColors.background,
            ),
            child: Column(
              spacing: 16.0,
              children: [
                MexiSearchBar(
                  controller: _searchController,
                  onChanged: (value) {
                    searchProduct(value);
                  },
                ),

                // Filtros de categoría
                CategoryFilter(
                  categories: _categories,
                  onCategorySelected: _onCategorySelected,
                  selectedCategory: _selectedCategory,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _onCategorySelected(selected, index) {
    if (selected) {
      _filterProducts(_categories[index]);
    } else {
      _filterProducts('Todos');
    }
  }

  void _loadNotifications() {
    _productsProvider.getNotifications();
    setState(() {
      _notifications = _productsProvider.notifications;
    });
  }

  void _showMap(Product filteredProduct) async {
    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=${filteredProduct.name}';
    final Uri uri = Uri.parse(googleMapsUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('No se pudo abrir el mapa para: ${filteredProduct.name}')),
      );
    }
  }

  Widget _buildModernDrawer() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 310,
        maxWidth: MediaQuery.of(context).size.width * 0.5,
      ),
      child: Drawer(
        elevation: 16,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Container(
          color: const Color.fromARGB(197, 0, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildDrawerMenuItems(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerMenuItems() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildMenuItem(SolarIconsBold.home, 'Inicio'),
        _buildMenuItem(SolarIconsBold.heart, 'Favoritos'),
        _buildMenuItem(SolarIconsBold.code, 'Mi Github'),
        _buildMenuItem(SolarIconsBold.mailbox, 'Contacto'),
        _buildMenuItem(SolarIconsBold.file, 'Aviso de Privacidad'),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.white54),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      hoverColor: Colors.white12,
      onTap: () {
        Navigator.pop(context);
        switch (title) {
          case 'Inicio':
            _productsProvider.getProducts('');
            setState(() {
              _selectedCategory = 'Todos';
              _products = _productsProvider.items;
              _filteredProducts = _products;
              _productsProvider.notifyChanges();
              updateFavorites();
            });
            _filteredProducts = _products;
            break;
          case 'Favoritos':
            setState(() {
              _filteredProducts = _products.where((product) {
                return _favoriteProvider.favorites
                    .any((p) => p.id == product.id);
              }).toList();
              _productsProvider.notifyChanges();
              updateFavorites();
            });
            break;
          case 'Mi Github':
            _launchURL('https://github.com/Josuant');
            break;
          case 'Contacto':
            _launchURL('mailto:alvarez.nava.antonio@gmail.com');
            break;
          case 'Aviso de Privacidad':
            _launchURL(
                'https://docs.google.com/document/d/e/2PACX-1vRMDr4s7fVqeUMpwFr8C2r1HTdUj9laqwrhBA_L8X8ederFhdQBYExZCrHZfQQgFi0HAU2Nr7pLFIxH/pub');
            break;
        }
      },
    );
  }
}
