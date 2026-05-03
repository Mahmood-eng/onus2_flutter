import 'package:flutter/material.dart';
import 'package:onus2/core/constants/colors.dart';
import 'package:provider/provider.dart';
import '../data/dummy_data.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../core/extensions.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onCartPressed;

  const HomeScreen({super.key, this.onCartPressed});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final List<String> categories;
  String activeCategory = 'All';

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
    final filteredProducts = activeCategory == 'All'
        ? dummyProducts
        : dummyProducts.where((p) => p.category == activeCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Home",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            Text(
              "Discover products you love",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: AppColors.primary),
            onPressed: widget.onCartPressed,
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 18),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) {
                  final isSelected = category == activeCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      onSelected: (_) =>
                          setState(() => activeCategory = category),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (ctx, i) =>
                    ProductGridCard(product: filteredProducts[i]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {},
      ),
    );
  }
}

class ProductGridCard extends StatelessWidget {
  final dynamic product;
  const ProductGridCard({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    final favs = Provider.of<FavoritesProvider>(context);
    final cart = Provider.of<CartProvider>(context, listen: false);
    final isFavorite = favs.favoriteIds.contains(product.id);

    return Container(
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
                  height: 250,
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
                      color: isFavorite ? const Color.fromARGB(255, 255, 153, 0) : Colors.grey,
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
    );
  }
}
