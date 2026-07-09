import 'package:flutter/material.dart';
import 'package:skillfix/l10n/app_localizations.dart';
import 'home_screen.dart';
import 'shopping_lists_screen.dart';
import 'maintenance_screen.dart';
import 'repair_history_screen.dart';
import 'favorites_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  static MainShellState? of(BuildContext context) =>
      context.findAncestorStateOfType<MainShellState>();

  @override
  State<MainShell> createState() => MainShellState();
}

class MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  set currentIndex(int index) => setState(() => _currentIndex = index);

  static const List<Widget> _screens = [
    HomeScreen(),
    ShoppingListsScreen(),
    MaintenanceScreen(),
    RepairHistoryScreen(),
    FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      // Clamp text scaling so large accessibility font sizes don't push the
      // icon + label past the fixed 56px item height (RenderFlex overflow).
      bottomNavigationBar: MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1.0,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: AppLocalizations.of(context)!.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_cart_outlined),
              activeIcon: const Icon(Icons.shopping_cart),
              label: AppLocalizations.of(context)!.shopping,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_today_outlined),
              activeIcon: const Icon(Icons.calendar_today),
              label: AppLocalizations.of(context)!.maintenance,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.assignment_outlined),
              activeIcon: const Icon(Icons.assignment),
              label: AppLocalizations.of(context)!.history,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.bookmark_border),
              activeIcon: const Icon(Icons.bookmark),
              label: AppLocalizations.of(context)!.favorites,
            ),
          ],
        ),
      ),
    );
  }
}
