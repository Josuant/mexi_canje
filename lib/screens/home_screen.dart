import 'package:flutter/material.dart';
import 'package:mexi_canje/screens/search_sreen.dart';
import 'package:mexi_canje/widgets/product_card.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();

    return Scaffold(
      appBar: AppBar(
        title: Text('MexiCanje'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SearchScreen()),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: apiService.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (ctx, i) => ProductCard(product: snapshot.data![i]),
          );
        },
      ),
    );
  }
}
