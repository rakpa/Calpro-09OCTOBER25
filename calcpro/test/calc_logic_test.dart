import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:calcpro/models/unit_data.dart';
import 'package:calcpro/services/finance_math.dart';

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

    test('celsius to fahrenheit', () {
      final c = temperatureUnits.firstWhere((u) => u.name == 'Celsius');
      final f = temperatureUnits.firstWhere((u) => u.name == 'Fahrenheit');
      expect(convertUnits(value: 0, from: c, to: f), closeTo(32, 0.001));
      expect(convertUnits(value: 100, from: c, to: f), closeTo(212, 0.001));
    });

    test('liters to gallons', () {
      final l = volumeUnits.firstWhere((u) => u.name == 'Liters');
      final g = volumeUnits.firstWhere((u) => u.name == 'Gallons (US)');
      expect(
        convertUnits(value: 1, from: l, to: g),
        closeTo(0.264172, 0.00001),
      );
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

  group('EMI math', () {
    test('standard EMI amortization', () {
      const p = 250000.0;
      const annual = 8.5;
      const years = 20.0;
      final r = (annual / 100) / 12;
      final n = years * 12;
      final emi = p * r * math.pow(1 + r, n) / (math.pow(1 + r, n) - 1);
      expect(emi, closeTo(2167.0, 5));
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

  group('Sales tax', () {
    test('add tax', () {
      const price = 100.0;
      const rate = 8.25;
      final tax = price * rate / 100;
      expect(price + tax, closeTo(108.25, 0.001));
    });

    test('remove tax', () {
      const total = 108.25;
      const rate = 8.25;
      final pretax = total / (1 + rate / 100);
      expect(pretax, closeTo(100.0, 0.01));
    });
  });

  group('Unit price', () {
    test('cheaper per unit wins', () {
      final a = 4.99 / 12;
      final b = 7.49 / 20;
      expect(a > b, isTrue);
    });
  });

  group('Mortgage affordability', () {
    test('loan from payment inverts EMI', () {
      const payment = 1500.0;
      const annual = 6.5;
      const years = 30.0;
      final r = (annual / 100) / 12;
      final n = years * 12;
      final loan =
          payment * (math.pow(1 + r, n) - 1) / (r * math.pow(1 + r, n));
      final check =
          loan * r * math.pow(1 + r, n) / (math.pow(1 + r, n) - 1);
      expect(check, closeTo(payment, 0.5));
    });
  });

  group('FinanceMath', () {
    test('emi matches standard amortization', () {
      final payment = FinanceMath.emi(
        principal: 200000,
        annualPercent: 6,
        years: 30,
      );
      expect(payment, closeTo(1199.10, 0.5));
    });

    test('loanFromPayment inverts emi', () {
      final payment = FinanceMath.emi(
        principal: 250000,
        annualPercent: 6.5,
        years: 30,
      );
      final loan = FinanceMath.loanFromPayment(
        payment: payment,
        annualPercent: 6.5,
        years: 30,
      );
      expect(loan, closeTo(250000, 1));
    });

    test('futureValue with deposits grows', () {
      final fv = FinanceMath.futureValue(
        principal: 1000,
        annualPercent: 6,
        years: 1,
        monthlyDeposit: 100,
      );
      expect(fv, greaterThan(1000 + 1200));
    });

    test('amortization schedule ends near zero', () {
      final rows = FinanceMath.amortizationSchedule(
        principal: 10000,
        annualPercent: 5,
        years: 2,
      );
      expect(rows.length, 24);
      expect(rows.last.balance, closeTo(0, 0.05));
    });

    test('currency convert USD to EUR', () {
      final eur = CurrencyRates.convert(amount: 100, from: 'USD', to: 'EUR');
      expect(eur, closeTo(92, 0.01));
    });
  });

  group('Fraction reduce', () {
    test('add 1/2 + 1/3 = 5/6', () {
      const an = 1, ad = 2, bn = 1, bd = 3;
      final num = an * bd + bn * ad;
      final den = ad * bd;
      int gcd(int a, int b) {
        a = a.abs();
        b = b.abs();
        while (b != 0) {
          final t = b;
          b = a % b;
          a = t;
        }
        return a == 0 ? 1 : a;
      }

      final g = gcd(num, den);
      expect(num ~/ g, 5);
      expect(den ~/ g, 6);
    });
  });
}
