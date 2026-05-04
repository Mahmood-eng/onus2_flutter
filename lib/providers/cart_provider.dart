import 'package:flutter/material.dart';
import 'package:onus2_flutter/data/dummy_data.dart';

class CartProvider with ChangeNotifier {
  final Map<String, int> _items = {}; // ProductID : Quantity
  final Set<String> _selectedItems = {}; // IDs for selected items in cart UI

  Map<String, int> get items => _items;
  Set<String> get selectedItems => _selectedItems;

  void addToCart(String productId) {
    if (_items.containsKey(productId)) {
      _items[productId] = _items[productId]! + 1;
    } else {
      _items[productId] = 1;
    }
    notifyListeners();
  }

  void toggleSelection(String productId) {
    if (_selectedItems.contains(productId)) {
      _selectedItems.remove(productId);
    } else {
      _selectedItems.add(productId);
    }
    notifyListeners();
  }

  void selectAll() {
    _selectedItems
      ..clear()
      ..addAll(_items.keys);
    notifyListeners();
  }

  void updateQuantity(String productId, int delta) {
    if (_items.containsKey(productId)) {
      _items[productId] = (_items[productId]! + delta).clamp(1, 99);
      notifyListeners();
    }
  }

  void removeFromCart(String productId) {
    _items.remove(productId);
    _selectedItems.remove(productId);
    notifyListeners();
  }

  double get subtotal {
    return _items.entries.where((e) => _selectedItems.contains(e.key)).fold(0, (
      sum,
      entry,
    ) {
      final product = dummyProducts.firstWhere((p) => p.id == entry.key);
      return sum + (product.price * entry.value);
    });
  }
}
