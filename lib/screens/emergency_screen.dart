import 'package:flutter/material.dart';
import 'package:skillfix/l10n/app_localizations.dart';
import '../data/emergency_data.dart';
import '../models/emergency.dart';
import '../theme/app_theme.dart';
import 'emergency_detail_screen.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!.localeName;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          lang == 'en' ? 'What emergency do you have?' : '¿Qué emergencia tienes?',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.red[50],
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.red[700], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    lang == 'en'
                      ? 'SkillFix offers basic guidance. In a real emergency, call 911. Do not attempt dangerous repairs.'
                      : 'SkillFix ofrece orientación básica. En una emergencia real, llama al 911. No intentes reparaciones peligrosas.',
                    style: TextStyle(fontSize: 12, color: Colors.red[900], fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: EmergencyData.items.length,
              itemBuilder: (context, index) {
                final item = EmergencyData.items[index];
                return _EmergencyCard(item: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergencyCard extends StatelessWidget {
  final EmergencyItem item;

  const _EmergencyCard({required this.item});

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
            color: item.color.withAlpha(30),
            shape: BoxShape.circle,
          ),
          child: Icon(item.icon, color: item.color, size: 28),
        ),
        title: Text(
          item.getTitle(lang),
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: item.color.withAlpha(40),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                item.getDangerLabel(lang),
                style: TextStyle(color: item.color, fontSize: 10, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.getShortDescription(lang),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EmergencyDetailScreen(item: item),
            ),
          );
        },
      ),
    );
  }
}
