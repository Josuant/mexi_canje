import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/product.dart';
import '../providers/favorite_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return Card(
      child: ListTile(
        leading: Image.network(product.imageUrl),
        title: Text(product.name),
        subtitle: Text(product.category),
        trailing: IconButton(
          icon: Icon(
            favoriteProvider.favorites.any((p) => p.id == product.id)
                ? Icons.favorite
                : Icons.favorite_border,
            color: Colors.red,
          ),
          onPressed: () => favoriteProvider.toggleFavorite(product),
        ),
        onTap: () => launch(product.website),
      ),
    );
  }
}
