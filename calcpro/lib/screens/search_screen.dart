import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calcpro/models/calculator_item.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/ui_kit.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  static const _popular = [
    'Percentage',
    'Mortgage',
    'BMI',
    'Tip',
    'Discount',
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() => _query = _controller.text));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<CalculatorItem> get _results {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    return kCalculators.where((c) {
      return c.title.toLowerCase().contains(q) ||
          c.shortTitle.toLowerCase().contains(q) ||
          c.description.toLowerCase().contains(q) ||
          c.tags.any((t) => t.toLowerCase().contains(q));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final trending = kCalculators.take(4).toList();

    return Scaffold(
      backgroundColor: dark ? AppColors.bgDark : AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: SearchField(
                      controller: _controller,
                      autofocus: true,
                      hint: 'Search calculators',
                      onClear: () {
                        _controller.clear();
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                children: [
                  if (_query.isEmpty) ...[
                    Text(
                      'Popular Searches',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final term in _popular)
                          ActionChip(
                            label: Text(term),
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              _controller.text = term;
                              _controller.selection = TextSelection.fromPosition(
                                TextPosition(offset: term.length),
                              );
                            },
                            backgroundColor:
                                dark ? AppColors.surfaceDark : Colors.white,
                            side: BorderSide(
                              color:
                                  dark ? AppColors.lineDark : AppColors.line,
                            ),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: dark ? AppColors.inkDark : AppColors.ink,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Trending Now',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 12),
                    for (final item in trending) ...[
                      _SearchResultTile(item: item),
                      const SizedBox(height: 10),
                    ],
                  ] else if (_results.isEmpty) ...[
                    const SizedBox(height: 48),
                    Icon(
                      Icons.search_off_rounded,
                      size: 48,
                      color: dark ? AppColors.mutedDark : AppColors.muted,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No calculators found',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ] else ...[
                    Text(
                      'Results',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 12),
                    for (final item in _results) ...[
                      _SearchResultTile(item: item),
                      const SizedBox(height: 10),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final CalculatorItem item;
  const _SearchResultTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: dark ? AppColors.surfaceDark : Colors.white,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          Navigator.of(context).pushNamed(item.route);
        },
        borderRadius: BorderRadius.circular(AppRadii.lg),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.lg),
            border: Border.all(
              color: dark ? AppColors.lineDark : AppColors.line,
            ),
          ),
          child: Row(
            children: [
              AccentIconTile(icon: item.icon, accent: item.accent, size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: dark ? AppColors.inkDark : AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: dark ? AppColors.mutedDark : AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: dark ? AppColors.mutedDark : AppColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
