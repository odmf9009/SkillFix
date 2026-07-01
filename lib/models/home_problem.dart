import 'package:flutter/material.dart';
import 'package:skillfix/l10n/app_localizations.dart';

enum Difficulty { easy, medium, hard }

enum RiskLevel { low, medium, high }

class HomeProblem {
  final String id;
  final String tradeId;
  
  // Spanish
  final String titleEs;
  final String descriptionEs;
  final List<String> toolsEs;
  final List<String> materialsEs;
  final List<String> stepsEs;
  final List<String> warningsEs;
  
  // English
  final String titleEn;
  final String descriptionEn;
  final List<String> toolsEn;
  final List<String> materialsEn;
  final List<String> stepsEn;
  final List<String> warningsEn;

  final Difficulty difficulty;
  final int estimatedMinutes;
  final RiskLevel riskLevel;
  
  final String youtubeIdEs;
  final String youtubeIdEn;
  final bool isPopular;
  final DiyEvaluation? diyEvaluation;

  const HomeProblem({
    required this.id,
    required this.tradeId,
    required this.titleEs,
    required this.descriptionEs,
    required this.toolsEs,
    required this.materialsEs,
    required this.stepsEs,
    required this.warningsEs,
    required this.titleEn,
    required this.descriptionEn,
    required this.toolsEn,
    required this.materialsEn,
    required this.stepsEn,
    required this.warningsEn,
    required this.difficulty,
    required this.estimatedMinutes,
    required this.riskLevel,
    this.youtubeIdEs = '',
    this.youtubeIdEn = '',
    this.isPopular = false,
    this.diyEvaluation,
  });

  String getTitle(String lang) {
    if (lang == 'en') return titleEn.isNotEmpty ? titleEn : titleEs;
    return titleEs.isNotEmpty ? titleEs : titleEn;
  }

  String getDescription(String lang) {
    if (lang == 'en') return descriptionEn.isNotEmpty ? descriptionEn : descriptionEs;
    return descriptionEs.isNotEmpty ? descriptionEs : descriptionEn;
  }

  List<String> getTools(String lang) {
    if (lang == 'en') return toolsEn.isNotEmpty ? toolsEn : toolsEs;
    return toolsEs.isNotEmpty ? toolsEs : toolsEn;
  }

  List<String> getMaterials(String lang) {
    if (lang == 'en') return materialsEn.isNotEmpty ? materialsEn : materialsEs;
    return materialsEs.isNotEmpty ? materialsEs : materialsEn;
  }

  List<String> getSteps(String lang) {
    if (lang == 'en') return stepsEn.isNotEmpty ? stepsEn : stepsEs;
    return stepsEs.isNotEmpty ? stepsEs : stepsEn;
  }

  List<String> getWarnings(String lang) {
    if (lang == 'en') return warningsEn.isNotEmpty ? warningsEn : warningsEs;
    return warningsEs.isNotEmpty ? warningsEs : warningsEn;
  }
  String getYoutubeId(String lang) {
    if (lang == 'en' && youtubeIdEn.isNotEmpty) return youtubeIdEn;
    return youtubeIdEs; // Fallback to Spanish video if English doesn't exist
  }

