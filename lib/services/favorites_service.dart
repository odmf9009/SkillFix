import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService extends ChangeNotifier {
  static const _key = 'favorite_problem_ids';
  final Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_key) ?? [];
    _favoriteIds.clear();
    _favoriteIds.addAll(saved);
    notifyListeners();
  }

  bool isFavorite(String id) => _favoriteIds.contains(id);

  Future<void> toggle(String id) async {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _favoriteIds.toList());
  }
}
