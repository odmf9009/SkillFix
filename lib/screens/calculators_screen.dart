import 'package:flutter/material.dart';
import 'package:skillfix/l10n/app_localizations.dart';
import '../data/calculators_data.dart';
import '../models/calculator_tool.dart';
import '../theme/app_theme.dart';
import 'calculator_detail_screen.dart';

class CalculatorsScreen extends StatefulWidget {
  const CalculatorsScreen({super.key});

  @override
  State<CalculatorsScreen> createState() => _CalculatorsScreenState();
}

class _CalculatorsScreenState extends State<CalculatorsScreen> {
  String _query = '';
  String _selectedCategory = 'Todos';

  List<CalculatorTool> get _filteredTools {
    final lang = AppLocalizations.of(context)!.localeName;
    return CalculatorsData.tools.where((tool) {
      final matchesQuery = tool.getTitle(lang).toLowerCase().contains(_query.toLowerCase()) ||
          tool.getDescription(lang).toLowerCase().contains(_query.toLowerCase());
      final matchesCategory = _selectedCategory == 'Todos' || _selectedCategory == 'All' || tool.categoryEs == _selectedCategory || tool.categoryEn == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = l10n.localeName;
    final tools = _filteredTools;

    final categories = CalculatorsData.getCategories(lang);

    if (!categories.contains(_selectedCategory)) {
      _selectedCategory = categories.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.calculators, style: const TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: lang == 'en' ? 'What do you want to calculate?' : '¿Qué quieres calcular?',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Categories
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (v) => setState(() => _selectedCategory = cat),
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
          ),

          const SizedBox(height: 12),

          // Tools List
          Expanded(
            child: tools.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: tools.length,
                    itemBuilder: (context, index) {
                      final tool = tools[index];
                      return _CalculatorCard(tool: tool);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final lang = AppLocalizations.of(context)!.localeName;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calculate_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            lang == 'en' ? 'Calculator not found' : 'No encontramos esa calculadora',
            style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _CalculatorCard extends StatelessWidget {
  final CalculatorTool tool;
  const _CalculatorCard({required this.tool});

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!.localeName;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primary.withAlpha(20),
            shape: BoxShape.circle,
          ),
          child: Icon(tool.icon, color: AppTheme.primary, size: 24),
        ),
        title: Text(
          tool.getTitle(lang),
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              tool.getCategory(lang),
              style: const TextStyle(color: AppTheme.primary, fontSize: 11, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              tool.getDescription(lang),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CalculatorDetailScreen(tool: tool),
            ),
          );
        },
      ),
    );
  }
}
