import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                  style: AppFonts.h1(
                    color: dark ? AppColors.inkDark : AppColors.ink,
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
                        style: GoogleFonts.fredoka(
                          color: dark ? AppColors.inkDark : AppColors.ink,
                          fontSize: 14,
                        ),
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
                  const Divider(height: 1),
                  _tile(
                    context,
                    icon: Icons.apps_rounded,
                    label: 'App Icon',
                    trailing: Text(
                      'Default',
                      style: GoogleFonts.fredoka(
                        color: dark ? AppColors.mutedDark : AppColors.muted,
                        fontWeight: FontWeight.w500,
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
                    icon: Icons.volume_up_outlined,
                    label: 'Sound Effects',
                    value: false,
                    onChanged: (_) {},
                  ),
                  const Divider(height: 1),
                  _switchTile(
                    context,
                    icon: Icons.tips_and_updates_outlined,
                    label: 'Show Tips',
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
                    icon: Icons.language_rounded,
                    label: 'Language',
                    trailing: Text(
                      'English',
                      style: GoogleFonts.fredoka(
                        color: dark ? AppColors.mutedDark : AppColors.muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  _tile(
                    context,
                    icon: Icons.privacy_tip_outlined,
                    label: 'Privacy Policy',
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: dark ? AppColors.mutedDark : AppColors.muted,
                    ),
                  ),
                  const Divider(height: 1),
                  _tile(
                    context,
                    icon: Icons.info_outline_rounded,
                    label: 'About CalcPro',
                    trailing: Text(
                      '1.2.0',
                      style: GoogleFonts.fredoka(
                        color: dark ? AppColors.mutedDark : AppColors.muted,
                        fontWeight: FontWeight.w500,
                      ),
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
        style: GoogleFonts.fredoka(
          fontWeight: FontWeight.w500,
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
      title: Text(
        label,
        style: GoogleFonts.fredoka(fontWeight: FontWeight.w500),
      ),
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
            style: GoogleFonts.fredoka(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: dark ? AppColors.mutedDark : AppColors.muted,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: dark ? AppColors.surfaceDark : Colors.white,
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
          child: child,
        ),
      ],
    );
  }
}