  DiyEvaluation getEffectiveDiyEvaluation(String lang) {
    if (diyEvaluation != null) return diyEvaluation!;
    
    // Fallback based on riskLevel
    return switch (riskLevel) {
      RiskLevel.low => DiyEvaluation(
          level: DiyLevel.green,
          summaryEs: 'Puedes intentarlo tú si tienes herramientas básicas y entiendes los pasos.',
          summaryEn: 'You can try it yourself if you have basic tools and understand the steps.',
          canDoYourselfConditionsEs: ['Tienes las herramientas necesarias', 'El área de trabajo es segura'],
          canDoYourselfConditionsEn: ['You have the necessary tools', 'The work area is safe'],
          callTechnicianConditionsEs: ['No te sientes seguro', 'El problema parece más complejo'],
          callTechnicianConditionsEn: ['You don’t feel confident', 'The problem seems more complex'],
          requiredExperienceEs: 'Principiante',
          requiredExperienceEn: 'Beginner',
          requiredToolsEs: ['Básicas'],
          requiredToolsEn: ['Basic'],
          safetyReminderEs: 'Usa equipo de protección básico.',
          safetyReminderEn: 'Use basic protective equipment.',
          finalRecommendationEs: 'Es una tarea de bajo riesgo que puedes realizar siguiendo la guía.',
          finalRecommendationEn: 'It is a low-risk task that you can perform by following the guide.',
        ),
      RiskLevel.medium => DiyEvaluation(
          level: DiyLevel.yellow,
          summaryEs: 'Puedes intentarlo solo si tienes experiencia básica y entiendes los riesgos.',
          summaryEn: 'You can try it only if you have basic experience and understand the risks.',
          canDoYourselfConditionsEs: ['Tienes experiencia previa básica', 'Sigues todas las advertencias'],
          canDoYourselfConditionsEn: ['You have basic previous experience', 'You follow all warnings'],
          callTechnicianConditionsEs: ['Algo no coincide con la guía', 'Hay riesgo de daño por agua o electricidad'],
          callTechnicianConditionsEn: ['Something doesn’t match the guide', 'There is a risk of water or electrical damage'],
          requiredExperienceEs: 'Básica / Intermedia',
          requiredExperienceEn: 'Basic / Intermediate',
          requiredToolsEs: ['Específicas de la guía'],
          requiredToolsEn: ['Specific to the guide'],
          safetyReminderEs: 'Procede con precaución y detente si tienes dudas.',
          safetyReminderEn: 'Proceed with caution and stop if you have doubts.',
          finalRecommendationEs: 'Ten cuidado y asegúrate de entender cada paso antes de actuar.',
          finalRecommendationEn: 'Be careful and make sure you understand each step before acting.',
        ),
      RiskLevel.high => DiyEvaluation(
          level: DiyLevel.red,
          summaryEs: 'Este trabajo puede ser peligroso o causar daños importantes.',
          summaryEn: 'This job can be dangerous or cause significant damage.',
          canDoYourselfConditionsEs: ['Eres técnico calificado', 'Tienes experiencia avanzada'],
          canDoYourselfConditionsEn: ['You are a qualified technician', 'You have advanced experience'],
          callTechnicianConditionsEs: ['No tienes experiencia profesional', 'Hay riesgo eléctrico alto, gas o estructural'],
          callTechnicianConditionsEn: ['You don’t have professional experience', 'There is high electrical, gas, or structural risk'],
          requiredExperienceEs: 'Avanzada / Profesional',
          requiredExperienceEn: 'Advanced / Professional',
          requiredToolsEs: ['Profesionales / Aisladas'],
          requiredToolsEn: ['Professional / Insulated'],
          safetyReminderEs: 'Tu seguridad es lo primero. No tomes riesgos innecesarios.',
          safetyReminderEn: 'Your safety comes first. Do not take unnecessary risks.',
          finalRecommendationEs: 'Es mejor que este trabajo sea revisado por un técnico calificado.',
          finalRecommendationEn: 'It is better for this work to be reviewed by a qualified technician.',
        ),
    };
  }

  String getDifficultyLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (difficulty) {
      Difficulty.easy => l10n.easy,
      Difficulty.medium => l10n.medium,
      Difficulty.hard => l10n.hard,
    };
  }

  String getRiskLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (riskLevel) {
      RiskLevel.low => l10n.low,
      RiskLevel.medium => l10n.medium,
      RiskLevel.high => l10n.high,
    };
  }

  Color get difficultyColor => switch (difficulty) {
        Difficulty.easy => const Color(0xFF2E7D32),
        Difficulty.medium => const Color(0xFFE65100),
        Difficulty.hard => const Color(0xFFC62828),
      };

  Color get riskColor => switch (riskLevel) {
        RiskLevel.low => const Color(0xFF2E7D32),
        RiskLevel.medium => const Color(0xFFE65100),
        RiskLevel.high => const Color(0xFFC62828),
      };
}

enum DiyLevel { green, yellow, red }

class DiyEvaluation {
  final DiyLevel level;
  
  final String summaryEs;
  final String summaryEn;
  
  final List<String> canDoYourselfConditionsEs;
  final List<String> canDoYourselfConditionsEn;
  
  final List<String> callTechnicianConditionsEs;
  final List<String> callTechnicianConditionsEn;
  
  final String requiredExperienceEs;
  final String requiredExperienceEn;
  
