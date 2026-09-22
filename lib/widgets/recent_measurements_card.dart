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
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Medições recentes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const Spacer(),
              const Text(
                'Ver todas',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.brand,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          ...recent.map((record) => _row(record)),
        ],
      ),
    );
  }

  Widget _row(GlycemiaRecord record) {
    final key = GlycemiaRules.statusKey(record.status);
    final color = switch (key) {
      'ok' => AppColors.okFg,
      'warn' => AppColors.warnFg,
      'high' => AppColors.highFg,
      _ => AppColors.lowFg,
    };

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.line),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${record.glycemia} mg/dL',
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${record.dateLabel}, ${record.timeLabel}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 4,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .10),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  record.status,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 3),
          const Icon(
            Icons.chevron_right_rounded,
            size: 21,
            color: AppColors.muted,
          ),
        ],
      ),
    );
  }
}
