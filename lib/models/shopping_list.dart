import 'dart:convert';

enum ItemCategory { tool, material }

class ShoppingItem {
  final String id;
  String name;
  bool isBought;
  ItemCategory category;
  int quantity;
  String notes;
  
  // Campos preparados para futura monetización
  String? productUrl;
  String? affiliateUrl;
  String? storeName;
  double? estimatedPrice;
  String? imageUrl;

  ShoppingItem({
    required this.id,
    required this.name,
    this.isBought = false,
    required this.category,
    this.quantity = 1,
    this.notes = '',
    this.productUrl,
    this.affiliateUrl,
    this.storeName,
    this.estimatedPrice,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isBought': isBought,
      'category': category.index,
      'quantity': quantity,
      'notes': notes,
      'productUrl': productUrl,
      'affiliateUrl': affiliateUrl,
      'storeName': storeName,
      'estimatedPrice': estimatedPrice,
      'imageUrl': imageUrl,
    };
  }

  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      id: map['id'],
      name: map['name'],
      isBought: map['isBought'] ?? false,
      category: ItemCategory.values[map['category'] ?? 0],
      quantity: map['quantity'] ?? 1,
      notes: map['notes'] ?? '',
      productUrl: map['productUrl'],
      affiliateUrl: map['affiliateUrl'],
      storeName: map['storeName'],
      estimatedPrice: map['estimatedPrice'],
      imageUrl: map['imageUrl'],
    );
  }
}

class ShoppingList {
  final String id;
  final String guideId;
  final String guideTitle;
  final String tradeId;
  final DateTime createdAt;
  List<ShoppingItem> items;

  ShoppingList({
    required this.id,
    required this.guideId,
    required this.guideTitle,
    required this.tradeId,
    required this.createdAt,
    required this.items,
  });

  int get totalItems => items.length;
  int get boughtItems => items.where((i) => i.isBought).length;
  double get progress => totalItems == 0 ? 0 : boughtItems / totalItems;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'guideId': guideId,
      'guideTitle': guideTitle,
      'tradeId': tradeId,
      'createdAt': createdAt.toIso8601String(),
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  factory ShoppingList.fromMap(Map<String, dynamic> map) {
    return ShoppingList(
      id: map['id'],
      guideId: map['guideId'],
      guideTitle: map['guideTitle'],
      tradeId: map['tradeId'],
      createdAt: DateTime.parse(map['createdAt']),
      items: List<ShoppingItem>.from(
        (map['items'] as List).map((x) => ShoppingItem.fromMap(x)),
      ),
    );
  }

  String toJson() => json.encode(toMap());
}
