import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/glycemia_record.dart';
import '../repository/glycemia_repository.dart';
import '../widgets/app_header.dart';
import '../widgets/glycemia_chart.dart';
import '../widgets/measurement_card.dart';
import '../widgets/recent_measurements_card.dart';
import '../widgets/register_button.dart';
import '../widgets/report_card.dart';
import '../widgets/summary_card.dart';

class HomeScreen extends StatefulWidget {
  final GlycemiaRepository repository;
  const HomeScreen({super.key, required this.repository});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<GlycemiaRecord>> _recordsFuture;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  void _loadRecords() {
    _recordsFuture = widget.repository.getRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: FutureBuilder<List<GlycemiaRecord>>(
          future: _recordsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.brand),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Não foi possível carregar as medições.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.muted),
                  ),
                ),
              );
            }

            final records = [...?snapshot.data]
              ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
            final recent = records.length > 7
                ? records.sublist(records.length - 7)
                : records;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: const AppHeader(),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 112),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      MeasurementCard(
                        record: records.isEmpty ? null : records.last,
                      ),
                      const SizedBox(height: 14),
                      RegisterButton(onPressed: _showRegisterPreview),
                      const SizedBox(height: 14),
                      SummaryCard(records: records),
                      const SizedBox(height: 14),
                      GlycemiaChart(records: recent),
                      const SizedBox(height: 14),
                      const ReportCard(),
                      const SizedBox(height: 14),
                      RecentMeasurementsCard(records: records),
                    ]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showRegisterPreview() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => const _RegisterPreviewSheet(),
    );
  }
}

class _RegisterPreviewSheet extends StatelessWidget {
  const _RegisterPreviewSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.line,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Registrar glicemia',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.brandDeep,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'A tela de registro será implementada na etapa de dados locais. Nesta etapa, nenhum dado é gravado.',
              style: TextStyle(fontSize: 15, color: AppColors.muted, height: 1.4),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.brand,
                  foregroundColor: AppColors.onBrand,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Fechar',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
