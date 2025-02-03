import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  String _selectedCategory = 'Todas';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final ApiService apiService = ApiService();
    final products = await apiService.getProducts();
    setState(() {
      _products = products;
      _filteredProducts = products;
    });
  }

  void _searchProducts(String query) {
    setState(() {
      _filteredProducts = _products
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()) &&
              (_selectedCategory == 'Todas' ||
                  product.category == _selectedCategory))
          .toList();
    });
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _filteredProducts = _products
          .where((product) =>
              product.name
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) &&
              (category == 'Todas' || product.category == category))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Productos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _searchProducts,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              value: _selectedCategory,
              items: [
                'Todas',
                'Alimentos',
                'Bebidas',
                'Ropa',
                'Tecnología',
                'Cuidado Personal',
                'Hogar',
              ].map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _filterByCategory(newValue);
                }
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredProducts.length,
              itemBuilder: (ctx, i) =>
                  ProductCard(product: _filteredProducts[i]),
            ),
          ),
        ],
      ),
    );
  }
}
