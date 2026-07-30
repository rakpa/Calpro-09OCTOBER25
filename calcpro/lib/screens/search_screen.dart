import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final List<String> _recent = ['Percentage', 'Tip'];

  static const _popular = [
    'Percentage',
    'Mortgage',
    'BMI',
    'EMI',
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
          c.description.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final trending = [
      calculatorByRoute('/percentage')!,
      calculatorByRoute('/mortgage')!,
      calculatorByRoute('/health')!,
      calculatorByRoute('/financial')!,
    ];

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
                      hint: 'Search calculators...',
                      onClear: () => _controller.clear(),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
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
                      style: AppFonts.h3(
                        color: dark ? AppColors.inkDark : AppColors.ink,
                      ),
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
                              _controller.selection =
                                  TextSelection.fromPosition(
                                TextPosition(offset: term.length),
                              );
                            },
                            backgroundColor: dark
                                ? AppColors.surfaceDark
                                : AppColors.surfaceAlt,
                            labelStyle: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              color: dark ? AppColors.inkDark : AppColors.ink,
                            ),
                          ),
                      ],
                    ),
                    if (_recent.isNotEmpty) ...[
                      const SizedBox(height: 28),
                      Text(
                        'Recent Searches',
                        style: AppFonts.h3(
                          color: dark ? AppColors.inkDark : AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 8),
                      for (final term in List<String>.from(_recent))
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.history_rounded,
                            color:
                                dark ? AppColors.mutedDark : AppColors.muted,
                          ),
                          title: Text(
                            term,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.close_rounded, size: 18),
                            onPressed: () =>
                                setState(() => _recent.remove(term)),
                          ),
                          onTap: () => _controller.text = term,
                        ),
                    ],
                    const SizedBox(height: 20),
                    Text(
                      'Trending Now',
                      style: AppFonts.h3(
                        color: dark ? AppColors.inkDark : AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (final item in trending) ...[
                      _TrendCard(item: item),
                      const SizedBox(height: 10),
                    ],
                  ] else if (_results.isEmpty) ...[
                    const SizedBox(height: 48),
                    Icon(
                      Icons.search_off_rounded,
                      size: 56,
                      color: dark ? AppColors.mutedDark : AppColors.muted,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No calculators found',
                      textAlign: TextAlign.center,
                      style: AppFonts.h3(
                        color: dark ? AppColors.inkDark : AppColors.ink,
                      ),
                    ),
                  ] else ...[
                    Text(
                      'Results',
                      style: AppFonts.h3(
                        color: dark ? AppColors.inkDark : AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (final item in _results) ...[
                      _TrendCard(item: item),
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

class _TrendCard extends StatelessWidget {
  final CalculatorItem item;
  const _TrendCard({required this.item});

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
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              AccentIconTile(icon: item.icon, accent: item.accent, size: 48),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.shortTitle,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: dark ? AppColors.inkDark : AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Calculate ${item.shortTitle.toLowerCase()} easily',
                      style: AppFonts.body2(
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
