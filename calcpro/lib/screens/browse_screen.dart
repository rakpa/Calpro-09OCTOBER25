import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:calcpro/models/calculator_item.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/ui_kit.dart';

enum BrowseSort { popular, nameAz, nameZa }

class BrowseScreen extends StatefulWidget {
  final VoidCallback? onOpenFavorites;

  const BrowseScreen({super.key, this.onOpenFavorites});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final _controller = TextEditingController();
  String _query = '';
  String _chip = 'All';
  BrowseSort _sort = BrowseSort.popular;

  static const _chips = ['All', 'Finance', 'Health', 'Business', 'Everyday'];

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
      case BrowseSort.popular:
        list.sort((a, b) {
          final ap = a.tags.contains('Popular') ? 0 : 1;
          final bp = b.tags.contains('Popular') ? 0 : 1;
          if (ap != bp) return ap.compareTo(bp);
          return a.shortTitle.compareTo(b.shortTitle);
        });
      case BrowseSort.nameAz:
        list.sort((a, b) => a.shortTitle.compareTo(b.shortTitle));
      case BrowseSort.nameZa:
        list.sort((a, b) => b.shortTitle.compareTo(a.shortTitle));
    }
    return list;
  }

  String get _sortLabel => switch (_sort) {
        BrowseSort.popular => 'Sort by Popular',
        BrowseSort.nameAz => 'Sort A–Z',
        BrowseSort.nameZa => 'Sort Z–A',
      };

  Future<void> _pickSort() async {
    final choice = await showModalBottomSheet<BrowseSort>(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.surfaceDark
          : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final dark = Theme.of(context).brightness == Brightness.dark;
        Widget option(BrowseSort value, String label) {
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
                option(BrowseSort.popular, 'Popular'),
                option(BrowseSort.nameAz, 'Name A–Z'),
                option(BrowseSort.nameZa, 'Name Z–A'),
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
                        children: [
                          Expanded(
                            child: Text(
                              'Browse Calculators',
                              style: GoogleFonts.inter(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                height: 1.15,
                                color: dark
                                    ? AppColors.inkDark
                                    : AppColors.ink,
                              ),
                            ),
                          ),
                          Material(
                            color: dark ? AppColors.surfaceDark : Colors.white,
                            shape: const CircleBorder(),
                            elevation: dark ? 0 : 1,
                            shadowColor: Colors.black.withValues(alpha: 0.08),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () {
                                HapticFeedback.selectionClick();
                                widget.onOpenFavorites?.call();
                              },
                              child: SizedBox(
                                width: 44,
                                height: 44,
                                child: Icon(
                                  Icons.favorite_border_rounded,
                                  color: dark
                                      ? AppColors.inkDark
                                      : AppColors.ink,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SearchField(
                        controller: _controller,
                        hint: 'Search 120+ calculators...',
                        onClear: () => _controller.clear(),
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
                            return _BrowseChip(
                              label: chip,
                              selected: selected,
                              onTap: () => setState(() => _chip = chip),
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: dark ? AppColors.mutedDark : AppColors.muted,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No calculators found',
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: dark ? AppColors.inkDark : AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Try another category or clear your search.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: dark
                                ? AppColors.mutedDark
                                : AppColors.muted,
                          ),
                        ),
                      ],
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
                    return _BrowseRow(item: items[index]);
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class _BrowseChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _BrowseChip({
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

class _BrowseRow extends StatelessWidget {
  final CalculatorItem item;

  const _BrowseRow({required this.item});

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
                  color: item.accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item.icon, color: item.accent, size: 24),
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
