import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class ReportCard extends StatelessWidget {
  const ReportCard({super.key});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity, padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
    decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.line), borderRadius: BorderRadius.circular(22)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Row(children: [Icon(Icons.description_outlined, color: AppColors.brand, size: 22), SizedBox(width: 10), Text('Relatórios', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.brandDeep))]),
      const SizedBox(height: 8),
      const Text('Gere um relatório das suas medições por período.', style: TextStyle(fontSize: 15, color: AppColors.muted)),
      const SizedBox(height: 14),
      SizedBox(width: double.infinity, height: 48, child: TextButton(onPressed: () {}, style: TextButton.styleFrom(backgroundColor: AppColors.brandSoft, foregroundColor: AppColors.brandDeep, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), child: const Row(children: [Icon(Icons.description_outlined, size: 20), Spacer(), Text('Gerar relatório PDF', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)), Spacer(), Icon(Icons.chevron_right, size: 20)]))),
    ]),
  );
}
