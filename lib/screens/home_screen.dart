import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mexi_canje/models/notification.dart';
import 'package:mexi_canje/providers/favorite_provider.dart';
import 'package:mexi_canje/providers/products_provider.dart';
import 'package:mexi_canje/widgets/native_ad_card.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/product.dart';
import '../utils/constants.dart';
import '../widgets/product_card.dart';

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
      key: _scaffoldKey,
      drawer: _buildModernDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F7),
        leading: IconButton(
          icon: const Icon(
            SolarIconsOutline.hamburgerMenu,
            color: AppColors.primary,
            size: 32,
          ),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
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
            icon: const Icon(
              SolarIconsOutline.bell,
              color: AppColors.primary,
              size: 32,
            ),
            onPressed: () {
              _loadNotifications();
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: AppColors.primary,
                    title: const Text('Notificaciones',
                        style: TextStyle(color: Colors.white)),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _notifications
                          .map(
                            (notification) => ListTile(
                              title: Text(notification.title,
                                  style: const TextStyle(color: Colors.white)),
                              subtitle: Text(notification.description,
                                  style: const TextStyle(color: Colors.white)),
                            ),
                          )
                          .toList(),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cerrar',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  );
                },
              );
            },
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
                prefixIcon: const Icon(
                  SolarIconsOutline.magnifier,
                  size: 32,
                ),
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
                        if (selected) {
                          _filterProducts(_categories[index]);
                        } else {
                          _filterProducts('Todos');
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Grid de productos
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GridView.builder(
                      // GridView para los items normales (igual que en Opción 3)
                      shrinkWrap:
                          true, // Importante para que el GridView no sea infinito en un Column (igual que en Opción 3)
                      physics:
                          const NeverScrollableScrollPhysics(), // Desactivamos el scroll INTERNO del GridView (igual que en Opción 3)
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            MediaQuery.of(context).size.width > 600 ? 4 : 2,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                        childAspectRatio:
                            MediaQuery.of(context).size.width > 600
                                ? 0.6
                                : 0.75,
                      ),
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        // Construye un item normal del GridView
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
                        )
                            .animate() // Inicia la configuración de la animación
                            .fadeIn(duration: 300.ms) // Animación de aparición
                            .slideX(
                              begin: 0.1,
                              end: 0,
                              curve: Curves.easeOut,
                            )
                            .scale(
                              begin: const Offset(0.9, 0.9),
                              end: const Offset(1, 1),
                            );
                      },
                    ),
                    NativeAdCard(
                      productsProvider: _productsProvider,
                    ), // Anuncio nativo
                  ],
                ),
              ),
            ), // Anuncio nativo
          ],
        ),
      ),
    );
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
