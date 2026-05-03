import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/multiplayer_provider.dart';

/// Matchmaking screen – search for football rivals
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

    // Start matchmaking after frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(multiplayerProvider.notifier).startMatchmaking(widget.mode);
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(multiplayerProvider);

    // Listen for state changes and navigate
    ref.listen<MultiplayerState>(multiplayerProvider, (prev, next) {
      if (next.status == MultiplayerStatus.found) {
        // Show rival found animation briefly, then game starts
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
      // Show message when falling back to ghost run
      if (next.mode == MultiplayerMode.ghostRun &&
          prev?.mode != MultiplayerMode.ghostRun &&
          next.status == MultiplayerStatus.found) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No se encontraron rivales. ¡Tú contra el estadio! Modo Ghost Run activado.',
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 3),
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
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryDark,
                AppColors.primary,
                AppColors.primaryDark,
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
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ),

                const Spacer(),

                // Main content based on state
                _buildContent(state),

                const Spacer(),

                // Mode label
                Text(
                  _getModeLabel(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white70,
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
        return _buildRivalFound(state);
      case MultiplayerStatus.error:
        return _buildError(state.errorMessage ?? 'Error desconocido');
      default:
        return _buildSearching();
    }
  }

  Widget _buildSearching() {
    return Column(
      children: [
        // Spinning football animation
        AnimatedBuilder(
          animation: _spinController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _spinController.value * 6.28, // Full rotation
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.secondary.withOpacity(0.4),
                    width: 2,
                  ),
                ),
                child: CustomPaint(
                  painter: _RadarPainter(_spinController.value),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 40),
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Opacity(
              opacity: 0.5 + (_pulseController.value * 0.5),
              child: Text(
                'Buscando rival...',
                style: AppTextStyles.h2.copyWith(color: Colors.white),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          'Preparando la cancha...',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildRivalFound(MultiplayerState state) {
    return Column(
      children: [
        const Icon(
          Icons.sports_soccer,
          color: AppColors.secondary,
          size: 80,
        ),
        const SizedBox(height: 24),
        Text(
          '¡Rival encontrado!',
          style: AppTextStyles.h2.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          '⚽ ¡Que suene el silbato! ⚽',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.secondary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                state.opponentName ?? 'Rival',
                style: AppTextStyles.h3.copyWith(color: Colors.white),
              ),
              if (state.opponentElo != null) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.emoji_events,
                      color: AppColors.secondary,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${state.opponentElo} ELO',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          '¡Comienza el partido!',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildError(String message) {
    return Column(
      children: [
        const Icon(
          Icons.sports_soccer,
          color: AppColors.error,
          size: 80,
        ),
        const SizedBox(height: 24),
        Text(
          '¡Fuera de juego!',
          style: AppTextStyles.h3.copyWith(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          message,
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            ref.read(multiplayerProvider.notifier).reset();
            context.go('/home');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: AppColors.onSecondary,
          ),
          child: const Text('Volver al vestuario'),
        ),
      ],
    );
  }

  String _getModeLabel() {
    switch (widget.mode) {
      case MultiplayerMode.casual:
        return '⚽ Partido Amistoso';
      case MultiplayerMode.ranked:
        return '🏆 Partido Competitivo';
      case MultiplayerMode.ghostRun:
        return '👻 Ghost Run';
      case MultiplayerMode.friendChallenge:
        return '🤝 Reto de Amigo';
    }
  }
}

/// Custom painter for radar animation – styled as a football pitch circle
class _RadarPainter extends CustomPainter {
  final double progress;

  _RadarPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw sweep – gold accent sweep
    final sweepPaint = Paint()
      ..color = AppColors.secondary.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708 + (progress * 6.28), // Start from top
      0.5, // Sweep angle
      true,
      sweepPaint,
    );

    // Draw inner circles – pitch line style
    final circlePaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(center, radius * 0.33, circlePaint);
    canvas.drawCircle(center, radius * 0.66, circlePaint);

    // Draw center dot
    final dotPaint = Paint()
      ..color = AppColors.secondary.withOpacity(0.6)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 4, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
