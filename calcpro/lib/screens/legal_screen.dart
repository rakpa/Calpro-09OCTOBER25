import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:calcpro/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

/// In-app legal / support docs for App Store compliance.
class LegalScreen extends StatelessWidget {
  final LegalDoc doc;

  const LegalScreen({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(doc.title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Text(
            doc.body,
            style: GoogleFonts.inter(
              fontSize: 15,
              height: 1.55,
              color: dark ? AppColors.inkDark : AppColors.ink,
            ),
          ),
          if (doc.email != null) ...[
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () async {
                HapticFeedback.selectionClick();
                final uri = Uri(
                  scheme: 'mailto',
                  path: doc.email!,
                  query: 'subject=Calcara support',
                );
                await launchUrl(uri);
              },
              icon: const Icon(Icons.email_outlined),
              label: Text('Email ${doc.email}'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

enum LegalDocKind { privacy, terms, support }

class LegalDoc {
  final LegalDocKind kind;
  final String title;
  final String body;
  final String? email;

  const LegalDoc._({
    required this.kind,
    required this.title,
    required this.body,
    this.email,
  });

  static const privacy = LegalDoc._(
    kind: LegalDocKind.privacy,
    title: 'Privacy Policy',
    body: '''
Last updated: August 4, 2026

Calcara provides calculator tools for iOS.

On your device we may store preferences (theme, haptics, sound), favorites, recent searches, and calculation history. This data stays on your device unless you clear app data or uninstall.

We do not sell your personal information. We do not require an account.

Apple / the App Store may process download data under Apple’s privacy policy.

Contact: anubundu1@gmail.com
''',
    email: 'anubundu1@gmail.com',
  );

  static const terms = LegalDoc._(
    kind: LegalDocKind.terms,
    title: 'Terms of Use',
    body: '''
Last updated: August 4, 2026

By using Calcara you agree that calculator results are estimates for personal and educational use only. They are not financial, tax, medical, or legal advice.

The app is provided “as is.” Verify important decisions with a qualified professional.

Contact: anubundu1@gmail.com
''',
    email: 'anubundu1@gmail.com',
  );

  static const support = LegalDoc._(
    kind: LegalDocKind.support,
    title: 'Support',
    body: '''
Need help with Calcara?

Email anubundu1@gmail.com and include your iOS version plus a short description of the issue. We typically reply within 2 business days.

All calculators in this version are free to use.
''',
    email: 'anubundu1@gmail.com',
  );
}
