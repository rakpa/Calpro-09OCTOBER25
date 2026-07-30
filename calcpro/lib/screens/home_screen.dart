import 'package:flutter/material.dart';
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
  String _filter = 'Popular';

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

  List<CalculatorItem> get _filtered {
    final state = AppState.instance;
    switch (_filter) {
      case 'Favorites':
        return kCalculators.where((c) => state.isFavorite(c.route)).toList();
      case 'Recent':
      case 'History':
        final routes = state.history.map((e) => e.route).toSet();
        final recent =
            kCalculators.where((c) => routes.contains(c.route)).toList();
        if (recent.isEmpty) {
          return kCalculators.where((c) => c.tags.contains('Recent')).toList();
        }
        return recent;
      default:
        // Featured popular grid (snip shows 4 colorful cards)
        return kCalculators
            .where((c) =>
                c.route == '/percentage' ||
                c.route == '/mortgage' ||
                c.route == '/health' ||
                c.route == '/financial')
            .toList();
    }
  }

  List<CalculatorItem> get _more => kCalculators
      .where((c) => !_filtered.map((e) => e.route).contains(c.route))
      .toList();

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final items = _filtered;
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
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _greeting,
                                style: AppFonts.h1(
                                  color: dark
                                      ? AppColors.inkDark
                                      : AppColors.ink,
                                ),
                              ),
                            ),
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: AppColors.primaryMuted,
                                  child: Icon(
                                    Icons.person_rounded,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Positioned(
                                  right: 2,
                                  top: 2,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: AppColors.accentPink,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: dark
                                            ? AppColors.bgDark
                                            : AppColors.bg,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        SearchField(
                          readOnly: true,
                          showMic: true,
                          hint: 'Search calculators...',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const SearchScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 22),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            QuickActionButton(
                              icon: Icons.favorite_rounded,
                              label: 'Favorites',
                              color: AppColors.accentPink,
                              selected: _filter == 'Favorites',
                              onTap: () =>
                                  setState(() => _filter = 'Favorites'),
                            ),
                            QuickActionButton(
                              icon: Icons.schedule_rounded,
                              label: 'Recent',
                              color: AppColors.accentOrange,
                              selected: _filter == 'Recent',
                              onTap: () => setState(() => _filter = 'Recent'),
                            ),
                            QuickActionButton(
                              icon: Icons.local_fire_department_rounded,
                              label: 'Popular',
                              color: AppColors.accentPurple,
                              selected: _filter == 'Popular',
                              onTap: () =>
                                  setState(() => _filter = 'Popular'),
                            ),
                            QuickActionButton(
                              icon: Icons.account_balance_wallet_rounded,
                              label: 'History',
                              color: AppColors.accentBlue,
                              selected: _filter == 'History',
                              onTap: () =>
                                  setState(() => _filter = 'History'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),
                        Text(
                          _filter == 'Popular'
                              ? 'Popular Calculators'
                              : '$_filter Calculators',
                          style: AppFonts.h3(
                            color: dark ? AppColors.inkDark : AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (items.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 56,
                        color: dark ? AppColors.mutedDark : AppColors.muted,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No calculators found',
                        style: AppFonts.h3(
                          color: dark ? AppColors.inkDark : AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Try another category or star a calculator.',
                        textAlign: TextAlign.center,
                        style: AppFonts.body2(),
                      ),
                    ],
                  ),
                ),
              )
            else if (_filter == 'Popular')
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.05,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = items[index];
                      return FadeTransition(
                        opacity: CurvedAnimation(
                          parent: _intro,
                          curve: Interval(
                            (0.1 * index).clamp(0.0, 0.6),
                            1,
                            curve: Curves.easeOut,
                          ),
                        ),
                        child: _ColorCalcCard(item: item),
                      );
                    },
                    childCount: items.length,
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                sliver: SliverList.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) =>
                      _ListCalcCard(item: items[index]),
                ),
              ),
            if (_filter == 'Popular') ...[
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
                  itemCount: _more.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) =>
                      _ListCalcCard(item: _more[index]),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _ColorCalcCard extends StatefulWidget {
  final CalculatorItem item;
  const _ColorCalcCard({required this.item});

  @override
  State<_ColorCalcCard> createState() => _ColorCalcCardState();
}

class _ColorCalcCardState extends State<_ColorCalcCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return AnimatedScale(
      scale: _pressed ? 0.96 : 1,
      duration: const Duration(milliseconds: 120),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.of(context).pushNamed(item.route);
          },
          onHighlightChanged: (v) => setState(() => _pressed = v),
          borderRadius: BorderRadius.circular(AppRadii.xl),
          child: Ink(
            decoration: BoxDecoration(
              color: item.accent,
              borderRadius: BorderRadius.circular(AppRadii.xl),
              boxShadow: [
                BoxShadow(
                  color: item.accent.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.28),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(item.icon, color: Colors.white, size: 24),
                  ),
                  const Spacer(),
                  Text(
                    item.shortTitle,
                    style: GoogleFonts.fredoka(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.fredoka(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
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
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          Navigator.of(context).pushNamed(item.route);
        },
        borderRadius: BorderRadius.circular(AppRadii.xl),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.xl),
            boxShadow: dark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
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
                      style: GoogleFonts.fredoka(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
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
