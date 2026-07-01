import 'package:flutter/material.dart';
import 'package:skillfix/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/shopping_list.dart';
import '../services/shopping_list_service.dart';
import '../theme/app_theme.dart';
import '../utils/affiliate_links.dart';

class ShoppingListDetailScreen extends StatefulWidget {
  final ShoppingList list;

  const ShoppingListDetailScreen({super.key, required this.list});

  @override
  State<ShoppingListDetailScreen> createState() => _ShoppingListDetailScreenState();
}

class _ShoppingListDetailScreenState extends State<ShoppingListDetailScreen> {
  final TextEditingController _addItemController = TextEditingController();

  void _addItem() {
    final name = _addItemController.text.trim();
    if (name.isNotEmpty) {
      final newItem = ShoppingItem(
        id: const Uuid().v4(),
        name: name,
        category: ItemCategory.material, // Por defecto material si se agrega a mano
      );
      Provider.of<ShoppingListService>(context, listen: false)
          .addItemToList(widget.list.id, newItem);
      _addItemController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!.localeName;

    return Consumer<ShoppingListService>(
      builder: (context, service, _) {
        // Encontrar la lista actualizada en el servicio para reflejar cambios
        final currentList = service.lists.firstWhere((l) => l.id == widget.list.id);
        
        final tools = currentList.items.where((i) => i.category == ItemCategory.tool).toList();
        final materials = currentList.items.where((i) => i.category == ItemCategory.material).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text(currentList.guideTitle),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (tools.isNotEmpty) ...[
                      _sectionHeader(lang == 'en' ? 'Tools' : 'Herramientas', Icons.build_outlined),
                      ...tools.map((item) => _ItemTile(listId: currentList.id, item: item)),
                      const SizedBox(height: 24),
                    ],
                    if (materials.isNotEmpty) ...[
                      _sectionHeader(lang == 'en' ? 'Materials' : 'Materiales', Icons.inventory_2_outlined),
                      ...materials.map((item) => _ItemTile(listId: currentList.id, item: item)),
                    ],
                  ],
                ),
              ),
              _buildAddInput(),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddInput() {
    final lang = AppLocalizations.of(context)!.localeName;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(50), blurRadius: 10, offset: const Offset(0, -2))
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _addItemController,
              decoration: InputDecoration(
                hintText: lang == 'en' ? 'Add item manually...' : 'Agregar item manualmente...',
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                fillColor: Colors.grey[100],
                filled: true,
              ),
              onSubmitted: (_) => _addItem(),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: AppTheme.primary,
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: _addItem,
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  final String listId;
  final ShoppingItem item;

  const _ItemTile({required this.listId, required this.item});

  Future<void> _openLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!.localeName;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Checkbox(
        value: item.isBought,
        activeColor: Colors.green,
        onChanged: (v) {
          Provider.of<ShoppingListService>(context, listen: false)
              .toggleItemStatus(listId, item.id);
        },
      ),
      title: Text(
        item.name,
        style: TextStyle(
          fontSize: 15,
          color: item.isBought ? AppTheme.textSecondary : AppTheme.textPrimary,
          decoration: item.isBought ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _BuyButton(
            tooltip: lang == 'en' ? 'Search on Amazon' : 'Buscar en Amazon',
            icon: Icons.shopping_cart_outlined,
            color: const Color(0xFFFF9900),
            onTap: () => _openLink(AffiliateLinks.amazon(item.name)),
          ),
          _BuyButton(
            tooltip: lang == 'en' ? 'Search on Home Depot' : 'Buscar en Home Depot',
            icon: Icons.store_outlined,
            color: const Color(0xFFFF6600),
            onTap: () => _openLink(AffiliateLinks.homedepot(item.name)),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20, color: Colors.grey),
            onPressed: () {
              Provider.of<ShoppingListService>(context, listen: false)
                  .removeItemFromList(listId, item.id);
            },
          ),
        ],
      ),
    );
  }
}

class _BuyButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _BuyButton({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}
