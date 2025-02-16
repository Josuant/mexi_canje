import 'package:flutter/material.dart';
import 'package:mexi_canje/utils/constants.dart'; // Assuming AppStyles is defined here
import 'package:mexi_canje/widgets/contents/mexi_content.dart';
import 'package:smooth_corner/smooth_corner.dart';

// --- Reusable CategoryImageContainer Widget ---
class CategoryImageContainer extends StatelessWidget {
  final String? imageUrl; // Image URL can be null if data is missing
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
        ), // Use your AppStyles decoration
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                fit: BoxFit.fill,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  print(
                      'Error loading image from URL: $imageUrl - Error: $error');
                  return Center(
                    child: Text(categoryName!), // Show error icon
                  );
                },
              )
            : const Center(
                child: Icon(Icons.image_not_supported_outlined,
                    color: Colors.grey)), // Placeholder if no URL
      ),
    );
  }
}

// --- Reusable CategoryGrid Widget ---
class CategoryGrid extends StatelessWidget {
  final List<Map<String, String>> categories;
  final Function(bool, int) onCategorySelected;

  const CategoryGrid({
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
      physics:
          const NeverScrollableScrollPhysics(), // Disable GridView's scrolling
      shrinkWrap: true, // Make GridView take only necessary space
      crossAxisCount: 3,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      children: List.generate(
        categories.length,
        (index) {
          final category = categories[index];
          final imageUrl = category["url_imagen_categoria"];
          final categoryName = category[
              "nombre_categoria"]; // Assuming you might want to use category name later

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

// --- Modified CategoriesContent Widget ---
class CategoriesContent extends MexiContent {
  final List<Map<String, String>> categories;
  final Function(bool, int) onCategorySelected;

  const CategoriesContent({
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  List<Widget> getContents(BuildContext context) {
    if (categories.isNotEmpty) {
      return [
        CategoryGrid(
          categories: categories,
          onCategorySelected: onCategorySelected,
        ),
      ];
    }
    return [];
  }
}
