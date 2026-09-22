import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/app_theme.dart';
import '../domain/glycemia_rules.dart';
import '../models/glycemia_record.dart';
import '../repository/glycemia_repository.dart';
import '../widgets/app_header.dart';
import '../widgets/glycemia_chart.dart';
import '../widgets/measurement_card.dart';
import '../widgets/recent_measurements_card.dart';
import '../widgets/register_button.dart';
import '../widgets/report_card.dart';
import '../widgets/summary_card.dart';
import '../services/google_sheets_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> _refresh() async {
    setState(_loadRecords);
    await _recordsFuture;
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
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Não foi possível carregar as medições.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.muted),
                  ),
                ),
              );
            }

            final records = [...?snapshot.data]
              ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
            final recent = records.length > 7
                ? records.sublist(records.length - 7)
                : records;

            return RefreshIndicator(
              color: AppColors.brand,
              onRefresh: _refresh,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
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
                        RegisterButton(onPressed: _showRegisterForm),
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
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showRegisterForm() async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => _RegisterFormSheet(repository: widget.repository),
    );

    if (saved == true && mounted) {
      await _refresh();
    }
  }
}

class _RegisterFormSheet extends StatefulWidget {
  final GlycemiaRepository repository;
  const _RegisterFormSheet({required this.repository});

  @override
  State<_RegisterFormSheet> createState() => _RegisterFormSheetState();
}

class _RegisterFormSheetState extends State<_RegisterFormSheet> {
  final controller = TextEditingController();
  String? error;
  bool saving = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final value = int.tryParse(controller.text.trim());
    if (value == null || value <= 0) {
      setState(() => error = 'Digite um valor de glicemia válido.');
      return;
    }

    setState(() {
      error = null;
      saving = true;
    });

    try {
      final now = DateTime.now();
      final record = GlycemiaRules.buildRecord(
        dateTime: now,
        glycemia: value,
      );
      await widget.repository.addRecord(record);
      // Se o Google Sheets já estiver conectado, envia também a nova medição.
      try {
        final google = GoogleSheetsService.instance;
        if (google.user != null) {
          final prefs = await SharedPreferences.getInstance();
          final sheetId = prefs.getString('google_spreadsheet_id') ?? '';
          final range = prefs.getString('google_sheet_range') ?? 'A:E';
          if (sheetId.isNotEmpty) {
            await google.appendRecord(spreadsheetId: sheetId, range: range, record: record);
          }
        }
      } catch (_) {
        // O registro local permanece salvo mesmo se a internet estiver indisponível.
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (mounted) {
        setState(() {
          saving = false;
          error = 'Não foi possível salvar a medição.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 24 + bottom),
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
                fontSize: 23,
                fontWeight: FontWeight.w800,
                color: AppColors.brandDeep,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Digite somente o valor medido. Data, hora, turno e status serão preenchidos automaticamente.',
              style: TextStyle(
                fontSize: 14.5,
                height: 1.4,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => saving ? null : _save(),
              decoration: InputDecoration(
                labelText: 'Glicemia',
                hintText: 'Ex.: 99',
                suffixText: 'mg/dL',
                errorText: error,
                filled: true,
                fillColor: AppColors.bg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.line),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.line),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.brand,
                    width: 2,
                  ),
                ),
              ),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: saving ? null : _save,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.brand,
                  foregroundColor: AppColors.onBrand,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: saving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'SALVAR MEDIÇÃO',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
