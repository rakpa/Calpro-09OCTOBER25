import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calcpro/models/calculator_item.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/ui_kit.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final items = kCalculators
            .where((c) => AppState.instance.isFavorite(c.route))
            .toList();

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Text(
                    'Favorites',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
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
                          Icons.favorite_border_rounded,
                          size: 52,
                          color: dark ? AppColors.mutedDark : AppColors.muted,
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'No favorites yet',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Tap the heart on any calculator to save it here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                dark ? AppColors.mutedDark : AppColors.muted,
                          ),
                        ),
                        const SizedBox(height: 20),
                        PrimaryButton(
                          label: 'Explore Calculators',
                          onPressed: () {
                            // Pop to home tab is parent-managed; open search.
                            Navigator.of(context).pushNamed('/basic');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                sliver: SliverList.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final item = items[i];
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
                            border: Border.all(
                              color:
                                  dark ? AppColors.lineDark : AppColors.line,
                            ),
                          ),
                          child: Row(
                            children: [
                              AccentIconTile(
                                icon: item.icon,
                                accent: item.accent,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.shortTitle,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      item.description,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: dark
                                            ? AppColors.mutedDark
                                            : AppColors.muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => AppState.instance
                                    .toggleFavorite(item.route),
                                icon: const Icon(
                                  Icons.favorite_rounded,
                                  color: AppColors.accentPink,
                                ),
                              ),
                            ],
                          ),
                        ),
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
