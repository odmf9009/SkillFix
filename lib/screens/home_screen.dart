import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_shell.dart';
import '../data/mock_data.dart';
import '../data/problems_data.dart';
import '../data/diagnostic_data.dart';
import '../models/home_problem.dart';
import '../models/trade.dart';
import '../models/diagnostic.dart';
import '../theme/app_theme.dart';
import '../widgets/problem_card.dart';
import 'problem_list_screen.dart';
import 'problem_detail_screen.dart';
import 'diagnostic_screen.dart';
import 'diagnostic_list_screen.dart';
import 'emergency_screen.dart';
import 'calculators_screen.dart';
import '../services/maintenance_service.dart';
import 'package:skillfix/l10n/app_localizations.dart';
import '../services/language_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _selectedCategory = 'Todos';

  static const List<String> _activeTradeIds = [
    'electrical',
    'plumbing',
    'hvac',
    'drywall_painting',
    'handyman',
    'appliances',
    'security_cameras',
    'flooring',
    'roofing',
    'landscaping',
    'doors_windows',
    'concrete_masonry',
    'cleaning_pressure',
    'pool',
    'garage_door',
    'carpentry',
    'smart_home',
    'internet_wifi',
    'mechanics',
    'tool_basics',
    'pest_control',
    'moving_assembly',
    'home_organization'
  ];

  static const List<String> _categories = [
    'Todos',
    'Hogar',
    'Exterior',
    'Tecnología',
    'Vehículos',
    'Seguridad',
    'Aprender',
  ];

  List<Trade> get _activeTrades => _activeTradeIds
      .map((id) => MockData.trades.firstWhere((t) => t.id == id))
      .toList();

  List<Trade> get _filteredTrades {
    final allActive = _activeTrades;
    if (_selectedCategory == 'Todos') return allActive;
    return allActive
        .where((t) => t.categories.contains(_selectedCategory))
        .toList();
  }

  List<HomeProblem> get _popularProblems => ProblemsData.popular
      .where((p) => _activeTradeIds.contains(p.tradeId))
      .toList();

  List<HomeProblem> get _searchResults => ProblemsData.search(_query);

  Color _colorFor(String tradeId) =>
      MockData.trades.firstWhere((t) => t.id == tradeId).color;

  Trade _tradeFor(String tradeId) =>
      MockData.trades.firstWhere((t) => t.id == tradeId);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _goToDetail(HomeProblem problem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProblemDetailScreen(
          problem: problem,
          tradeColor: _colorFor(problem.tradeId),
        ),
      ),
    );
  }

  void _goToProblemList(Trade trade) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProblemListScreen(trade: trade),
      ),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  l10n.selectLanguage,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Text('🇪🇸', style: TextStyle(fontSize: 24)),
                title: Text(l10n.spanish),
                trailing: languageService.locale.languageCode == 'es'
                    ? const Icon(Icons.check, color: AppTheme.primary)
                    : null,
                onTap: () {
                  languageService.setLocale(const Locale('es'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
                title: Text(l10n.english),
                trailing: languageService.locale.languageCode == 'en'
                    ? const Icon(Icons.check, color: AppTheme.primary)
                    : null,
                onTap: () {
                  languageService.setLocale(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ---- App Bar ----
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            backgroundColor: AppTheme.primary,
            actions: [
              IconButton(
                icon: const Icon(Icons.language, color: Colors.white),
                onPressed: () => _showLanguageSelector(context),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Text(
                l10n.appTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),

          // ---- Barra de búsqueda ----
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: l10n.searchHint,
                  hintStyle: const TextStyle(color: AppTheme.textSecondary),
                  prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppTheme.textSecondary),
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

          // ---- Botón de EMERGENCIA ----
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EmergencyScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.red[200]!, width: 2),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.emergency.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: Colors.red,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              l10n.localeName == 'en' 
                                ? 'Quick instructions for dangerous situations.' 
                                : 'Instrucciones rápidas para situaciones peligrosas.',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFFB71C1C),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.red),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ---- Sección: RECORDATORIOS PENDIENTES ----
          Consumer<MaintenanceService>(
            builder: (context, maintenance, _) {
              final overdueCount = maintenance.reminders
                  .where((r) => r.isActive && r.nextDate.isBefore(DateTime.now()))
                  .length;
              if (overdueCount == 0) return const SliverToBoxAdapter(child: SizedBox.shrink());

              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.orange[200]!),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.notification_important, color: Colors.orange),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.localeName == 'en'
                              ? 'You have $overdueCount overdue maintenance task${overdueCount > 1 ? 's' : ''}.'
                              : 'Tienes $overdueCount tarea${overdueCount > 1 ? 's' : ''} de mantenimiento vencida${overdueCount > 1 ? 's' : ''}.',
                            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.orange),
                          ),
                        ),
                        TextButton(
                          onPressed: () => MainShell.of(context)?.currentIndex = 2,
                          child: Text(l10n.localeName == 'en' ? 'View tasks' : 'Ver tareas'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // ---- Contenido según búsqueda ----
          if (_query.isNotEmpty)
            ..._buildSearchResults()
          else
            ..._buildHomeContent(),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------
  // Resultados de búsqueda
  // ---------------------------------------------------------------
  List<Widget> _buildSearchResults() {
    final results = _searchResults;
    final l10n = AppLocalizations.of(context)!;
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 16, 12),
          child: Text(
            results.isEmpty
                ? (l10n.localeName == 'en' ? 'No results for "$_query"' : 'Sin resultados para "$_query"')
                : '${results.length} ${l10n.localeName == 'en' ? 'result' : 'resultado'}${results.length != 1 ? 's' : ''} ${l10n.localeName == 'en' ? 'for' : 'para'} "$_query"',
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
      ),
      if (results.isEmpty)
        SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off,
                    size: 64, color: AppTheme.textSecondary.withAlpha(80)),
                const SizedBox(height: 16),
                Text(
                  l10n.localeName == 'en' ? 'No results found' : 'No encontramos resultados',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        )
      else
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (ctx, i) {
              final p = results[i];
              final trade = _tradeFor(p.tradeId);
              return ProblemCard(
                problem: p,
                accentColor: trade.color,
                tradeLabel: trade.getName(l10n.localeName),
                onTap: () => _goToDetail(p),
              );
            },
            childCount: results.length,
          ),
        ),
    ];
  }

  // ---------------------------------------------------------------
  // Contenido principal (sin búsqueda)
  // ---------------------------------------------------------------
  List<Widget> _buildHomeContent() {
    final l10n = AppLocalizations.of(context)!;
    final popularFlows = DiagnosticData.flows.where((f) => f.isPopular).toList();

    return [
      // ---- SECCIÓN: Diagnóstico Rápido (Horizontal) ----
      SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(l10n.quickDiagnosis),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Text(
                l10n.localeName == 'en'
                    ? 'Answer a few questions and find the possible cause.'
                    : 'Responde unas preguntas y encuentra la posible causa.',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
      SliverToBoxAdapter(
        child: SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: popularFlows.length,
            itemBuilder: (ctx, i) {
              final flow = popularFlows[i];
              return _DiagnosticChip(
                flow: flow,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DiagnosticScreen(flow: flow),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DiagnosticListScreen()),
              );
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: AppTheme.primary, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              l10n.localeName == 'en' ? 'View all diagnostics' : 'Ver todos los diagnósticos',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
          ),
        ),
      ),

      // ---- SECCIÓN: Problemas Populares (Horizontal) ----
      SliverToBoxAdapter(child: _sectionHeader(l10n.popularProblems)),
      SliverToBoxAdapter(
        child: SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _popularProblems.length,
            itemBuilder: (ctx, i) {
              final p = _popularProblems[i];
              return _PopularProblemChip(
                problem: p,
                color: _colorFor(p.tradeId),
                onTap: () => _goToDetail(p),
              );
            },
          ),
        ),
      ),

      // ---- SECCIÓN: Filtros de Categoría (Horizontal) ----
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _categories.map((cat) {
                final lang = AppLocalizations.of(context)!.localeName;
                String label = cat;
                if (cat == 'Todos') label = lang == 'en' ? 'All' : 'Todos';
                if (cat == 'Hogar') label = lang == 'en' ? 'Home' : 'Hogar';
                if (cat == 'Exterior') label = lang == 'en' ? 'Outdoor' : 'Exterior';
                if (cat == 'Tecnología') label = lang == 'en' ? 'Technology' : 'Tecnología';
                if (cat == 'Vehículos') label = lang == 'en' ? 'Vehicles' : 'Vehículos';
                if (cat == 'Seguridad') label = lang == 'en' ? 'Security' : 'Seguridad';
                if (cat == 'Aprender') label = lang == 'en' ? 'Learn' : 'Aprender';

                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (v) => setState(() => _selectedCategory = cat),
                    selectedColor: AppTheme.primary.withAlpha(50),
                    checkmarkColor: AppTheme.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    ),
                    backgroundColor: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? AppTheme.primary : Colors.transparent,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),

      // ---- SECCIÓN: Calculadoras Útiles (Destacada) ----
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CalculatorsScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF37474F), Color(0xFF263238)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(30),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.calculate_outlined, color: Colors.white, size: 40),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.calculators,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.localeName == 'en'
                            ? 'Paint, Floors, Electrical and more.'
                            : 'Pintura, Pisos, Electricidad y más.',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 18),
                ],
              ),
            ),
          ),
        ),
      ),

      // ---- SECCIÓN: Grid de Oficios ----
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          delegate: SliverChildBuilderDelegate(
            (ctx, i) {
              final trade = _filteredTrades[i];
              return _CompactTradeCard(
                trade: trade,
                problemCount: ProblemsData.forTrade(trade.id).length,
                onTap: () => _goToProblemList(trade),
              );
            },
            childCount: _filteredTrades.length,
          ),
        ),
      ),
    ];
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------
// Widget: Popular Problem Chip (Horizontal)
// ----------------------------------------------------------------
class _PopularProblemChip extends StatelessWidget {
  final HomeProblem problem;
  final Color color;
  final VoidCallback onTap;

