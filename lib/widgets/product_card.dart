import 'package:cached_network_image/cached_network_image.dart';
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
    return Container(
      height: 200.0,
      width: 500.0,
      padding: const EdgeInsets.all(15.0),
      decoration: AppStyles.mexiDecoration,
      child: Row(
        spacing: 15.0,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background2,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Stack(
                children: [
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                            imageUrl: product.imageUrl,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, error, stackTrace) {
                              return Icon(
                                product.categories.isNotEmpty
                                    ? AppIcons.categoryIcons[
                                            product.categories.first] ??
                                        SolarIconsBold.cupHot
                                    : SolarIconsBold.linkBroken,
                                size: 50,
                                color: Colors.grey,
                              );
                            })),
                  )),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: InkWell(
                      onTap: onFavPressed,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Icon(
                          product.isFavorite ?? false
                              ? SolarIconsBold.heart
                              : SolarIconsOutline.heart,
                          color: (product.isFavorite ?? false)
                              ? Colors.red
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  textScaler: TextScaler.linear(0.8),
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: product.name.length > 14 ? 18.0 : 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  product.categories.first,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: AppColors.secondary,
                  ),
                ),
                SizedBox(height: 5.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 1.0),
                  decoration: BoxDecoration(
                    color: product.mexicanidad == "100% Mexicana"
                        ? AppColors.secondary
                        : product.mexicanidad ==
                                "Mexicana con Inversión Extranjera"
                            ? AppColors.yellow
                            : product.mexicanidad == "Negocio local"
                                ? AppColors.primary
                                : product.mexicanidad ==
                                        "Distribuidora mexicana de productos extranjeros"
                                    ? AppColors.orange
                                    : AppColors.gray,
                    borderRadius: BorderRadius.circular(6.0),
                    boxShadow: product.mexicanidad == "100% Mexicana" ||
                            product.mexicanidad == "Negocio local"
                        ? [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 5),
                              blurRadius: 4.0,
                            ),
                          ]
                        : [],
                  ),
                  child: Text(
                    product.mexicanidad,
                    style: TextStyle(
                      fontSize: product.mexicanidad == "100% Mexicana" ||
                              product.mexicanidad == "Negocio local"
                          ? 14.0
                          : 11.0,
                      color: product.mexicanidad == "100% Mexicana" ||
                              product.mexicanidad == "Negocio local"
                          ? AppColors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: onMapPressed,
                        padding: const EdgeInsets.all(0),
                        icon: Container(
                          width: 70,
                          padding: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withAlpha(100),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: const Icon(SolarIconsOutline.mapPoint,
                              color: AppColors.secondary, size: 28),
                        ),
                      ),
                      if (product.website.isNotEmpty)
                        IconButton(
                          onPressed: onWebPressed,
                          padding: const EdgeInsets.all(0),
                          icon: Container(
                            width: 70,
                            padding: const EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(30.0),
                              boxShadow: AppStyles.getShadows,
                            ),
                            child: const Icon(SolarIconsBold.cartLarge,
                                color: AppColors.white, size: 28),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
