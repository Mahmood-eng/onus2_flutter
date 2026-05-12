import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

class ProductsResponse {
  final List<Product> products;
  final bool isOffline;
  final String? message;

  ProductsResponse({
    required this.products,
    this.isOffline = false,
    this.message,
  });
}

class ProductService {
  static final Map<String, Product> _cache = {};
  static const String _cachePrefix = 'products_';

  static Product? getProductById(String id) {
    return _cache[id];
  }

  static List<Product> getProductsByIds(Set<String> ids) {
    return ids.map(getProductById).whereType<Product>().toList();
  }

  static void _cacheProducts(List<Product> products) {
    for (final product in products) {
      _cache[product.id] = product;
    }
  }

  static Future<List<Product>> loadAllCachedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith(_cachePrefix));
    final List<Product> products = [];

    for (final key in keys) {
      final raw = prefs.getString(key);
      if (raw == null) continue;
      final data = json.decode(raw) as Map<String, dynamic>;
      final productsJson = data['products'] as List<dynamic>?;
      if (productsJson == null) continue;
      products.addAll(
        productsJson
            .map((item) => Product.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    }

    _cacheProducts(products);
    return products;
  }

  static Future<List<Product>> loadProductsByIds(Set<String> ids) async {
    if (ids.isEmpty) return [];

    final directMatches = getProductsByIds(ids);
    if (directMatches.length == ids.length) return directMatches;

    await loadAllCachedProducts();
    final cachedMatches = getProductsByIds(ids);
    if (cachedMatches.length == ids.length) return cachedMatches;

    final allResponse = await fetchProducts('All');
    return allResponse.products
        .where((product) => ids.contains(product.id))
        .toList();
  }

  static Future<ProductsResponse> fetchProducts(String categoryName) async {
    final normalizedCategory = categoryName.trim().toLowerCase();
    final apiUrl = normalizedCategory == 'all'
        ? 'https://dummyjson.com/products?limit=100'
        : 'https://dummyjson.com/products/category/$normalizedCategory';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode != 200) {
        throw Exception('Failed to load products.');
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final productsJson = data['products'] as List<dynamic>;
      final products = productsJson
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();

      _cacheProducts(products);
      await saveToOffline(normalizedCategory, response.body);

      return ProductsResponse(products: products);
    } catch (error) {
      final offlineProducts = await loadFromOffline(normalizedCategory);
      if (offlineProducts.isNotEmpty) {
        return ProductsResponse(
          products: offlineProducts,
          isOffline: true,
          message: 'وضع الأوفلاين',
        );
      }

      final allOfflineProducts = await loadAllCachedProducts();
      final filteredProducts = normalizedCategory == 'all'
          ? allOfflineProducts
          : allOfflineProducts.where((product) {
              final category = product.category.toLowerCase();
              return category == normalizedCategory ||
                  category.contains(normalizedCategory);
            }).toList();

      return ProductsResponse(
        products: filteredProducts,
        isOffline: true,
        message: 'وضع الأوفلاين',
      );
    }
  }

  static Future<void> saveToOffline(String category, String jsonBody) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_cachePrefix${category == 'all' ? 'all' : category}';
    await prefs.setString(key, jsonBody);
  }

  static Future<List<Product>> loadFromOffline(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_cachePrefix${category == 'all' ? 'all' : category}';
    final raw = prefs.getString(key);
    if (raw == null) return [];

    final data = json.decode(raw) as Map<String, dynamic>;
    final productsJson = data['products'] as List<dynamic>?;
    if (productsJson == null) return [];

    final products = productsJson
        .map((json) => Product.fromJson(json as Map<String, dynamic>))
        .toList();
    _cacheProducts(products);
    return products;
  }
}
