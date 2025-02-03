import 'package:flutter/material.dart';
import 'package:mexi_canje/utils/constants.dart';
import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onMapPressed;
  final VoidCallback onWebPressed;
  final VoidCallback onFavPressed;

  const ProductCard({
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
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    isSelected: product.isFavorite,
                    selectedIcon:
                        const Icon(Icons.favorite, color: AppColors.accent),
                    icon: const Icon(Icons.favorite, color: Color(0xFFD5D5D5)),
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
                  icon: const Icon(Icons.map, size: 18, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
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
                  icon:
                      const Icon(Icons.language, size: 18, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
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
