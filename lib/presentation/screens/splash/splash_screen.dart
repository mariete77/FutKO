import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';

/// Splash screen — "PantallaCarga" design.
/// Stadium atmosphere with grass texture, goal post silhouette, and pitch progress bar.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _checkAuthAndNavigate();
  }

  void _initAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    final authState = ref.read(authStateChangesProvider);
    authState.when(
      data: (user) {
        if (user != null) {
          context.go('/home');
        } else {
          context.go('/login');
        }
      },
      loading: () {},
      error: (_, __) {
        context.go('/login');
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Stadium glow radial ─────────────────────────
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.2),
                  radius: 0.8,
                  colors: [
                    const Color(0x2610b981),
                    AppColors.background,
                  ],
                ),
              ),
            ),
          ),

          // ── Grass texture ───────────────────────────────
          Positioned.fill(
            child: _GrassTexture(),
          ),

          // ── Goal post silhouette (bottom) ───────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.35,
            child: Opacity(
              opacity: 0.08,
              child: CustomPaint(
                painter: _GoalPostPainter(),
                size: Size.infinite,
              ),
            ),
          ),

          // ── Decorative glows ────────────────────────────
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            right: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.yellow500.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.25,
            left: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.emerald500.withOpacity(0.06),
              ),
            ),
          ),

          // ── Central content ─────────────────────────────
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 3),

                        // Logo ball
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.emerald950,
                            border: Border.all(
                              color: AppColors.yellow500.withOpacity(0.5),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.yellow500.withOpacity(0.3),
                                blurRadius: 40,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.sports_soccer,
                            size: 56,
                            color: AppColors.yellow500,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Brand Typography
                        Text(
                          'FutKO',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 56,
                            fontWeight: FontWeight.w900,
                            color: AppColors.yellow500,
                            letterSpacing: -2,
                            fontStyle: FontStyle.italic,
                            shadows: [
                              Shadow(
                                color: AppColors.yellow500.withOpacity(0.4),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Loading text
                        Text(
                          'CALENTANDO MOTORES...',
                          style: GoogleFonts.lexend(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                            letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Pitch progress bar
                        _PitchProgressBar(),

                        const Spacer(flex: 2),

                        // Footer stats
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Row(
                            children: [
                              Expanded(
                                child: _StatCard(
                                  value: '10K+',
                                  label: 'Goles',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _StatCard(
                                  value: '50+',
                                  label: 'Ligas',
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Grass Texture ─────────────────────────────────────────
class _GrassTexture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GrassPainter(),
      size: Size.infinite,
    );
  }
}

class _GrassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1;

    // Horizontal pitch lines
    for (double y = 0; y < size.height; y += 80) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Dot pattern
    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.025);
    const spacing = 24.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Goal Post Painter ─────────────────────────────────────
class _GoalPostPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final goalWidth = size.width * 0.6;
    final goalHeight = size.height * 0.7;
    final left = (size.width - goalWidth) / 2;
    final top = size.height - goalHeight;

    // Posts
    canvas.drawLine(
      Offset(left, top),
      Offset(left, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(left + goalWidth, top),
      Offset(left + goalWidth, size.height),
      paint,
    );
    // Crossbar
    canvas.drawLine(
      Offset(left, top),
      Offset(left + goalWidth, top),
      paint,
    );

    // Net pattern
    final netPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 0.5;
    const netSpacing = 16.0;
    for (double x = left; x <= left + goalWidth; x += netSpacing) {
      canvas.drawLine(
        Offset(x, top),
        Offset(x, size.height),
        netPaint,
      );
    }
    for (double y = top; y <= size.height; y += netSpacing) {
      canvas.drawLine(
        Offset(left, y),
        Offset(left + goalWidth, y),
        netPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Pitch Progress Bar ────────────────────────────────────
class _PitchProgressBar extends StatefulWidget {
  @override
  State<_PitchProgressBar> createState() => _PitchProgressBarState();
}

class _PitchProgressBarState extends State<_PitchProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..forward();
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
        final progress = _controller.value;
        return Container(
          width: 280,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: Stack(
              children: [
                // Grass fill
                FractionallySizedBox(
                  widthFactor: progress * 0.75,
                  heightFactor: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF065f46), Color(0xFF10b981)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.emerald500.withOpacity(0.5),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
                // Soccer ball scrubber
                Positioned(
                  left: (progress * 0.75 * 280) - 12,
                  top: -4,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey.shade400,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.sports_soccer,
                      size: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
                // Center line decoration
                Center(
                  child: Container(
                    width: 1,
                    height: double.infinity,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                Center(
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Stat Card ─────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.lexend(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}
