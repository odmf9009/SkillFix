import 'package:flutter/material.dart';
import 'package:skillfix/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../services/shopping_list_service.dart';
import '../models/shopping_list.dart';
import '../theme/app_theme.dart';
import 'shopping_list_detail_screen.dart';

class ShoppingListsScreen extends StatelessWidget {
  const ShoppingListsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = l10n.localeName;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.shopping),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<ShoppingListService>(
        builder: (context, service, _) {
          if (service.lists.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.blue.withAlpha(20),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        size: 64,
                        color: Colors.blue.withAlpha(150),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.noShoppingListsYet,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      lang == 'en'
                        ? 'Open a guide and tap "Create shopping list" to save tools and materials.'
                        : 'Abre una guía y toca "Crear lista de compras" para guardar herramientas y materiales.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: service.lists.length,
            itemBuilder: (context, index) {
              final list = service.lists[index];
              return _ShoppingListCard(list: list);
            },
          );
        },
      ),
    );
  }
}

class _ShoppingListCard extends StatelessWidget {
  final ShoppingList list;

  const _ShoppingListCard({required this.list});

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!.localeName;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ShoppingListDetailScreen(list: list),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${lang == 'en' ? 'List' : 'Lista'}: ${list.guideTitle}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                    onPressed: () {
                      _showDeleteDialog(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${lang == 'en' ? 'Guide' : 'Guía'}: ${list.guideTitle}',
                style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: list.progress,
                        backgroundColor: Colors.grey[200],
                        color: Colors.green,
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${list.boughtItems}/${list.totalItems} items',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    final lang = AppLocalizations.of(context)!.localeName;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(lang == 'en' ? 'Delete list?' : '¿Eliminar lista?'),
        content: Text(lang == 'en' ? 'This action cannot be undone.' : 'Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(lang == 'en' ? 'Cancel' : 'Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<ShoppingListService>(context, listen: false).removeList(list.id);
              Navigator.pop(ctx);
            },
            child: Text(lang == 'en' ? 'Delete' : 'Eliminar', style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
