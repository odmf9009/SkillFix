import 'package:flutter/material.dart';
import 'package:skillfix/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../models/emergency.dart';
import '../models/repair_history.dart';
import '../models/home_problem.dart';
import '../services/repair_history_service.dart';
import '../data/problems_data.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import 'problem_detail_screen.dart';

class EmergencyDetailScreen extends StatefulWidget {
  final EmergencyItem item;

  const EmergencyDetailScreen({super.key, required this.item});

  @override
  State<EmergencyDetailScreen> createState() => _EmergencyDetailScreenState();
}

class _EmergencyDetailScreenState extends State<EmergencyDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Record history
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final historyService = Provider.of<RepairHistoryService>(context, listen: false);
      
      // Use a dummy HomeProblem to record the emergency event in history
      final dummyProblem = HomeProblem(
        id: widget.item.id,
        tradeId: 'emergency',
        titleEs: widget.item.titleEs,
        titleEn: widget.item.titleEn,
        descriptionEs: widget.item.shortDescriptionEs,
        descriptionEn: widget.item.shortDescriptionEn,
        difficulty: Difficulty.hard,
        estimatedMinutes: 0,
        riskLevel: switch (widget.item.dangerLevel) {
          DangerLevel.medium => RiskLevel.medium,
          _ => RiskLevel.high,
        },
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
        problem: dummyProblem,
        eventType: HistoryEventType.emergencyViewed,
      );
    });
  }

  void _goToGuide() {
    if (widget.item.relatedGuideId == null) return;

    try {
      final problem = ProblemsData.all.firstWhere((p) => p.id == widget.item.relatedGuideId);
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

  void _showHelpDialog() {
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

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final lang = AppLocalizations.of(context)!.localeName;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          lang == 'en' ? 'EMERGENCY INSTRUCTIONS' : 'INSTRUCCIONES DE EMERGENCIA', 
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)
        ),
        backgroundColor: item.color,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Danger Header ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: item.color,
              child: Column(
                children: [
                  Icon(item.icon, size: 64, color: Colors.white),
                  const SizedBox(height: 16),
                  Text(
                    item.getTitle(lang),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(50),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item.getDangerLabel(lang),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),

            // --- Main Instructions ---
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Safety Message
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red[100]!),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.security, color: Colors.red[700]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.getSafetyMessage(lang),
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.red[900]),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  _instructionSection(lang == 'en' ? 'WHAT TO DO FIRST:' : 'QUÉ HACER PRIMERO:', item.getDoFirstSteps(lang), Icons.check_circle, Colors.green),
                  const SizedBox(height: 24),
                  _instructionSection(lang == 'en' ? 'WHAT NOT TO DO:' : 'QUÉ NO HACER:', item.getDoNotSteps(lang), Icons.cancel, Colors.red),
                  const SizedBox(height: 24),
                  _instructionSection(lang == 'en' ? 'CALL 911 IF:' : 'LLAMAR AL 911 SI:', item.getCall911Conditions(lang), Icons.emergency, Colors.red[900]!),
                  const SizedBox(height: 24),
                  _instructionSection(lang == 'en' ? 'CALL A TECHNICIAN IF:' : 'LLAMAR A UN TÉCNICO SI:', item.getCallTechnicianConditions(lang), Icons.build, AppTheme.primary),

                  const SizedBox(height: 40),

                  // Actions
                  if (item.relatedGuideId != null) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _goToGuide,
                        icon: const Icon(Icons.menu_book),
                        label: Text('${lang == 'en' ? 'View guide' : 'Ver guía'}: ${item.getRelatedGuideTitle(lang)}'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _showHelpDialog,
                      icon: const Icon(Icons.support_agent),
                      label: Text(l10n.requestTechnician),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(color: Colors.redAccent, width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _instructionSection(String title, List<String> steps, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: color),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...steps.map((step) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Expanded(child: Text(step, style: const TextStyle(fontSize: 15, color: AppTheme.textPrimary))),
                ],
              ),
            )),
      ],
    );
  }
}
