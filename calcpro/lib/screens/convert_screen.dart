import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:calcpro/models/unit_data.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/services/widget_sync.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';
import 'package:calcpro/widgets/ui_kit.dart';

class ConvertScreen extends StatefulWidget {
  const ConvertScreen({super.key});

  @override
  State<ConvertScreen> createState() => _ConvertScreenState();
}

class _ConvertScreenState extends State<ConvertScreen> {
  UnitCategory category = UnitCategory.length;
  late UnitDef fromUnit;
  late UnitDef toUnit;
  final valueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final units = unitsFor(category);
    fromUnit = units.firstWhere((u) => u.name == 'Meters');
    toUnit = units.firstWhere((u) => u.name == 'Feet');
    valueController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    valueController.dispose();
    super.dispose();
  }

  void _onCategory(int index) {
    final c = UnitCategory.values[index];
    setState(() {
      category = c;
      final units = unitsFor(c);
      fromUnit = units[0];
      toUnit = units.length > 1 ? units[1] : units[0];
    });
  }

  String? get result {
    if (valueController.text.isEmpty) return null;
    final value = double.tryParse(valueController.text);
    if (value == null) return null;
    final converted = convertUnits(value: value, from: fromUnit, to: toUnit);
    return NumberFormat('#,##0.########').format(converted);
  }

  void _swap() => setState(() {
        final tmp = fromUnit;
        fromUnit = toUnit;
        toUnit = tmp;
      });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final units = unitsFor(category);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Converter'),
        actions: [
          ListenableBuilder(
            listenable: AppState.instance,
            builder: (context, _) {
              final fav = AppState.instance.isFavorite('/convert');
              return IconButton(
                onPressed: () => AppState.instance.toggleFavorite('/convert'),
                icon: Icon(
                  fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: fav ? AppColors.accentPink : null,
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in UnitCategory.values)
                FilterChip(
                  selected: category == c,
                  label: Text(categoryLabel(c)),
                  onSelected: (_) =>
                      _onCategory(UnitCategory.values.indexOf(c)),
                  selectedColor: AppColors.primaryMuted,
                  checkmarkColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: category == c
                        ? AppColors.primary
                        : (dark ? AppColors.mutedDark : AppColors.muted),
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (result != null)
            AppCard(
              child: Column(
                children: [
                  Text(
                    '${valueController.text} ${fromUnit.name}',
                    style: AppFonts.body2(),
                  ),
                  Text(result!, style: AppFonts.result()),
                  Text(toUnit.name, style: AppFonts.body1()),
                ],
              ),
            ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LabeledDropdown<UnitDef>(
                  label: 'From',
                  value: fromUnit,
                  items: units
                      .map((u) => DropdownMenuItem(value: u, child: Text(u.name)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => fromUnit = v);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: IconButton(
                    onPressed: _swap,
                    icon: const Icon(
                      Icons.swap_vert_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                LabeledDropdown<UnitDef>(
                  label: 'To',
                  value: toUnit,
                  items: units
                      .map((u) => DropdownMenuItem(value: u, child: Text(u.name)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => toUnit = v);
                  },
                ),
                const SizedBox(height: 16),
                LabeledField(label: 'Value', controller: valueController),
              ],
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Convert',
            onPressed: valueController.text.isEmpty
                ? null
                : () {
                    setState(() {});
                    if (result != null) {
                      AppState.instance.addHistory(
                        route: '/convert',
                        title: 'Converter',
                        result: '$result ${toUnit.name}',
                      );
                      WidgetSync.publish();
                    }
                  },
          ),
        ],
      ),
    );
  }
}
