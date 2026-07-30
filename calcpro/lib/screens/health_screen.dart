import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/services/widget_sync.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';
import 'package:calcpro/widgets/ui_kit.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  int mode = 0; // BMI, Ideal, BMR, TDEE
  final weight = TextEditingController(text: '70');
  final height = TextEditingController(text: '175');
  final age = TextEditingController(text: '30');
  bool isMale = true;
  int activity = 2;
  String? bmi;
  String? category;
  Color categoryColor = Colors.grey;
  String? idealKg;
  String? bmr;
  String? tdee;

  static const _activity = [
    ('Sedentary', 1.2),
    ('Light', 1.375),
    ('Moderate', 1.55),
    ('Active', 1.725),
    ('Athlete', 1.9),
  ];

  @override
  void initState() {
    super.initState();
    for (final c in [weight, height, age]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    weight.dispose();
    height.dispose();
    age.dispose();
    super.dispose();
  }

  void _clear() {
    setState(() {
      weight.clear();
      height.clear();
      age.clear();
      bmi = category = idealKg = bmr = tdee = null;
    });
  }

  void _calc() {
    final w = double.tryParse(weight.text);
    final hCm = double.tryParse(height.text);
    final a = double.tryParse(age.text);
    if (w == null || hCm == null) return;

    if (mode == 0) {
      final h = hCm / 100;
      final value = w / (h * h);
      late String cat;
      late Color color;
      if (value < 18.5) {
        cat = 'Underweight';
        color = const Color(0xFF3B82F6);
      } else if (value < 25) {
        cat = 'Normal weight';
        color = const Color(0xFF22C55E);
      } else if (value < 30) {
        cat = 'Overweight';
        color = const Color(0xFFEAB308);
      } else {
        cat = 'Obese';
        color = const Color(0xFFEF4444);
      }
      setState(() {
        bmi = value.toStringAsFixed(1);
        category = cat;
        categoryColor = color;
        idealKg = bmr = tdee = null;
      });
      AppState.instance.addHistory(route: '/health', title: 'BMI', result: bmi!);
    } else if (mode == 1) {
      final inches = hCm / 2.54;
      final over5 = (inches - 60).clamp(0, 100);
      final ideal = isMale ? 48 + 2.7 * over5 : 45.5 + 2.2 * over5;
      setState(() {
        idealKg = ideal.toStringAsFixed(1);
        bmi = category = bmr = tdee = null;
      });
      AppState.instance
          .addHistory(route: '/health', title: 'Ideal Weight', result: '$idealKg kg');
    } else {
      if (a == null) return;
      // Mifflin-St Jeor
      final base = 10 * w + 6.25 * hCm - 5 * a + (isMale ? 5 : -161);
      setState(() {
        bmr = base.toStringAsFixed(0);
        tdee = (base * _activity[activity].$2).toStringAsFixed(0);
        bmi = category = idealKg = null;
      });
      AppState.instance.addHistory(
        route: '/health',
        title: mode == 2 ? 'BMR' : 'TDEE',
        result: mode == 2 ? '$bmr kcal' : '$tdee kcal',
      );
    }
    WidgetSync.publish();
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: dark ? AppColors.bgDark : AppColors.bg,
      appBar: AppBar(
        title: const Text('Health'),
        actions: [
          IconButton(onPressed: _clear, icon: const Icon(Icons.refresh_rounded)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          SegmentControl(
            labels: const ['BMI', 'Ideal', 'BMR', 'TDEE'],
            index: mode,
            onChanged: (i) => setState(() => mode = i),
          ),
          const SizedBox(height: 16),
          if (bmi != null)
            AppCard(
              color: AppColors.resultBg,
              child: Column(
                children: [
                  Text('BMI $bmi', style: AppFonts.result()),
                  Text(category!, style: AppFonts.body1().copyWith(color: categoryColor)),
                ],
              ),
            ),
          if (idealKg != null)
            AppCard(
              color: AppColors.resultBg,
              child: Text('Ideal ~ $idealKg kg', style: AppFonts.result()),
            ),
          if (bmr != null)
            AppCard(
              color: AppColors.resultBg,
              child: Column(
                children: [
                  Text('BMR $bmr kcal/day', style: AppFonts.result()),
                  if (tdee != null)
                    Text('TDEE $tdee kcal/day', style: AppFonts.body1()),
                ],
              ),
            ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                LabeledField(label: 'Weight (kg)', controller: weight, compact: true),
                const Divider(height: 20),
                LabeledField(label: 'Height (cm)', controller: height, compact: true),
                if (mode >= 1) ...[
                  const Divider(height: 20),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: Text(isMale ? 'Male' : 'Female'),
                    value: isMale,
                    onChanged: (v) => setState(() => isMale = v),
                  ),
                ],
                if (mode >= 2) ...[
                  const Divider(height: 20),
                  LabeledField(label: 'Age', controller: age, compact: true),
                ],
                if (mode == 3) ...[
                  const Divider(height: 20),
                  DropdownButtonFormField<int>(
                    value: activity,
                    decoration: const InputDecoration(labelText: 'Activity level'),
                    items: [
                      for (var i = 0; i < _activity.length; i++)
                        DropdownMenuItem(value: i, child: Text(_activity[i].$1)),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => activity = v);
                    },
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            mode >= 2
                ? 'Mifflin–St Jeor equation. Educational only — not medical advice.'
                : 'Hamwi / WHO ranges. Educational only — not medical advice.',
            style: AppFonts.body2(
              color: dark ? AppColors.mutedDark : AppColors.muted,
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(label: 'Calculate', onPressed: _calc),
        ],
      ),
    );
  }
}
