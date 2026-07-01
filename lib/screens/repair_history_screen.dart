import 'package:flutter/material.dart';
import 'package:skillfix/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../services/repair_history_service.dart';
import '../models/repair_history.dart';
import '../models/home_problem.dart';
import '../data/problems_data.dart';
import '../data/emergency_data.dart';
import '../data/calculators_data.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import 'problem_detail_screen.dart';
import 'emergency_detail_screen.dart';
import 'calculator_detail_screen.dart';
import '../models/emergency.dart';
import '../models/calculator_tool.dart';

class RepairHistoryScreen extends StatefulWidget {
  const RepairHistoryScreen({super.key});

  @override
  State<RepairHistoryScreen> createState() => _RepairHistoryScreenState();
}

class _RepairHistoryScreenState extends State<RepairHistoryScreen> {
  String _selectedFilter = 'Todos';

  List<String> _getFilters(BuildContext context) {
    final lang = AppLocalizations.of(context)!.localeName;
    if (lang == 'en') {
      return [
        'All',
        'Views',
        'Completed',
        'Favorites',
        'Shopping list',
        'Diagnostics',
        'Help requested',
      ];
    }
    return [
      'Todos',
      'Vistas',
      'Completadas',
      'Favoritos',
      'Lista de compras',
      'Diagnósticos',
      'Ayuda solicitada',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filters = _getFilters(context);
    
    // Adjust _selectedFilter if it doesn't match the new language's filters
    // This is a simple way to handle language change on this screen
    if (!filters.contains(_selectedFilter)) {
       _selectedFilter = filters.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.history, style: const TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          _buildFilters(filters),
          Expanded(
            child: Consumer<RepairHistoryService>(
              builder: (context, historyService, _) {
                if (historyService.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final filteredHistory = _applyFilters(historyService.history);

                if (filteredHistory.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildHistoryList(filteredHistory);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(List<String> filters) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (v) => setState(() => _selectedFilter = filter),
              selectedColor: AppTheme.primary.withAlpha(50),
              checkmarkColor: AppTheme.primary,
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                fontSize: 12,
              ),
              backgroundColor: Colors.grey[100],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          );
        },
      ),
    );
  }

  List<RepairHistoryEntry> _applyFilters(List<RepairHistoryEntry> history) {
    var result = history;
    final lang = AppLocalizations.of(context)!.localeName;

    if (_selectedFilter != 'Todos' && _selectedFilter != 'All') {
      result = result.where((e) {
        if (lang == 'en') {
          return switch (_selectedFilter) {
            'Views' => e.eventType == HistoryEventType.viewed,
            'Completed' => e.eventType == HistoryEventType.completed,
            'Favorites' => e.eventType == HistoryEventType.favoriteAdded,
            'Shopping list' => e.eventType == HistoryEventType.shoppingListCreated,
            'Diagnostics' => e.eventType == HistoryEventType.diagnosticCompleted,
            'Help requested' => e.eventType == HistoryEventType.technicianRequested,
            _ => true,
          };
        }
        return switch (_selectedFilter) {
          'Vistas' => e.eventType == HistoryEventType.viewed,
          'Completadas' => e.eventType == HistoryEventType.completed,
          'Favoritos' => e.eventType == HistoryEventType.favoriteAdded,
          'Lista de compras' => e.eventType == HistoryEventType.shoppingListCreated,
          'Diagnósticos' => e.eventType == HistoryEventType.diagnosticCompleted,
          'Ayuda solicitada' => e.eventType == HistoryEventType.technicianRequested,
          _ => true,
        };
      }).toList();
    }

    return result;
  }

  Widget _buildHistoryList(List<RepairHistoryEntry> history) {
    // Group by date
    final Map<String, List<RepairHistoryEntry>> grouped = {};
    for (var entry in history) {
      final dateStr = _getDateGroupLabel(entry.date);
      if (!grouped.containsKey(dateStr)) {
        grouped[dateStr] = [];
      }
      grouped[dateStr]!.add(entry);
    }

    final groups = grouped.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final groupLabel = groups[index];
        final entries = grouped[groupLabel]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              child: Text(
                groupLabel,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            ...entries.map((e) => _HistoryItemCard(entry: e)),
          ],
        );
      },
    );
  }

  String _getDateGroupLabel(DateTime date) {
    final lang = AppLocalizations.of(context)!.localeName;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final entryDate = DateTime(date.year, date.month, date.day);

    if (entryDate == today) return lang == 'en' ? 'Today' : 'Hoy';
    if (entryDate == yesterday) return lang == 'en' ? 'Yesterday' : 'Ayer';
    
    final diff = today.difference(entryDate).inDays;
    if (diff < 7) return lang == 'en' ? 'This week' : 'Esta semana';
    if (diff < 30) return lang == 'en' ? 'This month' : 'Este mes';
    
    return '${_getMonthName(date.month, lang)} ${date.year}';
  }

  String _getMonthName(int month, String lang) {
    if (lang == 'en') {
      const months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      return months[month - 1];
    }
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return months[month - 1];
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    final lang = l10n.localeName;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              l10n.noHistoryYet,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              lang == 'en'
                ? 'Open a guide, create a shopping list or mark a repair as completed to see it here.'
                : 'Abre una guía, crea una lista de compras o marca una reparación como completada para verla aquí.',
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
}

