import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../domain/glycemia_rules.dart';
import '../models/glycemia_record.dart';

class MeasurementCard extends StatelessWidget {
  final GlycemiaRecord? record;
  const MeasurementCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    if (record == null) {
      return _card(const Text('Nenhuma medição registrada ainda.'));
    }
    final key = GlycemiaRules.statusKey(record!.status);
    return _card(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Última medição', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.brandDeep)),
          const SizedBox(height: 6),
          Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
            Text('${record!.glycemia}', style: const TextStyle(fontSize: 64, height: 1, fontWeight: FontWeight.w800, color: AppColors.brandDeep)),
            const SizedBox(width: 8),
            const Text('mg/dL', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.brandDeep)),
          ]),
          const SizedBox(height: 8),
          Text('${record!.dateLabel}  •  ${record!.timeLabel}  •  ${record!.shift}', style: const TextStyle(fontSize: 15, color: AppColors.muted)),
          const SizedBox(height: 12),
          Row(children: [
            _StatusChip(status: record!.status, keyName: key),
            const SizedBox(width: 10),
            Flexible(child: Text(GlycemiaRules.statusNote(record!.status), style: const TextStyle(fontSize: 14, color: AppColors.muted))),
          ]),
        ],
      ),
    );
  }

  Widget _card(Widget child) => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
    decoration: BoxDecoration(
      color: AppColors.surfaceTint,
      border: Border.all(color: AppColors.line),
      borderRadius: BorderRadius.circular(22),
    ),
    child: child,
  );
}

class _StatusChip extends StatelessWidget {
  final String status;
  final String keyName;
  const _StatusChip({required this.status, required this.keyName});

  @override
  Widget build(BuildContext context) {
    final bg = switch (keyName) { 'ok' => AppColors.okBg, 'warn' => AppColors.warnBg, 'high' => AppColors.highBg, _ => AppColors.lowBg };
    final fg = switch (keyName) { 'ok' => AppColors.okFg, 'warn' => AppColors.warnFg, 'high' => AppColors.highFg, _ => AppColors.lowFg };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(status, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: fg)),
    );
  }
}
