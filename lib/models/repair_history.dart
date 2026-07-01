import 'package:flutter/material.dart';
import 'home_problem.dart';

enum HistoryEventType {
  viewed,
  started,
  completed,
  shoppingListCreated,
  favoriteAdded,
  diagnosticCompleted,
  technicianRequested,
  emergencyViewed,
  maintenanceReminderCreated,
  maintenanceCompleted,
  maintenancePostponed,
  maintenanceDeleted,
  calculatorUsed,
}

class RepairHistoryEntry {
  final String id;
  final String guideId;
  final String guideTitle;
  final String tradeId;
  final DateTime date;
  final HistoryEventType eventType;
  final String? note;
  final Difficulty difficulty;
  final RiskLevel riskLevel;
  final int estimatedMinutes;
  final bool isCompleted;
  final String? diagnosticResultId;

  const RepairHistoryEntry({
    required this.id,
    required this.guideId,
    required this.guideTitle,
    required this.tradeId,
    required this.date,
    required this.eventType,
    this.note,
    required this.difficulty,
    required this.riskLevel,
    required this.estimatedMinutes,
    this.isCompleted = false,
    this.diagnosticResultId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'guideId': guideId,
        'guideTitle': guideTitle,
        'tradeId': tradeId,
        'date': date.toIso8601String(),
        'eventType': eventType.name,
        'note': note,
        'difficulty': difficulty.name,
        'riskLevel': riskLevel.name,
        'estimatedMinutes': estimatedMinutes,
        'isCompleted': isCompleted,
        'diagnosticResultId': diagnosticResultId,
      };

  factory RepairHistoryEntry.fromJson(Map<String, dynamic> json) =>
      RepairHistoryEntry(
        id: json['id'],
        guideId: json['guideId'],
        guideTitle: json['guideTitle'],
        tradeId: json['tradeId'],
        date: DateTime.parse(json['date']),
        eventType: HistoryEventType.values.byName(json['eventType']),
        note: json['note'],
        difficulty: Difficulty.values.byName(json['difficulty']),
        riskLevel: RiskLevel.values.byName(json['riskLevel']),
        estimatedMinutes: json['estimatedMinutes'],
        isCompleted: json['isCompleted'] ?? false,
        diagnosticResultId: json['diagnosticResultId'],
      );

  String get eventLabel => switch (eventType) {
        HistoryEventType.viewed => 'Vista',
        HistoryEventType.started => 'Empezada',
        HistoryEventType.completed => 'Completada',
        HistoryEventType.shoppingListCreated => 'Lista de compras creada',
        HistoryEventType.favoriteAdded => 'Guardada en favoritos',
        HistoryEventType.diagnosticCompleted => 'Diagnóstico realizado',
        HistoryEventType.technicianRequested => 'Ayuda solicitada',
        HistoryEventType.emergencyViewed => 'Emergencia consultada',
        HistoryEventType.maintenanceReminderCreated => 'Recordatorio creado',
        HistoryEventType.maintenanceCompleted => 'Mantenimiento realizado',
        HistoryEventType.maintenancePostponed => 'Mantenimiento pospuesto',
        HistoryEventType.maintenanceDeleted => 'Recordatorio eliminado',
        HistoryEventType.calculatorUsed => 'Calculadora usada',
      };

  IconData get icon => switch (eventType) {
        HistoryEventType.viewed => Icons.visibility_outlined,
        HistoryEventType.started => Icons.play_arrow_outlined,
        HistoryEventType.completed => Icons.check_circle_outline,
        HistoryEventType.shoppingListCreated => Icons.shopping_cart_outlined,
        HistoryEventType.favoriteAdded => Icons.bookmark_outline,
        HistoryEventType.diagnosticCompleted => Icons.psychology_outlined,
        HistoryEventType.technicianRequested => Icons.support_agent,
        HistoryEventType.emergencyViewed => Icons.warning_amber_rounded,
        HistoryEventType.maintenanceReminderCreated => Icons.notification_add_outlined,
        HistoryEventType.maintenanceCompleted => Icons.build_circle_outlined,
        HistoryEventType.maintenancePostponed => Icons.more_time,
        HistoryEventType.maintenanceDeleted => Icons.delete_sweep_outlined,
        HistoryEventType.calculatorUsed => Icons.calculate_outlined,
      };

  Color get color => isCompleted ? Colors.green : Colors.blue;

  RepairHistoryEntry copyWith({
    String? note,
    bool? isCompleted,
    HistoryEventType? eventType,
    String? guideId,
  }) {
    return RepairHistoryEntry(
      id: id,
      guideId: guideId ?? this.guideId,
      guideTitle: guideTitle,
      tradeId: tradeId,
      date: date,
      eventType: eventType ?? this.eventType,
      note: note ?? this.note,
      difficulty: difficulty,
      riskLevel: riskLevel,
      estimatedMinutes: estimatedMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      diagnosticResultId: diagnosticResultId,
    );
  }
}
