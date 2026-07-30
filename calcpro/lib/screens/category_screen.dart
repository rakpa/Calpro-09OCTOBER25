import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:calcpro/models/calculator_item.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/ui_kit.dart';
import 'package:calcpro/widgets/app_status.dart';

class CategoryScreen extends StatelessWidget {
  final String category;

  const CategoryScreen({super.key, required this.category});

  List<CalculatorItem> get _items {
    final state = AppState.instance;
    switch (category) {
      case 'Favorites':
        return kCalculators.where((c) => state.isFavorite(c.route)).toList();
      case 'Recent':
      case 'History':
        final routes = state.history.map((e) => e.route).toSet();
        final list =
            kCalculators.where((c) => routes.contains(c.route)).toList();
        if (list.isEmpty) {
          return kCalculators.where((c) => c.tags.contains('Recent')).toList();
        }
        return list;
      case 'Popular':
        return kCalculators.where((c) => c.tags.contains('Popular')).toList();
      case 'Finance':
        return kCalculators
            .where((c) =>
                c.route == '/mortgage' ||
                c.route == '/financial' ||
                c.route == '/tip' ||
                c.route == '/discount')
            .toList();
      case 'Health':
        return kCalculators
            .where((c) => c.route == '/health' || c.route == '/bmi')
            .toList();
      case 'Everyday':
        return kCalculators
            .where((c) =>
                c.route == '/percentage' ||
                c.route == '/basic' ||
                c.route == '/convert' ||
                c.route == '/scientific')
            .toList();
      default:
        return kCalculators;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: dark ? AppColors.bgDark : AppColors.bg,
      appBar: AppBar(title: Text('$category Calculators')),
      body: ListenableBuilder(
        listenable: AppState.instance,
        builder: (context, _) {
          final items = _items;
          if (items.isEmpty) {
            return AppStatusView.empty(
              title: 'Nothing here yet',
              message: 'Explore calculators and star your favorites.',
              actionLabel: 'Browse all',
              onAction: () => Navigator.pop(context),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final item = items[i];
              final fav = AppState.instance.isFavorite(item.route);
              return Material(
                color: dark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(AppRadii.xl),
                child: InkWell(
                  onTap: () {
                    AppState.instance.selectionFeedback();
                    Navigator.of(context).pushNamed(item.route);
                  },
                  borderRadius: BorderRadius.circular(AppRadii.xl),
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
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: dark
                                      ? AppColors.inkDark
                                      : AppColors.ink,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.description,
                                style: AppFonts.body2(
                                  color: dark
                                      ? AppColors.mutedDark
                                      : AppColors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              AppState.instance.toggleFavorite(item.route),
                          icon: Icon(
                            fav
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: fav
                                ? AppColors.accentPink
                                : (dark
                                    ? AppColors.mutedDark
                                    : AppColors.muted),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
