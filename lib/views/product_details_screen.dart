import 'package:flutter/material.dart';
import 'package:onus2_flutter/core/constants/colors.dart';
import 'package:onus2_flutter/models/product_model.dart';
import 'widgets/product_details_header.dart';
import 'widgets/product_image.dart';
import 'widgets/product_info.dart';
import 'widgets/product_details_section.dart';
import 'widgets/product_action_buttons.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const ProductDetailsHeader(),
                    const SizedBox(height: 12),
                    ProductImage(product: product),
                    const SizedBox(height: 30),
                    ProductInfo(product: product),
                    const SizedBox(height: 24),
                    ProductDetailsSection(product: product),
                    const SizedBox(height: 22),
                    ProductActionButtons(product: product),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
