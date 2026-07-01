import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static const String _prefKey = 'selected_language';
  static const String _onboardingKey = 'has_seen_onboarding';

  Locale _locale = const Locale('es');
  bool _hasSeenOnboarding = false;

  Locale get locale => _locale;
  bool get hasSeenOnboarding => _hasSeenOnboarding;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString(_prefKey);
    if (langCode != null) {
      _locale = Locale(langCode);
    }
    _hasSeenOnboarding = prefs.getBool(_onboardingKey) ?? false;
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (!['es', 'en'].contains(locale.languageCode)) return;
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, locale.languageCode);
  }

  Future<void> completeOnboarding() async {
    _hasSeenOnboarding = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }
}