  const _PopularProblemChip({
    required this.problem,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: color.withAlpha(30),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                problem.getDifficultyLabel(context),
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              problem.getTitle(l10n.localeName),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------
// Widget: Compact Trade Card (Grid)
// ----------------------------------------------------------------
class _CompactTradeCard extends StatelessWidget {
  final Trade trade;
  final int problemCount;
  final VoidCallback onTap;

  const _CompactTradeCard({
    required this.trade,
    required this.problemCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [trade.color, trade.color.withAlpha(220)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: trade.color.withAlpha(60),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -10,
              bottom: -10,
              child: Icon(
                trade.icon,
                size: 80,
                color: Colors.white.withAlpha(30),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(50),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(trade.icon, color: Colors.white, size: 24),
                  ),
                  const Spacer(),
                  Text(
                    trade.getName(l10n.localeName),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.localeName == 'en'
                      ? '$problemCount guides' 
                      : '$problemCount guías',
                    style: TextStyle(
                      color: Colors.white.withAlpha(200),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
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
}

// ----------------------------------------------------------------
// Widget: Diagnostic Flow Chip (Horizontal)
// ----------------------------------------------------------------
class _DiagnosticChip extends StatelessWidget {
  final DiagnosticFlow flow;
  final VoidCallback onTap;

  const _DiagnosticChip({
    required this.flow,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.primary.withAlpha(20),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.primary.withAlpha(40)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(flow.icon ?? Icons.psychology_outlined, color: AppTheme.primary, size: 24),
            const SizedBox(height: 8),
            Text(
              flow.getTitle(l10n.localeName),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

