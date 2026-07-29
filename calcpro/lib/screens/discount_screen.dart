import 'package:flutter/material.dart';
import 'package:calcpro/widgets/calc_scaffold.dart';

class DiscountScreen extends StatefulWidget {
  const DiscountScreen({super.key});

  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabs;
  final singlePrice = TextEditingController();
  final singleDiscount = TextEditingController();
  final multiPrice = TextEditingController();
  final d1 = TextEditingController();
  final d2 = TextEditingController();
  final d3 = TextEditingController();

  String? singleFinal;
  String? singleSaved;
  String? multiFinal;
  String? multiSaved;
  List<String> breakdown = [];

  @override
  void initState() {
    super.initState();
    tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabs.dispose();
    singlePrice.dispose();
    singleDiscount.dispose();
    multiPrice.dispose();
    d1.dispose();
    d2.dispose();
    d3.dispose();
    super.dispose();
  }

  void _clear() {
    setState(() {
      singlePrice.clear();
      singleDiscount.clear();
      multiPrice.clear();
      d1.clear();
      d2.clear();
      d3.clear();
      singleFinal = singleSaved = multiFinal = multiSaved = null;
      breakdown = [];
    });
  }

  void _calcSingle() {
    final price = double.tryParse(singlePrice.text);
    final discount = double.tryParse(singleDiscount.text);
    if (price == null || discount == null) return;
    final saved = (price * discount) / 100;
    setState(() {
      singleSaved = saved.toStringAsFixed(2);
      singleFinal = (price - saved).toStringAsFixed(2);
    });
  }

  void _calcMulti() {
    final price = double.tryParse(multiPrice.text);
    if (price == null) return;
    var current = price;
    final savings = <String>[];
    for (final c in [d1, d2, d3]) {
      if (c.text.isEmpty) continue;
      final discount = double.tryParse(c.text);
      if (discount == null) continue;
      final amount = (current * discount) / 100;
      savings.add(amount.toStringAsFixed(2));
      current -= amount;
    }
    if (savings.isEmpty) return;
    final totalSaved =
        savings.map(double.parse).fold<double>(0, (a, b) => a + b);
    setState(() {
      breakdown = [
        for (var i = 0; i < savings.length; i++)
          if (double.parse(savings[i]) > 0)
            'Discount ${i + 1}: \$${savings[i]}',
      ];
      multiSaved = totalSaved.toStringAsFixed(2);
      multiFinal = current.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalcScaffold(
      title: 'Discount Calculator',
      icon: Icons.local_offer,
      description: 'Calculate sale prices with single or stacked discounts.',
      onClear: _clear,
      body: Column(
        children: [
          TabBar(
            controller: tabs,
            labelColor: Colors.black,
            tabs: const [
              Tab(text: 'Single Discount'),
              Tab(text: 'Multiple Discounts'),
            ],
          ),
          SizedBox(
            height: 420,
            child: TabBarView(
              controller: tabs,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    children: [
                      LabeledField(
                        label: 'Original Price (\$)',
                        controller: singlePrice,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      LabeledField(
                        label: 'Discount Percentage (%)',
                        controller: singleDiscount,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: singlePrice.text.isEmpty ||
                                singleDiscount.text.isEmpty
                            ? null
                            : _calcSingle,
                        child: const Text('Calculate'),
                      ),
                      if (singleFinal != null)
                        ResultPanel(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Final Price: \$$singleFinal'),
                              Text('You Save: \$$singleSaved'),
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
                      LabeledField(
                        label: 'Original Price (\$)',
                        controller: multiPrice,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 8),
                      LabeledField(label: 'Discount 1 (%)', controller: d1, onChanged: (_) => setState(() {})),
                      const SizedBox(height: 8),
                      LabeledField(label: 'Discount 2 (%)', controller: d2, onChanged: (_) => setState(() {})),
                      const SizedBox(height: 8),
                      LabeledField(label: 'Discount 3 (%)', controller: d3, onChanged: (_) => setState(() {})),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: multiPrice.text.isEmpty ||
                                (d1.text.isEmpty && d2.text.isEmpty && d3.text.isEmpty)
                            ? null
                            : _calcMulti,
                        child: const Text('Calculate'),
                      ),
                      if (multiFinal != null)
                        ResultPanel(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Final Price: \$$multiFinal'),
                              Text('Total Savings: \$$multiSaved'),
                              ...breakdown.map((b) => Text(b)),
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
