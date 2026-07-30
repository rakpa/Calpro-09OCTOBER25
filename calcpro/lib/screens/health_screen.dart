import 'package:flutter/material.dart';
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
  int mode = 0;
  final weight = TextEditingController();
  final heightBmi = TextEditingController();
  final heightIdeal = TextEditingController();
  bool isMale = true;
  String? bmi;
  String? category;
  Color categoryColor = Colors.grey;
  String? idealKg;

  @override
  void initState() {
    super.initState();
    for (final c in [weight, heightBmi, heightIdeal]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    weight.dispose();
    heightBmi.dispose();
    heightIdeal.dispose();
    super.dispose();
  }

  void _clear() {
    setState(() {
      weight.clear();
      heightBmi.clear();
      heightIdeal.clear();
      bmi = category = idealKg = null;
    });
  }

  void _calcBmi() {
    final w = double.tryParse(weight.text);
    final hCm = double.tryParse(heightBmi.text);
    if (w == null || hCm == null || hCm == 0) return;
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
    });
    AppState.instance.addHistory(route: '/health', title: 'BMI', result: bmi!);
    WidgetSync.publish();
  }

  void _calcIdeal() {
    final hCm = double.tryParse(heightIdeal.text);
    if (hCm == null) return;
    final heightInches = hCm / 2.54;
    const baseHeight = 60.0;
    final idealLbs = isMale
        ? 48 + 2.7 * (heightInches - baseHeight)
        : 45.5 + 2.2 * (heightInches - baseHeight);
    setState(() => idealKg = (idealLbs * 0.453592).toStringAsFixed(1));
    AppState.instance.addHistory(
      route: '/health',
      title: 'Ideal Weight',
      result: '$idealKg kg',
    );
    WidgetSync.publish();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: dark ? AppColors.bgDark : AppColors.bg,
      appBar: AppBar(
        title: const Text('BMI / Health'),
        actions: [
          ListenableBuilder(
            listenable: AppState.instance,
            builder: (context, _) {
              final fav = AppState.instance.isFavorite('/health');
              return IconButton(
                onPressed: () => AppState.instance.toggleFavorite('/health'),
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
          SegmentControl(
            labels: const ['BMI', 'Ideal Weight'],
            index: mode,
            onChanged: (i) => setState(() => mode = i),
          ),
          const SizedBox(height: 16),
          if (mode == 0 && bmi != null)
            AppCard(
              child: Column(
                children: [
                  Text('BMI', style: AppFonts.body2()),
                  Text(bmi!, style: AppFonts.result(color: categoryColor)),
                  Text(category!, style: AppFonts.h3(color: categoryColor)),
                ],
              ),
            ),
          if (mode == 1 && idealKg != null)
            AppCard(
              child: Column(
                children: [
                  Text('Ideal weight', style: AppFonts.body2()),
                  Text('$idealKg kg', style: AppFonts.result()),
                  Text('Hamwi estimate · not medical advice',
                      style: AppFonts.caption()),
                ],
              ),
            ),
          const SizedBox(height: 16),
          AppCard(
            child: mode == 0
                ? Column(
                    children: [
                      LabeledField(label: 'Weight (kg)', controller: weight, compact: true),
                      const Divider(height: 24),
                      LabeledField(label: 'Height (cm)', controller: heightBmi, compact: true),
                    ],
                  )
                : Column(
                    children: [
                      SegmentControl(
                        labels: const ['Male', 'Female'],
                        index: isMale ? 0 : 1,
                        onChanged: (i) => setState(() => isMale = i == 0),
                      ),
                      const SizedBox(height: 16),
                      LabeledField(label: 'Height (cm)', controller: heightIdeal, compact: true),
                    ],
                  ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Calculate',
            onPressed: mode == 0
                ? (weight.text.isEmpty || heightBmi.text.isEmpty ? null : _calcBmi)
                : (heightIdeal.text.isEmpty ? null : _calcIdeal),
          ),
        ],
      ),
    );
  }
}
