import 'package:flutter_test/flutter_test.dart';
import 'package:controle_glicemico/domain/glycemia_rules.dart';

void main() {
  group('STATUS', () {
    test('classifica abaixo de 70 como Hipoglicemia', () {
      expect(GlycemiaRules.statusFor(69), 'Hipoglicemia');
    });
    test('classifica 70 a 140 como Normal', () {
      expect(GlycemiaRules.statusFor(70), 'Normal');
      expect(GlycemiaRules.statusFor(140), 'Normal');
    });
    test('classifica acima de 140 até 180 como Atenção', () {
      expect(GlycemiaRules.statusFor(141), 'Atenção');
      expect(GlycemiaRules.statusFor(180), 'Atenção');
    });
    test('classifica acima de 180 como Hiperglicemia', () {
      expect(GlycemiaRules.statusFor(181), 'Hiperglicemia');
    });
  });

  group('TURNO', () {
    test('antes de 12:00 e Manhã', () {
      expect(GlycemiaRules.shiftFor(DateTime(2026, 9, 21, 11, 59)), 'Manhã');
    });
    test('12:00 até antes de 18:00 e Tarde', () {
      expect(GlycemiaRules.shiftFor(DateTime(2026, 9, 21, 12, 0)), 'Tarde');
      expect(GlycemiaRules.shiftFor(DateTime(2026, 9, 21, 17, 59)), 'Tarde');
    });
    test('18:00 em diante e Noite', () {
      expect(GlycemiaRules.shiftFor(DateTime(2026, 9, 21, 18, 0)), 'Noite');
    });
  });
}
