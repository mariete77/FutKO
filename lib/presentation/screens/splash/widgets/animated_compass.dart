import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Animated football icon widget for the splash screen.
/// A spinning football with pulsing glow effect.
class AnimatedCompass extends StatefulWidget {
  const AnimatedCompass({super.key});

  @override
  State<AnimatedCompass> createState() => _AnimatedCompassState();
}

class _AnimatedCompassState extends State<AnimatedCompass>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * pi,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.primary.withOpacity(0.05),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
            child: CustomPaint(
              painter: _FootballPainter(
                progress: _controller.value,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Paints a classic football (soccer ball) pattern.
class _FootballPainter extends CustomPainter {
  final double progress;

  _FootballPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    // Main circle (ball outline)
    final ballPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(center, radius, ballPaint);

    // Fill
    final fillPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.08)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, fillPaint);

    // Pentagon pattern (center)
    final pentagonPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw center pentagon
    final pentagonPoints = <Offset>[];
    for (int i = 0; i < 5; i++) {
      final angle = (i * 72 - 90) * pi / 180;
      pentagonPoints.add(Offset(
        center.dx + radius * 0.38 * cos(angle),
        center.dy + radius * 0.38 * sin(angle),
      ));
    }

    final pentagonPath = Path()..addPolygon(pentagonPoints, true);
    canvas.drawPath(pentagonPath, pentagonPaint);

    // Fill pentagon
    final pentagonFill = Paint()
      ..color = AppColors.primary.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    canvas.drawPath(pentagonPath, pentagonFill);

    // Lines from pentagon vertices to circle edge
    final linePaint = Paint()
      ..color = AppColors.primary.withOpacity(0.5)
      ..strokeWidth = 1.5;

    for (int i = 0; i < 5; i++) {
      final innerAngle = (i * 72 - 90) * pi / 180;
      final outerAngle = (i * 72 - 90) * pi / 180;
      canvas.drawLine(
        Offset(
          center.dx + radius * 0.38 * cos(innerAngle),
          center.dy + radius * 0.38 * sin(innerAngle),
        ),
        Offset(
          center.dx + radius * 0.85 * cos(outerAngle),
          center.dy + radius * 0.85 * sin(outerAngle),
        ),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FootballPainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
