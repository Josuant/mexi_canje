// home_screen.dart
import 'package:flutter/material.dart';
import 'package:mexi_canje/models/aviso.dart';
import 'package:mexi_canje/providers/favorite_provider.dart';
import 'package:mexi_canje/providers/products_provider.dart';
import 'package:mexi_canje/widgets/category_filter.dart';
import 'package:mexi_canje/widgets/contents/avisos_content.dart';
import 'package:mexi_canje/widgets/contents/categories_content.dart';
import 'package:mexi_canje/widgets/contents/info_content.dart';
import 'package:mexi_canje/widgets/contents/products_content.dart';
import 'package:mexi_canje/widgets/mexi_bottom_bar.dart';
import 'package:mexi_canje/widgets/native_ad_card.dart';
import 'package:mexi_canje/widgets/search_bar.dart';
import 'package:provider/provider.dart'; // Import Provider
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
  final ScrollController _scrollController = ScrollController();
  List<Product> _filteredProducts = []; // Use only filtered products
  String _selectedCategory = 'Todos';
  final TextEditingController _searchController = TextEditingController();
  bool _favorites = false;
  int _index = 0;
  String _title = "Categorías";
  bool _showCategories = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    await productsProvider.getCategories();
    await productsProvider.getNotifications();
    await _loadProducts(''); // Load all products initially
  }

  Future<void> _loadProducts(String searchTerm, [String? category]) async {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    await productsProvider.getProducts(searchTerm, category);
    _updateFilteredProducts(productsProvider.items);
  }

  void _updateFilteredProducts(List<Product> products) {
    final favoriteProvider =
        Provider.of<FavoriteProvider>(context, listen: false);
    favoriteProvider
        .loadFavorites(); // Load favorites here, only once when products are loaded

    List<Product> filtered = products;
    if (_selectedCategory != 'Todos') {
      filtered = products
          .where((product) => product.categories.contains(_selectedCategory))
          .toList();
    }

    _filteredProducts = filtered.map((product) {
      final isFavorite =
          favoriteProvider.favorites.any((p) => p.id == product.id);
      return product.copyWith(isFavorite: isFavorite);
    }).toList();

    if (mounted) {
      setState(() {}); // Update UI after filtering and favorite update
    }
  }

  void _filterProducts(String category) {
    setState(() {
      _showCategories = false; // Hide categories when filtering products
      _selectedCategory = category;
    });
    if (category == 'Todos') {
      _loadProducts(_searchController.text); // Reload all products
    } else {
      _searchController.clear();
      _loadProducts('', category); // Load products by category
    }
  }

  void searchProduct(String value) {
    _showCategories = false;
    _loadProducts(value, _selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final categories = productsProvider.categories;
    final notifications = productsProvider.notifications;

    return Scaffold(
      backgroundColor: AppColors.background,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        toolbarHeight: 0.0,
      ),
      bottomNavigationBar: MexiBottomBar(
        onItemTapped: (index) {
          _showCategories = true;
          _navigateTo(index);
        },
        selectedIndex: _index,
      ),
      body: Column(
        verticalDirection: VerticalDirection.up,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
              fit: FlexFit.loose,
              child: SingleChildScrollView(
                  controller: _scrollController,
                  clipBehavior: Clip.none,
                  child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                      ),
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: 35,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _getContent(
                                _index, productsProvider, notifications),
                            Text(
                              "Espacio publicitario",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 26,
                                color: AppColors.primary,
                              ),
                            ),
                            NativeAdCard(
                              productsProvider: productsProvider,
                            ),
                          ])))),

          const SizedBox(height: 20, width: 20),
          // Barra de búsqueda
          Container(
            clipBehavior: Clip.antiAlias,
            padding:
                const EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
            decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Mexicanje",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                      height: 1),
                ),
                Text("Encuentra productos mexicanos",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    )),
                const SizedBox(height: 15),
                MexiSearchBar(
                  controller: _searchController,
                  onChanged: (value) {
                    searchProduct(value);
                  },
                  onSubmitted: (value) {
                    searchProduct(value);
                  },
                ),

                // Filtros de categoría
                if ((_index == 0) && !_showCategories)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: CategoryFilter(
                      categories: categories
                          .map((category) =>
                              category['nombre_categoria'] as String)
                          .toList(),
                      onCategorySelected: _onCategorySelected,
                      selectedCategory: _selectedCategory,
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      _title,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 26,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ProductsContent getProductsContent() {
    return ProductsContent(
      filteredProducts: _filteredProducts,
      onShowMap: _showMap,
      onWebPressed: _launchURL,
      onFavPressed: toggleFav,
      category: _selectedCategory,
      favoritesEnabled: _favorites,
      favoriteProvider: Provider.of<FavoriteProvider>(context),
    );
  }

  CategoriesContent getCategoriesContent(ProductsProvider productsProvider) {
    return CategoriesContent(
      categories: productsProvider.categories.cast<Map<String, String>>(),
      onCategorySelected: _onCategorySelected,
    );
  }

  toggleFav(index) {
    final favoriteProvider =
        Provider.of<FavoriteProvider>(context, listen: false);
    final product = _filteredProducts[index];
    favoriteProvider.toggleFavorite(product);
    setState(() {
      _filteredProducts[index] =
          product.copyWith(isFavorite: product.isFavorite);
      _updateFilteredProducts(_filteredProducts);
    });
  }

  void _onCategorySelected(bool selected, int index) {
    _showCategories = false;
    _navigateTo(0);
    if (selected) {
      _filterProducts(Provider.of<ProductsProvider>(context, listen: false)
              .categories[index]['nombre_categoria'] ??
          'Todos');
    } else {
      _filterProducts('Todos');
    }
  }

  void _showMap(String productName) async {
    final filteredProduct =
        _filteredProducts.firstWhere((p) => p.name == productName);
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

  Widget _getContent(
      int index, ProductsProvider productsProvider, List<Aviso> notifications) {
    switch (index) {
      case 0:
        return _showCategories
            ? getCategoriesContent(productsProvider)
            : getProductsContent();
      case 1:
        return getProductsContent();
      case 2:
        return AvisosContent(avisos: notifications);
      case 3:
        return InfoContent();
      default:
        return getCategoriesContent(productsProvider);
    }
  }

  void _navigateTo(int index) {
    _scrollController.jumpTo(0);
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final favoriteProvider =
        Provider.of<FavoriteProvider>(context, listen: false);

    setState(() {
      _index = index;
      _searchController.clear();
      _selectedCategory = 'Todos';
      _favorites = false;

      switch (index) {
        case 0:
          _title = "Categorías";
          break;
        case 1:
          _title = "Favoritos";
          _showCategories = false;
          _favorites = true;
          updateFavoritesFromProvider(); // Refresh favorites status
          break;
        case 2:
          _title = "Avisos";
          _showCategories = false;
          break;
        case 3:
          _title = "Información";
          _showCategories = false;
          break;
        default:
          _title = "Categorías";
          _showCategories = true;
      }
    });
  }

  void updateFavoritesFromProvider() {
    final favoriteProvider =
        Provider.of<FavoriteProvider>(context, listen: false);
    setState(() {
      _filteredProducts = favoriteProvider.favorites.map((product) {
        return product.copyWith(isFavorite: true);
      }).toList();
    });
  }
}
