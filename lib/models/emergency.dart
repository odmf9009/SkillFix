import 'package:flutter/material.dart';

enum DangerLevel {
  medium,
  high,
  critical,
}

class EmergencyItem {
  final String id;
  
  final String titleEs;
  final String titleEn;
  
  final String relatedTradeEs;
  final String relatedTradeEn;

  final DangerLevel dangerLevel;
  
  final String shortDescriptionEs;
  final String shortDescriptionEn;
  
  final List<String> doFirstStepsEs;
  final List<String> doFirstStepsEn;
  
  final List<String> doNotStepsEs;
  final List<String> doNotStepsEn;
  
  final List<String> call911ConditionsEs;
  final List<String> call911ConditionsEn;
  
  final List<String> callTechnicianConditionsEs;
  final List<String> callTechnicianConditionsEn;
  
  final String? relatedGuideId;
  final String? relatedGuideTitleEs;
  final String? relatedGuideTitleEn;
  
  final String safetyMessageEs;
  final String safetyMessageEn;
  
  final IconData icon;

  const EmergencyItem({
    required this.id,
    required this.titleEs,
    required this.titleEn,
    required this.relatedTradeEs,
    required this.relatedTradeEn,
    required this.dangerLevel,
    required this.shortDescriptionEs,
    required this.shortDescriptionEn,
    required this.doFirstStepsEs,
    required this.doFirstStepsEn,
    required this.doNotStepsEs,
    required this.doNotStepsEn,
    required this.call911ConditionsEs,
    required this.call911ConditionsEn,
    required this.callTechnicianConditionsEs,
    required this.callTechnicianConditionsEn,
    this.relatedGuideId,
    this.relatedGuideTitleEs,
    this.relatedGuideTitleEn,
    required this.safetyMessageEs,
    required this.safetyMessageEn,
    required this.icon,
  });

  String getTitle(String lang) => lang == 'en' ? titleEn : titleEs;
  String getRelatedTrade(String lang) => lang == 'en' ? relatedTradeEn : relatedTradeEs;
  String getShortDescription(String lang) => lang == 'en' ? shortDescriptionEn : shortDescriptionEs;
  List<String> getDoFirstSteps(String lang) => lang == 'en' ? doFirstStepsEn : doFirstStepsEs;
  List<String> getDoNotSteps(String lang) => lang == 'en' ? doNotStepsEn : doNotStepsEs;
  List<String> getCall911Conditions(String lang) => lang == 'en' ? call911ConditionsEn : call911ConditionsEs;
  List<String> getCallTechnicianConditions(String lang) => lang == 'en' ? callTechnicianConditionsEn : callTechnicianConditionsEs;
  String? getRelatedGuideTitle(String lang) => lang == 'en' ? relatedGuideTitleEn : relatedGuideTitleEs;
  String getSafetyMessage(String lang) => lang == 'en' ? safetyMessageEn : safetyMessageEs;

  Color get color => switch (dangerLevel) {
        DangerLevel.medium => const Color(0xFFFBC02D), // Amber
        DangerLevel.high => const Color(0xFFE64A19), // Deep Orange
        DangerLevel.critical => const Color(0xFFD32F2F), // Red
      };

  String getDangerLabel(String lang) {
    if (lang == 'en') {
      return switch (dangerLevel) {
        DangerLevel.medium => 'Medium Danger',
        DangerLevel.high => 'High Danger',
        DangerLevel.critical => 'Critical Danger',
      };
    }
    return switch (dangerLevel) {
      DangerLevel.medium => 'Peligro Medio',
      DangerLevel.high => 'Peligro Alto',
      DangerLevel.critical => 'Peligro Crítico',
    };
  }
}
