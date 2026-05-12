import 'package:flutter/material.dart';
import 'package:onus2_flutter/core/constants/colors.dart';
import 'package:onus2_flutter/data_api/prodcut_service.dart';
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
        child: FutureBuilder<ProductsResponse>(
          future: ProductService.fetchProducts(category),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error loading products'));
            }

            final response = snapshot.data;
            if (response == null || response.products.isEmpty) {
              return Center(child: Text('No products found'));
            }

            return Column(
              children: [
                if (response.isOffline)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      response.message ?? 'وضع الأوفلاين',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.orange[900],
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                SizedBox(height: response.isOffline ? 12 : 0),
                Expanded(
                  child: CategoryProductsGrid(products: response.products),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
