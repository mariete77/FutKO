import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Confetti particle for celebration effects
class ConfettiParticle {
  final Color color;
  double x;
  double y;
  double vx;
  double vy;
  double rotation;
  double rotationSpeed;
  final double size;
  final double gravity;
  final double drag;

  ConfettiParticle({
    required this.color,
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.rotation,
    required this.rotationSpeed,
    required this.size,
    this.gravity = 0.3,
    this.drag = 0.98,
  });

  void update() {
    x += vx;
    y += vy;
    vy += gravity;
    vx *= drag;
    vy *= drag;
    rotation += rotationSpeed;
  }

  bool get isOffScreen => y > 1000;
}

/// Confetti widget that shows celebration particles
class ConfettiCelebration extends StatefulWidget {
  final bool isActive;
  final int particleCount;
  final VoidCallback? onComplete;

  const ConfettiCelebration({
    super.key,
    this.isActive = false,
    this.particleCount = 50,
    this.onComplete,
  });

  @override
  State<ConfettiCelebration> createState() => _ConfettiCelebrationState();
}

class _ConfettiCelebrationState extends State<ConfettiCelebration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<ConfettiParticle> _particles = [];
  final _random = math.Random();

  final List<Color> _colors = [
    const Color(0xFF10b981), // Emerald
    const Color(0xFFeab308), // Yellow
    const Color(0xFFf97316), // Orange
    const Color(0xFF3b82f6), // Blue
    const Color(0xFFec4899), // Pink
    const Color(0xFF8b5cf6), // Purple
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _controller.addListener(_updateParticles);
  }

  @override
  void didUpdateWidget(ConfettiCelebration oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _startCelebration();
    }
  }

  void _startCelebration() {
    _particles.clear();
    final size = MediaQuery.of(context).size;

    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(ConfettiParticle(
        color: _colors[_random.nextInt(_colors.length)],
        x: size.width / 2 + (_random.nextDouble() - 0.5) * 200,
        y: size.height / 2,
        vx: (_random.nextDouble() - 0.5) * 20,
        vy: -10 - _random.nextDouble() * 15,
        rotation: _random.nextDouble() * math.pi * 2,
        rotationSpeed: (_random.nextDouble() - 0.5) * 0.3,
        size: 8 + _random.nextDouble() * 12,
      ));
    }

    _controller.forward(from: 0);
  }

  void _updateParticles() {
    if (!mounted) return;

    setState(() {
      for (final particle in _particles) {
        particle.update();
      }
      _particles.removeWhere((p) => p.isOffScreen);
    });

    if (_particles.isEmpty && _controller.isAnimating) {
      _controller.stop();
      widget.onComplete?.call();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_particles.isEmpty) return const SizedBox.shrink();

    return IgnorePointer(
      child: CustomPaint(
        size: Size.infinite,
        painter: _ConfettiPainter(_particles),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;

  _ConfettiPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(particle.x, particle.y);
      canvas.rotate(particle.rotation);

      // Draw confetti as a small rectangle
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: particle.size,
          height: particle.size * 0.6,
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Streak celebration widget with fire particles
class StreakCelebration extends StatelessWidget {
  final int streak;

  const StreakCelebration({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFf97316), Color(0xFFef4444)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFf97316).withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$streak',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
