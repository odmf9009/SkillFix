import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/seasonal_checklist.dart';
import '../data/seasonal_data.dart';

class SeasonalService extends ChangeNotifier {
  static const _key = 'seasonal_progress';

  final Map<String, Set<String>> _done = {
    'spring': {},
    'summer': {},
    'fall': {},
    'winter': {},
  };

  bool isTaskDone(Season season, String taskId) =>
      _done[season.name]!.contains(taskId);

  void toggleTask(Season season, String taskId) {
    final set = _done[season.name]!;
    if (set.contains(taskId)) {
      set.remove(taskId);
    } else {
      set.add(taskId);
    }
    notifyListeners();
    _save();
  }

  int completedCount(Season season) => _done[season.name]!.length;

  int totalCount(Season season) => SeasonalData.tasksFor(season).length;

  double progress(Season season) {
    final total = totalCount(season);
    return total == 0 ? 0 : completedCount(season) / total;
  }

  void resetSeason(Season season) {
    _done[season.name]!.clear();
    notifyListeners();
    _save();
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      for (final entry in map.entries) {
        if (_done.containsKey(entry.key)) {
          _done[entry.key] = Set<String>.from(entry.value as List);
        }
      }
    }
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final map = {for (final e in _done.entries) e.key: e.value.toList()};
    await prefs.setString(_key, jsonEncode(map));
  }
}
