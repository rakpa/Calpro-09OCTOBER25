import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:calcpro/models/calculator_item.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/theme/app_theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  String _dayLabel(DateTime at) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(at.year, at.month, at.day);
    final diff = today.difference(day).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return DateFormat.MMMd().format(at);
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final entries = AppState.instance.history;
        final groups = <String, List<HistoryEntry>>{};
        for (final e in entries) {
          final key = _dayLabel(e.at);
          groups.putIfAbsent(key, () => []).add(e);
        }

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
                  child: Row(
                    children: [
                      Text(
                        'History',
                        style: AppFonts.h1(
                          color: dark ? AppColors.inkDark : AppColors.ink,
                        ),
                      ),
                      const Spacer(),
                      if (entries.isNotEmpty)
                        TextButton(
                          onPressed: () => AppState.instance.clearHistory(),
                          child: Text(
                            'Clear',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            if (entries.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.history_rounded,
                          size: 56,
                          color: dark ? AppColors.mutedDark : AppColors.muted,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'No history yet',
                          style: AppFonts.h3(
                            color: dark ? AppColors.inkDark : AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Your recent calculations will show up here.',
                          textAlign: TextAlign.center,
                          style: AppFonts.body2(),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              for (final entry in groups.entries) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Text(
                      entry.key,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: dark ? AppColors.mutedDark : AppColors.muted,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList.separated(
                    itemCount: entry.value.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final h = entry.value[i];
                      final calc = calculatorByRoute(h.route);
                      return Material(
                        color: dark
                            ? AppColors.surfaceDark
                            : (calc?.pastel ?? AppColors.surfaceRaised),
                        borderRadius: BorderRadius.circular(AppRadii.lg),
                        child: InkWell(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            Navigator.of(context).pushNamed(h.route);
                          },
                          borderRadius: BorderRadius.circular(AppRadii.lg),
                          child: Ink(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppRadii.lg),
                              border: Border.all(
                                color: dark
                                    ? AppColors.lineDark
                                    : Colors.white.withValues(alpha: 0.65),
                              ),
                            ),
                            child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                if (calc != null)
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color:
                                          calc.accent.withValues(alpha: 0.16),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(calc.icon,
                                        color: calc.accent, size: 22),
                                  )
                                else
                                  const Icon(Icons.calculate_rounded),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        h.title,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        DateFormat.jm().format(h.at),
                                        style: AppFonts.caption(
                                          color: dark
                                              ? AppColors.mutedDark
                                              : AppColors.muted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    h.result,
                                    textAlign: TextAlign.right,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
          ],
        );
      },
    );
  }
}
