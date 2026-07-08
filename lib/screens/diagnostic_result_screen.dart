import 'package:flutter/material.dart';
import 'package:skillfix/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../models/diagnostic.dart';
import '../models/home_problem.dart';
import '../models/repair_history.dart';
import '../models/tutorial_video.dart';
import '../services/repair_history_service.dart';
import '../services/language_service.dart';
import '../services/youtube_service.dart';
import '../data/problems_data.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import 'problem_detail_screen.dart';
import 'video_player_screen.dart';

class DiagnosticResultScreen extends StatefulWidget {
  final DiagnosticResult result;
  final DiagnosticFlow flow;

  const DiagnosticResultScreen({
    super.key,
    required this.result,
    required this.flow,
  });

  @override
  State<DiagnosticResultScreen> createState() => _DiagnosticResultScreenState();
}

class _DiagnosticResultScreenState extends State<DiagnosticResultScreen> {
  final YoutubeService _youtube = YoutubeService();
  late final Future<List<TutorialVideo>> _videosFuture;

  /// Builds a natural-language YouTube query for the detected problem in the
  /// language selected in the app, e.g. "cómo reparar Fuga en la llave".
  String _buildVideoQuery(String lang) {
    final prefix = lang == 'en' ? 'how to fix' : 'cómo reparar';
    final topic = widget.result.getTitle(lang);
    return '$prefix $topic';
  }

