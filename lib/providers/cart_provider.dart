import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data_api/prodcut_service.dart';
import '../models/product_model.dart';

class CartProvider with ChangeNotifier {
  final Map<String, int> _items = {};
  final Set<String> _selectedItems = {};

  Map<String, int> get items => _items;
  Set<String> get selectedItems => _selectedItems;

  CartProvider() {
    _loadCartFromPrefs();
  }

  Future<void> _saveCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cart_data', jsonEncode(_items));
  }

  Future<void> _loadCartFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('cart_data');
    if (savedData != null) {
      final Map<String, dynamic> decoded = jsonDecode(savedData);
      decoded.forEach((key, value) => _items[key] = value as int);
      notifyListeners();
    }
  }

  void addToCart(String productId) {
    if (_items.containsKey(productId)) {
      _items[productId] = _items[productId]! + 1;
    } else {
      _items[productId] = 1;
    }
    _saveCartToPrefs();
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
      _saveCartToPrefs();
      notifyListeners();
    }
  }

  void removeFromCart(String productId) {
    _items.remove(productId);
    _selectedItems.remove(productId);
    _saveCartToPrefs();
    notifyListeners();
  }

  double calculateSubtotal(List<Product> loadedProducts) {
    double total = 0.0;
    for (var product in loadedProducts) {
      if (_items.containsKey(product.id)) {
        total += product.price * _items[product.id]!;
      }
    }
    return total;
  }
}
