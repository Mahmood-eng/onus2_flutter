import 'package:flutter/material.dart';
import 'package:onus2_flutter/core/constants/colors.dart';
import '../data/dummy_data.dart';
import 'category_products_screen.dart';
import 'widgets/category_grid.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late final List<String> categories;
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    categories = [
      'All',
      ...{for (var product in dummyProducts) product.category},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Categories',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Browse by section',
              style: TextStyle(color: Colors.grey[700], fontSize: 16),
            ),
            SizedBox(height: 14),
            CategoryGrid(
              categories: categories,
              selectedCategory: selectedCategory,
              onCategorySelected: (category) {
                setState(() => selectedCategory = category);
                final products = category == 'All'
                    ? dummyProducts
                    : dummyProducts
                          .where((p) => p.category == category)
                          .toList();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryProductsScreen(
                      category: category,
                      products: products,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
