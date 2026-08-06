import 'package:flutter/material.dart';
import 'package:calcpro/widgets/soft_nav.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:calcpro/services/app_state.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:calcpro/screens/premium_screen.dart';
import 'package:calcpro/screens/legal_screen.dart';
import 'package:calcpro/app_info.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        final state = AppState.instance;
        final mode = state.themeMode;

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
                        style: GoogleFonts.inter(
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
                          if (v != null) state.setThemeMode(v);
                        },
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
                    value: state.hapticsEnabled,
                    onChanged: state.setHaptics,
                  ),
                  const Divider(height: 1),
                  _switchTile(
                    context,
                    icon: Icons.volume_up_outlined,
                    label: 'Sound Effects',
                    value: state.soundEnabled,
                    onChanged: state.setSound,
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
                    icon: Icons.workspace_premium_rounded,
                    label: state.isPremium
                        ? 'Calcara Plus · Unlimited history'
                        : 'Calcara Plus',
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: dark ? AppColors.mutedDark : AppColors.muted,
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        SoftPageRoute(
                          builder: (_) => const PremiumScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _tile(
                    context,
                    icon: Icons.info_outline_rounded,
                    label: 'About ${AppInfo.name}',
                    trailing: Text(
                      AppInfo.versionName,
                      style: GoogleFonts.inter(
                        color: dark ? AppColors.mutedDark : AppColors.muted,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: AppInfo.name,
                        applicationVersion: AppInfo.versionName,
                        applicationLegalese:
                            '© 2026 Good Life\nCalculators for everyday life.',
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _Section(
              title: 'Legal & Support',
              child: Column(
                children: [
                  _tile(
                    context,
                    icon: Icons.privacy_tip_outlined,
                    label: 'Privacy Policy',
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: dark ? AppColors.mutedDark : AppColors.muted,
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        SoftPageRoute(
                          builder: (_) =>
                              const LegalScreen(doc: LegalDoc.privacy),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _tile(
                    context,
                    icon: Icons.description_outlined,
                    label: 'Terms of Use',
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: dark ? AppColors.mutedDark : AppColors.muted,
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        SoftPageRoute(
                          builder: (_) =>
                              const LegalScreen(doc: LegalDoc.terms),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _tile(
                    context,
                    icon: Icons.support_agent_rounded,
                    label: 'Support',
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: dark ? AppColors.mutedDark : AppColors.muted,
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        SoftPageRoute(
                          builder: (_) =>
                              const LegalScreen(doc: LegalDoc.support),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _tile(
                    context,
                    icon: Icons.open_in_new_rounded,
                    label: 'Open Privacy Policy (web)',
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: dark ? AppColors.mutedDark : AppColors.muted,
                    ),
                    onTap: () => _openUrl(AppInfo.privacyPolicyUrl),
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
    VoidCallback? onTap,
  }) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      onTap: onTap,
      leading: Icon(icon, color: AppColors.primary, size: 26),
      title: Text(
        label,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          fontSize: 17,
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
        style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 17),
      ),
      trailing: Switch.adaptive(
        value: value,
        activeColor: AppColors.primary,
        onChanged: (v) {
          AppState.instance.selectionFeedback();
          onChanged(v);
        },
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
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: dark ? AppColors.mutedDark : AppColors.muted,
            ),
          ),
        ),
        Material(
          color: dark ? AppColors.surfaceDark : AppColors.surfaceRaised,
          borderRadius: BorderRadius.circular(AppRadii.xl),
          elevation: dark ? 0 : 0,
          shadowColor: Colors.black.withValues(alpha: 0.12),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadii.xl),
              border: Border.all(
                color: dark
                    ? AppColors.lineDark
                    : Colors.white.withValues(alpha: 0.7),
              ),
              gradient: dark
                  ? null
                  : const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFFFDFB),
                        Color(0xFFF3F6FC),
                        Color(0xFFF1F8F4),
                      ],
                    ),
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}
