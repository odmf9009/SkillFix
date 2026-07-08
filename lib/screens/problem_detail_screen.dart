import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import '../data/diagnostic_data.dart';
import '../models/home_problem.dart';
import '../models/diagnostic.dart';
import '../models/shopping_list.dart';
import '../models/repair_history.dart';
import '../services/favorites_service.dart';
import '../services/shopping_list_service.dart';
import '../services/repair_history_service.dart';
import '../theme/app_theme.dart';
import 'diagnostic_screen.dart';
import 'shopping_list_detail_screen.dart';
import 'add_edit_reminder_screen.dart';
import 'package:skillfix/l10n/app_localizations.dart';

class ProblemDetailScreen extends StatefulWidget {
  final HomeProblem problem;
  final Color tradeColor;

  const ProblemDetailScreen({
    super.key,
    required this.problem,
    required this.tradeColor,
  });

  @override
  State<ProblemDetailScreen> createState() => _ProblemDetailScreenState();
}

class _ProblemDetailScreenState extends State<ProblemDetailScreen> {
  late List<bool> _checkedSteps;

  bool get _hasVideo => widget.problem.getYoutubeId(AppLocalizations.of(context)!.localeName).isNotEmpty;

  @override
  void initState() {
    super.initState();
    _checkedSteps = List.filled(widget.problem.stepsEs.length, false);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RepairHistoryService>(context, listen: false).addEntry(
        problem: widget.problem,
        eventType: HistoryEventType.viewed,
      );
    });
  }

  Future<void> _openInYouTube() async {
    final lang = AppLocalizations.of(context)!.localeName;
    final url = Uri.parse(
        'https://www.youtube.com/watch?v=${widget.problem.getYoutubeId(lang)}');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.errorOpeningYoutube)),
        );
      }
    }
  }

  void _showHelpDialog() {
    Provider.of<RepairHistoryService>(context, listen: false).addEntry(
      problem: widget.problem,
      eventType: HistoryEventType.technicianRequested,
    );
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.handyman, color: widget.tradeColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.requestTechnician,
                style: const TextStyle(fontSize: 17),
              ),
            ),
          ],
        ),
        content: Text(
          AppLocalizations.of(context)!.soonFixRadar,
          style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              AppLocalizations.of(context)!.understood,
              style: TextStyle(color: widget.tradeColor),
            ),
          ),
        ],
      ),
    );
  }

  void _createShoppingList() {
    final shoppingService = Provider.of<ShoppingListService>(context, listen: false);
    final existingList = shoppingService.getListForGuide(widget.problem.id);

    if (existingList != null) {
      final lang = AppLocalizations.of(context)!.localeName;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(lang == 'en' ? 'This guide already has a shopping list' : 'Esta guía ya tiene una lista de compras'),
          action: SnackBarAction(
            label: lang == 'en' ? 'See list' : 'Ver lista',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ShoppingListDetailScreen(list: existingList)),
              );
            },
          ),
        ),
      );
      return;
    }

    // Crear nueva lista
    final List<ShoppingItem> items = [];
    final lang = AppLocalizations.of(context)!.localeName;
    
    for (var tool in widget.problem.getTools(lang)) {
      items.add(ShoppingItem(
        id: Uuid().v4(),
        name: tool,
        category: ItemCategory.tool,
      ));
    }

    for (var material in widget.problem.getMaterials(lang)) {
      items.add(ShoppingItem(
        id: Uuid().v4(),
        name: material,
        category: ItemCategory.material,
      ));
    }

    final newList = ShoppingList(
      id: Uuid().v4(),
      guideId: widget.problem.id,
      guideTitle: widget.problem.getTitle(lang),
      tradeId: widget.problem.tradeId,
      createdAt: DateTime.now(),
      items: items,
    );

    shoppingService.addList(newList);

    Provider.of<RepairHistoryService>(context, listen: false).addEntry(
      problem: widget.problem,
      eventType: HistoryEventType.shoppingListCreated,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(lang == 'en' ? 'Shopping list created' : 'Lista de compras creada'),
        action: SnackBarAction(
          label: lang == 'en' ? 'See list' : 'Ver lista',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ShoppingListDetailScreen(list: newList)),
            );
          },
        ),
      ),
    );
  }

  void _evaluateMyCase() {
    // Try to find a diagnostic flow for this trade or specific problem
    try {
      final List<DiagnosticFlow> flows = DiagnosticData.flows;
      
      // 1. Try to find by specific guide ID
      DiagnosticFlow? foundFlow;
      for (final f in flows) {
        if (f.relatedGuideId == widget.problem.id) {
          foundFlow = f;
          break;
        }
      }

      if (foundFlow != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DiagnosticScreen(flow: foundFlow!)),
        );
      } else {
        // No specific diagnostic for this guide
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.localeName == 'en' 
              ? 'Assessment not available for this guide yet.' 
              : 'Todavía no hay evaluación disponible para esta guía.'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error finding diagnostic flow: $e');
    }
  }

  void _toggleCompleted() {
    final historyService = Provider.of<RepairHistoryService>(context, listen: false);
    final isCompleted = historyService.isGuideCompleted(widget.problem.id);
    final lang = AppLocalizations.of(context)!.localeName;

    if (isCompleted) {
      historyService.removeAsCompleted(widget.problem.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lang == 'en' ? 'Completed status removed' : 'Estado completado eliminado')),
      );
    } else {
      historyService.markAsCompleted(widget.problem.id, widget.problem);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lang == 'en' ? 'Guide marked as completed' : 'Guía marcada como completada')),
      );
    }
  }

  void _createReminder() {
    final lang = AppLocalizations.of(context)!.localeName;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditReminderScreen(
          initialTitle: widget.problem.getTitle(lang),
          relatedGuideId: widget.problem.id,
          relatedGuideTitle: widget.problem.getTitle(lang),
        ),
      ),
    );
  }

  int get _completedSteps =>
      _checkedSteps.where((c) => c).length;

  @override
  Widget build(BuildContext context) {
    final problem = widget.problem;

    final lang = AppLocalizations.of(context)!.localeName;

    Widget body = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---- Título ----
                Text(
                  problem.getTitle(lang),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  problem.getDescription(lang),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),

                const SizedBox(height: 16),

                // ---- Chips de metadata ----
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _metaChip(
                      Icons.signal_cellular_alt,
                      problem.getDifficultyLabel(context),
                      problem.difficultyColor,
                    ),
                    _metaChip(
                      Icons.schedule,
                      '${problem.estimatedMinutes} min',
                      AppTheme.primary,
                    ),
                    _metaChip(
                      Icons.warning_amber_rounded,
                      '${AppLocalizations.of(context)!.risk} ${problem.getRiskLabel(context)}',
                      problem.riskColor,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ---- Evaluación DIY ----
                _diyEvaluationSection(problem.getEffectiveDiyEvaluation(lang)),

                const SizedBox(height: 24),

                // ---- Advertencia de seguridad ----
                _warningsSection(problem.getWarnings(lang)),

                const SizedBox(height: 24),

                // ---- Herramientas ----
                if (problem.getTools(lang).isNotEmpty) ...[
                  _sectionTitle(AppLocalizations.of(context)!.toolsNeeded, Icons.hardware),
                  const SizedBox(height: 10),
                  _itemList(problem.getTools(lang), Icons.build_circle_outlined,
                      widget.tradeColor),
                  const SizedBox(height: 24),
                ],

                // ---- Materiales ----
                if (problem.getMaterials(lang).isNotEmpty) ...[
                  _sectionTitle(AppLocalizations.of(context)!.materialsNeeded, Icons.inventory_2_outlined),
                  const SizedBox(height: 10),
                  _itemList(problem.getMaterials(lang), Icons.check_box_outline_blank,
                      widget.tradeColor),
                  const SizedBox(height: 24),
                ],

                // ---- Checklist paso a paso ----
                _sectionTitle(
                  '${AppLocalizations.of(context)!.stepsToFollow} ($_completedSteps/${problem.getSteps(lang).length})',
                  Icons.checklist_rounded,
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: problem.getSteps(lang).isEmpty
                      ? 0
                      : _completedSteps / problem.getSteps(lang).length,
                  color: widget.tradeColor,
                  backgroundColor: widget.tradeColor.withAlpha(40),
                  borderRadius: BorderRadius.circular(4),
                  minHeight: 5,
                ),
                const SizedBox(height: 12),
                _stepsChecklist(problem.getSteps(lang)),

                const SizedBox(height: 24),

                // ---- Botones de acción ----
                Consumer<RepairHistoryService>(
                  builder: (context, historyService, _) {
                    final isCompleted = historyService.isGuideCompleted(problem.id);
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _toggleCompleted,
                        icon: Icon(isCompleted ? Icons.check_circle : Icons.check_circle_outline),
                        label: Text(isCompleted ? AppLocalizations.of(context)!.alreadyCompleted : AppLocalizations.of(context)!.markAsCompleted),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: isCompleted ? Colors.green : Colors.grey[200],
                          foregroundColor: isCompleted ? Colors.white : AppTheme.textPrimary,
                          elevation: isCompleted ? 2 : 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                if (problem.getTools(lang).isNotEmpty || problem.getMaterials(lang).isNotEmpty) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _createShoppingList,
                      icon: const Icon(Icons.add_shopping_cart),
                      label: Text(AppLocalizations.of(context)!.createShoppingList),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: widget.tradeColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // ---- Botón: Crear recordatorio ----
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _createReminder,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(AppLocalizations.of(context)!.localeName == 'en' ? 'Create maintenance reminder' : 'Crear recordatorio de mantenimiento'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      foregroundColor: AppTheme.primary,
                      side: const BorderSide(color: AppTheme.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                if (_hasVideo) ...[
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _openInYouTube,
                      icon: const Icon(Icons.open_in_new),
                      label: Text(AppLocalizations.of(context)!.watchOnYoutube),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        foregroundColor: widget.tradeColor,
                        side: BorderSide(color: widget.tradeColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _showHelpDialog,
                    icon: const Icon(Icons.support_agent),
                    label: Text(AppLocalizations.of(context)!.couldNotFixIt),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: const Color(0xFFE53935),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: widget.tradeColor,
        leading: const BackButton(color: Colors.white),
        title: Text(
          problem.getTitle(lang),
          style: const TextStyle(fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          Consumer<FavoritesService>(
            builder: (context, favService, _) {
              final isFav = favService.isFavorite(problem.id);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (!isFav) {
                    Provider.of<RepairHistoryService>(context, listen: false).addEntry(
                      problem: widget.problem,
                      eventType: HistoryEventType.favoriteAdded,
                    );
                  }
                  favService.toggle(problem.id);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isFav
                          ? AppLocalizations.of(context)!.removedFromFavorites
                          : AppLocalizations.of(context)!.savedToFavorites),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: body,
    );
  }

  Widget _metaChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: widget.tradeColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _itemList(List<String> items, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: AppTheme.cardShadow,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _stepsChecklist(List<String> steps) {
    return Column(
      children: List.generate(steps.length, (i) {
        final checked = _checkedSteps[i];
        return GestureDetector(
          onTap: () => setState(() => _checkedSteps[i] = !_checkedSteps[i]),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: checked
                  ? widget.tradeColor.withAlpha(18)
                  : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: checked
                    ? widget.tradeColor.withAlpha(80)
                    : Colors.transparent,
              ),
              boxShadow: checked
                  ? []
                  : const [
                      BoxShadow(
                        color: AppTheme.cardShadow,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: checked
                        ? widget.tradeColor
                        : widget.tradeColor.withAlpha(30),
                  ),
                  child: checked
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : Center(
                          child: Text(
                            '${i + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: widget.tradeColor,
                            ),
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    steps[i],
                    style: TextStyle(
                      fontSize: 14,
                      color: checked
                          ? AppTheme.textSecondary
                          : AppTheme.textPrimary,
                      decoration: checked
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _warningsSection(List<String> warnings) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFF8F00).withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: Color(0xFFE65100), size: 18),
              SizedBox(width: 6),
              Text(
                'Advertencias de seguridad',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFE65100),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...warnings.map((w) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ',
                        style: TextStyle(
                            color: Color(0xFFE65100),
                            fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Text(
                        w,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6D4C41),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _diyEvaluationSection(DiyEvaluation diy) {
    final lang = AppLocalizations.of(context)!.localeName;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: diy.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: diy.textColor.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(diy.icon, color: diy.textColor, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '¿Puedo hacerlo yo o necesito técnico?',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    Text(
                      diy.getTitleLabel(context),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: diy.textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            diy.getSummary(lang),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _diyList(lang == 'en' ? 'You can try if...' : 'Puedes intentarlo si...', diy.getCanDoYourselfConditions(lang),
              Icons.check, diy.textColor),
          const SizedBox(height: 12),
          _diyList(lang == 'en' ? 'Better call a technician if...' : 'Mejor llama a un técnico si...', diy.getCallTechnicianConditions(lang),
              Icons.close, Colors.redAccent),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(150),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.psychology, size: 16, color: AppTheme.textSecondary),
                    const SizedBox(width: 8),
                    Text(
                      '${lang == 'en' ? 'Experience' : 'Experiencia'}: ${diy.getRequiredExperience(lang)}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${lang == 'en' ? 'Reminder' : 'Recordatorio'}: ${diy.getSafetyReminder(lang)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            diy.getFinalRecommendation(lang),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: diy.textColor,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: _evaluateMyCase,
              icon: const Icon(Icons.quiz_outlined),
              label: Text(AppLocalizations.of(context)!.evaluateMyCase),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: AppTheme.primary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _diyList(String title, List<String> items, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 14, color: color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
