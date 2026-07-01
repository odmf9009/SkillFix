import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/repair_history.dart';
import '../models/home_problem.dart';
import '../data/problems_data.dart';
import '../data/emergency_data.dart';
import '../data/calculators_data.dart';

class RepairHistoryService extends ChangeNotifier {
  List<RepairHistoryEntry> _history = [];
  bool _isLoading = true;

  List<RepairHistoryEntry> get history => List.unmodifiable(_history);
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? historyJson = prefs.getString('repair_history');
      if (historyJson != null) {
        final List<dynamic> decoded = jsonDecode(historyJson);
        _history = decoded.map((item) => RepairHistoryEntry.fromJson(item)).toList();
        
        // Attempt to repair old or broken entries
        if (await _repairHistory()) {
          await _save();
        }
      }
    } catch (e) {
      debugPrint('Error loading history: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> _repairHistory() async {
    bool changed = false;
    for (int i = 0; i < _history.length; i++) {
      final entry = _history[i];
      
      bool isInvalidId = entry.guideId.isEmpty || 
                        (!ProblemsData.all.any((p) => p.id == entry.guideId) &&
                         !EmergencyData.items.any((e) => e.id == entry.guideId) &&
                         !CalculatorsData.tools.any((c) => c.id == entry.guideId));

      if (isInvalidId) {
        // Search problems by title
        final problemsByTitle = ProblemsData.all.where((p) => 
          p.titleEs.toLowerCase() == entry.guideTitle.toLowerCase() ||
          p.titleEn.toLowerCase() == entry.guideTitle.toLowerCase()
        ).toList();

        HomeProblem? match;
        if (problemsByTitle.length == 1) {
          match = problemsByTitle.first;
        } else if (problemsByTitle.length > 1) {
          // Narrow down by trade
          final tradeMatch = problemsByTitle.where((p) => p.tradeId == entry.tradeId).toList();
          if (tradeMatch.isNotEmpty) {
            match = tradeMatch.first;
          }
        }

        if (match != null) {
          _history[i] = _history[i].copyWith(guideId: match.id);
          changed = true;
        } else {
          // Check emergencies
          final emergenciesByTitle = EmergencyData.items.where((e) => 
            e.titleEs.toLowerCase() == entry.guideTitle.toLowerCase() ||
            e.titleEn.toLowerCase() == entry.guideTitle.toLowerCase()
          ).toList();
          
          if (emergenciesByTitle.isNotEmpty) {
            _history[i] = _history[i].copyWith(guideId: emergenciesByTitle.first.id);
            changed = true;
          }
        }
      }
    }
    return changed;
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String historyJson = jsonEncode(_history.map((e) => e.toJson()).toList());
      await prefs.setString('repair_history', historyJson);
    } catch (e) {
      debugPrint('Error saving history: $e');
    }
  }

  Future<void> addEntry({
    required HomeProblem problem,
    required HistoryEventType eventType,
    String? note,
    String? diagnosticResultId,
  }) async {
    // Avoid duplicating "viewed" or "emergencyViewed" events on the same day for the same guide
    if (eventType == HistoryEventType.viewed || eventType == HistoryEventType.emergencyViewed) {
      final now = DateTime.now();
      final alreadyViewedToday = _history.any((e) =>
          e.guideId == problem.id &&
          e.eventType == eventType &&
          e.date.year == now.year &&
          e.date.month == now.month &&
          e.date.day == now.day);
      if (alreadyViewedToday) return;
    }

    final entry = RepairHistoryEntry(
      id: const Uuid().v4(),
      guideId: problem.id,
      guideTitle: problem.titleEs,
      tradeId: problem.tradeId,
      date: DateTime.now(),
      eventType: eventType,
      note: note,
      difficulty: problem.difficulty,
      riskLevel: problem.riskLevel,
      estimatedMinutes: problem.estimatedMinutes,
      isCompleted: eventType == HistoryEventType.completed,
      diagnosticResultId: diagnosticResultId,
    );

    _history.insert(0, entry);
    notifyListeners();
    await _save();
  }

  Future<void> markAsCompleted(String guideId, HomeProblem problem) async {
    final alreadyCompleted = _history.any((e) => e.guideId == guideId && e.isCompleted);
    if (alreadyCompleted) return;

    // Update existing entries for this guide to isCompleted = true or add a new completed entry
    bool found = false;
    for (int i = 0; i < _history.length; i++) {
      if (_history[i].guideId == guideId) {
        _history[i] = _history[i].copyWith(isCompleted: true);
        found = true;
      }
    }

    await addEntry(
      problem: problem,
      eventType: HistoryEventType.completed,
    );

    if (found) {
      notifyListeners();
      await _save();
    }
  }

  Future<void> removeAsCompleted(String guideId) async {
    _history = _history.where((e) => !(e.guideId == guideId && e.eventType == HistoryEventType.completed)).toList();
    for (int i = 0; i < _history.length; i++) {
      if (_history[i].guideId == guideId) {
        _history[i] = _history[i].copyWith(isCompleted: false);
      }
    }
    notifyListeners();
    await _save();
  }

  bool isGuideCompleted(String guideId) {
    return _history.any((e) => e.guideId == guideId && e.eventType == HistoryEventType.completed);
  }

  Future<void> updateNote(String entryId, String note) async {
    final index = _history.indexWhere((e) => e.id == entryId);
    if (index != -1) {
      _history[index] = _history[index].copyWith(note: note);
      notifyListeners();
      await _save();
    }
  }

  Future<void> deleteEntry(String entryId) async {
    _history.removeWhere((e) => e.id == entryId);
    notifyListeners();
    await _save();
  }
}
