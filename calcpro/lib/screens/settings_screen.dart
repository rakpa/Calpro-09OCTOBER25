import 'package:flutter/material.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final mode = AppState.instance.themeMode;

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: Text(
                  'Settings',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                ),
              ),
            ),
            _Section(
              title: 'Appearance',
              child: Column(
                children: [
                  _tile(
                    context,
                    icon: Icons.dark_mode_outlined,
                    label: 'Theme',
                    trailing: DropdownButtonHideUnderline(
                      child: DropdownButton<ThemeMode>(
                        value: mode,
                        items: const [
                          DropdownMenuItem(
                            value: ThemeMode.system,
                            child: Text('System'),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.light,
                            child: Text('Light'),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.dark,
                            child: Text('Dark'),
                          ),
                        ],
                        onChanged: (v) {
                          if (v != null) AppState.instance.setThemeMode(v);
                        },
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  _tile(
                    context,
                    icon: Icons.palette_outlined,
                    label: 'Accent Color',
                    trailing: Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _Section(
              title: 'Preferences',
              child: Column(
                children: [
                  _switchTile(
                    context,
                    icon: Icons.vibration_rounded,
                    label: 'Haptic Feedback',
                    value: true,
                    onChanged: (_) {},
                  ),
                  const Divider(height: 1),
                  _switchTile(
                    context,
                    icon: Icons.tips_and_updates_outlined,
                    label: 'Tips',
                    value: true,
                    onChanged: (_) {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _Section(
              title: 'General',
              child: Column(
                children: [
                  _tile(
                    context,
                    icon: Icons.info_outline_rounded,
                    label: 'About CalcPro',
                    trailing: Text(
                      '1.1.0',
                      style: TextStyle(
                        color: dark ? AppColors.mutedDark : AppColors.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  _tile(
                    context,
                    icon: Icons.privacy_tip_outlined,
                    label: 'Privacy',
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: dark ? AppColors.mutedDark : AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Widget trailing,
  }) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: dark ? AppColors.inkDark : AppColors.ink,
        ),
      ),
      trailing: trailing,
    );
  }

  Widget _switchTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      leading: Icon(icon, color: AppColors.primary),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: Switch.adaptive(
        value: value,
        activeColor: AppColors.primary,
        onChanged: onChanged,
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: dark ? AppColors.mutedDark : AppColors.muted,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: dark ? AppColors.surfaceDark : Colors.white,
            borderRadius: BorderRadius.circular(AppRadii.xl),
            border: Border.all(
              color: dark ? AppColors.lineDark : AppColors.line,
            ),
          ),
          child: child,
        ),
      ],
    );
  }
}
