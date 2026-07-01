import 'package:flutter/material.dart';
import '../data/diagnostic_data.dart';
import '../data/mock_data.dart';
import '../models/diagnostic.dart';
import '../models/trade.dart';
import '../theme/app_theme.dart';
import 'diagnostic_screen.dart';
import 'package:skillfix/l10n/app_localizations.dart';

class DiagnosticListScreen extends StatefulWidget {
  const DiagnosticListScreen({super.key});

  @override
  State<DiagnosticListScreen> createState() => _DiagnosticListScreenState();
}

class _DiagnosticListScreenState extends State<DiagnosticListScreen> {
  String _selectedTradeId = 'all';

  final List<Map<String, String>> _filters = [
    {'id': 'all', 'es': 'Todos', 'en': 'All'},
    {'id': 'electrical', 'es': 'Electricidad', 'en': 'Electrical'},
    {'id': 'plumbing', 'es': 'Plomería', 'en': 'Plumbing'},
    {'id': 'hvac', 'es': 'HVAC', 'en': 'HVAC'},
    {'id': 'appliances', 'es': 'Electrodomésticos', 'en': 'Appliances'},
    {'id': 'internet_wifi', 'es': 'Internet / WiFi', 'en': 'Internet / WiFi'},
    {'id': 'smart_home', 'es': 'Smart Home', 'en': 'Smart Home'},
    {'id': 'garage_door', 'es': 'Garage Door', 'en': 'Garage Door'},
    {'id': 'pool', 'es': 'Pool', 'en': 'Pool'},
    {'id': 'roofing', 'es': 'Exterior', 'en': 'Exterior'},
  ];

  List<DiagnosticFlow> get _filteredFlows {
    if (_selectedTradeId == 'all') return DiagnosticData.flows;
    return DiagnosticData.flows.where((f) => f.tradeId == _selectedTradeId).toList();
  }

  Trade _tradeFor(String tradeId) {
    try {
      return MockData.trades.firstWhere((t) => t.id == tradeId);
    } catch (e) {
      return MockData.trades.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = l10n.localeName;

    return Scaffold(
      appBar: AppBar(
        title: Text(lang == 'en' ? 'All Diagnostics' : 'Todos los diagnósticos'),
      ),
      body: Column(
        children: [
          // ---- Filtros ----
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              itemBuilder: (ctx, i) {
                final filter = _filters[i];
                final isSelected = _selectedTradeId == filter['id'];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(lang == 'en' ? filter['en']! : filter['es']!),
                    selected: isSelected,
                    onSelected: (v) => setState(() => _selectedTradeId = filter['id']!),
                    selectedColor: AppTheme.primary.withAlpha(50),
                    checkmarkColor: AppTheme.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                );
              },
            ),
          ),

          // ---- Lista ----
          Expanded(
            child: _filteredFlows.isEmpty
                ? Center(
                    child: Text(
                      lang == 'en' ? 'No diagnostics for this category' : 'No hay diagnósticos para esta categoría',
                      style: const TextStyle(color: AppTheme.textSecondary),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredFlows.length,
                    itemBuilder: (ctx, i) {
                      final flow = _filteredFlows[i];
                      final trade = _tradeFor(flow.tradeId);
                      return _DiagnosticListCard(flow: flow, trade: trade);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _DiagnosticListCard extends StatelessWidget {
  final DiagnosticFlow flow;
  final Trade trade;

  const _DiagnosticListCard({required this.flow, required this.trade});

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!.localeName;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DiagnosticScreen(flow: flow)),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: trade.color.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: Icon(flow.icon ?? trade.icon, color: trade.color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            flow.getTitle(lang),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        if (flow.isPopular)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.amber[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              lang == 'en' ? 'POPULAR' : 'POPULAR',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                color: Colors.amber[900],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trade.getName(lang),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: trade.color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      flow.getDescription(lang),
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox.shrink(), // Placeholder for risk if needed
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => DiagnosticScreen(flow: flow)),
                            );
                          },
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: Text(lang == 'en' ? 'START' : 'INICIAR'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppTheme.primary,
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
