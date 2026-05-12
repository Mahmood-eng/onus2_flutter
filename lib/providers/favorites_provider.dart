import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider with ChangeNotifier {
  static const _favoritesKey = 'favorite_ids';
  final Set<String> _favoriteIds = {};
  final Set<String> _selectedForAction = {};

  FavoritesProvider() {
    _loadFavorites();
  }

  Set<String> get favoriteIds => _favoriteIds;
  Set<String> get selectedForAction => _selectedForAction;

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_favoritesKey) ?? [];
    _favoriteIds.clear();
    _favoriteIds.addAll(ids);
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, _favoriteIds.toList());
  }

  void toggleFavorite(String productId) {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    _saveFavorites();
    notifyListeners();
  }

  void toggleSelection(String productId) {
    if (_selectedForAction.contains(productId)) {
      _selectedForAction.remove(productId);
    } else {
      _selectedForAction.add(productId);
    }
    notifyListeners();
  }

  void removeSelected() {
    _favoriteIds.removeWhere((id) => _selectedForAction.contains(id));
    _selectedForAction.clear();
    _saveFavorites();
    notifyListeners();
  }
}
