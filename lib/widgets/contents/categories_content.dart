import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mexi_canje/utils/constants.dart'; // Assuming AppStyles is defined here
import 'package:smooth_corner/smooth_corner.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:shimmer/shimmer.dart';

class CategoryImageContainer extends StatelessWidget {
  final String? imageUrl;
  final String? categoryName;
  final int? categoryindex;
  final Function(bool, int) onCategorySelected;

  const CategoryImageContainer({
    super.key,
    this.imageUrl,
    this.categoryName,
    required this.onCategorySelected,
    this.categoryindex,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onCategorySelected(true, categoryindex!);
      },
      child: Container(
        height: 500,
        clipBehavior: Clip.hardEdge,
        decoration: ShapeDecoration(
          shadows: AppStyles.getShadows,
          shape: SmoothRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            smoothness: 0.6,
          ),
        ),
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                fit: BoxFit.fill,
                errorWidget: (context, error, stackTrace) {
                  return Center(
                    child: Text(categoryName!),
                  );
                },
                progressIndicatorBuilder: (context, url, downloadProgress) {
                  return Stack(
                    // Overlay shimmer effect while loading
                    fit: StackFit.expand,
                    children: [
                      _buildShimmerPlaceholder(),
                    ],
                  );
                },
                imageUrl: imageUrl!,
              )
            : Center(
                child: Icon(SolarIconsOutline.linkBroken, color: Colors.grey)),
      ),
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        color: Colors.grey[300], // Solid color for shimmer base
      ),
    );
  }
}

class CategoriesContent extends StatelessWidget {
  final List<Map<String, String>> categories;
  final Function(bool, int) onCategorySelected;

  const CategoriesContent({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const Center(child: Text("No categories available."));
    }

    return GridView.count(
      childAspectRatio: 0.65,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      children: List.generate(
        categories.length,
        (index) {
          final category = categories[index];
          final imageUrl = category["url_imagen_categoria"];
          final categoryName = category["nombre_categoria"];

          return CategoryImageContainer(
            imageUrl: imageUrl,
            categoryName: categoryName,
            onCategorySelected: onCategorySelected,
            categoryindex: index,
          );
        },
      ),
    );
  }
}
