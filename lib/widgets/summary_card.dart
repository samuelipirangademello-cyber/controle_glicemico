import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/glycemia_record.dart';

class SummaryCard extends StatelessWidget {
  final List<GlycemiaRecord> records;

  const SummaryCard({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    final values = records.map((r) => r.glycemia).toList();
    final avg =
        values.isEmpty ? null : values.reduce((a, b) => a + b) / values.length;
    final min =
        values.isEmpty ? null : values.reduce((a, b) => a < b ? a : b);
    final max =
        values.isEmpty ? null : values.reduce((a, b) => a > b ? a : b);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
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
                'Resumo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const Spacer(),
              Text(
                'Últimos 7 dias',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _metric('Média', avg == null ? '—' : '${avg.round()}'),
              _divider(),
              _metric('Mínima', min == null ? '—' : '$min'),
              _divider(),
              _metric('Máxima', max == null ? '—' : '$max'),
              _divider(),
              _metric('Medições', '${values.length}', unit: 'registros'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metric(String label, String value, {String unit = 'mg/dL'}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11.5,
              color: AppColors.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.brandDeep,
            ),
          ),
          Text(
            unit,
            style: const TextStyle(
              fontSize: 9.5,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      color: AppColors.line,
    );
  }
}
