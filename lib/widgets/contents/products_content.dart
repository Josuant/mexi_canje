import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mexi_canje/models/product.dart';
import 'package:mexi_canje/providers/products_provider.dart';
import 'package:mexi_canje/utils/constants.dart';
import 'package:mexi_canje/widgets/contents/mexi_content.dart';
import 'package:mexi_canje/widgets/native_ad_card.dart';
import 'package:mexi_canje/widgets/product_card.dart';

class ProductsContent extends MexiContent {
  final ProductsProvider productsProvider;
  final List<Product> filteredProducts;
  final Function(String) onShowMap;
  final Function(String) onWebPressed;
  final Function(int) onFavPressed;

  const ProductsContent({
    super.key,
    required this.productsProvider,
    required this.filteredProducts,
    required this.onShowMap,
    required this.onWebPressed,
    required this.onFavPressed,
  });

  @override
  List<Widget> getContents(BuildContext context) {
    return [
      GridView.builder(
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
            product: filteredProducts[index],
            onMapPressed: () {
              onShowMap(filteredProducts[index].name);
            },
            onWebPressed: () => onWebPressed(filteredProducts[index].website),
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
      ),
      NativeAdCard(
        productsProvider: productsProvider,
      ),
    ];
  }
}
