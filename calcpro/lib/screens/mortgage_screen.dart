import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';

class MortgageScreen extends StatefulWidget {
  const MortgageScreen({super.key});

  @override
  State<MortgageScreen> createState() => _MortgageScreenState();
}

class _MortgageScreenState extends State<MortgageScreen> {
  final principal = TextEditingController();
  final rate = TextEditingController();
  final term = TextEditingController();
  final propertyTax = TextEditingController();
  final insurance = TextEditingController();

  String? monthlyPayment;
  String? totalPayment;
  String? totalInterest;
  String? totalTax;
  String? totalInsurance;
  String? principalDisplay;
  final currency = NumberFormat.currency(symbol: '\$');

  @override
  void dispose() {
    principal.dispose();
    rate.dispose();
    term.dispose();
    propertyTax.dispose();
    insurance.dispose();
    super.dispose();
  }

  void _clear() {
    setState(() {
      principal.clear();
      rate.clear();
      term.clear();
      propertyTax.clear();
      insurance.clear();
      monthlyPayment = totalPayment = totalInterest = null;
      totalTax = totalInsurance = principalDisplay = null;
    });
  }

  void _calculate() {
    final p = double.tryParse(principal.text);
    final annualRate = double.tryParse(rate.text);
    final years = double.tryParse(term.text);
    if (p == null || annualRate == null || years == null) return;

    final r = (annualRate / 100) / 12;
    final n = years * 12;
    final monthlyTax =
        propertyTax.text.isEmpty ? 0.0 : (double.tryParse(propertyTax.text) ?? 0) / 12;
    final monthlyIns =
        insurance.text.isEmpty ? 0.0 : (double.tryParse(insurance.text) ?? 0) / 12;

    double mortgagePayment;
    if (r == 0) {
      mortgagePayment = p / n;
    } else {
      mortgagePayment =
          p * (r * math.pow(1 + r, n)) / (math.pow(1 + r, n) - 1);
    }

    final totalMonthly = mortgagePayment + monthlyTax + monthlyIns;
    setState(() {
      monthlyPayment = totalMonthly.toStringAsFixed(2);
      totalPayment = (totalMonthly * n).toStringAsFixed(2);
      principalDisplay = p.toStringAsFixed(2);
      totalInterest = ((mortgagePayment * n) - p).toStringAsFixed(2);
      totalTax = monthlyTax > 0 ? (monthlyTax * n).toStringAsFixed(2) : null;
      totalInsurance =
          monthlyIns > 0 ? (monthlyIns * n).toStringAsFixed(2) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ready = principal.text.isNotEmpty &&
        rate.text.isNotEmpty &&
        term.text.isNotEmpty;

    return CalcScaffold(
      title: 'Mortgage Calculator',
      icon: Icons.home,
      description: 'Estimate monthly mortgage payments with optional tax and insurance.',
      onClear: _clear,
      body: Column(
        children: [
          LabeledField(
            label: 'Loan Amount (\$)',
            controller: principal,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          LabeledField(
            label: 'Annual Interest Rate (%)',
            controller: rate,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          LabeledField(
            label: 'Loan Term (Years)',
            controller: term,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          LabeledField(
            label: 'Annual Property Tax (\$) — optional',
            controller: propertyTax,
          ),
          const SizedBox(height: 12),
          LabeledField(
            label: 'Annual Insurance (\$) — optional',
            controller: insurance,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: ready ? _calculate : null,
            child: const Text('Calculate'),
          ),
          if (monthlyPayment != null)
            ResultPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Monthly Payment: \$$monthlyPayment'),
                  Text('Total Payment: \$$totalPayment'),
                  Text('Principal: \$$principalDisplay'),
                  Text('Total Interest: \$$totalInterest'),
                  if (totalTax != null) Text('Total Property Tax: \$$totalTax'),
                  if (totalInsurance != null)
                    Text('Total Insurance: \$$totalInsurance'),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
