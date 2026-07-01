import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skillfix/l10n/app_localizations.dart';
import '../models/seasonal_checklist.dart';
import '../data/seasonal_data.dart';
import '../services/seasonal_service.dart';
import '../theme/app_theme.dart';

class SeasonalScreen extends StatefulWidget {
  const SeasonalScreen({super.key});

  @override
  State<SeasonalScreen> createState() => _SeasonalScreenState();
}

class _SeasonalScreenState extends State<SeasonalScreen>
    with TickerProviderStateMixin {
  late final TabController _tab;

  static const _seasons = [
    Season.spring,
    Season.summer,
    Season.fall,
    Season.winter,
  ];

  @override
  void initState() {
    super.initState();
    final initial = _seasons.indexOf(SeasonalData.currentSeason);
    _tab = TabController(length: 4, vsync: this, initialIndex: initial);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!.localeName;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          lang == 'en' ? 'Seasonal Checklist' : 'Checklist Estacional',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        bottom: TabBar(
          controller: _tab,
          labelColor: AppTheme.primary,
          unselectedLabelColor: AppTheme.textSecondary,
          indicatorColor: AppTheme.primary,
          tabs: [
            _SeasonTab(emoji: '🌸', label: lang == 'en' ? 'Spring' : 'Primavera'),
            _SeasonTab(emoji: '☀️', label: lang == 'en' ? 'Summer' : 'Verano'),
            _SeasonTab(emoji: '🍂', label: lang == 'en' ? 'Fall' : 'Otoño'),
            _SeasonTab(emoji: '❄️', label: lang == 'en' ? 'Winter' : 'Invierno'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: _seasons
            .map((s) => _SeasonPage(season: s))
            .toList(),
      ),
    );
  }
}

class _SeasonTab extends StatelessWidget {
  final String emoji;
  final String label;
  const _SeasonTab({required this.emoji, required this.label});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

// ── Season page ──────────────────────────────────────────────────────────────

class _SeasonPage extends StatelessWidget {
  final Season season;
  const _SeasonPage({required this.season});

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!.localeName;

    return Consumer<SeasonalService>(
      builder: (context, service, _) {
        final tasks = SeasonalData.tasksFor(season);
        final completed = service.completedCount(season);
        final total = tasks.length;
        final prog = service.progress(season);
        final color = SeasonalData.colorFor(season);

        return Column(
          children: [
            // Progress card
            _ProgressCard(
              season: season,
              completed: completed,
              total: total,
              progress: prog,
              color: color,
              lang: lang,
              onReset: () => _confirmReset(context, service, lang),
            ),

            // Task list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                children: _buildList(context, tasks, service, lang, color),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildList(
    BuildContext context,
    List<SeasonalTask> tasks,
    SeasonalService service,
    String lang,
    Color color,
  ) {
    final widgets = <Widget>[];
    String? lastCat;

    for (final task in tasks) {
      final cat = lang == 'en' ? task.categoryEn : task.categoryEs;
      if (cat != lastCat) {
        if (lastCat != null) widgets.add(const SizedBox(height: 12));
        widgets.add(_CategoryHeader(label: cat));
        lastCat = cat;
      }
      widgets.add(_TaskTile(
        task: task,
        isDone: service.isTaskDone(season, task.id),
        accentColor: color,
        lang: lang,
        onToggle: () => service.toggleTask(season, task.id),
      ));
    }

    return widgets;
  }

  void _confirmReset(BuildContext context, SeasonalService service, String lang) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(lang == 'en' ? 'Reset checklist?' : '¿Reiniciar checklist?'),
        content: Text(
          lang == 'en'
              ? 'This will uncheck all tasks for this season.'
              : 'Se desmarcarán todas las tareas de esta temporada.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(lang == 'en' ? 'Cancel' : 'Cancelar'),
          ),
          TextButton(
            onPressed: () {
              service.resetSeason(season);
              Navigator.pop(ctx);
            },
            child: Text(
              lang == 'en' ? 'Reset' : 'Reiniciar',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widgets ──────────────────────────────────────────────────────────────────

class _ProgressCard extends StatelessWidget {
  final Season season;
  final int completed;
  final int total;
  final double progress;
  final Color color;
  final String lang;
  final VoidCallback onReset;

  const _ProgressCard({
    required this.season,
    required this.completed,
    required this.total,
    required this.progress,
    required this.color,
    required this.lang,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = completed == total;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                SeasonalData.emojiFor(season),
                style: const TextStyle(fontSize: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lang == 'en'
                          ? SeasonalData.nameEn(season)
                          : SeasonalData.nameEs(season),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      isDone
                          ? (lang == 'en' ? '✓ All done!' : '✓ ¡Todo listo!')
                          : '$completed / $total ${lang == 'en' ? 'tasks' : 'tareas'}',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white60),
                tooltip: lang == 'en' ? 'Reset' : 'Reiniciar',
                onPressed: onReset,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  final String label;
  const _CategoryHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 6, left: 4),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: AppTheme.textSecondary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  final SeasonalTask task;
  final bool isDone;
  final Color accentColor;
  final String lang;
  final VoidCallback onToggle;

  const _TaskTile({
    required this.task,
    required this.isDone,
    required this.accentColor,
    required this.lang,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final title = lang == 'en' ? task.titleEn : task.titleEs;

    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isDone ? Colors.green.withAlpha(80) : Colors.grey.withAlpha(40),
        ),
      ),
      color: isDone ? Colors.green.withAlpha(12) : Colors.white,
      child: CheckboxListTile(
        value: isDone,
        onChanged: (_) => onToggle(),
        activeColor: Colors.green,
        checkColor: Colors.white,
        controlAffinity: ListTileControlAffinity.leading,
        dense: true,
        title: Row(
          children: [
            if (task.isHighPriority && !isDone) ...[
              const Icon(Icons.priority_high, size: 14, color: Colors.red),
              const SizedBox(width: 2),
            ],
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  decoration: isDone ? TextDecoration.lineThrough : null,
                  color: isDone ? AppTheme.textSecondary : AppTheme.textPrimary,
                  fontWeight: task.isHighPriority && !isDone
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
