import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:skillfix/l10n/app_localizations.dart';
import 'screens/splash_screen.dart';
import 'services/favorites_service.dart';
import 'services/shopping_list_service.dart';
import 'services/repair_history_service.dart';
import 'services/maintenance_service.dart';
import 'services/language_service.dart';
import 'services/seasonal_service.dart';
import 'theme/app_theme.dart';

void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

  final favoritesService = FavoritesService();
  await favoritesService.load();

  final shoppingService = ShoppingListService();
  await shoppingService.load();

  final historyService = RepairHistoryService();
  await historyService.load();

  final maintenanceService = MaintenanceService();
  await maintenanceService.load();

  final languageService = LanguageService();
  await languageService.load();

  final seasonalService = SeasonalService();
  await seasonalService.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: favoritesService),
        ChangeNotifierProvider.value(value: shoppingService),
        ChangeNotifierProvider.value(value: historyService),
        ChangeNotifierProvider.value(value: maintenanceService),
        ChangeNotifierProvider.value(value: languageService),
        ChangeNotifierProvider.value(value: seasonalService),
      ],
      child: const SkillFixApp(),
    ),
  );
}

class SkillFixApp extends StatelessWidget {
  const SkillFixApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);

    return MaterialApp(
      title: 'Skill Fix',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      locale: languageService.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'),
        Locale('en'),
      ],
      home: const SplashScreen(),
    );
  }
}