class _HistoryItemCard extends StatelessWidget {
  final RepairHistoryEntry entry;

  const _HistoryItemCard({required this.entry});

  dynamic _getContent(String lang) {
    // 1. Try problems
    try {
      return ProblemsData.all.firstWhere((p) => p.id == entry.guideId);
    } catch (_) {}

    // 2. Try emergencies
    try {
      return EmergencyData.items.firstWhere((e) => e.id == entry.guideId);
    } catch (_) {}

    // 3. Try calculators
    try {
      return CalculatorsData.tools.firstWhere((c) => c.id == entry.guideId);
    } catch (_) {}

    // 4. Fallback search by title
    final matches = ProblemsData.all.where((p) => p.getTitle(lang).toLowerCase() == entry.guideTitle.toLowerCase()).toList();
    if (matches.isNotEmpty) {
      if (matches.length == 1) return matches.first;
      try {
        return matches.firstWhere((p) => p.tradeId == entry.tradeId);
      } catch (_) {
        return matches.first;
      }
    }

    // 5. Try emergencies by title
    try {
      return EmergencyData.items.firstWhere((e) => e.getTitle(lang).toLowerCase() == entry.guideTitle.toLowerCase());
    } catch (_) {}

    return null;
  }

  void _openGuide(BuildContext context) {
    final lang = AppLocalizations.of(context)!.localeName;
    final content = _getContent(lang);

    if (content == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(lang == 'en' ? 'Guide not found. It may have been deleted or updated.' : 'No se encontró esta guía. Puede haber sido eliminada o actualizada.'),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    if (content is HomeProblem) {
      Color tradeColor = AppTheme.primary;
      try {
        tradeColor = MockData.trades.firstWhere((t) => t.id == content.tradeId).color;
      } catch (_) {}
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProblemDetailScreen(
            problem: content,
            tradeColor: tradeColor,
          ),
        ),
      );
    } else if (content is EmergencyItem) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EmergencyDetailScreen(item: content),
        ),
      );
    } else if (content is CalculatorTool) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CalculatorDetailScreen(tool: content),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!.localeName;
    final historyService = Provider.of<RepairHistoryService>(context, listen: false);
    final timeStr = '${entry.date.hour.toString().padLeft(2, '0')}:${entry.date.minute.toString().padLeft(2, '0')}';
    final content = _getContent(lang);
    final hasContent = content != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppTheme.cardShadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: entry.color.withAlpha(30),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(entry.icon, color: entry.color, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.guideTitle,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              '${_getEventLabel(entry.eventType, lang)} · $timeStr',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: entry.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                        onPressed: () => historyService.deleteEntry(entry.id),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _detailInfo(Icons.signal_cellular_alt, _getDifficultyLabel(entry.difficulty, lang)),
                      const SizedBox(width: 12),
                      _detailInfo(Icons.warning_amber_rounded, '${lang == 'en' ? 'Risk' : 'Riesgo'} ${_getRiskLabel(entry.riskLevel, lang)}'),
                      const SizedBox(width: 12),
                      _detailInfo(Icons.schedule, '${entry.estimatedMinutes} min'),
                    ],
                  ),
                  if (entry.note != null && entry.note!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Text(
                        entry.note!,
                        style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[100]!)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: hasContent ? () => _openGuide(context) : null,
                      icon: Icon(
                        hasContent ? Icons.open_in_new : Icons.link_off,
                        size: 16,
                      ),
                      label: Text(hasContent ? (lang == 'en' ? 'Open guide' : 'Abrir guía') : (lang == 'en' ? 'Guide not available' : 'Guía no disponible')),
                      style: TextButton.styleFrom(
                        foregroundColor: hasContent ? AppTheme.primary : Colors.grey,
                      ),
                    ),
                  ),
                  Container(width: 1, height: 30, color: Colors.grey[100]),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => _showNoteDialog(context, historyService),
                      icon: Icon(entry.note == null ? Icons.add_comment : Icons.edit_note, size: 16),
                      label: Text(entry.note == null ? (lang == 'en' ? 'Note' : 'Nota') : (lang == 'en' ? 'Edit note' : 'Editar nota')),
                      style: TextButton.styleFrom(foregroundColor: AppTheme.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getEventLabel(HistoryEventType type, String lang) {
    if (lang == 'en') {
       return switch (type) {
        HistoryEventType.viewed => 'Viewed',
        HistoryEventType.started => 'Started',
        HistoryEventType.completed => 'Completed',
        HistoryEventType.favoriteAdded => 'Added to Favorites',
        HistoryEventType.shoppingListCreated => 'Shopping List Created',
        HistoryEventType.diagnosticCompleted => 'Diagnosis Completed',
        HistoryEventType.emergencyViewed => 'Emergency Viewed',
        HistoryEventType.technicianRequested => 'Technician Requested',
        HistoryEventType.maintenanceReminderCreated => 'Reminder Created',
        HistoryEventType.maintenanceCompleted => 'Maintenance Completed',
        HistoryEventType.maintenancePostponed => 'Maintenance Postponed',
        HistoryEventType.maintenanceDeleted => 'Reminder Deleted',
        HistoryEventType.calculatorUsed => 'Calculator Used',
      };
    }
    return switch (type) {
      HistoryEventType.viewed => 'Vista',
      HistoryEventType.started => 'Empezada',
      HistoryEventType.completed => 'Completada',
      HistoryEventType.favoriteAdded => 'En Favoritos',
      HistoryEventType.shoppingListCreated => 'Lista de compras',
      HistoryEventType.diagnosticCompleted => 'Diagnóstico',
      HistoryEventType.emergencyViewed => 'Emergencia',
      HistoryEventType.technicianRequested => 'Ayuda solicitada',
      HistoryEventType.maintenanceReminderCreated => 'Recordatorio creado',
      HistoryEventType.maintenanceCompleted => 'Mantenimiento realizado',
      HistoryEventType.maintenancePostponed => 'Mantenimiento pospuesto',
      HistoryEventType.maintenanceDeleted => 'Recordatorio eliminado',
      HistoryEventType.calculatorUsed => 'Calculadora usada',
    };
  }

  String _getDifficultyLabel(Difficulty d, String lang) {
     if (lang == 'en') {
       return switch (d) {
        Difficulty.easy => 'Easy',
        Difficulty.medium => 'Medium',
        Difficulty.hard => 'Hard',
      };
    }
    return switch (d) {
      Difficulty.easy => 'Fácil',
      Difficulty.medium => 'Media',
      Difficulty.hard => 'Difícil',
    };
  }

  String _getRiskLabel(RiskLevel r, String lang) {
    if (lang == 'en') {
       return switch (r) {
        RiskLevel.low => 'Low',
        RiskLevel.medium => 'Medium',
        RiskLevel.high => 'High',
      };
    }
    return switch (r) {
      RiskLevel.low => 'Bajo',
      RiskLevel.medium => 'Medio',
      RiskLevel.high => 'Alto',
    };
  }

  Widget _detailInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: AppTheme.textSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  void _showNoteDialog(BuildContext context, RepairHistoryService service) {
    final lang = AppLocalizations.of(context)!.localeName;
    final controller = TextEditingController(text: entry.note);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(lang == 'en' ? 'Repair note' : 'Nota de reparación'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: lang == 'en' ? 'e.g. Bought the outlet at Home Depot' : 'Ej: Compré el tomacorriente en Home Depot'),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(lang == 'en' ? 'Cancel' : 'Cancelar')),
          ElevatedButton(
            onPressed: () {
              service.updateNote(entry.id, controller.text);
              Navigator.pop(ctx);
            },
            child: Text(lang == 'en' ? 'Save' : 'Guardar'),
          ),
        ],
      ),
    );
  }
}
