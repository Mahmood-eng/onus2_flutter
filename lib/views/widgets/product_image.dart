import 'package:flutter/material.dart';
import 'package:onus2_flutter/core/constants/colors.dart';
import 'package:onus2_flutter/core/extensions.dart';
import 'package:onus2_flutter/providers/favorites_provider.dart';
import 'package:provider/provider.dart';

class ProductImage extends StatelessWidget {
  final dynamic product;

  const ProductImage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final favs = Provider.of<FavoritesProvider>(context);
    final isFavorite = favs.favoriteIds.contains(product.id);

    return Material(
      borderRadius: BorderRadius.circular(24),
      elevation: 10,
      shadowColor: Colors.black12,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 1.08,
              child: Hero(
                tag: product.id,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white70,
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? AppColors.primary : Colors.grey[700],
                  ),
                  onPressed: () {
                    favs.toggleFavorite(product.id);
                    context.showAppSnackBar(
                      isFavorite
                          ? 'Removed ${product.name} from favorites'
                          : 'Added ${product.name} to favorites',
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
