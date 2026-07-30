import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  static const _filters = ['Favorites', 'Recent', 'History', 'Popular'];

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
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  List<CalculatorItem> get _filtered {
    final state = AppState.instance;
    switch (_filter) {
      case 'Favorites':
        return kCalculators
            .where((c) => state.isFavorite(c.route))
            .toList();
      case 'Recent':
      case 'History':
        final routes = state.history.map((e) => e.route).toSet();
        final recent = kCalculators.where((c) => routes.contains(c.route)).toList();
        if (recent.isEmpty) {
          return kCalculators.where((c) => c.tags.contains('Recent')).toList();
        }
        return recent;
      default:
        return kCalculators.where((c) => c.tags.contains('Popular')).toList();
    }
  }

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
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _intro,
                      curve: Curves.easeOut,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$_greeting 👋',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.6,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'What would you like to calculate?',
                          style: TextStyle(
                            color: dark ? AppColors.mutedDark : AppColors.muted,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 18),
                        SearchField(
                          readOnly: true,
                          hint: 'Search calculators',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const SearchScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          height: 40,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _filters.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, i) {
                              final label = _filters[i];
                              final selected = _filter == label;
                              return GestureDetector(
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  setState(() => _filter = label);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? AppColors.primary
                                        : (dark
                                            ? AppColors.surfaceDark
                                            : Colors.white),
                                    borderRadius:
                                        BorderRadius.circular(AppRadii.pill),
                                    border: Border.all(
                                      color: selected
                                          ? AppColors.primary
                                          : (dark
                                              ? AppColors.lineDark
                                              : AppColors.line),
                                    ),
                                  ),
                                  child: Text(
                                    label,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                      color: selected
                                          ? Colors.white
                                          : (dark
                                              ? AppColors.inkDark
                                              : AppColors.ink),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 22),
                        Row(
                          children: [
                            Text(
                              _filter == 'Popular'
                                  ? 'Popular Calculators'
                                  : '$_filter Calculators',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const Spacer(),
                            Text(
                              '${items.length}',
                              style: TextStyle(
                                color: dark
                                    ? AppColors.mutedDark
                                    : AppColors.muted,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (items.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 48,
                          color: dark ? AppColors.mutedDark : AppColors.muted,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Nothing here yet',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: dark ? AppColors.inkDark : AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Star calculators or run a few to fill this list.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                dark ? AppColors.mutedDark : AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                sliver: SliverList.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final start = (0.06 * index).clamp(0.0, 0.5);
                    return FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _intro,
                        curve: Interval(start, 1, curve: Curves.easeOut),
                      ),
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.06),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _intro,
                            curve: Interval(
                              start,
                              1,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                        ),
                        child: _PopularCard(item: item),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class _PopularCard extends StatefulWidget {
  final CalculatorItem item;
  const _PopularCard({required this.item});

  @override
  State<_PopularCard> createState() => _PopularCardState();
}

class _PopularCardState extends State<_PopularCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final fav = AppState.instance.isFavorite(item.route);

    return AnimatedScale(
      scale: _pressed ? 0.98 : 1,
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
              color: dark ? AppColors.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(AppRadii.xl),
              border: Border.all(
                color: dark ? AppColors.lineDark : AppColors.line,
              ),
              boxShadow: dark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  AccentIconTile(icon: item.icon, accent: item.accent),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.shortTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            letterSpacing: -0.2,
                            color: dark ? AppColors.inkDark : AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.3,
                            color:
                                dark ? AppColors.mutedDark : AppColors.muted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                size: 16, color: Color(0xFFFFB020)),
                            const SizedBox(width: 4),
                            Text(
                              '${item.rating} · ${item.ratingCount}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: dark
                                    ? AppColors.mutedDark
                                    : AppColors.muted,
                              ),
                            ),
                          ],
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
                      fav
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: fav
                          ? AppColors.accentPink
                          : (dark ? AppColors.mutedDark : AppColors.muted),
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
