import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/glycemia_record.dart';

class ReportService {
  static Future<void> printReport({required DateTime start, required DateTime end, required List<GlycemiaRecord> records}) async {
    await Printing.layoutPdf(onLayout: (format) => _buildPdf(format, start, end, records));
  }

  static Future<List<int>> _buildPdf(PdfPageFormat format, DateTime start, DateTime end, List<GlycemiaRecord> records) async {
    final pdf = pw.Document();
    final avg = records.isEmpty ? 0 : records.map((r) => r.glycemia).reduce((a,b)=>a+b) / records.length;
    final min = records.isEmpty ? 0 : records.map((r)=>r.glycemia).reduce((a,b)=>a<b?a:b);
    final max = records.isEmpty ? 0 : records.map((r)=>r.glycemia).reduce((a,b)=>a>b?a:b);
    pdf.addPage(pw.MultiPage(pageFormat: format, build: (context) => [
      pw.Text('Controle Glicêmico', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
      pw.SizedBox(height: 8),
      pw.Text('Período: ${_date(start)} a ${_date(end)}'),
      pw.SizedBox(height: 18),
      pw.Row(children: [
        _metric('Média', avg.toStringAsFixed(0)),
        _metric('Mínima', '$min'),
        _metric('Máxima', '$max'),
        _metric('Registros', '${records.length}'),
      ]),
      pw.SizedBox(height: 20),
      if (records.isNotEmpty) pw.Table.fromTextArray(
        headers: const ['Data', 'Hora', 'Glicemia', 'Turno', 'Status'],
        data: records.map((r) => [r.dateLabel, r.timeLabel, '${r.glycemia} mg/dL', r.shift, r.status]).toList(),
        headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        cellStyle: const pw.TextStyle(fontSize: 8),
        cellPadding: const pw.EdgeInsets.all(5),
      ) else pw.Text('Nenhuma medição encontrada no período.'),
    ]));
    return pdf.save();
  }
  static pw.Widget _metric(String label, String value) => pw.Expanded(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [pw.Text(label), pw.SizedBox(height: 4), pw.Text(value, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold))]));
  static String _date(DateTime d) => '${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year}';
}
