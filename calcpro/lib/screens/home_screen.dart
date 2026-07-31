import 'package:flutter/material.dart';
import 'package:calcpro/widgets/soft_nav.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:calcpro/models/calculator_item.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/ui_kit.dart';
import 'package:calcpro/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _intro;
  String _chip = 'All';

  static const _chips = ['All', 'Finance', 'Health', 'Business', 'Everyday'];

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
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

  List<CalculatorItem> get _filtered {
    if (_chip == 'All') return List<CalculatorItem>.from(kCalculators);
    return kCalculators.where((c) => c.tags.contains(_chip)).toList();
  }

  List<CalculatorItem> get _popular {
    final pool = _chip == 'All'
        ? kCalculators.where((c) => c.tags.contains('Popular')).toList()
        : _filtered;
    return pool.take(6).toList();
  }

  /// Recent history, or Mortgage + Health placeholders so the section matches the snip.
  List<(CalculatorItem, String)> get _continueRows {
    final seen = <String>{};
    final out = <(CalculatorItem, String)>[];
    for (final h in AppState.instance.history) {
      if (seen.contains(h.route)) continue;
      final item = calculatorByRoute(h.route);
      if (item == null) continue;
      seen.add(h.route);
      out.add((item, 'Last used ${_relative(h.at)}'));
      if (out.length >= 2) break;
    }
    if (out.isNotEmpty) return out;

    final defaults = <CalculatorItem?>[
      calculatorByRoute('/mortgage'),
      calculatorByRoute('/health'),
    ];
    for (final item in defaults) {
      if (item == null) continue;
      out.add((item, 'Suggested for you'));
    }
    return out;
  }

  CalculatorItem get _calculatorOfDay {
    // Snip features compound interest; Savings is our compound-growth tool.
    final compound = calculatorByRoute('/savings');
    if (compound != null) return compound;
    final day =
        DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    return kCalculators[day % kCalculators.length];
  }

  String _relative(DateTime at) {
    final d = DateTime.now().difference(at);
    if (d.inMinutes < 1) return 'just now';
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    if (d.inHours < 24) return '${d.inHours}h ago';
    if (d.inDays == 1) return 'yesterday';
    return '${d.inDays}d ago';
  }

  void _openSearch() {
    Navigator.of(context).push(
      SoftPageRoute(builder: (_) => const SearchScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final continueRows = _continueRows;
        final popular = _popular;
        final ofDay = _calculatorOfDay;

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _intro,
                      curve: Curves.easeOut,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$_greeting 👋',
                                    style: GoogleFonts.inter(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      height: 1.15,
                                      color: dark
                                          ? AppColors.inkDark
                                          : AppColors.ink,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'What would you like to calculate?',
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      height: 1.35,
                                      color: dark
                                          ? AppColors.mutedDark
                                          : AppColors.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            _RoundIconButton(
                              icon: Icons.notifications_none_rounded,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('No new notifications'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        SearchField(
                          readOnly: true,
                          showMic: false,
                          hint: 'Search 120+ calculators...',
                          onTap: _openSearch,
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 40,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _chips.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, i) {
                              final chip = _chips[i];
                              final selected = _chip == chip;
                              return _CategoryChip(
                                label: chip,
                                selected: selected,
                                onTap: () => setState(() => _chip = chip),
                              );
                            },
                          ),
                        ),
                        if (continueRows.isNotEmpty) ...[
                          const SizedBox(height: 22),
                          Text(
                            'Continue where you left off',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: dark ? AppColors.inkDark : AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              for (var i = 0; i < continueRows.length; i++) ...[
                                if (i > 0) const SizedBox(width: 12),
                                Expanded(
                                  child: _ContinueCard(
                                    item: continueRows[i].$1,
                                    subtitle: continueRows[i].$2,
                                  ),
                                ),
                              ],
                              if (continueRows.length == 1)
                                const Expanded(child: SizedBox.shrink()),
                            ],
                          ),
                        ],
                        const SizedBox(height: 22),
                        Text(
                          'Popular this week',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: dark ? AppColors.inkDark : AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.78,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = popular[index];
                    return FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _intro,
                        curve: Interval(
                          (0.08 * index).clamp(0.0, 0.55),
                          1,
                          curve: Curves.easeOut,
                        ),
                      ),
                      child: _PopularCard(item: item),
                    );
                  },
                  childCount: popular.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                child: _CalculatorOfDayBanner(item: ofDay),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: dark ? AppColors.surfaceDark : Colors.white,
      shape: const CircleBorder(),
      elevation: dark ? 0 : 1,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            icon,
            color: dark ? AppColors.inkDark : AppColors.ink,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
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
      borderRadius: BorderRadius.circular(999),
      elevation: selected || dark ? 0 : 0.5,
      shadowColor: Colors.black.withValues(alpha: 0.06),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: selected
                  ? Colors.white
                  : (dark ? AppColors.mutedDark : AppColors.muted),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContinueCard extends StatelessWidget {
  final CalculatorItem item;
  final String subtitle;

  const _ContinueCard({required this.item, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: dark ? AppColors.surfaceDark : Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: dark ? 0 : 2,
      shadowColor: Colors.black.withValues(alpha: 0.07),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          Navigator.of(context).pushNamed(item.route);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: item.accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: item.accent, size: 20),
              ),
              const SizedBox(height: 12),
              Text(
                item.shortTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: dark ? AppColors.inkDark : AppColors.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: dark ? AppColors.mutedDark : AppColors.muted,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Continue',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PopularCard extends StatelessWidget {
  final CalculatorItem item;

  const _PopularCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final fav = AppState.instance.isFavorite(item.route);

    return Material(
      color: dark ? AppColors.surfaceDark : Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: dark ? 0 : 2,
      shadowColor: Colors.black.withValues(alpha: 0.07),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          Navigator.of(context).pushNamed(item.route);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 8, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: item.accent.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(item.icon, color: item.accent, size: 18),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      AppState.instance.toggleFavorite(item.route);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        fav
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 18,
                        color: fav
                            ? AppColors.primary
                            : (dark ? AppColors.mutedDark : AppColors.muted),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                item.shortTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: dark ? AppColors.inkDark : AppColors.ink,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                item.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  height: 1.25,
                  color: dark ? AppColors.mutedDark : AppColors.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalculatorOfDayBanner extends StatelessWidget {
  final CalculatorItem item;

  const _CalculatorOfDayBanner({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 0,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          Navigator.of(context).pushNamed(item.route);
        },
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF6C5CE7),
                Color(0xFF8B7CF7),
                Color(0xFFA29BFE),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.28),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(item.icon, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Calculator of the Day',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.88),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
