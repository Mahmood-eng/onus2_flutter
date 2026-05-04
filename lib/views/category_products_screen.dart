import 'package:flutter/material.dart';
import 'package:onus2_flutter/core/constants/colors.dart';
import 'package:onus2_flutter/views/widgets/category_products_grid.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String category;
  final List<dynamic> products;

  const CategoryProductsScreen({
    super.key,
    required this.category,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            Text(
              '${products.length} products',
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: CategoryProductsGrid(products: products),
      ),
    );
  }
}
