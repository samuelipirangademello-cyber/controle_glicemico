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
      return _card(
        const Text(
          'Nenhuma medição registrada ainda.',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.muted,
          ),
        ),
      );
    }

    final key = GlycemiaRules.statusKey(record!.status);
    final statusBg = switch (key) {
      'ok' => AppColors.okBg,
      'warn' => AppColors.warnBg,
      'high' => AppColors.highBg,
      _ => AppColors.lowBg,
    };
    final statusFg = switch (key) {
      'ok' => AppColors.okFg,
      'warn' => AppColors.warnFg,
      'high' => AppColors.highFg,
      _ => AppColors.lowFg,
    };

    return _card(
      Stack(
        children: [
          Positioned(
            top: 2,
            right: 0,
            child: Container(
              width: 58,
              height: 58,
              decoration: const BoxDecoration(
                color: Color(0xFFF7E3E7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.water_drop_rounded,
                color: AppColors.brand,
                size: 29,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 72),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Última glicemia',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${record!.glycemia}',
                      style: const TextStyle(
                        fontSize: 50,
                        height: .98,
                        fontWeight: FontWeight.w800,
                        color: AppColors.brandDeep,
                      ),
                    ),
                    const SizedBox(width: 7),
                    const Text(
                      'mg/dL',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${record!.dateLabel}, ${record!.timeLabel}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.muted,
                  ),
                ),
                const SizedBox(height: 11),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    record!.status,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: statusFg,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFF9FA),
            Color(0xFFFFF1F3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.line),
      ),
      child: child,
    );
  }
}
