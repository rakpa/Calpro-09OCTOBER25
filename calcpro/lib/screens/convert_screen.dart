import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:calcpro/models/unit_data.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';

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
  }

  @override
  void dispose() {
    valueController.dispose();
    super.dispose();
  }

  void _onCategory(UnitCategory c) {
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
    final formatted = NumberFormat('#,##0.########').format(converted);
    return '${valueController.text} ${fromUnit.name} = $formatted ${toUnit.name}';
  }

  @override
  Widget build(BuildContext context) {
    final units = unitsFor(category);
    return CalcScaffold(
      title: 'Unit Converter',
      icon: Icons.swap_vert,
      description: 'Convert between length, weight, and area units.',
      onClear: () => setState(() => valueController.clear()),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Category', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          DropdownButtonFormField<UnitCategory>(
            value: category,
            items: UnitCategory.values
                .map((c) => DropdownMenuItem(value: c, child: Text(categoryLabel(c))))
                .toList(),
            onChanged: (v) {
              if (v != null) _onCategory(v);
            },
          ),
          const SizedBox(height: 16),
          const Text('From', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          DropdownButtonFormField<UnitDef>(
            value: fromUnit,
            items: units
                .map((u) => DropdownMenuItem(value: u, child: Text(u.name)))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => fromUnit = v);
            },
          ),
          const SizedBox(height: 16),
          const Text('To', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          DropdownButtonFormField<UnitDef>(
            value: toUnit,
            items: units
                .map((u) => DropdownMenuItem(value: u, child: Text(u.name)))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => toUnit = v);
            },
          ),
          const SizedBox(height: 16),
          LabeledField(
            label: 'Value',
            controller: valueController,
            onChanged: (_) => setState(() {}),
          ),
          if (result != null) ResultPanel(child: Text(result!)),
        ],
      ),
    );
  }
}
