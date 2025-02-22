// widgets/category_filter.dart
import 'package:flutter/material.dart';
import 'package:mexi_canje/utils/constants.dart';

class CategoryFilter extends StatefulWidget {
  final List<String> categories;
  final Function(bool, int) onCategorySelected;
  final String selectedCategory;

  const CategoryFilter({
    super.key,
    required this.categories,
    required this.onCategorySelected,
    required this.selectedCategory,
  });

  @override
  CategoryFilterState createState() => CategoryFilterState();
}

class CategoryFilterState extends State<CategoryFilter> {
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = 0;

  // Define a fixed width for all chips
  final double _chipWidth = 80.0; // Adjust this value as needed

  @override
  void initState() {
    super.initState();
    _updateSelectedIndex();
    WidgetsBinding.instance.addPostFrameCallback(_scrollToSelected);
  }

  @override
  void didUpdateWidget(covariant CategoryFilter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCategory != widget.selectedCategory) {
      _updateSelectedIndex();
      WidgetsBinding.instance.addPostFrameCallback(_scrollToSelected);
    }
  }

  void _updateSelectedIndex() {
    _selectedIndex = widget.categories.indexOf(widget.selectedCategory);
    if (_selectedIndex == -1) {
      _selectedIndex = 0;
    }
  }

  Future<void> _scrollToSelected(Duration timeStamp) async {
    if (_scrollController.hasClients) {
      final index = _selectedIndex;
      if (index >= 0 && index < widget.categories.length) {
        // Use the fixed chip width for scrolling calculation
        final scrollPosition = index * (_chipWidth + 26);
        _scrollController.animateTo(
          scrollPosition,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              backgroundColor: AppColors.background,
              elevation: 10.0,
              // Set fixed width using label padding and SizedBox in label
              labelPadding: EdgeInsets.zero, // Remove default padding
              label: SizedBox(
                height: 20,
                width: _selectedIndex == index
                    ? category.length * 8.0 + 10.0
                    : _chipWidth, // Fixed width for the chip label
                child: Align(
                  alignment: Alignment.center, // Center text within fixed width
                  child: Text(
                    category,
                    textAlign: TextAlign.center, // Center text alignment
                    overflow: TextOverflow
                        .ellipsis, // Handle overflow if text is too long
                    maxLines: 1,
                    style: TextStyle(
                      color: _selectedIndex == index
                          ? AppColors.white
                          : AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              selected: _selectedIndex == index,
              selectedColor: AppColors.primary,
              showCheckmark: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              side: const BorderSide(color: Colors.transparent),
              onSelected: (isSelected) {
                setState(() {
                  _selectedIndex = index;
                });
                widget.onCategorySelected(isSelected, index);
                WidgetsBinding.instance.addPostFrameCallback(_scrollToSelected);
              },
            ),
          );
        },
      ),
    );
  }
}
