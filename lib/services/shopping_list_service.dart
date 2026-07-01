import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/shopping_list.dart';

class ShoppingListService extends ChangeNotifier {
  static const _key = 'user_shopping_lists';
  List<ShoppingList> _lists = [];

  List<ShoppingList> get lists => List.unmodifiable(_lists);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_key);
    if (data != null) {
      final List<dynamic> decoded = json.decode(data);
      _lists = decoded.map((item) => ShoppingList.fromMap(item)).toList();
      notifyListeners();
    }
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(_lists.map((l) => l.toMap()).toList());
    await prefs.setString(_key, encoded);
  }

  ShoppingList? getListForGuide(String guideId) {
    try {
      return _lists.firstWhere((l) => l.guideId == guideId);
    } catch (_) {
      return null;
    }
  }

  Future<void> addList(ShoppingList list) async {
    // Evitar duplicados por guideId
    _lists.removeWhere((l) => l.guideId == list.guideId);
    _lists.insert(0, list);
    await save();
    notifyListeners();
  }

  Future<void> removeList(String id) async {
    _lists.removeWhere((l) => l.id == id);
    await save();
    notifyListeners();
  }

  Future<void> toggleItemStatus(String listId, String itemId) async {
    final listIndex = _lists.indexWhere((l) => l.id == listId);
    if (listIndex != -1) {
      final itemIndex = _lists[listIndex].items.indexWhere((i) => i.id == itemId);
      if (itemIndex != -1) {
        _lists[listIndex].items[itemIndex].isBought = !_lists[listIndex].items[itemIndex].isBought;
        await save();
        notifyListeners();
      }
    }
  }

  Future<void> addItemToList(String listId, ShoppingItem item) async {
    final index = _lists.indexWhere((l) => l.id == listId);
    if (index != -1) {
      _lists[index].items.add(item);
      await save();
      notifyListeners();
    }
  }

  Future<void> removeItemFromList(String listId, String itemId) async {
    final index = _lists.indexWhere((l) => l.id == listId);
    if (index != -1) {
      _lists[index].items.removeWhere((i) => i.id == itemId);
      await save();
      notifyListeners();
    }
  }
}
