import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/services/widget_sync.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';
import 'package:calcpro/widgets/ui_kit.dart';

class RoiScreen extends StatefulWidget {
  const RoiScreen({super.key});

  @override
  State<RoiScreen> createState() => _RoiScreenState();
}

class _RoiScreenState extends State<RoiScreen> {
  final invested = TextEditingController(text: '10000');
  final returned = TextEditingController(text: '12500');
  final currency = NumberFormat.currency(symbol: '\$');
  double? profit;
  double? roiPct;

  @override
  void initState() {
    super.initState();
    for (final c in [invested, returned]) {
      c.addListener(_recalc);
    }
    _recalc();
  }

  @override
  void dispose() {
    invested.dispose();
    returned.dispose();
    super.dispose();
  }

  void _recalc() {
    final i = double.tryParse(invested.text);
    final r = double.tryParse(returned.text);
    if (i == null || r == null || i == 0) {
      setState(() => profit = roiPct = null);
      return;
    }
    setState(() {
      profit = double.parse((r - i).toStringAsFixed(2));
      roiPct = double.parse((((r - i) / i) * 100).toStringAsFixed(2));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('ROI')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          if (roiPct != null)
            AppCard(
              color: AppColors.resultBg,
              child: Column(
                children: [
                  Text('Return on investment', style: AppFonts.body2()),
                  Text('${roiPct!.toStringAsFixed(2)}%', style: AppFonts.result()),
                  Text(
                    'Profit ${currency.format(profit)}',
                    style: AppFonts.body1(),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              children: [
                LabeledField(label: 'Amount invested', controller: invested, compact: true),
                const Divider(height: 24),
                LabeledField(label: 'Amount returned', controller: returned, compact: true),
              ],
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Save to history',
            onPressed: roiPct == null
                ? null
                : () {
                    HapticFeedback.lightImpact();
                    AppState.instance.addHistory(
                      route: '/roi',
                      title: 'ROI',
                      result: '${roiPct!.toStringAsFixed(2)}%',
                    );
                    WidgetSync.publish();
                  },
          ),
        ],
      ),
    );
  }
}
