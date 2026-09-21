class GlycemiaRecord {
  final DateTime dateTime;
  final int glycemia;
  final String shift;
  final String status;

  const GlycemiaRecord({
    required this.dateTime,
    required this.glycemia,
    required this.shift,
    required this.status,
  });

  String get dateLabel {
    final d = dateTime.day.toString().padLeft(2, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final y = dateTime.year.toString();
    return '$d/$m/$y';
  }

  String get timeLabel {
    final h = dateTime.hour.toString().padLeft(2, '0');
    final m = dateTime.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
