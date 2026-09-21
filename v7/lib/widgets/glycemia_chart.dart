import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/glycemia_record.dart';

class GlycemiaChart extends StatelessWidget {
  final List<GlycemiaRecord> records;
  const GlycemiaChart({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Evolução da glicemia',
      icon: Icons.show_chart,
      child: Column(children: [
        SizedBox(height: 190, width: double.infinity, child: CustomPaint(painter: _ChartPainter(records))),
        const SizedBox(height: 14),
        _SecondaryButton(label: 'Ver gráfico completo', icon: Icons.chevron_right, onPressed: () {}),
      ]),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<GlycemiaRecord> records;
  _ChartPainter(this.records);

  @override
  void paint(Canvas canvas, Size size) {
    if (records.length < 2) return;
    final left = 34.0, right = 10.0, top = 10.0, bottom = 30.0;
    final chartW = size.width - left - right;
    final chartH = size.height - top - bottom;
    final vals = records.map((r) => r.glycemia.toDouble()).toList();
    final minValue = vals.reduce((a, b) => a < b ? a : b);
    final maxValue = vals.reduce((a, b) => a > b ? a : b);
    final minV = math.max(0, ((minValue - 10) / 50).floor() * 50).toDouble();
    final maxV = ((maxValue + 10) / 50).ceil() * 50.0;
    final range = math.max(1, maxV - minV);
    double x(int i) => left + (i / (records.length - 1)) * chartW;
    double y(double v) => top + (1 - ((v - minV) / range)) * chartH;

    final gridPaint = Paint()..color = AppColors.line..strokeWidth = 1;
    final linePaint = Paint()..color = AppColors.accent..strokeWidth = 2.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
    final dotPaint = Paint()..color = AppColors.surface..style = PaintingStyle.fill;
    final dotStroke = Paint()..color = AppColors.accent..strokeWidth = 2..style = PaintingStyle.stroke;
    final text = TextPainter(textDirection: TextDirection.ltr);

    for (double v = minV; v <= maxV; v += 50) {
      final yy = y(v);
      canvas.drawLine(Offset(left, yy), Offset(size.width - right, yy), gridPaint);
      text.text = TextSpan(text: '${v.toInt()}', style: const TextStyle(fontSize: 11, color: AppColors.muted));
      text.layout(); text.paint(canvas, Offset(left - text.width - 6, yy - text.height / 2));
    }

    final path = Path();
    for (var i = 0; i < records.length; i++) {
      final p = Offset(x(i), y(vals[i]));
      if (i == 0) path.moveTo(p.dx, p.dy); else path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, linePaint);
    for (var i = 0; i < records.length; i++) {
      final p = Offset(x(i), y(vals[i]));
      canvas.drawCircle(p, i == records.length - 1 ? 4.5 : 3, dotPaint);
      canvas.drawCircle(p, i == records.length - 1 ? 4.5 : 3, dotStroke);
    }
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) => oldDelegate.records != records;
}

class _Card extends StatelessWidget {
  final String title; final IconData icon; final Widget child;
  const _Card({required this.title, required this.icon, required this.child});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity, padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
    decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.line), borderRadius: BorderRadius.circular(22), boxShadow: const [BoxShadow(color: Color(0x0D5B1828), blurRadius: 16, offset: Offset(0, 6))]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Icon(icon, color: AppColors.brand, size: 22), const SizedBox(width: 10), Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.brandDeep))]),
      const SizedBox(height: 12), child,
    ]),
  );
}

class _SecondaryButton extends StatelessWidget {
  final String label; final IconData icon; final VoidCallback onPressed;
  const _SecondaryButton({required this.label, required this.icon, required this.onPressed});
  @override
  Widget build(BuildContext context) => SizedBox(width: double.infinity, height: 48, child: TextButton(onPressed: onPressed, style: TextButton.styleFrom(backgroundColor: AppColors.brandSoft, foregroundColor: AppColors.brandDeep, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), child: Row(children: [const Spacer(), Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)), const Spacer(), Icon(icon, size: 20)])));
}
