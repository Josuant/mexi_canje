import 'package:flutter/material.dart';
import 'package:mexi_canje/utils/constants.dart';
import 'package:solar_icons/solar_icons.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onMapPressed;
  final VoidCallback onWebPressed;
  final VoidCallback onFavPressed;

  const ProductCard({
    super.key,
    required this.product,
    required this.onMapPressed,
    required this.onWebPressed,
    required this.onFavPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                  child: product.imageUrl.isNotEmpty
                      ? Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              SolarIconsBold.linkBroken,
                              size: 50,
                              color: Colors.grey,
                            );
                          },
                        )
                      : // Icon depends on first category of the product
                      Icon(
                          product.categories.isNotEmpty
                              ? Constants.categoryIcons[
                                      product.categories.first] ??
                                  SolarIconsBold.cupHot
                              : SolarIconsBold.linkBroken,
                          size: 50,
                          color: Colors.grey,
                        ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    isSelected: product.isFavorite,
                    selectedIcon: const Icon(SolarIconsBold.heart,
                        color: AppColors.accent),
                    icon: const Icon(SolarIconsBold.heart,
                        color: Color(0xFFD5D5D5)),
                    onPressed: onFavPressed,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: IconButton(
                  icon: const Icon(SolarIconsBold.pointOnMap,
                      size: 32, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                      ),
                    ),
                  ),
                  onPressed: onMapPressed,
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: IconButton(
                  icon: const Icon(SolarIconsBold.cartLarge,
                      size: 32, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(8),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15),
                        ),
                      )),
                  onPressed: onWebPressed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Constants {
  static const Map<String, IconData> categoryIcons = {
    'Alimentos': SolarIconsBold.chefHat,
    'Bebidas': SolarIconsBold.bottle,
    'Automóviles': SolarIconsBold.cart,
    'Bienes raíces': SolarIconsBold.home1,
    'Electrónicos': SolarIconsBold.smartphone,
    'Hogar': SolarIconsBold.armchair_2,
    'Jardín': SolarIconsBold.leaf,
    'Juguetes': SolarIconsBold.gamepad,
    'Libros': SolarIconsBold.book,
    'Mascotas': SolarIconsBold.paw,
    'Moda': SolarIconsBold.bag,
    'Muebles': SolarIconsBold.chair,
    'Niños': SolarIconsBold.smileCircle,
    'Salud y belleza': SolarIconsBold.heart,
    'Servicios': SolarIconsBold.washingMachine,
    'Tecnología': SolarIconsBold.laptop,
    'Viajes': SolarIconsBold.signpost2,
    'Aerolínea': SolarIconsBold.signpost2,
    'Finanzas': SolarIconsBold.wallet,
    'Servicios Financieros': SolarIconsBold.wallet,
    'Energía': SolarIconsBold.lightbulb,
    'Telecomunicaciones': SolarIconsBold.smartphone,
    'Lácteos': SolarIconsBold.cupHot,
    'Carnes': SolarIconsBold.donutBitten,
    'Botanas': SolarIconsBold.donutBitten,
    'Panadería': SolarIconsBold.donutBitten,
    'Bebidas alcohólicas': SolarIconsBold.bottle,
    'Retail': SolarIconsBold.shop,
  };
}
