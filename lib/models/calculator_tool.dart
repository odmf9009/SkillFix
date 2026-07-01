import 'package:flutter/material.dart';

enum CalculatorFieldType { number, dropdown, toggle }

class CalculatorField {
  final String key;
  final String labelEs;
  final String labelEn;
  final String? unitEs;
  final String? unitEn;
  final CalculatorFieldType type;
  final List<String>? optionsEs; // For dropdown
  final List<String>? optionsEn; // For dropdown
  final double defaultValue;

  const CalculatorField({
    required this.key,
    required this.labelEs,
    required this.labelEn,
    this.unitEs,
    this.unitEn,
    this.type = CalculatorFieldType.number,
    this.optionsEs,
    this.optionsEn,
    this.defaultValue = 0,
  });

  String getLabel(String lang) {
    if (lang == 'en') return labelEn.isNotEmpty ? labelEn : labelEs;
    return labelEs.isNotEmpty ? labelEs : labelEn;
  }

  String? getUnit(String lang) {
    if (lang == 'en') return (unitEn != null && unitEn!.isNotEmpty) ? unitEn : unitEs;
    return (unitEs != null && unitEs!.isNotEmpty) ? unitEs : unitEn;
  }

  List<String>? getOptions(String lang) {
    if (lang == 'en') return (optionsEn != null && optionsEn!.isNotEmpty) ? optionsEn : optionsEs;
    return (optionsEs != null && optionsEs!.isNotEmpty) ? optionsEs : optionsEn;
  }
}

class CalculatorTool {
  final String id;
  final String titleEs;
  final String titleEn;
  final String tradeId;
  final String categoryEs;
  final String categoryEn;
  final String descriptionEs;
  final String descriptionEn;
  final IconData icon;
  final List<CalculatorField> fields;
  final String? relatedGuideId;
  final String? relatedGuideTitleEs;
  final String? relatedGuideTitleEn;
  final String? disclaimerEs;
  final String? disclaimerEn;
  final Map<String, double> Function(Map<String, double> inputs) calculate;
  final String resultTemplateEs;
  final String resultTemplateEn;
  final String? resultExplanationEs;
  final String? resultExplanationEn;
  final List<String> shoppingItemsEs;
  final List<String> shoppingItemsEn;
  final bool hasReminder;

  const CalculatorTool({
    required this.id,
    required this.titleEs,
    required this.titleEn,
    required this.tradeId,
    required this.categoryEs,
    required this.categoryEn,
    required this.descriptionEs,
    required this.descriptionEn,
    required this.icon,
    required this.fields,
    this.relatedGuideId,
    this.relatedGuideTitleEs,
    this.relatedGuideTitleEn,
    this.disclaimerEs,
    this.disclaimerEn,
    required this.calculate,
    required this.resultTemplateEs,
    required this.resultTemplateEn,
    this.resultExplanationEs,
    this.resultExplanationEn,
    this.shoppingItemsEs = const [],
    this.shoppingItemsEn = const [],
    this.hasReminder = false,
  });

  String getTitle(String lang) {
    if (lang == 'en') return titleEn.isNotEmpty ? titleEn : titleEs;
    return titleEs.isNotEmpty ? titleEs : titleEn;
  }

  String getCategory(String lang) {
    if (lang == 'en') return categoryEn.isNotEmpty ? categoryEn : categoryEs;
    return categoryEs.isNotEmpty ? categoryEs : categoryEn;
  }

  String getDescription(String lang) {
    if (lang == 'en') return descriptionEn.isNotEmpty ? descriptionEn : descriptionEs;
    return descriptionEs.isNotEmpty ? descriptionEs : descriptionEn;
  }

  String? getRelatedGuideTitle(String lang) {
    if (lang == 'en') return (relatedGuideTitleEn != null && relatedGuideTitleEn!.isNotEmpty) ? relatedGuideTitleEn : relatedGuideTitleEs;
    return (relatedGuideTitleEs != null && relatedGuideTitleEs!.isNotEmpty) ? relatedGuideTitleEs : relatedGuideTitleEn;
  }

  String? getDisclaimer(String lang) {
    if (lang == 'en') return (disclaimerEn != null && disclaimerEn!.isNotEmpty) ? disclaimerEn : disclaimerEs;
    return (disclaimerEs != null && disclaimerEs!.isNotEmpty) ? disclaimerEs : disclaimerEn;
  }

  String getResultTemplate(String lang) {
    if (lang == 'en') return resultTemplateEn.isNotEmpty ? resultTemplateEn : resultTemplateEs;
    return resultTemplateEs.isNotEmpty ? resultTemplateEs : resultTemplateEn;
  }

  String? getResultExplanation(String lang) {
    if (lang == 'en') return (resultExplanationEn != null && resultExplanationEn!.isNotEmpty) ? resultExplanationEn : resultExplanationEs;
    return (resultExplanationEs != null && resultExplanationEs!.isNotEmpty) ? resultExplanationEs : resultExplanationEn;
  }

  List<String> getShoppingItems(String lang) {
    if (lang == 'en') return shoppingItemsEn.isNotEmpty ? shoppingItemsEn : shoppingItemsEs;
    return shoppingItemsEs.isNotEmpty ? shoppingItemsEs : shoppingItemsEn;
  }
}
