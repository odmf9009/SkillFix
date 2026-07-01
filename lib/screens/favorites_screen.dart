import 'package:flutter/material.dart';
import 'package:skillfix/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../data/mock_data.dart';
import '../data/problems_data.dart';
import '../models/home_problem.dart';
import '../services/favorites_service.dart';
import '../theme/app_theme.dart';
import '../widgets/problem_card.dart';
import 'problem_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = l10n.localeName;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.favorites),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<FavoritesService>(
        builder: (context, favService, _) {
          // Obtener los problemas favoritos filtrando la lista global 'all'
          final List<HomeProblem> favoriteProblems = ProblemsData.all
              .where((p) => favService.favoriteIds.contains(p.id))
              .toList();

          if (favoriteProblems.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.bookmark_border,
                        size: 64,
                        color: AppTheme.primary.withAlpha(150),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.noFavoritesYet,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      lang == 'en' 
                        ? 'Open a guide and tap the bookmark to save it here.' 
                        : 'Abre una guía y toca el marcador para guardarla aquí.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: favoriteProblems.length,
            itemBuilder: (context, index) {
              final problem = favoriteProblems[index];
              final trade =
                  MockData.trades.firstWhere((t) => t.id == problem.tradeId);

              return Dismissible(
                key: Key('fav_${problem.id}'),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  favService.toggle(problem.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.removedFromFavorites)),
                  );
                },
                child: ProblemCard(
                  problem: problem,
                  tradeLabel: trade.getName(lang),
                  accentColor: trade.color,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProblemDetailScreen(
                          problem: problem,
                          tradeColor: trade.color,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