  final List<String> requiredToolsEs;
  final List<String> requiredToolsEn;
  
  final String safetyReminderEs;
  final String safetyReminderEn;
  
  final String finalRecommendationEs;
  final String finalRecommendationEn;

  const DiyEvaluation({
    required this.level,
    required this.summaryEs,
    required this.summaryEn,
    required this.canDoYourselfConditionsEs,
    required this.canDoYourselfConditionsEn,
    required this.callTechnicianConditionsEs,
    required this.callTechnicianConditionsEn,
    required this.requiredExperienceEs,
    required this.requiredExperienceEn,
    required this.requiredToolsEs,
    required this.requiredToolsEn,
    required this.safetyReminderEs,
    required this.safetyReminderEn,
    required this.finalRecommendationEs,
    required this.finalRecommendationEn,
  });

  String getSummary(String lang) {
    if (lang == 'en') return summaryEn.isNotEmpty ? summaryEn : summaryEs;
    return summaryEs.isNotEmpty ? summaryEs : summaryEn;
  }

  List<String> getCanDoYourselfConditions(String lang) {
    if (lang == 'en') return canDoYourselfConditionsEn.isNotEmpty ? canDoYourselfConditionsEn : canDoYourselfConditionsEs;
    return canDoYourselfConditionsEs.isNotEmpty ? canDoYourselfConditionsEs : canDoYourselfConditionsEn;
  }

  List<String> getCallTechnicianConditions(String lang) {
    if (lang == 'en') return callTechnicianConditionsEn.isNotEmpty ? callTechnicianConditionsEn : callTechnicianConditionsEs;
    return callTechnicianConditionsEs.isNotEmpty ? callTechnicianConditionsEs : callTechnicianConditionsEn;
  }

  String getRequiredExperience(String lang) {
    if (lang == 'en') return requiredExperienceEn.isNotEmpty ? requiredExperienceEn : requiredExperienceEs;
    return requiredExperienceEs.isNotEmpty ? requiredExperienceEs : requiredExperienceEn;
  }

  List<String> getRequiredTools(String lang) {
    if (lang == 'en') return requiredToolsEn.isNotEmpty ? requiredToolsEn : requiredToolsEs;
    return requiredToolsEs.isNotEmpty ? requiredToolsEs : requiredToolsEn;
  }

  String getSafetyReminder(String lang) {
    if (lang == 'en') return safetyReminderEn.isNotEmpty ? safetyReminderEn : safetyReminderEs;
    return safetyReminderEs.isNotEmpty ? safetyReminderEs : safetyReminderEn;
  }

  String getFinalRecommendation(String lang) {
    if (lang == 'en') return finalRecommendationEn.isNotEmpty ? finalRecommendationEn : finalRecommendationEs;
    return finalRecommendationEs.isNotEmpty ? finalRecommendationEs : finalRecommendationEn;
  }

  String getLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (level) {
      DiyLevel.green => l10n.tryIf.replaceAll('...', ''), // Just a label, so stripping the dots
      DiyLevel.yellow => l10n.medium,
      DiyLevel.red => l10n.callIf.replaceAll('...', ''),
    };
  }

  // Better labels for the UI
  String getTitleLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (level) {
      DiyLevel.green => l10n.localeName == 'en' ? 'You can do it' : 'Puedes hacerlo tú',
      DiyLevel.yellow => l10n.localeName == 'en' ? 'Do it with care' : 'Hazlo con cuidado',
      DiyLevel.red => l10n.localeName == 'en' ? 'Better call a pro' : 'Mejor llama a un técnico',
    };
  }

  Color get color => switch (level) {
        DiyLevel.green => const Color(0xFFE8F5E9),
        DiyLevel.yellow => const Color(0xFFFFF3E0),
        DiyLevel.red => const Color(0xFFFFEBEE),
      };

  Color get textColor => switch (level) {
        DiyLevel.green => const Color(0xFF2E7D32),
        DiyLevel.yellow => const Color(0xFFE65100),
        DiyLevel.red => const Color(0xFFC62828),
      };

  IconData get icon => switch (level) {
        DiyLevel.green => Icons.check_circle_outline,
        DiyLevel.yellow => Icons.error_outline,
        DiyLevel.red => Icons.warning_amber_rounded,
      };
}
