import 'package:flutter/material.dart';
import 'package:onus2_flutter/data_api/prodcut_service.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

import '../models/product_model.dart';
import '../core/constants/colors.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  static String id = "cart";

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _hasSelectedOnOpen = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final cartIds = cart.items.keys.toList();

    if (!_hasSelectedOnOpen && cart.items.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        cart.selectAll();
      });
      _hasSelectedOnOpen = true;
    }

    if (cart.items.isEmpty) {
      _hasSelectedOnOpen = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: cartIds.isEmpty
          ? Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : FutureBuilder<List<Product>>(
              future: ProductService.loadProductsByIds(cartIds),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final products = snapshot.data ?? [];
                final subtotal = cart.calculateSubtotal(products);

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (ctx, i) {
                          final product = products[i];
                          return Card(
                            margin: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 6,
                            shadowColor: Colors.black26,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: cart.selectedItems.contains(
                                      product.id,
                                    ),
                                    onChanged: (_) =>
                                        cart.toggleSelection(product.id),
                                    activeColor: AppColors.primary,
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      product.imageUrl,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "\$${product.price}",
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            _qtyBtn(
                                              Icons.remove,
                                              () => cart.updateQuantity(
                                                product.id,
                                                -1,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12,
                                              ),
                                              child: Text(
                                                "${cart.items[product.id]}",
                                              ),
                                            ),
                                            _qtyBtn(
                                              Icons.add,
                                              () => cart.updateQuantity(
                                                product.id,
                                                1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                    onPressed: () =>
                                        cart.removeFromCart(product.id),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          _rowText(
                            "Subtotal",
                            "\$${subtotal.toStringAsFixed(2)}",
                          ),
                          _rowText("Shipping", "FREE", isFree: true),
                          Divider(),
                          _rowText(
                            "Total",
                            "\$${subtotal.toStringAsFixed(2)}",
                            isTotal: true,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Checkout (\$${subtotal.toStringAsFixed(2)}) →",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback tap) => GestureDetector(
    onTap: tap,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(icon, size: 20, color: AppColors.primary),
    ),
  );

  Widget _rowText(
    String title,
    String val, {
    bool isFree = false,
    bool isTotal = false,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          val,
          style: TextStyle(
            color: isFree ? Colors.orange : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: isTotal ? 18 : 14,
          ),
        ),
      ],
    ),
  );
}
