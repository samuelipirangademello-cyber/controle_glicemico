import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/glycemia_record.dart';

class SummaryCard extends StatelessWidget {
  final List<GlycemiaRecord> records;
  const SummaryCard({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    final values = records.map((r) => r.glycemia).toList();
    final avg = values.isEmpty ? null : values.reduce((a, b) => a + b) / values.length;
    final min = values.isEmpty ? null : values.reduce((a, b) => a < b ? a : b);
    final max = values.isEmpty ? null : values.reduce((a, b) => a > b ? a : b);
    return _Card(
      title: 'Resumo do período',
      icon: Icons.bar_chart,
      child: Column(children: [
        _row('Total de medições', '${values.length}'),
        _row('Média glicêmica', avg == null ? '—' : '${avg.round()} mg/dL'),
        _row('Menor valor', min == null ? '—' : '$min mg/dL'),
        _row('Maior valor', max == null ? '—' : '$max mg/dL'),
      ]),
    );
  }

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(fontSize: 15.5, color: AppColors.ink)),
      Text(value, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.brandDeep)),
    ]),
  );
}

class _Card extends StatelessWidget {
  final String title; final IconData icon; final Widget child;
  const _Card({required this.title, required this.icon, required this.child});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
    decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.line), borderRadius: BorderRadius.circular(22), boxShadow: const [BoxShadow(color: Color(0x0D5B1828), blurRadius: 16, offset: Offset(0, 6))]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Icon(icon, color: AppColors.brand, size: 22), const SizedBox(width: 10), Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.brandDeep))]),
      const SizedBox(height: 6),
      child,
    ]),
  );
}
