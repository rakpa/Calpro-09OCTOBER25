import 'package:flutter/material.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/services/widget_sync.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/ui_kit.dart';

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
      setState(() => isStart ? startDate = picked : endDate = picked);
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
    AppState.instance.addHistory(
      route: '/date-diff',
      title: 'Date Diff',
      result: '$y y $m m $d d',
    );
    WidgetSync.publish();
  }

  String _fmt(DateTime? d) {
    if (d == null) return 'Select';
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Date Difference'),
        actions: [
          ListenableBuilder(
            listenable: AppState.instance,
            builder: (context, _) {
              final fav = AppState.instance.isFavorite('/date-diff');
              return IconButton(
                onPressed: () =>
                    AppState.instance.toggleFavorite('/date-diff'),
                icon: Icon(
                  fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: fav ? AppColors.accentPink : null,
                ),
              );
            },
          ),
          IconButton(onPressed: _clear, icon: const Icon(Icons.refresh_rounded)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          if (years != null)
            AppCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _stat('$years', 'Years'),
                  _stat('$months', 'Months'),
                  _stat('$days', 'Days'),
                ],
              ),
            ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Start date'),
                  trailing: Text(_fmt(startDate), style: AppFonts.body1()),
                  onTap: () => _pick(true),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('End date'),
                  trailing: Text(_fmt(endDate), style: AppFonts.body1()),
                  onTap: () => _pick(false),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Calculate',
            onPressed:
                startDate == null || endDate == null ? null : _calculate,
          ),
        ],
      ),
    );
  }

  Widget _stat(String v, String label) => Column(
        children: [
          Text(v, style: AppFonts.h1()),
          Text(label, style: AppFonts.caption()),
        ],
      );
}
