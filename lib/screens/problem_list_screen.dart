import 'package:flutter/material.dart';
import 'package:skillfix/l10n/app_localizations.dart';
import '../data/problems_data.dart';
import '../data/calculators_data.dart';
import '../models/home_problem.dart';
import '../models/trade.dart';
import '../theme/app_theme.dart';
import '../widgets/problem_card.dart';
import 'problem_detail_screen.dart';
import 'calculator_detail_screen.dart';

class ProblemListScreen extends StatefulWidget {
  final Trade trade;

  const ProblemListScreen({super.key, required this.trade});

  @override
  State<ProblemListScreen> createState() => _ProblemListScreenState();
}

class _ProblemListScreenState extends State<ProblemListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  late final List<HomeProblem> _allProblems;

  @override
  void initState() {
    super.initState();
    _allProblems = ProblemsData.forTrade(widget.trade.id);
  }

  List<HomeProblem> get _filtered {
    final lang = AppLocalizations.of(context)!.localeName;
    if (_query.isEmpty) return _allProblems;
    final q = _query.toLowerCase();
    return _allProblems
        .where((p) =>
            p.getTitle(lang).toLowerCase().contains(q) ||
            p.getDescription(lang).toLowerCase().contains(q))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!.localeName;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            backgroundColor: widget.trade.color,
            leading: const BackButton(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.trade.getName(lang),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    widget.trade.getDescription(lang),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ---- Calculadoras para este oficio ----
          _buildTradeCalculators(),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: lang == 'en' ? 'Search problem...' : 'Buscar problema...',
                  hintStyle:
                      const TextStyle(color: AppTheme.textSecondary),
                  prefixIcon: const Icon(Icons.search,
                      color: AppTheme.textSecondary),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear,
                              color: AppTheme.textSecondary),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Text(
                '${_filtered.length} ${lang == 'en' ? 'problem' : 'problema'}${_filtered.length != 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ),
          _filtered.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 56,
                            color: AppTheme.textSecondary.withAlpha(100)),
                        const SizedBox(height: 12),
                        Text(
                          lang == 'en' 
                            ? 'No problems found\nfor "$_query"' 
                            : 'No se encontraron problemas\npara "$_query"',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == _filtered.length) {
                        return const SizedBox(height: 24);
                      }
                      final problem = _filtered[index];
                      return ProblemCard(
                        problem: problem,
                        accentColor: widget.trade.color,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProblemDetailScreen(
                              problem: problem,
                              tradeColor: widget.trade.color,
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: _filtered.length + 1,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildTradeCalculators() {
    final lang = AppLocalizations.of(context)!.localeName;
    final tradeCalcs = CalculatorsData.tools.where((t) => t.tradeId == widget.trade.id).toList();
    if (tradeCalcs.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              lang == 'en' ? 'Calculation tools' : 'Herramientas de cálculo',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
            ),
          ),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: tradeCalcs.length,
              itemBuilder: (context, index) {
                final tool = tradeCalcs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CalculatorDetailScreen(tool: tool)),
                    );
                  },
                  child: Container(
                    width: 130,
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 4, offset: const Offset(0, 2)),
                      ],
                      border: Border.all(color: widget.trade.color.withAlpha(30)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(tool.icon, color: widget.trade.color, size: 20),
                        const SizedBox(height: 6),
                        Text(
                          tool.getTitle(lang),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: widget.trade.color),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
