import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:calcpro/theme/app_theme.dart';

/// Cute calculator mascot matching the Calcara splash snip.
class CalculatorMascot extends StatelessWidget {
  final double width;

  const CalculatorMascot({super.key, this.width = 280});

  @override
  Widget build(BuildContext context) {
    final height = width * 1.15;
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _MascotPainter(),
        size: Size(width, height),
      ),
    );
  }
}

class _MascotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final bodyR = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.08, h * 0.04, w * 0.84, h * 0.92),
      Radius.circular(w * 0.18),
    );

    // Soft shadow
    canvas.drawRRect(
      bodyR.shift(Offset(0, h * 0.02)),
      Paint()
        ..color = const Color(0xFF1A1A40).withValues(alpha: 0.08)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
    );

    // White body
    canvas.drawRRect(bodyR, Paint()..color = Colors.white);
    canvas.drawRRect(
      bodyR,
      Paint()
        ..color = const Color(0xFFE8EAF2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Screen
    final screen = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.18, h * 0.12, w * 0.64, h * 0.28),
      Radius.circular(w * 0.08),
    );
    canvas.drawRRect(screen, Paint()..color = const Color(0xFF2A2A3A));

    // Happy eyes
    final eyePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.035
      ..strokeCap = StrokeCap.round;
    final eyeY = h * 0.24;
    final eyeW = w * 0.08;
    final eyeH = h * 0.035;
    // left
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(w * 0.38, eyeY),
        width: eyeW,
        height: eyeH,
      ),
      3.6,
      2.2,
      false,
      eyePaint,
    );
    // right
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(w * 0.62, eyeY),
        width: eyeW,
        height: eyeH,
      ),
      3.6,
      2.2,
      false,
      eyePaint,
    );

    // Smile
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.30),
        width: w * 0.12,
        height: h * 0.05,
      ),
      0.2,
      2.7,
      false,
      Paint()
        ..color = AppColors.primarySoft
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.028
        ..strokeCap = StrokeCap.round,
    );

    // Purple keypad tiles
    const labels = ['+', '−', '×', '='];
    final tile = w * 0.16;
    final startX = w * 0.18;
    final startY = h * 0.48;
    final gap = w * 0.04;
    for (var i = 0; i < 4; i++) {
      final col = i % 2;
      final row = i ~/ 2;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          startX + col * (tile + gap),
          startY + row * (tile + gap),
          tile,
          tile,
        ),
        Radius.circular(w * 0.045),
      );
      canvas.drawRRect(rect, Paint()..color = AppColors.primary);
      final tp = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: GoogleFonts.fredoka(
            color: Colors.white,
            fontSize: w * 0.09,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(
          rect.left + (tile - tp.width) / 2,
          rect.top + (tile - tp.height) / 2,
        ),
      );
    }

    // Tall orange equals button
    final orange = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        w * 0.58,
        h * 0.48,
        w * 0.24,
        tile * 2 + gap,
      ),
      Radius.circular(w * 0.06),
    );
    canvas.drawRRect(orange, Paint()..color = AppColors.accentOrange);

    final barPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = w * 0.03
      ..strokeCap = StrokeCap.round;
    final cx = orange.left + orange.width / 2;
    final cy = orange.top + orange.height / 2;
    canvas.drawLine(
      Offset(cx - w * 0.05, cy - h * 0.018),
      Offset(cx + w * 0.05, cy - h * 0.018),
      barPaint,
    );
    canvas.drawLine(
      Offset(cx - w * 0.05, cy + h * 0.018),
      Offset(cx + w * 0.05, cy + h * 0.018),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Sparkle extends StatelessWidget {
  final double size;
  final Color color;

  const Sparkle({
    super.key,
    this.size = 18,
    this.color = AppColors.sparkle,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _SparklePainter(color),
    );
  }
}

class _SparklePainter extends CustomPainter {
  final Color color;
  _SparklePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final path = Path()
      ..moveTo(cx, 0)
      ..lineTo(cx + size.width * 0.18, cy - size.height * 0.18)
      ..lineTo(size.width, cy)
      ..lineTo(cx + size.width * 0.18, cy + size.height * 0.18)
      ..lineTo(cx, size.height)
      ..lineTo(cx - size.width * 0.18, cy + size.height * 0.18)
      ..lineTo(0, cy)
      ..lineTo(cx - size.width * 0.18, cy - size.height * 0.18)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Shared Calcara brand header used on splash / onboarding.
class CalcaraBrandHeader extends StatelessWidget {
  const CalcaraBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Text(
              'Calcara',
              style: AppFonts.display(color: AppColors.brandNavy),
            ),
            const Positioned(
              right: -28,
              top: -6,
              child: Sparkle(size: 22),
            ),
            const Positioned(
              right: -8,
              top: -18,
              child: Sparkle(size: 14),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Smart calculators for everyday life.',
          textAlign: TextAlign.center,
          style: GoogleFonts.fredoka(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: AppColors.brandMuted,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class FeaturePitchCard extends StatelessWidget {
  const FeaturePitchCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1A40).withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primaryMuted,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Fast. Beautiful. Accurate.\nAll in one place.',
              style: GoogleFonts.fredoka(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.brandNavy,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
