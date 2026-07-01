import 'package:flutter/material.dart';
import 'package:skillfix/l10n/app_localizations.dart';

enum MaintenancePriority { low, medium, high }

enum MaintenanceFrequency {
  once,
  weekly,
  biweekly,
  monthly,
  bimonthly,
  quarterly,
  semiannually,
  annually,
  custom,
}

class MaintenanceReminder {
  final String id;
  final String titleEs;
  final String titleEn;
  final String descriptionEs;
  final String descriptionEn;
  final String tradeId;
  final String? relatedGuideId;
  final String? relatedGuideTitleEs;
  final String? relatedGuideTitleEn;
  final MaintenanceFrequency frequency;
  final int customDays; // Used if frequency is custom
  final DateTime createdAt;
  final DateTime nextDate;
  final DateTime? lastCompletedDate;
  final bool isActive;
  final MaintenancePriority priority;
  final String instructionsEs;
  final String instructionsEn;
  final List<String> toolsEs;
  final List<String> toolsEn;
  final List<String> materialsEs;
  final List<String> materialsEn;
  final String? note;

  const MaintenanceReminder({
    required this.id,
    required this.titleEs,
    required this.titleEn,
    required this.descriptionEs,
    required this.descriptionEn,
    required this.tradeId,
    this.relatedGuideId,
    this.relatedGuideTitleEs,
    this.relatedGuideTitleEn,
    required this.frequency,
    this.customDays = 0,
    required this.createdAt,
    required this.nextDate,
    this.lastCompletedDate,
    this.isActive = true,
    required this.priority,
    required this.instructionsEs,
    required this.instructionsEn,
    this.toolsEs = const [],
    this.toolsEn = const [],
    this.materialsEs = const [],
    this.materialsEn = const [],
    this.note,
  });

  String getTitle(String lang) => lang == 'en' ? titleEn : titleEs;
  String getDescription(String lang) => lang == 'en' ? descriptionEn : descriptionEs;
  String getInstructions(String lang) => lang == 'en' ? instructionsEn : instructionsEs;
  String? getRelatedGuideTitle(String lang) => lang == 'en' ? relatedGuideTitleEn : relatedGuideTitleEs;

  Map<String, dynamic> toJson() => {
        'id': id,
        'titleEs': titleEs,
        'titleEn': titleEn,
        'descriptionEs': descriptionEs,
        'descriptionEn': descriptionEn,
        'tradeId': tradeId,
        'relatedGuideId': relatedGuideId,
        'relatedGuideTitleEs': relatedGuideTitleEs,
        'relatedGuideTitleEn': relatedGuideTitleEn,
        'frequency': frequency.name,
        'customDays': customDays,
        'createdAt': createdAt.toIso8601String(),
        'nextDate': nextDate.toIso8601String(),
        'lastCompletedDate': lastCompletedDate?.toIso8601String(),
        'isActive': isActive,
        'priority': priority.name,
        'instructionsEs': instructionsEs,
        'instructionsEn': instructionsEn,
        'toolsEs': toolsEs,
        'toolsEn': toolsEn,
        'materialsEs': materialsEs,
        'materialsEn': materialsEn,
        'note': note,
      };

