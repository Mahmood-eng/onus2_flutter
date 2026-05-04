import 'package:flutter/material.dart';
import 'package:onus2_flutter/core/constants/colors.dart';

class CategoryGrid extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryGrid({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'All':
        return Icons.category;
      case 'Laptops':
        return Icons.laptop;
      case 'Keyboards':
        return Icons.keyboard;
      case 'Mice':
        return Icons.mouse;
      case 'Tablets':
        return Icons.tablet;
      case 'Headphones':
        return Icons.headphones;
      case 'Monitors':
        return Icons.monitor;
      case 'Audio':
        return Icons.speaker;
      case 'Wearables':
        return Icons.watch;
      case 'Accessories':
        return Icons.devices_other;
      case 'Furniture':
        return Icons.chair;
      case 'Networking':
        return Icons.router;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = category == selectedCategory;
        return GestureDetector(
          onTap: () => onCategorySelected(category),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getCategoryIcon(category),
                  color: isSelected ? Colors.white : AppColors.primary,
                  size: 26,
                ),
                const SizedBox(height: 8),
                Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
