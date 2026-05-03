import 'package:flutter/material.dart';

class FavoritesProvider with ChangeNotifier {
  final Set<String> _favoriteIds = {};
  final Set<String> _selectedForAction = {};

  Set<String> get favoriteIds => _favoriteIds;
  Set<String> get selectedForAction => _selectedForAction;

  void toggleFavorite(String productId) {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
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
    notifyListeners();
  }
}