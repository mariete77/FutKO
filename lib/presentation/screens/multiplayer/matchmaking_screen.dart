import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/multiplayer_provider.dart';

/// Matchmaking screen - search for opponents with a broadcast-style radar.
class MatchmakingScreen extends ConsumerStatefulWidget {
  final MultiplayerMode mode;

  const MatchmakingScreen({super.key, required this.mode});

  @override
  ConsumerState<MatchmakingScreen> createState() => _MatchmakingScreenState();
}

class _MatchmakingScreenState extends ConsumerState<MatchmakingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _spinController;
  late AnimationController _blipController;
  late AnimationController _scanLineController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _blipController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();

    // Start matchmaking after frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(multiplayerProvider.notifier).startMatchmaking(widget.mode);
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _spinController.dispose();
    _blipController.dispose();
    _scanLineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(multiplayerProvider);

    // Listen for state changes and navigate
    ref.listen<MultiplayerState>(multiplayerProvider, (prev, next) {
      if (next.status == MultiplayerStatus.found) {
        context.go('/multiplayer-vs');
      }
      if (next.status == MultiplayerStatus.playing) {
        context.go('/multiplayer-game');
      }
      if (next.status == MultiplayerStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? 'Error'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    return PopScope(
      canPop: state.status != MultiplayerStatus.playing,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          ref.read(multiplayerProvider.notifier).cancelSearch();
          context.go('/home');
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.2),
              radius: 1.2,
              colors: [
                Color(0xFF1a2820),
                Color(0xFF0c0f0f),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Back button
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      ref.read(multiplayerProvider.notifier).cancelSearch();
                      context.go('/home');
                    },
                    icon: Icon(Icons.close, color: AppColors.onSurface),
                  ),
                ),

                const Spacer(),

                // Main content based on state
                _buildContent(state),

                const Spacer(),

                // Mode label
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    _getModeLabel().toUpperCase(),
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.onSurfaceVariant,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(MultiplayerState state) {
    switch (state.status) {
      case MultiplayerStatus.searching:
        return _buildSearching();
      case MultiplayerStatus.found:
        return _buildOpponentFound(state);
      case MultiplayerStatus.error:
        return _buildError(state.errorMessage ?? 'Error desconocido');
      default:
        return _buildSearching();
    }
  }

  Widget _buildSearching() {
    return Column(
      children: [
        SizedBox(
          width: 260,
          height: 260,
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _spinController,
              _blipController,
              _scanLineController,
            ]),
            builder: (context, child) {
              return CustomPaint(
                painter: _BroadcastRadarPainter(
                  sweepAngle: _spinController.value * 2 * math.pi,
                  blipPhase: _blipController.value,
                  scanLinePhase: _scanLineController.value,
                  primaryColor: AppColors.primary,
                  accentColor: AppColors.secondary,
                  surfaceColor: AppColors.onSurface,
                ),
                size: const Size(260, 260),
              );
            },
          ),
        ),
        const SizedBox(height: 40),
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Opacity(
              opacity: 0.55 + (_pulseController.value * 0.45),
              child: Column(
                children: [
                  Text(
                    'BUSCANDO OPONENTE',
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.onSurface,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildBroadcastTicker(),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          _getStatusDetail(),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildBroadcastTicker() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.6),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'SEÑAL EN VIVO',
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.primary,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  String _getStatusDetail() {
    switch (widget.mode) {
      case MultiplayerMode.casual:
        return 'Emparejamiento casual activo';
      case MultiplayerMode.ranked:
        return 'Buscando rival de ranking similar';
      case MultiplayerMode.friendChallenge:
        return 'Esperando respuesta del desafío';
    }
  }

  Widget _buildOpponentFound(MultiplayerState state) {
    return Column(
      children: [
        const Icon(
          Icons.check_circle,
          color: AppColors.correct,
          size: 80,
        ),
        const SizedBox(height: 24),
        Text(
          '¡Oponente encontrado!',
          style: AppTextStyles.h2.copyWith(color: AppColors.onSurface),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                state.opponentName ?? 'Oponente',
                style: AppTextStyles.h3.copyWith(color: AppColors.onSurface),
                textAlign: TextAlign.center,
              ),
              if (state.opponentElo != null) ...[
                const SizedBox(height: 4),
                Text(
                  '${state.opponentElo} ELO',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Comenzando partida...',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildError(String message) {
    return Column(
      children: [
        const Icon(
          Icons.error_outline,
          color: AppColors.error,
          size: 80,
        ),
        const SizedBox(height: 24),
        Text(
          message,
          style: AppTextStyles.h3.copyWith(color: AppColors.onSurface),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            ref.read(multiplayerProvider.notifier).reset();
            context.go('/home');
          },
          child: const Text('Volver'),
        ),
      ],
    );
  }

  String _getModeLabel() {
    switch (widget.mode) {
      case MultiplayerMode.casual:
        return 'Partida Casual';
      case MultiplayerMode.ranked:
        return 'Partida Clasificatoria';
      case MultiplayerMode.friendChallenge:
        return 'Reto de Amigo';
    }
  }
}

/// Broadcast-style radar painter with rotating sweep, range rings and
/// animated opponent blips.
class _BroadcastRadarPainter extends CustomPainter {
  final double sweepAngle;
  final double blipPhase;
  final double scanLinePhase;
  final Color primaryColor;
  final Color accentColor;
  final Color surfaceColor;

  _BroadcastRadarPainter({
    required this.sweepAngle,
    required this.blipPhase,
    required this.scanLinePhase,
    required this.primaryColor,
    required this.accentColor,
    required this.surfaceColor,
  });

  static const _ringCount = 4;
  static const _sweepLength = math.pi / 2.5;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    _drawOuterRim(canvas, center, radius);
    _drawRings(canvas, center, radius);
    _drawCrosshairs(canvas, center, radius);
    _drawSweep(canvas, center, radius);
    _drawScanLine(canvas, center, radius);
    _drawBlips(canvas, center, radius);
    _drawCenterHub(canvas, center);
    _drawHudMarks(canvas, center, radius);
  }

  void _drawOuterRim(Canvas canvas, Offset center, double radius) {
    final rimPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius - 1, rimPaint);

    final glowPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(center, radius - 1, glowPaint);
  }

  void _drawRings(Canvas canvas, Offset center, double radius) {
    final ringPaint = Paint()
      ..color = surfaceColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final activeRingPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 1; i <= _ringCount; i++) {
      final r = radius * (i / _ringCount);
      canvas.drawCircle(center, r, i == _ringCount ? activeRingPaint : ringPaint);
    }
  }

  void _drawCrosshairs(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = surfaceColor.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(center.dx - radius + 8, center.dy),
      Offset(center.dx + radius - 8, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - radius + 8),
      Offset(center.dx, center.dy + radius - 8),
      paint,
    );

    // Tick marks every 45 degrees
    for (int i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      final inner = radius * 0.92;
      final outer = radius * 0.98;
      canvas.drawLine(
        Offset(
          center.dx + math.cos(angle) * inner,
          center.dy + math.sin(angle) * inner,
        ),
        Offset(
          center.dx + math.cos(angle) * outer,
          center.dy + math.sin(angle) * outer,
        ),
        paint,
      );
    }
  }

  void _drawSweep(Canvas canvas, Offset center, double radius) {
    // Gradient sweep arc
    final rect = Rect.fromCircle(center: center, radius: radius - 4);
    final gradient = SweepGradient(
      center: Alignment.center,
      startAngle: 0,
      endAngle: _sweepLength,
      colors: [
        primaryColor.withValues(alpha: 0.0),
        primaryColor.withValues(alpha: 0.15),
        primaryColor.withValues(alpha: 0.45),
        accentColor.withValues(alpha: 0.75),
      ],
      stops: const [0.0, 0.5, 0.85, 1.0],
      transform: GradientRotation(sweepAngle - _sweepLength),
    );

    final sweepPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      rect,
      sweepAngle - _sweepLength,
      _sweepLength,
      true,
      sweepPaint,
    );

    // Leading edge line
    final edgePaint = Paint()
      ..color = accentColor.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawLine(
      center,
      Offset(
        center.dx + math.cos(sweepAngle) * (radius - 4),
        center.dy + math.sin(sweepAngle) * (radius - 4),
      ),
      edgePaint,
    );
  }

  void _drawScanLine(Canvas canvas, Offset center, double radius) {
    // A subtle secondary rotating line for extra broadcast energy
    final secondaryAngle = scanLinePhase * 2 * math.pi * -0.7;
    final paint = Paint()
      ..color = primaryColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawLine(
      center,
      Offset(
        center.dx + math.cos(secondaryAngle) * (radius - 4),
        center.dy + math.sin(secondaryAngle) * (radius - 4),
      ),
      paint,
    );
  }

  void _drawBlips(Canvas canvas, Offset center, double radius) {
    // Fixed blip positions, animated opacity/size
    final blips = [
      (angle: 0.45, distance: 0.62, delay: 0.0),
      (angle: 2.10, distance: 0.38, delay: 0.33),
      (angle: 3.80, distance: 0.75, delay: 0.66),
      (angle: 5.20, distance: 0.55, delay: 0.15),
    ];

    for (final blip in blips) {
      final localPhase = (blipPhase + blip.delay) % 1.0;
      // Only visible during part of the cycle, like a real radar contact
      if (localPhase > 0.7) continue;

      final opacity = 1.0 - (localPhase / 0.7);
      final size = 3 + localPhase * 5;
      final pos = Offset(
        center.dx + math.cos(blip.angle) * radius * blip.distance,
        center.dy + math.sin(blip.angle) * radius * blip.distance,
      );

      final blipPaint = Paint()
        ..color = accentColor.withValues(alpha: opacity)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawCircle(pos, size, blipPaint);

      // Target bracket
      final bracketPaint = Paint()
        ..color = accentColor.withValues(alpha: opacity * 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawCircle(pos, size + 4, bracketPaint);
    }
  }

  void _drawCenterHub(Canvas canvas, Offset center) {
    final hubPaint = Paint()
      ..color = surfaceColor.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 6, hubPaint);

    final ringPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, 10, ringPaint);

    final glowPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(center, 14, glowPaint);
  }

  void _drawHudMarks(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = surfaceColor.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Small corner brackets at the top-left and bottom-right
    const bracketLength = 12.0;
    const bracketOffset = 8.0;

    // Top left
    canvas.drawLine(
      Offset(center.dx - radius + bracketOffset, center.dy - radius + bracketOffset + bracketLength),
      Offset(center.dx - radius + bracketOffset, center.dy - radius + bracketOffset),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx - radius + bracketOffset, center.dy - radius + bracketOffset),
      Offset(center.dx - radius + bracketOffset + bracketLength, center.dy - radius + bracketOffset),
      paint,
    );

    // Top right
    canvas.drawLine(
      Offset(center.dx + radius - bracketOffset, center.dy - radius + bracketOffset + bracketLength),
      Offset(center.dx + radius - bracketOffset, center.dy - radius + bracketOffset),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + radius - bracketOffset, center.dy - radius + bracketOffset),
      Offset(center.dx + radius - bracketOffset - bracketLength, center.dy - radius + bracketOffset),
      paint,
    );

    // Bottom left
    canvas.drawLine(
      Offset(center.dx - radius + bracketOffset, center.dy + radius - bracketOffset - bracketLength),
      Offset(center.dx - radius + bracketOffset, center.dy + radius - bracketOffset),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx - radius + bracketOffset, center.dy + radius - bracketOffset),
      Offset(center.dx - radius + bracketOffset + bracketLength, center.dy + radius - bracketOffset),
      paint,
    );

    // Bottom right
    canvas.drawLine(
      Offset(center.dx + radius - bracketOffset, center.dy + radius - bracketOffset - bracketLength),
      Offset(center.dx + radius - bracketOffset, center.dy + radius - bracketOffset),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + radius - bracketOffset, center.dy + radius - bracketOffset),
      Offset(center.dx + radius - bracketOffset - bracketLength, center.dy + radius - bracketOffset),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _BroadcastRadarPainter oldDelegate) {
    return oldDelegate.sweepAngle != sweepAngle ||
        oldDelegate.blipPhase != blipPhase ||
        oldDelegate.scanLinePhase != scanLinePhase;
  }
}
