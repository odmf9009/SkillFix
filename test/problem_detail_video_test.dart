import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:skillfix/data/problems_data.dart';
import 'package:skillfix/l10n/app_localizations.dart';
import 'package:skillfix/models/home_problem.dart';
import 'package:skillfix/screens/problem_detail_screen.dart';
import 'package:skillfix/services/favorites_service.dart';
import 'package:skillfix/services/language_service.dart';
import 'package:skillfix/services/repair_history_service.dart';
import 'package:skillfix/services/shopping_list_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget build(HomeProblem problem) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesService()),
        ChangeNotifierProvider(create: (_) => ShoppingListService()),
        ChangeNotifierProvider(create: (_) => RepairHistoryService()),
        ChangeNotifierProvider(create: (_) => LanguageService()),
      ],
      child: MaterialApp(
        locale: const Locale('es'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('es'), Locale('en')],
        home: ProblemDetailScreen(
          problem: problem,
          tradeColor: const Color(0xFF1976D2),
        ),
      ),
    );
  }

  testWidgets('la sección de videos relacionados siempre se muestra',
      (tester) async {
    final problem = ProblemsData.all.firstWhere((p) => p.youtubeIdEs.isEmpty);

    await tester.pumpWidget(build(problem));
    await tester.pumpAndSettle();

    expect(find.text('Videos relacionados'), findsOneWidget);
  });

  testWidgets(
      'si la búsqueda en vivo falla y no hay video curado, cae al botón de búsqueda',
      (tester) async {
    // En los widget tests el cliente HTTP está bloqueado (responde 400), así
    // que la búsqueda en vivo falla; sin video curado se muestra el fallback.
    final problem = ProblemsData.all.firstWhere((p) => p.youtubeIdEs.isEmpty);

    await tester.pumpWidget(build(problem));
    await tester.pumpAndSettle();

    expect(find.text('Buscar videos en YouTube'), findsOneWidget);
  });

  testWidgets('con video curado, el carrusel muestra tarjetas de video',
      (tester) async {
    // El video curado se muestra aunque la API en vivo falle, y aparece la
    // tarjeta final para seguir buscando en YouTube.
    final problem = ProblemsData.all.firstWhere((p) => p.youtubeIdEs.isNotEmpty);

    await tester.pumpWidget(build(problem));
    await tester.pumpAndSettle();

    expect(find.text('Buscar más\nen YouTube'), findsOneWidget);
    expect(find.text('Buscar videos en YouTube'), findsNothing);
  });
}
