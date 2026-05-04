import 'package:flutter/material.dart';
import 'package:onus2_flutter/core/constants/colors.dart';

class ProductDetailsSection extends StatelessWidget {
  final dynamic product;

  const ProductDetailsSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final description = product.description.isNotEmpty
        ? product.description
        : 'Experience premium ${product.category.toLowerCase()} performance with the ${product.name}. Designed for modern users, it delivers reliable quality, clear styling, and a seamless fit in your daily workflow.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textMain,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: TextStyle(
            fontSize: 15,
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 22),
        Text(
          'Why you will love it',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textMain,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildFeatureChip('Premium comfort'),
            _buildFeatureChip('Award-winning design'),
            _buildFeatureChip('Trusted quality'),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureChip(String title) {
    return Chip(
      label: Text(title),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
