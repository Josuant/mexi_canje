import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mexi_canje/models/product.dart';
import 'package:mexi_canje/providers/favorite_provider.dart';
import 'package:mexi_canje/widgets/product_card.dart';

class ProductsContent extends StatelessWidget {
  final List<Product> filteredProducts;
  final Function(String) onShowMap;
  final Function(String) onWebPressed;
  final Function(int) onFavPressed;
  final String category;
  final bool favoritesEnabled;

  const ProductsContent({
    super.key,
    required this.filteredProducts,
    required this.onShowMap,
    required this.onWebPressed,
    required this.onFavPressed,
    required this.category,
    required this.favoritesEnabled,
    required FavoriteProvider favoriteProvider,
  });

  @override
  Widget build(BuildContext context) {
    return filteredProducts.isEmpty
        ? favoritesEnabled
            ? EmptyListWidget(text: '¡Aún no añades favoritos!')
            : EmptyListWidget(text: '¡Chin!, no encontramos algo')
        : GridView.builder(
            cacheExtent: 100,
            clipBehavior: Clip.none,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 1,
                crossAxisSpacing: 35.0,
                mainAxisSpacing: 35.0,
                mainAxisExtent: 190.0),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              return ProductCard(
                key: ValueKey(filteredProducts[index].id),
                product: filteredProducts[index],
                onMapPressed: () {
                  onShowMap(filteredProducts[index].name);
                },
                onWebPressed: () =>
                    onWebPressed(filteredProducts[index].website),
                onFavPressed: () => onFavPressed(index),
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
          );
  }
}

class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF4CAF96),
                fontSize: 24,
              )),
          Image.asset(
            'assets/images/empty_list.png',
            height: 200,
          ),
        ],
      ),
    );
  }
}
