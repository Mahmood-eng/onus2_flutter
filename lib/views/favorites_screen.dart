import 'package:flutter/material.dart';
import 'package:onus2/views/cart_screen.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../data/dummy_data.dart';
import '../core/constants/colors.dart';
import '../core/extensions.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoritesProvider>(context);
    final favList = dummyProducts
        .where((p) => favProvider.favoriteIds.contains(p.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorites\n${favList.length} Items",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: AppColors.primary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CartScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: favList.length,
              itemBuilder: (ctx, i) {
                final product = favList[i];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  shadowColor: Colors.black12,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12),
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: favProvider.selectedForAction.contains(
                            product.id,
                          ),
                          onChanged: (_) =>
                              favProvider.toggleSelection(product.id),
                          activeColor: AppColors.primary,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    title: Text(
                      product.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      product.category,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            favProvider.toggleFavorite(product.id);
                            context.showAppSnackBar(
                              'Removed ${product.name} from favorites',
                            );
                          },
                          child: Icon(
                            Icons.favorite,
                            color: AppColors.primary,
                            size: 28,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "\$${product.price}",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (favProvider.selectedForAction.isNotEmpty)
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${favProvider.selectedForAction.length} items selected",
                  ),
                  TextButton.icon(
                    onPressed: () {
                      favProvider.removeSelected();
                      context.showAppSnackBar(
                        'Removed selected items from favorites',
                      );
                    },
                    icon: Icon(Icons.delete, color: Colors.red),
                    label: Text(
                      "Remove from Favorites",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
