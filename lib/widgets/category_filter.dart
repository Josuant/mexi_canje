import 'package:flutter/material.dart';
import 'package:mexi_canje/utils/constants.dart';

class CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final Function(bool, int) onCategorySelected;
  final String selectedCategory;

  const CategoryFilter(
      {super.key,
      required this.categories,
      required this.onCategorySelected,
      required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
                label: Text(categories[index]),
                selected: selectedCategory == categories[index],
                selectedColor: AppColors.primary,
                showCheckmark: false,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                side: BorderSide(color: Colors.transparent),
                labelStyle: TextStyle(
                  color: selectedCategory == categories[index]
                      ? AppColors.white
                      : AppColors.gray,
                ),
                onSelected: (isSelected) =>
                    onCategorySelected(isSelected, index)),
          );
        },
      ),
    );
  }
}
