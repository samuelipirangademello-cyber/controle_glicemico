import '../models/glycemia_record.dart';

class GlycemiaRules {
  static String statusFor(int value) {
    if (value < 70) return 'Hipoglicemia';
    if (value <= 140) return 'Normal';
    if (value <= 180) return 'Atenção';
    return 'Hiperglicemia';
  }

  static String shiftFor(DateTime time) {
    if (time.hour < 12) return 'Manhã';
    if (time.hour < 18) return 'Tarde';
    return 'Noite';
  }

  static GlycemiaRecord buildRecord({
    required DateTime dateTime,
    required int glycemia,
  }) {
    return GlycemiaRecord(
      dateTime: dateTime,
      glycemia: glycemia,
      shift: shiftFor(dateTime),
      status: statusFor(glycemia),
    );
  }

  static String statusKey(String status) {
    switch (status) {
      case 'Hipoglicemia':
        return 'low';
      case 'Atenção':
        return 'warn';
      case 'Hiperglicemia':
        return 'high';
      default:
        return 'ok';
    }
  }

  static String statusNote(String status) {
    switch (statusKey(status)) {
      case 'low':
        return 'Abaixo da faixa definida.';
      case 'warn':
        return 'Requer atenção.';
      case 'high':
        return 'Acima da faixa definida.';
      default:
        return 'Faixa dentro do intervalo definido.';
    }
  }
}
