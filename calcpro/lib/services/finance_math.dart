import 'dart:math' as math;

/// Shared finance formulas used across Calcara (EMI, mortgage, savings).
class FinanceMath {
  static double monthlyRate(double annualPercent) => (annualPercent / 100) / 12;

  static double emi({
    required double principal,
    required double annualPercent,
    required double years,
  }) {
    final r = monthlyRate(annualPercent);
    final n = years * 12;
    if (n <= 0) return 0;
    if (r == 0) return principal / n;
    return principal * r * math.pow(1 + r, n) / (math.pow(1 + r, n) - 1);
  }

  static double loanFromPayment({
    required double payment,
    required double annualPercent,
    required double years,
  }) {
    final r = monthlyRate(annualPercent);
    final n = years * 12;
    if (n <= 0) return 0;
    if (r == 0) return payment * n;
    return payment * (math.pow(1 + r, n) - 1) / (r * math.pow(1 + r, n));
  }

  /// Future value with optional monthly deposits (end of period).
  static double futureValue({
    required double principal,
    required double annualPercent,
    required double years,
    double monthlyDeposit = 0,
  }) {
    final r = monthlyRate(annualPercent);
    final n = years * 12;
    if (n <= 0) return principal;
    if (r == 0) return principal + monthlyDeposit * n;
    final growth = principal * math.pow(1 + r, n);
    final annuity = monthlyDeposit * (math.pow(1 + r, n) - 1) / r;
    return growth + annuity;
  }

  static List<AmortizationRow> amortizationSchedule({
    required double principal,
    required double annualPercent,
    required double years,
    int maxRows = 360,
  }) {
    final r = monthlyRate(annualPercent);
    final n = (years * 12).round();
    if (n <= 0) return const [];
    final payment = emi(
      principal: principal,
      annualPercent: annualPercent,
      years: years,
    );
    var balance = principal;
    final rows = <AmortizationRow>[];
    final limit = math.min(n, maxRows);
    for (var i = 1; i <= limit; i++) {
      final interest = r == 0 ? 0.0 : balance * r;
      var principalPart = payment - interest;
      if (principalPart > balance) principalPart = balance;
      balance = (balance - principalPart).clamp(0, double.infinity).toDouble();
      rows.add(
        AmortizationRow(
          month: i,
          payment: payment,
          principal: principalPart,
          interest: interest,
          balance: balance,
        ),
      );
      if (balance <= 0.01) break;
    }
    return rows;
  }
}

class AmortizationRow {
  final int month;
  final double payment;
  final double principal;
  final double interest;
  final double balance;

  const AmortizationRow({
    required this.month,
    required this.payment,
    required this.principal,
    required this.interest,
    required this.balance,
  });
}

/// Offline USD-based FX table (approximate). Enough for everyday convert demos.
class CurrencyRates {
  static const updatedLabel = 'Offline mid-market approx · Jul 2026';

  /// Units of currency per 1 USD.
  static const Map<String, double> perUsd = {
    'USD': 1,
    'EUR': 0.92,
    'GBP': 0.79,
    'INR': 83.5,
    'JPY': 157.0,
    'CAD': 1.37,
    'AUD': 1.52,
    'CHF': 0.89,
    'CNY': 7.25,
    'MXN': 18.2,
    'BRL': 5.45,
    'AED': 3.67,
    'SGD': 1.35,
    'HKD': 7.82,
    'KRW': 1380.0,
    'ZAR': 18.5,
    'NZD': 1.66,
    'SEK': 10.6,
    'NOK': 10.8,
    'DKK': 6.85,
  };

  static double convert({
    required double amount,
    required String from,
    required String to,
  }) {
    final fromRate = perUsd[from] ?? 1;
    final toRate = perUsd[to] ?? 1;
    final usd = amount / fromRate;
    return usd * toRate;
  }
}
