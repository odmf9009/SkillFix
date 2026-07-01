import 'package:flutter/material.dart';

class Trade {
  final String id;
  final String nameEs;
  final String nameEn;
  final IconData icon;
  final Color color;
  final String descriptionEs;
  final String descriptionEn;
  final List<String> categories;

  const Trade({
    required this.id,
    required this.nameEs,
    required this.nameEn,
    required this.icon,
    required this.color,
    required this.descriptionEs,
    required this.descriptionEn,
    this.categories = const ['Hogar'],
  });

  String getName(String languageCode) => languageCode == 'en' ? nameEn : nameEs;
  String getDescription(String languageCode) => languageCode == 'en' ? descriptionEn : descriptionEs;

  // Compatibility getters (defaults to Spanish)
  String get name => nameEs;
  String get description => descriptionEs;
}
