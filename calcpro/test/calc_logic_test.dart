import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:calcpro/models/unit_data.dart';

void main() {
  group('Unit conversion', () {
    test('meters to feet', () {
      final meters = lengthUnits.firstWhere((u) => u.name == 'Meters');
      final feet = lengthUnits.firstWhere((u) => u.name == 'Feet');
      final result = convertUnits(value: 1, from: meters, to: feet);
      expect(result, closeTo(3.28084, 0.00001));
    });

    test('kilograms to pounds', () {
      final kg = weightUnits.firstWhere((u) => u.name == 'Kilograms');
      final lb = weightUnits.firstWhere((u) => u.name == 'Pounds');
      final result = convertUnits(value: 1, from: kg, to: lb);
      expect(result, closeTo(2.20462, 0.00001));
    });
  });

  group('Mortgage math', () {
    test('zero interest divides evenly', () {
      const p = 120000.0;
      const n = 120.0;
      expect(p / n, 1000);
    });

    test('standard amortization', () {
      const p = 200000.0;
      const annual = 6.0;
      const years = 30.0;
      final r = (annual / 100) / 12;
      final n = years * 12;
      final payment = p * (r * math.pow(1 + r, n)) / (math.pow(1 + r, n) - 1);
      expect(payment, closeTo(1199.10, 0.5));
    });
  });

  group('Financial compound interest', () {
    test('A = P(1+r)^t', () {
      const p = 1000.0;
      const r = 0.05;
      const t = 10.0;
      final amount = p * math.pow(1 + r, t);
      expect(amount, closeTo(1628.89, 0.01));
    });
  });

  group('Percentage formulas', () {
    test('X% of Y', () {
      expect((25 * 200) / 100, 50);
    });

    test('what percent', () {
      expect((50 / 200) * 100, 25);
    });

    test('percent change', () {
      expect(((150 - 100) / 100) * 100, 50);
    });
  });

  group('Discount', () {
    test('single discount', () {
      const price = 100.0;
      const discount = 20.0;
      final saved = (price * discount) / 100;
      expect(price - saved, 80);
    });

    test('stacked discounts compound', () {
      var current = 100.0;
      for (final d in [10.0, 10.0]) {
        current -= (current * d) / 100;
      }
      expect(current, closeTo(81.0, 0.001));
    });
  });
}
