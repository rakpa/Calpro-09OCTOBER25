import 'package:flutter/material.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/services/widget_sync.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/ui_kit.dart';

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
      totalDays = end.difference(start).inDays;
    });
    AppState.instance.addHistory(
      route: '/age',
      title: 'Age',
      result: '$y y $m m $d d',
    );
    WidgetSync.publish();
  }

  String _fmt(DateTime? d) {
    if (d == null) return 'Select date';
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: dark ? AppColors.bgDark : AppColors.bg,
      appBar: AppBar(
        title: const Text('Age'),
        actions: [
          ListenableBuilder(
            listenable: AppState.instance,
            builder: (context, _) {
              final fav = AppState.instance.isFavorite('/age');
              return IconButton(
                onPressed: () => AppState.instance.toggleFavorite('/age'),
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
          if (totalDays != null) ...[
            const SizedBox(height: 8),
            Text('$totalDays total days', textAlign: TextAlign.center, style: AppFonts.body2()),
          ],
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.cake_rounded, color: AppColors.primary),
                  title: const Text('Birth date'),
                  trailing: Text(_fmt(birthDate), style: AppFonts.body1()),
                  onTap: _pickBirth,
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.event_rounded, color: AppColors.primary),
                  title: const Text('As of'),
                  trailing: Text(_fmt(toDate), style: AppFonts.body1()),
                  onTap: _pickTo,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Calculate Age',
            onPressed: birthDate == null ? null : _calculate,
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
