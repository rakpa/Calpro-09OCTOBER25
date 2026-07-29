import 'package:flutter/material.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';

class DateDiffScreen extends StatefulWidget {
  const DateDiffScreen({super.key});

  @override
  State<DateDiffScreen> createState() => _DateDiffScreenState();
}

class _DateDiffScreenState extends State<DateDiffScreen> {
  DateTime? startDate;
  DateTime? endDate;
  int? years;
  int? months;
  int? days;

  void _clear() {
    setState(() {
      startDate = endDate = null;
      years = months = days = null;
    });
  }

  Future<void> _pick(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? startDate : endDate) ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  void _calculate() {
    if (startDate == null || endDate == null) return;
    var start = startDate!;
    var end = endDate!;
    if (end.isBefore(start)) {
      final tmp = start;
      start = end;
      end = tmp;
    }

    var y = end.year - start.year;
    var m = end.month - start.month;
    var d = end.day - start.day;
    if (d < 0) {
      m -= 1;
      d += DateTime(end.year, end.month, 0).day;
    }
    if (m < 0) {
      y -= 1;
      m += 12;
    }

    setState(() {
      years = y;
      months = m;
      days = d;
    });
  }

  String _fmt(DateTime? d) {
    if (d == null) return 'Select date';
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return CalcScaffold(
      title: 'Date Difference',
      icon: Icons.date_range,
      description: 'Calculate years, months, and days between two dates.',
      onClear: _clear,
      body: Column(
        children: [
          OutlinedButton(
            onPressed: () => _pick(true),
            child: Text('Start Date: ${_fmt(startDate)}'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => _pick(false),
            child: Text('End Date: ${_fmt(endDate)}'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: startDate == null || endDate == null ? null : _calculate,
            child: const Text('Calculate Difference'),
          ),
          if (years != null)
            ResultPanel(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _stat('$years', 'Years'),
                  _stat('$months', 'Months'),
                  _stat('$days', 'Days'),
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
