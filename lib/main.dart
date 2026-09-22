import 'package:flutter/material.dart';
import 'config/app_theme.dart';
import 'repository/local_glycemia_repository.dart';
import 'screens/home_screen.dart';
import 'screens/history_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const GlycemiaApp());
}

class GlycemiaApp extends StatelessWidget {
  const GlycemiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Controle Glicêmico',
      theme: appTheme(),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;
  final LocalGlycemiaRepository repository = LocalGlycemiaRepository();

  void _goTo(int value) => setState(() => index = value);

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      HomeScreen(repository: repository),
      HistoryScreen(repository: repository),
      ReportsScreen(repository: repository),
      SettingsScreen(repository: repository),
    ];

    return Scaffold(
      body: IndexedStack(index: index, children: screens),
      bottomNavigationBar: _BottomNavigation(
        currentIndex: index,
        onSelected: _goTo,
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onSelected;

  const _BottomNavigation({
    required this.currentIndex,
    required this.onSelected,
  });

  static const _items = [
    (Icons.home_outlined, Icons.home_rounded, 'Início'),
    (Icons.receipt_long_outlined, Icons.receipt_long_rounded, 'Histórico'),
    (Icons.insert_chart_outlined_rounded, Icons.insert_chart_rounded, 'Relatórios'),
    (Icons.settings_outlined, Icons.settings_rounded, 'Configurações'),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: SafeArea(
        top: false,
        child: Container(
          height: 76,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.line)),
          ),
          padding: const EdgeInsets.fromLTRB(8, 5, 8, 4),
          child: Row(
            children: [
              for (var i = 0; i < _items.length; i++)
                Expanded(
                  child: _BottomNavigationItem(
                    icon: currentIndex == i ? _items[i].$2 : _items[i].$1,
                    label: _items[i].$3,
                    selected: currentIndex == i,
                    onTap: () => onSelected(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavigationItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _BottomNavigationItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.brandSoft,
      highlightColor: AppColors.brandSoft.withValues(alpha: .35),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: selected ? AppColors.brand : AppColors.muted,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.5,
              height: 1.1,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              color: selected ? AppColors.brand : AppColors.muted,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: selected ? 20 : 0,
            height: 2.5,
            decoration: BoxDecoration(
              color: AppColors.brand,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        ],
      ),
    );
  }
}

