import 'package:flutter/material.dart';
import 'package:onus2_flutter/core/constants/colors.dart';
import 'package:onus2_flutter/data_api/prodcut_service.dart';
import 'package:onus2_flutter/models/product_model.dart';
import 'package:onus2_flutter/views/widgets/category_products_grid.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String category;

  const CategoryProductsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          category,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: StreamBuilder<List<Product>>(
          stream: ProductService.getProductsStream(category),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('حدث خطأ في تحميل المنتجات'));
            }

            final products = snapshot.data;
            if (products == null || products.isEmpty) {
              return Center(child: Text('No products found'));
            }

            return CategoryProductsGrid(products: products);
          },
        ),
      ),
    );
  }
}
