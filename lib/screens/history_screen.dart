import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../domain/glycemia_rules.dart';
import '../models/glycemia_record.dart';
import '../repository/glycemia_repository.dart';

class HistoryScreen extends StatefulWidget {
  final GlycemiaRepository repository;
  const HistoryScreen({super.key, required this.repository});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<GlycemiaRecord>> future;

  @override
  void initState() {
    super.initState();
    future = widget.repository.getRecords();
  }

  Future<void> _refresh() async {
    setState(() => future = widget.repository.getRecords());
    await future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: FutureBuilder<List<GlycemiaRecord>>(
          future: future,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.brand),
              );
            }

            final records = [...snapshot.data!]
              ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

            return RefreshIndicator(
              color: AppColors.brand,
              onRefresh: _refresh,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                itemCount: records.length + 1,
                separatorBuilder: (_, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const Padding(
                      padding: EdgeInsets.fromLTRB(4, 0, 4, 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Histórico',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: AppColors.brandDeep,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Todas as medições armazenadas neste aparelho.',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return _HistoryRow(record: records[index - 1]);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  final GlycemiaRecord record;
  const _HistoryRow({required this.record});

  @override
  Widget build(BuildContext context) {
    final key = GlycemiaRules.statusKey(record.status);
    final color = switch (key) {
      'ok' => AppColors.okFg,
      'warn' => AppColors.warnFg,
      'high' => AppColors.highFg,
      _ => AppColors.lowFg,
    };

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Container(
            width: 11,
            height: 11,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${record.glycemia} mg/dL',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${record.dateLabel} • ${record.timeLabel} • ${record.shift}',
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: .10),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              record.status,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
