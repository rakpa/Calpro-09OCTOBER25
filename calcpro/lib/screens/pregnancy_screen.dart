import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/services/widget_sync.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/ui_kit.dart';

class PregnancyScreen extends StatefulWidget {
  const PregnancyScreen({super.key});

  @override
  State<PregnancyScreen> createState() => _PregnancyScreenState();
}

class _PregnancyScreenState extends State<PregnancyScreen> {
  DateTime? lmp;
  DateTime? due;
  int? weeks;
  int? days;

  @override
  void initState() {
    super.initState();
    lmp = DateTime.now().subtract(const Duration(days: 60));
    _recalc();
  }

  void _recalc() {
    if (lmp == null) return;
    final d = lmp!.add(const Duration(days: 280));
    final elapsed = DateTime.now().difference(lmp!).inDays;
    setState(() {
      due = d;
      weeks = elapsed ~/ 7;
      days = elapsed % 7;
    });
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Pregnancy Due Date')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          if (due != null)
            AppCard(
              color: AppColors.resultBg,
              child: Column(
                children: [
                  Text('Estimated due date', style: AppFonts.body2()),
                  Text(_fmt(due!), style: AppFonts.result()),
                  const SizedBox(height: 8),
                  Text(
                    'Gestational age ~ ${weeks}w ${days}d',
                    style: AppFonts.body1(),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          AppCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('First day of last period (LMP)'),
              trailing: Text(_fmt(lmp!), style: AppFonts.body1()),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: lmp!,
                  firstDate: DateTime.now().subtract(const Duration(days: 300)),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  lmp = picked;
                  _recalc();
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Uses Naegele’s rule (LMP + 280 days). For education only — not medical advice.',
            style: AppFonts.body2(
              color: dark ? AppColors.mutedDark : AppColors.muted,
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Save to history',
            onPressed: due == null
                ? null
                : () {
                    HapticFeedback.lightImpact();
                    AppState.instance.addHistory(
                      route: '/pregnancy',
                      title: 'Due Date',
                      result: _fmt(due!),
                    );
                    WidgetSync.publish();
                  },
          ),
        ],
      ),
    );
  }
}
