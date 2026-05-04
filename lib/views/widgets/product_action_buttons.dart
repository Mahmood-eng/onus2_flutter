import 'package:flutter/material.dart';
import 'package:onus2_flutter/core/constants/colors.dart';
import 'package:onus2_flutter/core/extensions.dart';
import 'package:onus2_flutter/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class ProductActionButtons extends StatelessWidget {
  final dynamic product;

  const ProductActionButtons({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          icon: Icon(Icons.add_shopping_cart_outlined,color: Colors.white,),
          label: Text('Add to Cart', style: TextStyle(color: Colors.white)),
          onPressed: () {
            cart.addToCart(product.id);
            context.showAppSnackBar('Added ${product.name} to cart');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {
            cart.addToCart(product.id);
            context.showAppSnackBar('Ready to buy ${product.name}');
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.primary),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(
            'Buy Now',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
