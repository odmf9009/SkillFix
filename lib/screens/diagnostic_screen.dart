import 'package:flutter/material.dart';
import 'package:skillfix/l10n/app_localizations.dart';
import '../models/diagnostic.dart';
import '../theme/app_theme.dart';
import 'diagnostic_result_screen.dart';

class DiagnosticScreen extends StatefulWidget {
  final DiagnosticFlow flow;

  const DiagnosticScreen({super.key, required this.flow});

  @override
  State<DiagnosticScreen> createState() => _DiagnosticScreenState();
}

class _DiagnosticScreenState extends State<DiagnosticScreen> {
  late String _currentQuestionId;
  final List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _currentQuestionId = widget.flow.questions.first.id;
  }

  DiagnosticQuestion get _currentQuestion =>
      widget.flow.questions.firstWhere((q) => q.id == _currentQuestionId);

  void _onAnswer(DiagnosticAnswer answer) {
    if (answer.resultId != null) {
      final result = widget.flow.results.firstWhere((r) => r.id == answer.resultId);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DiagnosticResultScreen(result: result, flow: widget.flow),
        ),
      );
    } else if (answer.nextQuestionId != null) {
      setState(() {
        _history.add(_currentQuestionId);
        _currentQuestionId = answer.nextQuestionId!;
      });
    }
  }

  void _goBack() {
    if (_history.isNotEmpty) {
      setState(() {
        _currentQuestionId = _history.removeLast();
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!.localeName;
    final question = _currentQuestion;
    final progress = widget.flow.questions.indexOf(question) + 1;
    final total = widget.flow.questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.flow.getTitle(lang)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBack,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              lang == 'en' ? 'Cancel' : 'Cancelar', 
              style: const TextStyle(color: Colors.white)
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              lang == 'en' ? 'Question $progress of $total' : 'Pregunta $progress de $total',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress / total,
                minHeight: 8,
                backgroundColor: Colors.grey[200],
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 48),
            Text(
              question.getQuestionText(lang),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            ...question.answers.map((answer) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ElevatedButton(
                    onPressed: () => _onAnswer(answer),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primary,
                      side: const BorderSide(color: AppTheme.primary, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      answer.getText(lang),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
