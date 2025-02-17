import 'package:flutter/material.dart';
import 'package:mexi_canje/models/aviso.dart';
import 'package:mexi_canje/providers/favorite_provider.dart';
import 'package:mexi_canje/providers/products_provider.dart';
import 'package:mexi_canje/widgets/category_filter.dart';
import 'package:mexi_canje/widgets/contents/avisos_content.dart';
import 'package:mexi_canje/widgets/contents/categories_content.dart';
import 'package:mexi_canje/widgets/contents/info_content.dart';
import 'package:mexi_canje/widgets/contents/mexi_content.dart';
import 'package:mexi_canje/widgets/contents/products_content.dart';
import 'package:mexi_canje/widgets/mexi_bottom_bar.dart';
import 'package:mexi_canje/widgets/native_ad_card.dart';
import 'package:mexi_canje/widgets/search_bar.dart';
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
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  String _selectedCategory = 'Todos';
  final TextEditingController _searchController = TextEditingController();
  final FavoriteProvider _favoriteProvider = FavoriteProvider();
  final ProductsProvider _productsProvider = ProductsProvider();

  List<Map<String, String>> _categories = [];
  List<Aviso> _notifications = [];
  bool _favorites = false;
  int _index = 0;
  String _title = "Categorías";

  bool _showCategories = true;

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
    _showCategories = false;
    _navigateTo(0);
    _loadProducts(value, _selectedCategory);
  }

  void updateFavorites() {
    _filteredProducts = _filteredProducts.map((product) {
      final isFavorite =
          _favoriteProvider.favorites.any((p) => p.id == product.id);
      return product.copyWith(isFavorite: isFavorite);
    }).toList();
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
      bottomNavigationBar: MexiBottomBar(
        onItemTapped: (index) {
          _showCategories = true;
          _navigateTo(index);
        },
        selectedIndex: _index,
      ),
      body: Column(
        verticalDirection: VerticalDirection.up,
        children: [
          Expanded(
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
                          children: [
                            ..._getContent(_index).getContents(context),
                            Text(
                              "Espacio publicitario",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 26,
                                color: AppColors.primary,
                              ),
                            ),
                            NativeAdCard(
                              productsProvider: _productsProvider,
                            ),
                          ])))),

          SizedBox(
            height: 20,
            width: 20,
          ),
          // Barra de búsqueda
          Container(
            clipBehavior: Clip.antiAlias,
            padding:
                const EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
            decoration: BoxDecoration(
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
                SizedBox(height: 15),
                MexiSearchBar(
                  controller: _searchController,
                  onChanged: (value) {
                    searchProduct(value);
                  },
                ),

                // Filtros de categoría

                _index == 0 && !_showCategories
                    ? Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: CategoryFilter(
                          categories: _categories
                              .map((category) =>
                                  category['nombre_categoria'] ?? 'Todos')
                              .toList(),
                          onCategorySelected: _onCategorySelected,
                          selectedCategory: _selectedCategory,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          _title,
                          textAlign: TextAlign.start,
                          style: TextStyle(
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
    );
  }

  CategoriesContent getCategoriesContent() {
    return CategoriesContent(
      categories: _categories,
      onCategorySelected: _onCategorySelected,
    );
  }

  toggleFav(index) {
    final product = _filteredProducts[index];
    _favoriteProvider.toggleFavorite(product);
  }

  _onCategorySelected(selected, index) {
    _showCategories = false;
    _navigateTo(0);
    if (selected) {
      _filterProducts(_categories[index]['nombre_categoria'] ?? 'Todos');
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

  MexiContent _getContent(int index) {
    switch (index) {
      case 0:
        if (_showCategories) {
          return getCategoriesContent();
        } else {
          return getProductsContent();
        }
      case 1:
        return getProductsContent();
      case 2:
        return AvisosContent(avisos: _notifications);
      case 3:
        return InfoContent();
      default:
        return getCategoriesContent();
    }
  }

  void _navigateTo(int index) {
    _scrollController.jumpTo(0);
    switch (index) {
      case 0:
        _productsProvider.getProducts('');
        setState(() {
          _title = "Categorias";
          _selectedCategory = 'Todos';
          _products = _productsProvider.items;
          _filteredProducts = _products;
          _productsProvider.notifyChanges();
          _favorites = false;
          updateFavorites();
        });
        _filteredProducts = _products;
        break;
      case 1:
        setState(() {
          _title = "Favoritos";
          _searchController.clear();
          _selectedCategory = 'Todos';
          _products = _productsProvider.items;
          _filteredProducts = _products;
          _filteredProducts = _products.where((product) {
            return _favoriteProvider.favorites.any((p) => p.id == product.id);
          }).toList();
          _productsProvider.notifyChanges();
          updateFavorites();
          _favorites = true;
        });
        break;
      case 2:
        setState(() {
          _loadNotifications();
          _title = "Avisos";
        });
        break;
      case 3:
        setState(() {
          _title = "Información";
        });
        break;
    }
    _index = index;
  }
}
