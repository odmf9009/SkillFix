import 'package:flutter/material.dart';
import 'package:skillfix/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../services/maintenance_service.dart';
import '../services/repair_history_service.dart';
import '../models/maintenance_reminder.dart';
import '../models/home_problem.dart';
import '../models/repair_history.dart';
import '../data/maintenance_data.dart';
import '../data/problems_data.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import '../data/seasonal_data.dart';
import '../services/seasonal_service.dart';
import 'add_edit_reminder_screen.dart';
import 'problem_detail_screen.dart';
import 'seasonal_screen.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = l10n.localeName;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.maintenance, style: const TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppTheme.primary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddEditReminderScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<MaintenanceService>(
        builder: (context, maintenanceService, _) {
          if (maintenanceService.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final myReminders = maintenanceService.reminders;
          final suggestions = MaintenanceData.suggestions.where((s) => 
            !myReminders.any((r) => r.id == s.id)
          ).toList();

          return CustomScrollView(
            slivers: [
              // Seasonal banner — always visible at top
            SliverToBoxAdapter(
              child: Consumer<SeasonalService>(
                builder: (context, seasonal, _) =>
                    _SeasonalBanner(seasonal: seasonal, lang: lang),
              ),
            ),

            if (myReminders.isEmpty && suggestions.isEmpty)
              const SliverFillRemaining(
                child: _EmptyState(),
              ),

              if (myReminders.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: _SectionHeader(title: lang == 'en' ? 'My reminders' : 'Mis recordatorios'),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _ReminderCard(reminder: myReminders[index]),
                    childCount: myReminders.length,
                  ),
                ),
              ],

              if (suggestions.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: _SectionHeader(title: lang == 'en' ? 'Suggestions for your home' : 'Sugerencias para tu hogar'),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _SuggestionCard(reminder: suggestions[index]),
                    childCount: suggestions.length,
                  ),
                ),
              ],
              
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditReminderScreen()),
          );
        },
        label: Text(lang == 'en' ? 'Add reminder' : 'Agregar recordatorio'),
        icon: const Icon(Icons.add),
        backgroundColor: AppTheme.primary,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  final MaintenanceReminder reminder;
  const _ReminderCard({required this.reminder});

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!.localeName;
    final now = DateTime.now();
    final isOverdue = reminder.nextDate.isBefore(now) && reminder.isActive;
    final service = Provider.of<MaintenanceService>(context, listen: false);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isOverdue ? Border.all(color: Colors.red.withAlpha(100), width: 2) : null,
        boxShadow: const [
          BoxShadow(color: AppTheme.cardShadow, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (isOverdue ? Colors.red : AppTheme.primary).withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isOverdue ? Icons.priority_high : Icons.calendar_today,
                color: isOverdue ? Colors.red : AppTheme.primary,
                size: 24,
              ),
            ),
            title: Text(
              reminder.getTitle(lang),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  '${reminder.getFrequencyLabel(context)} · ${lang == 'en' ? 'Next' : 'Próximo'}: ${_formatDate(reminder.nextDate)}',
                  style: TextStyle(
                    color: isOverdue ? Colors.red : AppTheme.textSecondary,
                    fontWeight: isOverdue ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                if (isOverdue)
                  Text(lang == 'en' ? 'OVERDUE!' : '¡VENCIDO!', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w900, fontSize: 10)),
              ],
            ),
            trailing: Switch(
              value: reminder.isActive,
              onChanged: (v) => service.toggleActive(reminder.id),
              activeThumbColor: AppTheme.primary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final historyService = Provider.of<RepairHistoryService>(context, listen: false);
                      
                      // Log to history
                      final dummyProblem = HomeProblem(
                        id: reminder.relatedGuideId ?? reminder.id,
                        tradeId: reminder.tradeId,
                        titleEs: reminder.titleEs,
                        titleEn: reminder.titleEn,
                        descriptionEs: reminder.descriptionEs,
                        descriptionEn: reminder.descriptionEn,
                        difficulty: Difficulty.medium,
                        estimatedMinutes: 0,
                        riskLevel: RiskLevel.low,
                        toolsEs: [], toolsEn: [],
                        materialsEs: [], materialsEn: [],
                        stepsEs: [], stepsEn: [],
                        warningsEs: [], warningsEn: [],
                      );
                      
                      historyService.addEntry(
                        problem: dummyProblem,
                        eventType: HistoryEventType.maintenanceCompleted,
                        note: lang == 'en' ? 'Frequency: ${reminder.getFrequencyLabel(context)}' : 'Frecuencia: ${reminder.getFrequencyLabel(context)}',
                      );

                      service.completeReminder(reminder.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(lang == 'en' ? 'Maintenance marked as done' : 'Mantenimiento marcado como hecho')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(lang == 'en' ? 'Done' : 'Hecho'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.more_time, color: AppTheme.textSecondary),
                  onPressed: () => _showPostponeDialog(context, service),
                  tooltip: lang == 'en' ? 'Postpone' : 'Posponer',
                ),
                if (reminder.relatedGuideId != null)
                  IconButton(
                    icon: const Icon(Icons.menu_book, color: AppTheme.primary),
                    onPressed: () => _openGuide(context, reminder.relatedGuideId!),
                    tooltip: lang == 'en' ? 'View guide' : 'Ver guía',
                  ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () {
                    final historyService = Provider.of<RepairHistoryService>(context, listen: false);
                    final dummyProblem = HomeProblem(
                      id: reminder.relatedGuideId ?? reminder.id,
                      tradeId: reminder.tradeId,
                      titleEs: reminder.titleEs,
                      titleEn: reminder.titleEn,
                      descriptionEs: reminder.descriptionEs,
                      descriptionEn: reminder.descriptionEn,
                      difficulty: Difficulty.medium,
                      estimatedMinutes: 0,
                      riskLevel: RiskLevel.low,
                      toolsEs: [], toolsEn: [],
                      materialsEs: [], materialsEn: [],
                      stepsEs: [], stepsEn: [],
                      warningsEs: [], warningsEn: [],
                    );
                    historyService.addEntry(
                      problem: dummyProblem,
                      eventType: HistoryEventType.maintenanceDeleted,
                    );
                    service.deleteReminder(reminder.id);
                  },
                  tooltip: lang == 'en' ? 'Delete' : 'Eliminar',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPostponeDialog(BuildContext context, MaintenanceService service) {
    final lang = AppLocalizations.of(context)!.localeName;
    final historyService = Provider.of<RepairHistoryService>(context, listen: false);
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(lang == 'en' ? 'Postpone maintenance' : 'Posponer mantenimiento', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          ListTile(title: Text(lang == 'en' ? 'Tomorrow' : 'Mañana'), onTap: () { 
            service.postponeReminder(reminder.id, 1); 
            _logPostpone(historyService, 1, lang);
            Navigator.pop(ctx); 
          }),
          ListTile(title: Text(lang == 'en' ? 'In 3 days' : 'En 3 días'), onTap: () { 
            service.postponeReminder(reminder.id, 3); 
            _logPostpone(historyService, 3, lang);
            Navigator.pop(ctx); 
          }),
          ListTile(title: Text(lang == 'en' ? 'In 1 week' : 'En 1 semana'), onTap: () { 
            service.postponeReminder(reminder.id, 7); 
            _logPostpone(historyService, 7, lang);
            Navigator.pop(ctx); 
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _logPostpone(RepairHistoryService historyService, int days, String lang) {
    final dummyProblem = HomeProblem(
      id: reminder.relatedGuideId ?? reminder.id,
      tradeId: reminder.tradeId,
      titleEs: reminder.titleEs,
      titleEn: reminder.titleEn,
      descriptionEs: reminder.descriptionEs,
      descriptionEn: reminder.descriptionEn,
      difficulty: Difficulty.medium,
      estimatedMinutes: 0,
      riskLevel: RiskLevel.low,
      toolsEs: [], toolsEn: [],
      materialsEs: [], materialsEn: [],
      stepsEs: [], stepsEn: [],
      warningsEs: [], warningsEn: [],
    );
    historyService.addEntry(
      problem: dummyProblem,
      eventType: HistoryEventType.maintenancePostponed,
      note: lang == 'en' ? 'Postponed for $days day(s)' : 'Pospuesto por $days día(s)',
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final MaintenanceReminder reminder;
  const _SuggestionCard({required this.reminder});

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!.localeName;
    final service = Provider.of<MaintenanceService>(context, listen: false);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(Icons.lightbulb_outline, color: Colors.orange[400]),
        title: Text(reminder.getTitle(lang), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        subtitle: Text('${lang == 'en' ? 'Suggested' : 'Sugerido'}: ${reminder.getFrequencyLabel(context)}', style: const TextStyle(fontSize: 12)),
        trailing: TextButton(
          onPressed: () {
            service.addReminder(reminder);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(lang == 'en' ? 'Reminder activated' : 'Recordatorio activado')),
            );
          },
          child: Text(lang == 'en' ? 'Activate' : 'Activar'),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = l10n.localeName;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 80, color: Colors.grey[200]),
            const SizedBox(height: 16),
            Text(
              l10n.noRemindersYet,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              lang == 'en'
                ? 'Add reminders to keep your home in good condition and avoid problems.'
                : 'Agrega recordatorios para mantener tu casa en buen estado y evitar problemas.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddEditReminderScreen()),
                );
              },
              icon: const Icon(Icons.add),
              label: Text(lang == 'en' ? 'Create my first reminder' : 'Crear mi primer recordatorio'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}

class _SeasonalBanner extends StatelessWidget {
  final SeasonalService seasonal;
  final String lang;
  const _SeasonalBanner({required this.seasonal, required this.lang});

  @override
  Widget build(BuildContext context) {
    final season = SeasonalData.currentSeason;
    final color = SeasonalData.colorFor(season);
    final completed = seasonal.completedCount(season);
    final total = seasonal.totalCount(season);
    final prog = seasonal.progress(season);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SeasonalScreen()),
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: color.withAlpha(80), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Text(SeasonalData.emojiFor(season), style: const TextStyle(fontSize: 36)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang == 'en' ? 'Seasonal Checklist' : 'Checklist Estacional',
                    style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    lang == 'en' ? SeasonalData.nameEn(season) : SeasonalData.nameEs(season),
                    style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: prog,
                      minHeight: 6,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$completed / $total ${lang == 'en' ? 'tasks completed' : 'tareas completadas'}',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, color: Colors.white60, size: 16),
          ],
        ),
      ),
    );
  }
}

void _openGuide(BuildContext context, String guideId) {
  final lang = AppLocalizations.of(context)!.localeName;
  try {
    final problem = ProblemsData.all.firstWhere((p) => p.id == guideId);
    final trade = MockData.trades.firstWhere((t) => t.id == problem.tradeId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProblemDetailScreen(problem: problem, tradeColor: trade.color),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(lang == 'en' ? 'Guide not available' : 'Guía no disponible')));
  }
}
