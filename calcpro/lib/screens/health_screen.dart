import 'package:flutter/material.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabs;
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
    tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabs.dispose();
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
    String cat;
    Color color;
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
  }

  void _calcIdeal() {
    final hCm = double.tryParse(heightIdeal.text);
    if (hCm == null) return;
    final heightInches = hCm / 2.54;
    const baseHeight = 60.0;
    final idealLbs = isMale
        ? 48 + 2.7 * (heightInches - baseHeight)
        : 45.5 + 2.2 * (heightInches - baseHeight);
    setState(() {
      idealKg = (idealLbs * 0.453592).toStringAsFixed(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalcScaffold(
      title: 'Health Calculator',
      icon: Icons.favorite,
      description: 'BMI and Hamwi ideal weight estimates.',
      onClear: _clear,
      body: Column(
        children: [
          TabBar(
            controller: tabs,
            labelColor: Colors.black,
            tabs: const [
              Tab(text: 'BMI'),
              Tab(text: 'Ideal Weight'),
            ],
          ),
          SizedBox(
            height: 360,
            child: TabBarView(
              controller: tabs,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    children: [
                      LabeledField(
                        label: 'Weight (kg)',
                        controller: weight,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      LabeledField(
                        label: 'Height (cm)',
                        controller: heightBmi,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: weight.text.isEmpty || heightBmi.text.isEmpty
                            ? null
                            : _calcBmi,
                        child: const Text('Calculate BMI'),
                      ),
                      if (bmi != null)
                        ResultPanel(
                          child: Column(
                            children: [
                              Text('BMI: $bmi',
                                  style: const TextStyle(
                                      fontSize: 22, color: AppColors.primary)),
                              const SizedBox(height: 6),
                              Text(
                                category!,
                                style: TextStyle(color: categoryColor),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    children: [
                      SegmentedButton<bool>(
                        segments: const [
                          ButtonSegment(value: true, label: Text('Male')),
                          ButtonSegment(value: false, label: Text('Female')),
                        ],
                        selected: {isMale},
                        onSelectionChanged: (s) =>
                            setState(() => isMale = s.first),
                      ),
                      const SizedBox(height: 12),
                      LabeledField(
                        label: 'Height (cm)',
                        controller: heightIdeal,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed:
                            heightIdeal.text.isEmpty ? null : _calcIdeal,
                        child: const Text('Calculate Ideal Weight'),
                      ),
                      if (idealKg != null)
                        ResultPanel(
                          child: Column(
                            children: [
                              Text(
                                'Ideal Weight: $idealKg kg',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Hamwi formula estimate only. Not medical advice.',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
