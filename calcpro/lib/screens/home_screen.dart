import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:calcpro/models/calculator_item.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/ui_kit.dart';

enum _HomeSort { popular, nameAz, nameZa }

class _ChipSpec {
  final String label;
  final IconData icon;
  final Color accent;

  const _ChipSpec(this.label, this.icon, this.accent);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  String _query = '';
  String _chip = 'All';
  _HomeSort _sort = _HomeSort.popular;

  static const _chips = [
    _ChipSpec('All', Icons.apps_rounded, AppColors.primary),
    _ChipSpec('Finance', Icons.bar_chart_rounded, Color(0xFF0984E3)),
    _ChipSpec('Health', Icons.favorite_rounded, Color(0xFF00B894)),
    _ChipSpec('Everyday', Icons.calendar_today_rounded, Color(0xFF0984E3)),
    _ChipSpec('Business', Icons.work_outline_rounded, Color(0xFFE17055)),
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

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning,';
    if (h < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  List<CalculatorItem> get _items {
    var list = _chip == 'All'
        ? List<CalculatorItem>.from(kCalculators)
        : kCalculators.where((c) => c.tags.contains(_chip)).toList();

    final q = _query.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list
          .where(
            (c) =>
                c.title.toLowerCase().contains(q) ||
                c.shortTitle.toLowerCase().contains(q) ||
                c.description.toLowerCase().contains(q) ||
                c.tags.any((t) => t.toLowerCase().contains(q)),
          )
          .toList();
    }

    switch (_sort) {
      case _HomeSort.popular:
        list.sort((a, b) {
          final ap = a.tags.contains('Popular') ? 0 : 1;
          final bp = b.tags.contains('Popular') ? 0 : 1;
          if (ap != bp) return ap.compareTo(bp);
          return a.shortTitle.compareTo(b.shortTitle);
        });
      case _HomeSort.nameAz:
        list.sort((a, b) => a.shortTitle.compareTo(b.shortTitle));
      case _HomeSort.nameZa:
        list.sort((a, b) => b.shortTitle.compareTo(a.shortTitle));
    }
    return list;
  }

  String get _sortLabel => switch (_sort) {
        _HomeSort.popular => 'Sort by Popular',
        _HomeSort.nameAz => 'Sort A–Z',
        _HomeSort.nameZa => 'Sort Z–A',
      };

  Future<void> _pickSort() async {
    final choice = await showModalBottomSheet<_HomeSort>(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.surfaceDark
          : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final dark = Theme.of(context).brightness == Brightness.dark;
        Widget option(_HomeSort value, String label) {
          final selected = _sort == value;
          return ListTile(
            title: Text(
              label,
              style: GoogleFonts.inter(
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected
                    ? AppColors.primary
                    : (dark ? AppColors.inkDark : AppColors.ink),
              ),
            ),
            trailing: selected
                ? const Icon(Icons.check_rounded, color: AppColors.primary)
                : null,
            onTap: () => Navigator.pop(context, value),
          );
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: dark ? AppColors.lineDark : AppColors.line,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 12),
                option(_HomeSort.popular, 'Popular'),
                option(_HomeSort.nameAz, 'Name A–Z'),
                option(_HomeSort.nameZa, 'Name Z–A'),
              ],
            ),
          ),
        );
      },
    );
    if (choice != null) setState(() => _sort = choice);
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final items = _items;

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
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
                          _NotificationButton(
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
                        controller: _controller,
                        hint: 'Search 120+ calculators...',
                        onClear: () => _controller.clear(),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 42,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _chips.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 8),
                          itemBuilder: (context, i) {
                            final chip = _chips[i];
                            return _IconCategoryChip(
                              label: chip.label,
                              icon: chip.icon,
                              accent: chip.accent,
                              selected: _chip == chip.label,
                              onTap: () =>
                                  setState(() => _chip = chip.label),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              '${items.length} Calculator${items.length == 1 ? '' : 's'}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: dark
                                    ? AppColors.mutedDark
                                    : AppColors.muted,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              _pickSort();
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _sortLabel,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 20,
                                    color: AppColors.primary,
                                  ),
                                ],
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
            if (items.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'No calculators found',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: dark ? AppColors.mutedDark : AppColors.muted,
                      ),
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                sliver: SliverList.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return _HomeBrowseRow(item: items[index]);
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class _NotificationButton extends StatelessWidget {
  final VoidCallback onTap;

  const _NotificationButton({required this.onTap});

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
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.notifications_none_rounded,
                color: dark ? AppColors.inkDark : AppColors.ink,
                size: 22,
              ),
              Positioned(
                top: 11,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: dark ? AppColors.surfaceDark : Colors.white,
                      width: 1.5,
                    ),
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

class _IconCategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color accent;
  final bool selected;
  final VoidCallback onTap;

  const _IconCategoryChip({
    required this.label,
    required this.icon,
    required this.accent,
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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: selected
                ? null
                : Border.all(
                    color: dark ? AppColors.lineDark : AppColors.line,
                  ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: selected ? Colors.white : accent,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: selected
                      ? Colors.white
                      : (dark ? AppColors.inkDark : AppColors.ink),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeBrowseRow extends StatelessWidget {
  final CalculatorItem item;

  const _HomeBrowseRow({required this.item});

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
          padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: item.accent,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: item.accent.withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(item.icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.shortTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: dark ? AppColors.inkDark : AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: dark ? AppColors.mutedDark : AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  AppState.instance.toggleFavorite(item.route);
                },
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    fav
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 22,
                    color: fav
                        ? AppColors.primary
                        : (dark ? AppColors.mutedDark : AppColors.muted),
                  ),
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
