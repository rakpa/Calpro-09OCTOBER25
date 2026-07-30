import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:calcpro/models/calculator_item.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/ui_kit.dart';
import 'package:calcpro/screens/search_screen.dart';
import 'package:calcpro/screens/category_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _intro;
  String _category = 'Finance';

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning,';
    if (h < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  /// Featured popular grid — matches Calcara home snip.
  List<CalculatorItem> get _popular => kCalculators
      .where((c) =>
          c.route == '/percentage' ||
          c.route == '/mortgage' ||
          c.route == '/health' ||
          c.route == '/financial')
      .toList();

  /// Full catalog under the popular grid (order preserved).
  List<CalculatorItem> get _all => List<CalculatorItem>.from(kCalculators);

  void _openCategory(String category) {
    setState(() => _category = category);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CategoryScreen(category: category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final popular = _popular;
    final all = _all;

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _intro,
                      curve: Curves.easeOut,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _greeting,
                          style: AppFonts.h1(
                            color: dark ? AppColors.inkDark : AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SearchField(
                          readOnly: true,
                          showMic: false,
                          hint: 'Search calculators...',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const SearchScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _QuickPill(
                                label: 'Calculate',
                                background: AppColors.pastelLavender,
                                foreground: AppColors.primary,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const SearchScreen(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              _QuickPill(
                                label: 'Percentage',
                                icon: Icons.percent_rounded,
                                background: AppColors.pastelGreen,
                                foreground: const Color(0xFF1B7A4A),
                                onTap: () =>
                                    Navigator.of(context).pushNamed('/percentage'),
                              ),
                              const SizedBox(width: 8),
                              _QuickPill(
                                label: 'EMI',
                                icon: Icons.payments_outlined,
                                background: AppColors.pastelOrange,
                                foreground: const Color(0xFFC45C12),
                                onTap: () =>
                                    Navigator.of(context).pushNamed('/financial'),
                              ),
                              const SizedBox(width: 8),
                              _QuickPill(
                                label: 'Tax',
                                icon: Icons.receipt_long_rounded,
                                background: AppColors.pastelOrange,
                                foreground: const Color(0xFFC45C12),
                                onTap: () =>
                                    Navigator.of(context).pushNamed('/sales-tax'),
                              ),
                              const SizedBox(width: 8),
                              _QuickPill(
                                label: 'Convert',
                                icon: Icons.currency_exchange_rounded,
                                background: AppColors.pastelBlue,
                                foreground: const Color(0xFF1F6FB5),
                                onTap: () =>
                                    Navigator.of(context).pushNamed('/convert'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _CategoryTab(
                                label: 'Finance',
                                icon: Icons.account_balance_wallet_outlined,
                                selected: _category == 'Finance',
                                onTap: () => _openCategory('Finance'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _CategoryTab(
                                label: 'Health',
                                icon: Icons.favorite_border_rounded,
                                selected: _category == 'Health',
                                onTap: () => _openCategory('Health'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _CategoryTab(
                                label: 'Everyday',
                                icon: Icons.calendar_today_outlined,
                                selected: _category == 'Everyday',
                                onTap: () => _openCategory('Everyday'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Popular Calculators',
                                style: AppFonts.h3(
                                  color:
                                      dark ? AppColors.inkDark : AppColors.ink,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const CategoryScreen(category: 'Popular'),
                                  ),
                                );
                              },
                              child: Text(
                                'See all',
                                style: GoogleFonts.inter(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.08,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = popular[index];
                    return FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _intro,
                        curve: Interval(
                          (0.1 * index).clamp(0.0, 0.6),
                          1,
                          curve: Curves.easeOut,
                        ),
                      ),
                      child: _PastelCalcCard(item: item),
                    );
                  },
                  childCount: popular.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                child: Text(
                  'All Calculators',
                  style: AppFonts.h3(
                    color: dark ? AppColors.inkDark : AppColors.ink,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
              sliver: SliverList.separated(
                itemCount: all.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) =>
                    _ListCalcCard(item: all[index]),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _QuickPill extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  const _QuickPill({
    required this.label,
    this.icon,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(AppRadii.pill),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(AppRadii.pill),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: foreground),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: foreground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryTab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: selected
          ? AppColors.primary
          : (dark ? AppColors.surfaceDark : Colors.white),
      borderRadius: BorderRadius.circular(AppRadii.pill),
      elevation: selected || dark ? 0 : 0.5,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(AppRadii.pill),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: selected
                    ? Colors.white
                    : (dark ? AppColors.mutedDark : AppColors.muted),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: selected
                        ? Colors.white
                        : (dark ? AppColors.mutedDark : AppColors.muted),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PastelCalcCard extends StatefulWidget {
  final CalculatorItem item;
  const _PastelCalcCard({required this.item});

  @override
  State<_PastelCalcCard> createState() => _PastelCalcCardState();
}

class _PastelCalcCardState extends State<_PastelCalcCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bg = dark ? item.accent.withValues(alpha: 0.22) : item.pastel;

    return AnimatedScale(
      scale: _pressed ? 0.97 : 1,
      duration: const Duration(milliseconds: 120),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        elevation: dark ? 0 : 1.5,
        shadowColor: Colors.black.withValues(alpha: 0.10),
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.of(context).pushNamed(item.route);
          },
          onHighlightChanged: (v) => setState(() => _pressed = v),
          borderRadius: BorderRadius.circular(AppRadii.xl),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: dark ? Colors.white.withValues(alpha: 0.12) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: dark
                        ? null
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                  ),
                  child: Icon(item.icon, color: item.accent, size: 22),
                ),
                const Spacer(),
                Text(
                  item.shortTitle,
                  style: GoogleFonts.inter(
                    color: dark ? AppColors.inkDark : AppColors.ink,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: dark ? AppColors.mutedDark : AppColors.muted,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ListCalcCard extends StatelessWidget {
  final CalculatorItem item;
  const _ListCalcCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final fav = AppState.instance.isFavorite(item.route);

    return Material(
      color: dark ? AppColors.surfaceDark : Colors.white,
      borderRadius: BorderRadius.circular(AppRadii.xl),
      elevation: dark ? 0 : 1,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          Navigator.of(context).pushNamed(item.route);
        },
        borderRadius: BorderRadius.circular(AppRadii.xl),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              AccentIconTile(icon: item.icon, accent: item.accent),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.shortTitle,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        color: dark ? AppColors.inkDark : AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppFonts.body2(
                        color: dark ? AppColors.mutedDark : AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  HapticFeedback.selectionClick();
                  AppState.instance.toggleFavorite(item.route);
                },
                icon: Icon(
                  fav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: fav
                      ? AppColors.accentPink
                      : (dark ? AppColors.mutedDark : AppColors.muted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
