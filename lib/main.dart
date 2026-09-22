import 'package:flutter/material.dart';
import 'config/app_theme.dart';
import 'repository/in_memory_glycemia_repository.dart';
import 'screens/home_screen.dart';

void main() {
  // DIAGNÓSTICO (build 10): em vez do bloco colorido padrão do Flutter em
  // modo release quando um widget falha ao construir/desenhar, mostra o
  // texto real do erro na tela. Isso é só para investigação; será removido
  // assim que a causa for identificada e corrigida.
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        child: Text(
          'ERRO DE INTERFACE (envie esta tela ao Claude):\n\n'
          '${details.exceptionAsString()}\n\n'
          '${details.stack}',
          style: const TextStyle(color: Colors.red, fontSize: 11, fontFamily: 'monospace'),
        ),
      ),
    );
  };
  // Captura também erros que aconteçam fora da construção de widgets
  // (ex.: em callbacks assíncronos), para não sumirem silenciosamente.
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };
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
  final repository = InMemoryGlycemiaRepository();

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      HomeScreen(repository: repository),
      const _PlaceholderScreen(
        title: 'Histórico',
        icon: Icons.list_alt_outlined,
        message: 'O histórico completo será desenvolvido na próxima etapa.',
      ),
      const _PlaceholderScreen(
        title: 'Relatórios',
        icon: Icons.description_outlined,
        message: 'Os relatórios serão desenvolvidos nas próximas etapas.',
      ),
      const _PlaceholderScreen(
        title: 'Configurações',
        icon: Icons.settings_outlined,
        message: 'As configurações serão desenvolvidas nas próximas etapas.',
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: index, children: screens),
      bottomNavigationBar: _BottomNav(
        currentIndex: index,
        onSelected: (value) => setState(() => index = value),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onSelected;

  const _BottomNav({required this.currentIndex, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.home_outlined, Icons.home, 'Início'),
      (Icons.list_alt_outlined, Icons.list_alt, 'Histórico'),
      (Icons.bar_chart_outlined, Icons.bar_chart, 'Relatórios'),
      (Icons.settings_outlined, Icons.settings, 'Configurações'),
    ];

    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _NavItem(
                    icon: currentIndex == i ? items[i].$2 : items[i].$1,
                    label: items[i].$3,
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

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            constraints: const BoxConstraints(minHeight: 58),
            padding: const EdgeInsets.symmetric(vertical: 7),
            decoration: BoxDecoration(
              color: selected ? AppColors.brandSoft : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 23,
                  color: selected ? AppColors.brandDeep : AppColors.muted,
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    color: selected ? AppColors.brandDeep : AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final String message;

  const _PlaceholderScreen({
    required this.title,
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.brandSoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(icon, size: 30, color: AppColors.brandDeep),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.brandDeep,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, color: AppColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
