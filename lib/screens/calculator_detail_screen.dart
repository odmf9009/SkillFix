import 'package:flutter/material.dart';
import 'package:skillfix/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/calculator_tool.dart';
import '../models/home_problem.dart';
import '../models/shopping_list.dart';
import '../models/repair_history.dart';
import '../services/shopping_list_service.dart';
import '../services/repair_history_service.dart';
import '../data/problems_data.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import 'problem_detail_screen.dart';
import 'add_edit_reminder_screen.dart';
import 'shopping_list_detail_screen.dart';

class CalculatorDetailScreen extends StatefulWidget {
  final CalculatorTool tool;
  const CalculatorDetailScreen({super.key, required this.tool});

  @override
  State<CalculatorDetailScreen> createState() => _CalculatorDetailScreenState();
}

class _CalculatorDetailScreenState extends State<CalculatorDetailScreen> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, double> _inputs = {};
  Map<String, double>? _results;

  @override
  void initState() {
    super.initState();
    for (var field in widget.tool.fields) {
      if (field.type == CalculatorFieldType.number) {
        _controllers[field.key] = TextEditingController(text: field.defaultValue.toString());
        _inputs[field.key] = field.defaultValue;
      } else {
        _inputs[field.key] = field.defaultValue;
      }
    }
  }

  @override
  void dispose() {
    for (var c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _calculate() {
    final lang = AppLocalizations.of(context)!.localeName;

    // Update inputs from controllers
    for (var field in widget.tool.fields) {
      if (field.type == CalculatorFieldType.number) {
        final val = double.tryParse(_controllers[field.key]!.text) ?? 0;
        _inputs[field.key] = val;
      }
    }

    setState(() {
      _results = widget.tool.calculate(_inputs);
    });

    // Record to history
    final historyService = Provider.of<RepairHistoryService>(context, listen: false);
    final dummyProblem = HomeProblem(
      id: widget.tool.relatedGuideId ?? widget.tool.id,
      tradeId: widget.tool.tradeId,
      titleEs: widget.tool.titleEs,
      titleEn: widget.tool.titleEn,
      descriptionEs: widget.tool.descriptionEs,
      descriptionEn: widget.tool.descriptionEn,
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
      eventType: HistoryEventType.calculatorUsed,
      note: 'Result: ${_formatResult(widget.tool.getResultTemplate(lang)).replaceAll('\n', ' ')}',
    );
  }

  String _formatResult(String template) {
    if (_results == null) return '';
    String text = template;
    _results!.forEach((key, value) {
      String valStr;
      if (value == value.toInt().toDouble()) {
        valStr = value.toInt().toString();
      } else {
        valStr = value.toStringAsFixed(2).replaceAll(RegExp(r'\.00$'), '');
      }
      text = text.replaceAll('{$key}', valStr);
    });
    return text;
  }

  void _createShoppingList() {
    if (_results == null) return;
    
    final lang = AppLocalizations.of(context)!.localeName;
    final shoppingService = Provider.of<ShoppingListService>(context, listen: false);
    final List<ShoppingItem> items = [];
    
    for (var itemName in widget.tool.getShoppingItems(lang)) {
      items.add(ShoppingItem(
        id: const Uuid().v4(),
        name: itemName,
        category: ItemCategory.material,
      ));
    }

    final newList = ShoppingList(
      id: const Uuid().v4(),
      guideId: widget.tool.id,
      guideTitle: '${lang == 'en' ? 'Calculator' : 'Calculadora'}: ${widget.tool.getTitle(lang)}',
      tradeId: widget.tool.tradeId,
      createdAt: DateTime.now(),
      items: items,
    );

    shoppingService.addList(newList);

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

  void _goToGuide() {
    if (widget.tool.relatedGuideId == null) return;
    try {
      final problem = ProblemsData.all.firstWhere((p) => p.id == widget.tool.relatedGuideId);
      final trade = MockData.trades.firstWhere((t) => t.id == problem.tradeId);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProblemDetailScreen(problem: problem, tradeColor: trade.color),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.localeName == 'en' ? 'Guide not available' : 'Guía no disponible')));
    }
  }

  void _createReminder() {
    final lang = AppLocalizations.of(context)!.localeName;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditReminderScreen(
          initialTitle: widget.tool.getTitle(lang),
          relatedGuideId: widget.tool.relatedGuideId,
          relatedGuideTitle: widget.tool.getRelatedGuideTitle(lang),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!.localeName;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tool.getTitle(lang), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.tool.getDescription(lang), style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
            const SizedBox(height: 32),
            
            ...widget.tool.fields.map((field) => _buildField(field)),
            
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _calculate,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(lang == 'en' ? 'CALCULATE' : 'CALCULAR', style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              ),
            ),

            if (_results != null) ...[
              const SizedBox(height: 40),
              _buildResultCard(),
            ],

            if (widget.tool.getDisclaimer(lang) != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[100]!),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, color: Colors.orange, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.tool.getDisclaimer(lang)!,
                        style: TextStyle(fontSize: 12, color: Colors.orange[900]),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 40),
            
            if (widget.tool.relatedGuideId != null)
              _actionButton(
                label: '${lang == 'en' ? 'View guide' : 'Ver guía'}: ${widget.tool.getRelatedGuideTitle(lang)}',
                icon: Icons.menu_book,
                onPressed: _goToGuide,
                color: AppTheme.primary,
              ),

            if (widget.tool.shoppingItemsEs.isNotEmpty && _results != null)
              _actionButton(
                label: AppLocalizations.of(context)!.createShoppingList,
                icon: Icons.add_shopping_cart,
                onPressed: _createShoppingList,
                color: Colors.green,
                isOutlined: true,
              ),

            if (widget.tool.hasReminder)
              _actionButton(
                label: lang == 'en' ? 'Create maintenance reminder' : 'Crear recordatorio de mantenimiento',
                icon: Icons.notifications_active_outlined,
                onPressed: _createReminder,
                color: Colors.orange,
                isOutlined: true,
              ),
              
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildField(CalculatorField field) {
    final lang = AppLocalizations.of(context)!.localeName;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(field.getLabel(lang), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.textPrimary)),
          const SizedBox(height: 8),
          if (field.type == CalculatorFieldType.number)
            TextField(
              controller: _controllers[field.key],
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                suffixText: field.getUnit(lang),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            )
          else if (field.type == CalculatorFieldType.dropdown)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<double>(
                  value: _inputs[field.key],
                  isExpanded: true,
                  items: List.generate(field.getOptions(lang)!.length, (index) => 
                    DropdownMenuItem(value: index.toDouble(), child: Text(field.getOptions(lang)![index]))
                  ),
                  onChanged: (v) => setState(() => _inputs[field.key] = v!),
                ),
              ),
            )
          else if (field.type == CalculatorFieldType.toggle)
            SwitchListTile(
              title: Text(field.getLabel(lang), style: const TextStyle(fontSize: 14)),
              value: _inputs[field.key] == 1,
              onChanged: (v) => setState(() => _inputs[field.key] = v ? 1 : 0),
              contentPadding: EdgeInsets.zero,
            ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    final lang = AppLocalizations.of(context)!.localeName;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primary.withAlpha(15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primary.withAlpha(50), width: 2),
      ),
      child: Column(
        children: [
          Text(lang == 'en' ? 'RESULT' : 'RESULTADO', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppTheme.primary, letterSpacing: 1)),
          const SizedBox(height: 16),
          Text(
            _formatResult(widget.tool.getResultTemplate(lang)),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary, height: 1.5),
          ),
          if (widget.tool.getResultExplanation(lang) != null) ...[
            const SizedBox(height: 12),
            Text(
              _formatResult(widget.tool.getResultExplanation(lang)!),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
            ),
          ],
        ],
      ),
    );
  }

  Widget _actionButton({required String label, required IconData icon, required VoidCallback onPressed, required Color color, bool isOutlined = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        child: isOutlined 
          ? OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 20),
              label: Text(label),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                foregroundColor: color,
                side: BorderSide(color: color),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            )
          : ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 20),
              label: Text(label),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
      ),
    );
  }
}
