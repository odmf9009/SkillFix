import 'package:flutter/material.dart';
import 'package:skillfix/l10n/app_localizations.dart';
import '../models/home_problem.dart';
import '../theme/app_theme.dart';

class ProblemCard extends StatelessWidget {
  final HomeProblem problem;
  final VoidCallback onTap;
  final Color accentColor;
  final String? tradeLabel;

  const ProblemCard({
    super.key,
    required this.problem,
    required this.onTap,
    this.accentColor = AppTheme.primary,
    this.tradeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!.localeName;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: AppTheme.cardShadow,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accentColor.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  Icon(Icons.build_outlined, color: accentColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (tradeLabel != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: accentColor.withAlpha(20),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tradeLabel!,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: accentColor,
                          ),
                        ),
                      ),
                    ),
                  Text(
                    problem.getTitle(lang),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    problem.getDescription(lang),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      _chip(
                        problem.getDifficultyLabel(context),
                        problem.difficultyColor,
                      ),
                      _chip(
                        problem.getRiskLabel(context),
                        problem.riskColor,
                        icon: Icons.warning_amber_rounded,
                      ),
                      _chip(
                        '${problem.estimatedMinutes} min',
                        AppTheme.textSecondary,
                        icon: Icons.schedule,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: accentColor, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, Color color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
