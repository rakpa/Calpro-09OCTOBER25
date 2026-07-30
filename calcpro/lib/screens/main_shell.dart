import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/widgets/soft_nav.dart';
import 'package:calcpro/screens/home_screen.dart';
import 'package:calcpro/screens/favorites_screen.dart';
import 'package:calcpro/screens/history_screen.dart';
import 'package:calcpro/screens/settings_screen.dart';
import 'package:calcpro/screens/search_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _tabs = [
    _TabSpec(Icons.home_outlined, Icons.home_rounded, 'Home'),
    _TabSpec(Icons.favorite_border_rounded, Icons.favorite_rounded, 'Favorites'),
    _TabSpec(Icons.calculate_outlined, Icons.calculate_rounded, 'Calculate'),
    _TabSpec(Icons.history_outlined, Icons.history_rounded, 'History'),
    _TabSpec(Icons.settings_outlined, Icons.settings_rounded, 'Settings'),
  ];

  int get _bodyIndex {
    if (_index == 2) return 0;
    if (_index > 2) return _index - 1;
    return _index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: IndexedStack(
        index: _bodyIndex,
        sizing: StackFit.expand,
        children: const [
          HomeScreen(),
          FavoritesScreen(),
          HistoryScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        index: _index,
        tabs: _tabs,
        onChanged: (i) {
          HapticFeedback.selectionClick();
          if (i == 2) {
            Navigator.of(context).push(
              SoftPageRoute(builder: (_) => const SearchScreen()),
            );
            return;
          }
          if (i == _index) return;
          setState(() => _index = i);
        },
      ),
    );
  }
}

class _TabSpec {
  final IconData outline;
  final IconData filled;
  final String label;
  const _TabSpec(this.outline, this.filled, this.label);
}

class _BottomNav extends StatelessWidget {
  final int index;
  final List<_TabSpec> tabs;
  final ValueChanged<int> onChanged;

  const _BottomNav({
    required this.index,
    required this.tabs,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: dark ? AppColors.surfaceDark : AppColors.surfaceRaised,
        border: Border(
          top: BorderSide(
            color: dark
                ? AppColors.lineDark
                : Colors.white.withValues(alpha: 0.8),
          ),
        ),
        boxShadow: dark
            ? null
            : [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, -6),
                ),
              ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 8, 6, 6),
          child: Row(
            children: [
              for (var i = 0; i < tabs.length; i++)
                Expanded(
                  child: _NavItem(
                    spec: tabs[i],
                    selected: index == i,
                    isCenter: i == 2,
                    onTap: () => onChanged(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final _TabSpec spec;
  final bool selected;
  final bool isCenter;
  final VoidCallback onTap;

  const _NavItem({
    required this.spec,
    required this.selected,
    required this.isCenter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final inactive = dark ? AppColors.mutedDark : AppColors.muted;

    if (isCenter) {
      return GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(Icons.apps_rounded, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 4),
            Text(
              spec.label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? spec.filled : spec.outline,
              color: selected ? AppColors.primary : inactive,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              spec.label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? AppColors.primary : inactive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
