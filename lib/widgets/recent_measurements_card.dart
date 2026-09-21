import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../domain/glycemia_rules.dart';
import '../models/glycemia_record.dart';

class RecentMeasurementsCard extends StatelessWidget {
  final List<GlycemiaRecord> records;
  const RecentMeasurementsCard({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    final recent = records.reversed.take(4).toList();
    return Container(
      width: double.infinity, padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.line), borderRadius: BorderRadius.circular(22), boxShadow: const [BoxShadow(color: Color(0x0D5B1828), blurRadius: 16, offset: Offset(0, 6))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [Icon(Icons.list_alt, color: AppColors.brand, size: 22), SizedBox(width: 10), Text('Últimas medições', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.brandDeep))]),
        const SizedBox(height: 12),
        SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(
          columnSpacing: 18,
          headingRowColor: WidgetStateProperty.all(AppColors.surfaceSoft),
          columns: const [DataColumn(label: Text('Hora')), DataColumn(label: Text('Glicemia')), DataColumn(label: Text('Turno')), DataColumn(label: Text('Status'))],
          rows: recent.map((r) => DataRow(cells: [
            DataCell(Text(r.timeLabel)), DataCell(Text('${r.glycemia}', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.brandDeep))), DataCell(Text(r.shift)), DataCell(Text(r.status, style: TextStyle(fontWeight: FontWeight.w700, color: _statusColor(r.status)))),
          ])).toList(),
        )),
        const SizedBox(height: 14),
        SizedBox(width: double.infinity, height: 48, child: TextButton(onPressed: () {}, style: TextButton.styleFrom(backgroundColor: AppColors.brandSoft, foregroundColor: AppColors.brandDeep, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), child: const Row(children: [Icon(Icons.list_alt, size: 20), Spacer(), Text('Ver histórico completo', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)), Spacer(), Icon(Icons.chevron_right, size: 20)]))),
      ]),
    );
  }

  static Color _statusColor(String status) {
    switch (GlycemiaRules.statusKey(status)) {
      case 'low': return AppColors.lowFg;
      case 'warn': return AppColors.warnFg;
      case 'high': return AppColors.highFg;
      default: return AppColors.okFg;
    }
  }
}
