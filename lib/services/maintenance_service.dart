import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/maintenance_reminder.dart';

class MaintenanceService extends ChangeNotifier {
  List<MaintenanceReminder> _reminders = [];
  bool _isLoading = true;

  List<MaintenanceReminder> get reminders => List.unmodifiable(_reminders);
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? remindersJson = prefs.getString('maintenance_reminders');
      if (remindersJson != null) {
        final List<dynamic> decoded = jsonDecode(remindersJson);
        _reminders = decoded.map((item) => MaintenanceReminder.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint('Error loading reminders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String remindersJson = jsonEncode(_reminders.map((e) => e.toJson()).toList());
      await prefs.setString('maintenance_reminders', remindersJson);
    } catch (e) {
      debugPrint('Error saving reminders: $e');
    }
  }

  Future<void> addReminder(MaintenanceReminder reminder) async {
    _reminders.add(reminder);
    _sortReminders();
    notifyListeners();
    await _save();
    
    // NOTE: Plug notification scheduling logic here
    // Example: NotificationService.schedule(reminder);
  }

  Future<void> deleteReminder(String id) async {
    _reminders.removeWhere((r) => r.id == id);
    notifyListeners();
    await _save();
  }

  Future<void> toggleActive(String id) async {
    final index = _reminders.indexWhere((r) => r.id == id);
    if (index != -1) {
      _reminders[index] = _reminders[index].copyWith(isActive: !_reminders[index].isActive);
      notifyListeners();
      await _save();
    }
  }

  Future<void> completeReminder(String id) async {
    final index = _reminders.indexWhere((r) => r.id == id);
    if (index != -1) {
      final reminder = _reminders[index];
      final now = DateTime.now();
      final next = _calculateNextDate(now, reminder.frequency, reminder.customDays);

      _reminders[index] = reminder.copyWith(
        lastCompletedDate: now,
        nextDate: next,
      );
      _sortReminders();
      notifyListeners();
      await _save();

      // NOTE: Reschedule notification for nextDate here
    }
  }

  Future<void> postponeReminder(String id, int days) async {
    final index = _reminders.indexWhere((r) => r.id == id);
    if (index != -1) {
      _reminders[index] = _reminders[index].copyWith(
        nextDate: _reminders[index].nextDate.add(Duration(days: days)),
      );
      _sortReminders();
      notifyListeners();
      await _save();
    }
  }

  void _sortReminders() {
    _reminders.sort((a, b) => a.nextDate.compareTo(b.nextDate));
  }

  DateTime _calculateNextDate(DateTime from, MaintenanceFrequency freq, int customDays) {
    return switch (freq) {
      MaintenanceFrequency.once => from.add(const Duration(days: 3650)), // Practically never again
      MaintenanceFrequency.weekly => from.add(const Duration(days: 7)),
      MaintenanceFrequency.biweekly => from.add(const Duration(days: 14)),
      MaintenanceFrequency.monthly => from.add(const Duration(days: 30)),
      MaintenanceFrequency.bimonthly => from.add(const Duration(days: 60)),
      MaintenanceFrequency.quarterly => from.add(const Duration(days: 90)),
      MaintenanceFrequency.semiannually => from.add(const Duration(days: 180)),
      MaintenanceFrequency.annually => from.add(const Duration(days: 365)),
      MaintenanceFrequency.custom => from.add(Duration(days: customDays)),
    };
  }

  bool isReminderActiveForGuide(String guideId) {
    return _reminders.any((r) => r.relatedGuideId == guideId && r.isActive);
  }
}
