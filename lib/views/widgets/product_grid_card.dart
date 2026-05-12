import 'package:flutter/material.dart';
import 'package:onus2_flutter/core/constants/colors.dart';
import 'package:onus2_flutter/core/extensions.dart';
import 'package:onus2_flutter/models/product_model.dart';
import 'package:onus2_flutter/providers/cart_provider.dart';
import 'package:onus2_flutter/providers/favorites_provider.dart';
import 'package:onus2_flutter/views/product_details_screen.dart';
import 'package:provider/provider.dart';

class ProductGridCard extends StatelessWidget {
  final dynamic product;

  const ProductGridCard(List<Product> list, {super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final favs = Provider.of<FavoritesProvider>(context);
    final cart = Provider.of<CartProvider>(context, listen: false);
    final isFavorite = favs.favoriteIds.contains(product.id);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(product: product),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    product.imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      favs.toggleFavorite(product.id);
                      context.showAppSnackBar(
                        isFavorite
                            ? 'Removed ${product.name} from favorites'
                            : 'Added ${product.name} to favorites',
                      );
                    },
                    onLongPress: () {
                      favs.toggleFavorite(product.id);
                      context.showAppSnackBar(
                        isFavorite
                            ? 'Removed ${product.name} from favorites'
                            : 'Added ${product.name} to favorites',
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white70,
                      radius: 15,
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite
                            ? const Color.fromARGB(255, 255, 153, 0)
                            : Colors.grey,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${product.price}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          cart.addToCart(product.id);
                          context.showAppSnackBar(
                            'Added ${product.name} to cart',
                          );
                        },
                        onLongPress: () {
                          cart.addToCart(product.id);
                          context.showAppSnackBar(
                            'Added ${product.name} to cart',
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            Icons.add_shopping_cart,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