  @override
  void initState() {
    super.initState();

    // Language chosen in the app drives the YouTube search language.
    final lang = Provider.of<LanguageService>(context, listen: false)
        .locale
        .languageCode;
    _videosFuture = _youtube.searchByQuery(
      _buildVideoQuery(lang),
      languageCode: lang,
    );

    // Record "diagnosticCompleted" event
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final historyService = Provider.of<RepairHistoryService>(context, listen: false);
      
      // If there is a recommended guide, use its data to create a richer history entry
      HomeProblem? problem;
      if (widget.result.recommendedGuideId != null) {
        try {
          problem = ProblemsData.all.firstWhere((p) => p.id == widget.result.recommendedGuideId);
        } catch (_) {}
      }

      if (problem != null) {
        historyService.addEntry(
          problem: problem,
          eventType: HistoryEventType.diagnosticCompleted,
          diagnosticResultId: widget.result.id,
          note: 'Resultado: ${widget.result.titleEs}. Causa: ${widget.result.possibleCauseEs}',
        );
      } else {
        // Fallback for cases without a direct guide
        final fallbackProblem = HomeProblem(
          id: widget.flow.relatedGuideId ?? 'diag_${widget.flow.id}',
          tradeId: widget.flow.tradeId,
          titleEs: widget.flow.titleEs,
          titleEn: widget.flow.titleEn,
          descriptionEs: widget.flow.descriptionEs,
          descriptionEn: widget.flow.descriptionEn,
          difficulty: Difficulty.medium,
          estimatedMinutes: 0,
          riskLevel: widget.result.riskLevel,
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
          problem: fallbackProblem,
          eventType: HistoryEventType.diagnosticCompleted,
          diagnosticResultId: widget.result.id,
          note: 'Resultado: ${widget.result.titleEs}. Causa: ${widget.result.possibleCauseEs}',
        );
      }
    });
  }

  void _goToGuide(BuildContext context) {
    if (widget.result.recommendedGuideId == null) return;

    try {
      final problem = ProblemsData.all.firstWhere((p) => p.id == widget.result.recommendedGuideId);
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

  void _showHelpDialog(BuildContext context) {
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

  String _getGuideTitle(String lang) {
    if (widget.result.recommendedGuideTitleEs != null || widget.result.recommendedGuideTitleEn != null) {
      return widget.result.getRecommendedGuideTitle(lang) ?? '';
    }
    
    if (widget.result.recommendedGuideId != null) {
      try {
        final problem = ProblemsData.all.firstWhere((p) => p.id == widget.result.recommendedGuideId);
        return problem.getTitle(lang);
      } catch (_) {}
    }
    
    return '';
  }

  void _openVideo(TutorialVideo video) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoPlayerScreen(
          video: video,
          tradeColor: AppTheme.primary,
        ),
      ),
    );
  }

  String _videosErrorMessage(Object? error, String lang) {
    if (error is YoutubeApiException) {
      switch (error.error) {
        case YoutubeApiError.missingApiKey:
          return lang == 'en'
              ? 'Video suggestions are not configured.'
              : 'Las sugerencias de video no están configuradas.';
        case YoutubeApiError.quotaOrKey:
          return lang == 'en'
              ? 'Video service temporarily unavailable.'
              : 'Servicio de videos temporalmente no disponible.';
        case YoutubeApiError.network:
          return lang == 'en'
              ? 'No connection to load videos.'
              : 'Sin conexión para cargar los videos.';
        case YoutubeApiError.request:
          break;
      }
    }
    return lang == 'en'
        ? 'Could not load videos.'
        : 'No se pudieron cargar los videos.';
  }

  Widget _videosMessage(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: const TextStyle(
            color: AppTheme.textSecondary, fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget _buildVideosSection(BuildContext context, String lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.smart_display, color: Colors.red),
            const SizedBox(width: 8),
            Text(
              lang == 'en' ? 'Solution videos' : 'Videos de solución',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<TutorialVideo>>(
          future: _videosFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      lang == 'en' ? 'Searching videos…' : 'Buscando videos…',
                      style: const TextStyle(color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              );
            }
            if (snapshot.hasError) {
              return _videosMessage(_videosErrorMessage(snapshot.error, lang));
            }
            final videos = snapshot.data ?? const <TutorialVideo>[];
            if (videos.isEmpty) {
              return _videosMessage(lang == 'en'
                  ? 'No videos found for this problem.'
                  : 'No se encontraron videos para este problema.');
            }
            return Column(
              children: videos
                  .map((v) => _VideoSuggestionCard(
                        video: v,
                        onTap: () => _openVideo(v),
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final lang = AppLocalizations.of(context)!.localeName;
    final guideTitle = _getGuideTitle(lang);

    return Scaffold(
      appBar: AppBar(
        title: Text(lang == 'en' ? 'Diagnosis Result' : 'Resultado del Diagnóstico'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... (rest of the header remains the same)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: result.riskLevel == RiskLevel.high
                    ? Colors.red[50]
                    : AppTheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: result.riskLevel == RiskLevel.high
                      ? Colors.red[200]!
                      : AppTheme.primary.withAlpha(60),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        result.riskLevel == RiskLevel.high
                            ? Icons.warning_rounded
                            : Icons.check_circle_rounded,
                        color: result.riskLevel == RiskLevel.high
                            ? Colors.red
                            : AppTheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          result.getTitle(lang),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: result.riskLevel == RiskLevel.high
                                ? Colors.red[900]
                                : AppTheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    lang == 'en' ? 'POSSIBLE CAUSE:' : 'POSIBLE CAUSA:',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
                  ),
                  Text(
                    result.getPossibleCause(lang),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // --- Qué revisar ---
            Text(
              lang == 'en' ? 'First things to check:' : 'Qué revisar primero:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
            ),
            const SizedBox(height: 12),
            ...result.getFirstThingsToCheck(lang).map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.arrow_right, color: AppTheme.primary),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(fontSize: 15, color: AppTheme.textPrimary),
                        ),
                      ),
                    ],
                  ),
                )),

            const SizedBox(height: 32),

            // --- Mensaje de seguridad ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.security, color: Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      result.getSafetyMessage(lang),
                      style: TextStyle(fontSize: 13, color: Colors.orange[900], fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // --- Videos de solución (YouTube Data API v3) ---
            _buildVideosSection(context, lang),

            const SizedBox(height: 40),

            // --- Botones ---
            if (result.recommendedGuideId != null && guideTitle.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _goToGuide(context),
                  icon: const Icon(Icons.menu_book),
                  label: Text('${lang == 'en' ? 'View guide' : 'Ver guía'}: $guideTitle'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              )
            else if (result.recommendedGuideId != null)
               SizedBox(
                width: double.infinity,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      lang == 'en' ? 'Related guide not available' : 'Guía relacionada no disponible',
                      style: const TextStyle(color: AppTheme.textSecondary, fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showHelpDialog(context),
                icon: const Icon(Icons.support_agent),
                label: Text(AppLocalizations.of(context)!.requestTechnician),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

/// Compact horizontal card for a suggested YouTube video, aligned with the
/// diagnostic screen padding (thumbnail + title + channel).
class _VideoSuggestionCard extends StatelessWidget {
  final TutorialVideo video;
  final VoidCallback onTap;

  const _VideoSuggestionCard({required this.video, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: AppTheme.cardShadow,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(14)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    video.thumbnailUrl,
                    width: 128,
                    height: 78,
                    fit: BoxFit.cover,
                    errorBuilder: (context, e, _) => Container(
                      width: 128,
                      height: 78,
                      color: AppTheme.background,
                      child: const Icon(Icons.videocam_off,
                          color: AppTheme.textSecondary),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(128),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow,
                        color: Colors.white, size: 22),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      video.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      video.channelName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
