import 'package:flutter/material.dart';
import '../models/home_problem.dart';

class DiagnosticAnswer {
  final String id;
  final String textEs;
  final String textEn;
  final String? nextQuestionId;
  final String? resultId;
  final RiskLevel? riskModifier;

  const DiagnosticAnswer({
    required this.id,
    required this.textEs,
    required this.textEn,
    this.nextQuestionId,
    this.resultId,
    this.riskModifier,
  });

  String getText(String lang) {
    if (lang == 'en') return textEn.isNotEmpty ? textEn : textEs;
    return textEs.isNotEmpty ? textEs : textEn;
  }
}

class DiagnosticQuestion {
  final String id;
  final String questionTextEs;
  final String questionTextEn;
  final List<DiagnosticAnswer> answers;

  const DiagnosticQuestion({
    required this.id,
    required this.questionTextEs,
    required this.questionTextEn,
    required this.answers,
  });

  String getQuestionText(String lang) {
    if (lang == 'en') return questionTextEn.isNotEmpty ? questionTextEn : questionTextEs;
    return questionTextEs.isNotEmpty ? questionTextEs : questionTextEn;
  }
}

class DiagnosticResult {
  final String id;
  final String titleEs;
  final String titleEn;
  final String possibleCauseEs;
  final String possibleCauseEn;
  final RiskLevel riskLevel;
  final List<String> firstThingsToCheckEs;
  final List<String> firstThingsToCheckEn;
  final String? recommendedGuideId;
  final String? recommendedGuideTitleEs;
  final String? recommendedGuideTitleEn;
  final String safetyMessageEs;
  final String safetyMessageEn;
  final bool shouldCallTechnician;

  const DiagnosticResult({
    required this.id,
    required this.titleEs,
    required this.titleEn,
    required this.possibleCauseEs,
    required this.possibleCauseEn,
    required this.riskLevel,
    required this.firstThingsToCheckEs,
    required this.firstThingsToCheckEn,
    this.recommendedGuideId,
    this.recommendedGuideTitleEs,
    this.recommendedGuideTitleEn,
    required this.safetyMessageEs,
    required this.safetyMessageEn,
    this.shouldCallTechnician = false,
  });

  String getTitle(String lang) {
    if (lang == 'en') return titleEn.isNotEmpty ? titleEn : titleEs;
    return titleEs.isNotEmpty ? titleEs : titleEn;
  }

  String getPossibleCause(String lang) {
    if (lang == 'en') return possibleCauseEn.isNotEmpty ? possibleCauseEn : possibleCauseEs;
    return possibleCauseEs.isNotEmpty ? possibleCauseEs : possibleCauseEn;
  }

  List<String> getFirstThingsToCheck(String lang) {
    if (lang == 'en') return firstThingsToCheckEn.isNotEmpty ? firstThingsToCheckEn : firstThingsToCheckEs;
    return firstThingsToCheckEs.isNotEmpty ? firstThingsToCheckEs : firstThingsToCheckEn;
  }

  String? getRecommendedGuideTitle(String lang) {
    if (lang == 'en') return (recommendedGuideTitleEn != null && recommendedGuideTitleEn!.isNotEmpty) ? recommendedGuideTitleEn : recommendedGuideTitleEs;
    return (recommendedGuideTitleEs != null && recommendedGuideTitleEs!.isNotEmpty) ? recommendedGuideTitleEs : recommendedGuideTitleEn;
  }

  String getSafetyMessage(String lang) {
    if (lang == 'en') return safetyMessageEn.isNotEmpty ? safetyMessageEn : safetyMessageEs;
    return safetyMessageEs.isNotEmpty ? safetyMessageEs : safetyMessageEn;
  }
}

class DiagnosticFlow {
  final String id;
  final String titleEs;
  final String titleEn;
  final String tradeId;
  final String? relatedGuideId;
  final String descriptionEs;
  final String descriptionEn;
  final List<DiagnosticQuestion> questions;
  final List<DiagnosticResult> results;
  final bool isPopular;
  final IconData? icon;

  const DiagnosticFlow({
    required this.id,
    required this.titleEs,
    required this.titleEn,
    required this.tradeId,
    this.relatedGuideId,
    required this.descriptionEs,
    required this.descriptionEn,
    required this.questions,
    required this.results,
    this.isPopular = false,
    this.icon,
  });

  String getTitle(String lang) {
    if (lang == 'en') return titleEn.isNotEmpty ? titleEn : titleEs;
    return titleEs.isNotEmpty ? titleEs : titleEn;
  }

  String getDescription(String lang) {
    if (lang == 'en') return descriptionEn.isNotEmpty ? descriptionEn : descriptionEs;
    return descriptionEs.isNotEmpty ? descriptionEs : descriptionEn;
  }
}
