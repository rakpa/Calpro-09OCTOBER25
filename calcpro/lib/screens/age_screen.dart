import 'package:flutter/material.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';

class AgeScreen extends StatefulWidget {
  const AgeScreen({super.key});

  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  DateTime? birthDate;
  DateTime toDate = DateTime.now();
  int? years;
  int? months;
  int? days;
  int? totalDays;

  void _clear() {
    setState(() {
      birthDate = null;
      toDate = DateTime.now();
      years = months = days = totalDays = null;
    });
  }

  Future<void> _pickBirth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: birthDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365 * 100)),
    );
    if (picked != null) setState(() => birthDate = picked);
  }

  Future<void> _pickTo() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: toDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365 * 100)),
    );
    if (picked != null) setState(() => toDate = picked);
  }

  void _calculate() {
    if (birthDate == null) return;
    var start = birthDate!;
    var end = toDate;
    if (end.isBefore(start)) {
      final tmp = start;
      start = end;
      end = tmp;
    }

    // Calendar-accurate age (years / months / days)
    var y = end.year - start.year;
    var m = end.month - start.month;
    var d = end.day - start.day;
    if (d < 0) {
      m -= 1;
      final prevMonth = DateTime(end.year, end.month, 0);
      d += prevMonth.day;
    }
    if (m < 0) {
      y -= 1;
      m += 12;
    }

    setState(() {
      years = y;
      months = m;
      days = d;
      totalDays = end.difference(start).inDays;
    });
  }

  String _fmt(DateTime? d) {
    if (d == null) return 'Select date';
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return CalcScaffold(
      title: 'Age Calculator',
      icon: Icons.calendar_today,
      description: 'Calculate exact age between two dates.',
      purpleHeader: true,
      onClear: _clear,
      body: Column(
        children: [
          OutlinedButton.icon(
            onPressed: _pickBirth,
            icon: const Icon(Icons.cake),
            label: Text('Birth Date: ${_fmt(birthDate)}'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _pickTo,
            icon: const Icon(Icons.event),
            label: Text('Calculate To: ${_fmt(toDate)}'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: birthDate == null ? null : _calculate,
            child: const Text('Calculate Age'),
          ),
          if (years != null)
            ResultPanel(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _stat('$years', 'Years'),
                      _stat('$months', 'Months'),
                      _stat('$days', 'Days'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Total Days: $totalDays'),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        Text(label),
      ],
    );
  }
}
