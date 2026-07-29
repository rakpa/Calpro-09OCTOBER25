import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calcpro/models/calculator_item.dart';
import 'package:calcpro/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _intro;

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackdrop(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 168,
              backgroundColor: AppColors.primary,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primarySoft,
                        AppColors.primary,
                        AppColors.primaryDeep,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(22, 18, 22, 16),
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
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.18),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(
                                    Icons.calculate_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'CalcPro',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.6,
                                      ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              'Every calculation,\nin one place.',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    height: 1.15,
                                    letterSpacing: -0.4,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Fast tools for everyday math.',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.78),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 36),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.92,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = kCalculators[index];
                    final start = (0.08 * index).clamp(0.0, 0.55);
                    return FadeTransition(
                      opacity: CurvedAnimation(
                        parent: _intro,
                        curve: Interval(start, 1, curve: Curves.easeOut),
                      ),
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.08),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _intro,
                            curve: Interval(start, 1, curve: Curves.easeOutCubic),
                          ),
                        ),
                        child: _CalcCard(item: item),
                      ),
                    );
                  },
                  childCount: kCalculators.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalcCard extends StatefulWidget {
  final CalculatorItem item;

  const _CalcCard({required this.item});

  @override
  State<_CalcCard> createState() => _CalcCardState();
}

class _CalcCardState extends State<_CalcCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return AnimatedScale(
      scale: _pressed ? 0.97 : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.of(context).pushNamed(item.route);
          },
          onHighlightChanged: (v) => setState(() => _pressed = v),
          borderRadius: BorderRadius.circular(22),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: item.gradient,
              ),
              boxShadow: [
                BoxShadow(
                  color: item.gradient.last.withValues(alpha: 0.28),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -28,
                  right: -20,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -24,
                  left: -16,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(item.icon, color: Colors.white, size: 24),
                      ),
                      const Spacer(),
                      Text(
                        item.title.replaceAll(' Calculator', ''),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          height: 1.2,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.88),
                          fontSize: 12,
                          height: 1.3,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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
