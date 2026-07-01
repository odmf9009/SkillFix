import 'package:flutter/material.dart';
import 'package:skillfix/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/maintenance_reminder.dart';
import '../models/home_problem.dart';
import '../models/repair_history.dart';
import '../services/maintenance_service.dart';
import '../services/repair_history_service.dart';
import '../theme/app_theme.dart';

class AddEditReminderScreen extends StatefulWidget {
  final MaintenanceReminder? reminder;
  final String? initialTitle;
  final String? relatedGuideId;
  final String? relatedGuideTitle;

  const AddEditReminderScreen({
    super.key,
    this.reminder,
    this.initialTitle,
    this.relatedGuideId,
    this.relatedGuideTitle,
  });

  @override
  State<AddEditReminderScreen> createState() => _AddEditReminderScreenState();
}

class _AddEditReminderScreenState extends State<AddEditReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late MaintenanceFrequency _frequency;
  late MaintenancePriority _priority;
  late DateTime _nextDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.reminder != null 
        ? widget.reminder!.titleEs // Default to ES for editing if not sure
        : (widget.initialTitle ?? ''),
    );
    _descController = TextEditingController(
      text: widget.reminder?.descriptionEs ?? ''
    );
    _frequency = widget.reminder?.frequency ?? MaintenanceFrequency.monthly;
    _priority = widget.reminder?.priority ?? MaintenancePriority.medium;
    _nextDate = widget.reminder?.nextDate ?? DateTime.now().add(const Duration(days: 1));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final service = Provider.of<MaintenanceService>(context, listen: false);
    final historyService = Provider.of<RepairHistoryService>(context, listen: false);
    
    final reminder = MaintenanceReminder(
      id: widget.reminder?.id ?? const Uuid().v4(),
      titleEs: _titleController.text,
      titleEn: _titleController.text,
      descriptionEs: _descController.text,
      descriptionEn: _descController.text,
      tradeId: 'custom',
      relatedGuideId: widget.relatedGuideId ?? widget.reminder?.relatedGuideId,
      relatedGuideTitleEs: widget.relatedGuideTitle ?? widget.reminder?.relatedGuideTitleEs,
      relatedGuideTitleEn: widget.relatedGuideTitle ?? widget.reminder?.relatedGuideTitleEn,
      frequency: _frequency,
      createdAt: widget.reminder?.createdAt ?? DateTime.now(),
      nextDate: _nextDate,
      priority: _priority,
      instructionsEs: 'Instrucciones personalizadas.',
      instructionsEn: 'Custom instructions.',
    );

    service.addReminder(reminder);

    // Log to history
    final dummyProblem = HomeProblem(
      id: reminder.relatedGuideId ?? reminder.id,
      tradeId: reminder.tradeId,
      titleEs: reminder.titleEs,
      titleEn: reminder.titleEn,
      descriptionEs: reminder.descriptionEs,
      descriptionEn: reminder.descriptionEn,
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
      eventType: HistoryEventType.maintenanceReminderCreated,
      note: 'Frequency: ${reminder.getFrequencyLabel(context)}',
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!.localeName;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reminder == null 
          ? (lang == 'en' ? 'New reminder' : 'Nuevo recordatorio') 
          : (lang == 'en' ? 'Edit reminder' : 'Editar recordatorio')),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: lang == 'en' ? 'Title' : 'Título', 
                hintText: lang == 'en' ? 'e.g. Change AC filter' : 'Ej: Cambiar filtro del AC'
              ),
              validator: (v) => v == null || v.isEmpty ? (lang == 'en' ? 'Required' : 'Requerido') : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descController,
              decoration: InputDecoration(labelText: lang == 'en' ? 'Description (Optional)' : 'Descripción (Opcional)'),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            Text(lang == 'en' ? 'Frequency' : 'Frecuencia', style: const TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<MaintenanceFrequency>(
              isExpanded: true,
              value: _frequency,
              items: MaintenanceFrequency.values.map((f) => 
                DropdownMenuItem(value: f, child: Text(_getFrequencyLabel(f, lang)))
              ).toList(),
              onChanged: (v) => setState(() => _frequency = v!),
            ),
            const SizedBox(height: 24),
            Text(lang == 'en' ? 'Priority' : 'Prioridad', style: const TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: MaintenancePriority.values.map((p) {
                final isSelected = _priority == p;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(_getPriorityLabel(p, lang)),
                    selected: isSelected,
                    onSelected: (v) => setState(() => _priority = p),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            ListTile(
              title: Text(lang == 'en' ? 'Next date' : 'Próxima fecha', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${_nextDate.day}/${_nextDate.month}/${_nextDate.year}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _nextDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 3650)),
                );
                if (date != null) setState(() => _nextDate = date);
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(lang == 'en' ? 'Save reminder' : 'Guardar recordatorio'),
            ),
          ],
        ),
      ),
    );
  }

  String _getFrequencyLabel(MaintenanceFrequency f, String lang) {
    if (lang == 'en') {
      return switch (f) {
        MaintenanceFrequency.once => 'Once',
        MaintenanceFrequency.weekly => 'Weekly',
        MaintenanceFrequency.biweekly => 'Every 2 weeks',
        MaintenanceFrequency.monthly => 'Monthly',
        MaintenanceFrequency.bimonthly => 'Every 2 months',
        MaintenanceFrequency.quarterly => 'Quarterly',
        MaintenanceFrequency.semiannually => 'Semiannually',
        MaintenanceFrequency.annually => 'Annually',
        MaintenanceFrequency.custom => 'Custom',
      };
    }
    return switch (f) {
      MaintenanceFrequency.once => 'Una vez',
      MaintenanceFrequency.weekly => 'Semanal',
      MaintenanceFrequency.biweekly => 'Cada 2 semanas',
      MaintenanceFrequency.monthly => 'Mensual',
      MaintenanceFrequency.bimonthly => 'Cada 2 meses',
      MaintenanceFrequency.quarterly => 'Cada 3 meses',
      MaintenanceFrequency.semiannually => 'Cada 6 meses',
      MaintenanceFrequency.annually => 'Anual',
      MaintenanceFrequency.custom => 'Personalizado',
    };
  }

  String _getPriorityLabel(MaintenancePriority p, String lang) {
    if (lang == 'en') {
      return switch (p) {
        MaintenancePriority.low => 'Low',
        MaintenancePriority.medium => 'Medium',
        MaintenancePriority.high => 'High',
      };
    }
    return switch (p) {
      MaintenancePriority.low => 'Baja',
      MaintenancePriority.medium => 'Media',
      MaintenancePriority.high => 'Alta',
    };
  }
}