  factory MaintenanceReminder.fromJson(Map<String, dynamic> json) =>
      MaintenanceReminder(
        id: json['id'],
        titleEs: json['titleEs'] ?? json['title'] ?? '',
        titleEn: json['titleEn'] ?? json['title'] ?? '',
        descriptionEs: json['descriptionEs'] ?? json['description'] ?? '',
        descriptionEn: json['descriptionEn'] ?? json['description'] ?? '',
        tradeId: json['tradeId'],
        relatedGuideId: json['relatedGuideId'],
        relatedGuideTitleEs: json['relatedGuideTitleEs'] ?? json['relatedGuideTitle'],
        relatedGuideTitleEn: json['relatedGuideTitleEn'] ?? json['relatedGuideTitle'],
        frequency: MaintenanceFrequency.values.byName(json['frequency']),
        customDays: json['customDays'] ?? 0,
        createdAt: DateTime.parse(json['createdAt']),
        nextDate: DateTime.parse(json['nextDate']),
        lastCompletedDate: json['lastCompletedDate'] != null
            ? DateTime.parse(json['lastCompletedDate'])
            : null,
        isActive: json['isActive'] ?? true,
        priority: MaintenancePriority.values.byName(json['priority']),
        instructionsEs: json['instructionsEs'] ?? json['instructions'] ?? '',
        instructionsEn: json['instructionsEn'] ?? json['instructions'] ?? '',
        toolsEs: List<String>.from(json['toolsEs'] ?? json['tools'] ?? []),
        toolsEn: List<String>.from(json['toolsEn'] ?? json['tools'] ?? []),
        materialsEs: List<String>.from(json['materialsEs'] ?? json['materials'] ?? []),
        materialsEn: List<String>.from(json['materialsEn'] ?? json['materials'] ?? []),
        note: json['note'],
      );

  MaintenanceReminder copyWith({
    String? titleEs,
    String? titleEn,
    String? descriptionEs,
    String? descriptionEn,
    MaintenanceFrequency? frequency,
    int? customDays,
    DateTime? nextDate,
    DateTime? lastCompletedDate,
    bool? isActive,
    MaintenancePriority? priority,
    String? note,
  }) {
    return MaintenanceReminder(
      id: id,
      titleEs: titleEs ?? this.titleEs,
      titleEn: titleEn ?? this.titleEn,
      descriptionEs: descriptionEs ?? this.descriptionEs,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      tradeId: tradeId,
      relatedGuideId: relatedGuideId,
      relatedGuideTitleEs: relatedGuideTitleEs,
      relatedGuideTitleEn: relatedGuideTitleEn,
      frequency: frequency ?? this.frequency,
      customDays: customDays ?? this.customDays,
      createdAt: createdAt,
      nextDate: nextDate ?? this.nextDate,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      isActive: isActive ?? this.isActive,
      priority: priority ?? this.priority,
      instructionsEs: instructionsEs,
      instructionsEn: instructionsEn,
      toolsEs: toolsEs,
      toolsEn: toolsEn,
      materialsEs: materialsEs,
      materialsEn: materialsEn,
      note: note ?? this.note,
    );
  }

  String getFrequencyLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return '';

    return switch (frequency) {
      MaintenanceFrequency.once => l10n.localeName == 'en' ? 'Once' : 'Una vez',
      MaintenanceFrequency.weekly => l10n.localeName == 'en' ? 'Weekly' : 'Semanal',
      MaintenanceFrequency.biweekly => l10n.localeName == 'en' ? 'Every 2 weeks' : 'Cada 2 semanas',
      MaintenanceFrequency.monthly => l10n.localeName == 'en' ? 'Monthly' : 'Mensual',
      MaintenanceFrequency.bimonthly => l10n.localeName == 'en' ? 'Every 2 months' : 'Cada 2 meses',
      MaintenanceFrequency.quarterly => l10n.localeName == 'en' ? 'Every 3 months' : 'Cada 3 meses',
      MaintenanceFrequency.semiannually => l10n.localeName == 'en' ? 'Every 6 months' : 'Cada 6 meses',
      MaintenanceFrequency.annually => l10n.localeName == 'en' ? 'Yearly' : 'Anual',
      MaintenanceFrequency.custom => l10n.localeName == 'en' 
          ? 'Custom ($customDays days)' 
          : 'Personalizado ($customDays días)',
    };
  }

  Color get priorityColor => switch (priority) {
        MaintenancePriority.low => Colors.green,
        MaintenancePriority.medium => Colors.orange,
        MaintenancePriority.high => Colors.red,
      };
}
