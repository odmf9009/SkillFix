import 'package:flutter/material.dart';
import 'package:skillfix/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../models/diagnostic.dart';
import '../models/home_problem.dart';
import '../models/repair_history.dart';
import '../services/repair_history_service.dart';
import '../data/problems_data.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import 'problem_detail_screen.dart';

class DiagnosticResultScreen extends StatefulWidget {
  final DiagnosticResult result;
  final DiagnosticFlow flow;

  const DiagnosticResultScreen({
    super.key,
    required this.result,
    required this.flow,
  });

  @override
  State<DiagnosticResultScreen> createState() => _DiagnosticResultScreenState();
}

class _DiagnosticResultScreenState extends State<DiagnosticResultScreen> {
  @override
  void initState() {
    super.initState();
    
    // Record "diagnosticCompleted" event
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final historyService = Provider.of<RepairHistoryService>(context, listen: false);
      
      // If there is a recommended guide, use its data to create a richer history entry
      HomeProblem? problem;
      if (widget.result.recommendedGuideId != null) {
        try {
          problem = ProblemsData.all.firstWhere((p) => p.id == widget.result.recommendedGuideId);
        } catch (_) {}
      }

      if (problem != null) {
        historyService.addEntry(
          problem: problem,
          eventType: HistoryEventType.diagnosticCompleted,
          diagnosticResultId: widget.result.id,
          note: 'Resultado: ${widget.result.titleEs}. Causa: ${widget.result.possibleCauseEs}',
        );
      } else {
        // Fallback for cases without a direct guide
        final fallbackProblem = HomeProblem(
          id: widget.flow.relatedGuideId ?? 'diag_${widget.flow.id}',
          tradeId: widget.flow.tradeId,
          titleEs: widget.flow.titleEs,
          titleEn: widget.flow.titleEn,
          descriptionEs: widget.flow.descriptionEs,
          descriptionEn: widget.flow.descriptionEn,
          difficulty: Difficulty.medium,
          estimatedMinutes: 0,
          riskLevel: widget.result.riskLevel,
          toolsEs: [],
          toolsEn: [],
          materialsEs: [],
          materialsEn: [],
          stepsEs: [],
          stepsEn: [],
          warningsEs: [],
          warningsEn: [],
        );
        
        historyService.addEntry(
          problem: fallbackProblem,
          eventType: HistoryEventType.diagnosticCompleted,
          diagnosticResultId: widget.result.id,
          note: 'Resultado: ${widget.result.titleEs}. Causa: ${widget.result.possibleCauseEs}',
        );
      }
    });
  }

  void _goToGuide(BuildContext context) {
    if (widget.result.recommendedGuideId == null) return;

    try {
      final problem = ProblemsData.all.firstWhere((p) => p.id == widget.result.recommendedGuideId);
      final trade = MockData.trades.firstWhere((t) => t.id == problem.tradeId);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProblemDetailScreen(
            problem: problem,
            tradeColor: trade.color,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.localeName == 'en' ? 'Guide not available' : 'Guía no disponible')),
      );
    }
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppLocalizations.of(context)!.requestTechnician),
        content: Text(
          AppLocalizations.of(context)!.soonFixRadar,
          style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context)!.understood),
          ),
        ],
      ),
    );
  }

  String _getGuideTitle(String lang) {
    if (widget.result.recommendedGuideTitleEs != null || widget.result.recommendedGuideTitleEn != null) {
      return widget.result.getRecommendedGuideTitle(lang) ?? '';
    }
    
    if (widget.result.recommendedGuideId != null) {
      try {
        final problem = ProblemsData.all.firstWhere((p) => p.id == widget.result.recommendedGuideId);
        return problem.getTitle(lang);
      } catch (_) {}
    }
    
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final lang = AppLocalizations.of(context)!.localeName;
    final guideTitle = _getGuideTitle(lang);

    return Scaffold(
      appBar: AppBar(
        title: Text(lang == 'en' ? 'Diagnosis Result' : 'Resultado del Diagnóstico'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... (rest of the header remains the same)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: result.riskLevel == RiskLevel.high
                    ? Colors.red[50]
                    : AppTheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: result.riskLevel == RiskLevel.high
                      ? Colors.red[200]!
                      : AppTheme.primary.withAlpha(60),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        result.riskLevel == RiskLevel.high
                            ? Icons.warning_rounded
                            : Icons.check_circle_rounded,
                        color: result.riskLevel == RiskLevel.high
                            ? Colors.red
                            : AppTheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          result.getTitle(lang),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: result.riskLevel == RiskLevel.high
                                ? Colors.red[900]
                                : AppTheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    lang == 'en' ? 'POSSIBLE CAUSE:' : 'POSIBLE CAUSA:',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
                  ),
                  Text(
                    result.getPossibleCause(lang),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // --- Qué revisar ---
            Text(
              lang == 'en' ? 'First things to check:' : 'Qué revisar primero:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 12),
            ...result.getFirstThingsToCheck(lang).map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.arrow_right, color: AppTheme.primary),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(fontSize: 15, color: AppTheme.textPrimary),
                        ),
                      ),
                    ],
                  ),
                )),

            const SizedBox(height: 32),

            // --- Mensaje de seguridad ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.security, color: Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      result.getSafetyMessage(lang),
                      style: TextStyle(fontSize: 13, color: Colors.orange[900], fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // --- Botones ---
            if (result.recommendedGuideId != null && guideTitle.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _goToGuide(context),
                  icon: const Icon(Icons.menu_book),
                  label: Text('${lang == 'en' ? 'View guide' : 'Ver guía'}: $guideTitle'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              )
            else if (result.recommendedGuideId != null)
               SizedBox(
                width: double.infinity,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      lang == 'en' ? 'Related guide not available' : 'Guía relacionada no disponible',
                      style: const TextStyle(color: AppTheme.textSecondary, fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showHelpDialog(context),
                icon: const Icon(Icons.support_agent),
                label: Text(AppLocalizations.of(context)!.requestTechnician),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
