import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/audio_service.dart';
import '../../providers/multiplayer_provider.dart';
import '../../providers/user_provider.dart';

class MultiplayerVsScreen extends ConsumerStatefulWidget {
  const MultiplayerVsScreen({super.key});

  @override
  ConsumerState<MultiplayerVsScreen> createState() => _MultiplayerVsScreenState();
}

class _MultiplayerVsScreenState extends ConsumerState<MultiplayerVsScreen>
    with TickerProviderStateMixin {
  late AnimationController _vsController;
  late AnimationController _slideLeft;
  late AnimationController _slideRight;
  late AnimationController _pulseController;
  Timer? _autoStartTimer;

  @override
  void initState() {
    super.initState();
    _vsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideLeft = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideRight = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _vsController.forward();
    _slideLeft.forward();
    _slideRight.forward();

    AudioService().playVs();

    _autoStartTimer = Timer(const Duration(seconds: 5), _startGame);
  }

  @override
  void dispose() {
    _vsController.dispose();
    _slideLeft.dispose();
    _slideRight.dispose();
    _pulseController.dispose();
    _autoStartTimer?.cancel();
    super.dispose();
  }

  void _startGame() {
    _autoStartTimer?.cancel();
    ref.read(multiplayerProvider.notifier).startPlaying();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(multiplayerProvider);
    final userAsync = ref.watch(userNotifierProvider);
    final currentUser = userAsync.valueOrNull;

    ref.listen<MultiplayerState>(multiplayerProvider, (prev, next) {
      if (next.status == MultiplayerStatus.playing) {
        context.go('/multiplayer-game');
      }
      if (next.status == MultiplayerStatus.error) {
        context.go('/matchmaking/${state.mode.name}');
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
                Color(0xFF022c22),
                Color(0xFF065f46),
                Color(0xFF0f2e1b),
              ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Pitch texture overlay
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.03,
                    child: CustomPaint(
                      painter: _PitchTexturePainter(),
                    ),
                  ),
                ),
                Column(
                  children: [
                    // Top bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              _autoStartTimer?.cancel();
                              ref.read(multiplayerProvider.notifier).cancelSearch();
                              context.go('/home');
                            },
                            icon: const Icon(Icons.close, color: AppColors.onSurface),
                          ),
                          const Spacer(),
                          _buildModeBadge(state.mode),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Player cards + VS
                    SizedBox(
                      height: 340,
                      child: Row(
                        children: [
                          // Current player
                          Expanded(
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(-1, 0),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                parent: _slideLeft,
                                curve: Curves.easeOutCubic,
                              )),
                              child: _buildPlayerCard(
                                name: currentUser?.displayName ?? 'Tú',
                                elo: currentUser?.elo ?? 1000,
                                streak: currentUser?.stats.currentWinStreak ?? 0,
                                photoUrl: currentUser?.photoUrl,
                                isPlayer: true,
                              ),
                            ),
                          ),
                          // VS
                          SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, -1),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: _vsController,
                              curve: Curves.elasticOut,
                            )),
                            child: _buildVsBadge(),
                          ),
                          // Opponent
                          Expanded(
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1, 0),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                parent: _slideRight,
                                curve: Curves.easeOutCubic,
                              )),
                              child: _buildPlayerCard(
                                name: state.opponentName ?? 'Oponente',
                                elo: state.opponentElo ?? 1000,
                                streak: null,
                                isPlayer: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Action button
                    _buildStartButton(),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeBadge(MultiplayerMode mode) {
    final label = switch (mode) {
      MultiplayerMode.casual => 'PARTIDA CASUAL',
      MultiplayerMode.ranked => 'PARTIDA CLASIFICATORIA',
      MultiplayerMode.friendChallenge => 'RETO DE AMIGO',
    };
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurfaceVariant,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildPlayerCard({
    required String name,
    required int elo,
    int? streak,
    String? photoUrl,
    required bool isPlayer,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isPlayer ? 20 : 8, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.outlineVariant.withOpacity(0.15),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isPlayer
                      ? AppColors.primary.withOpacity(0.5)
                      : AppColors.secondary.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isPlayer
                            ? AppColors.primary
                            : AppColors.secondary)
                        .withOpacity(0.15),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: AppColors.surfaceContainerHighest,
                backgroundImage: photoUrl != null
                    ? CachedNetworkImageProvider(photoUrl)
                    : null,
                child: photoUrl == null
                    ? Icon(
                        Icons.person,
                        size: 40,
                        color: AppColors.onSurfaceVariant.withOpacity(0.5),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 12),
            // Name
            Text(
              name,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            // ELO
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: isPlayer
                    ? AppColors.primary.withOpacity(0.12)
                    : AppColors.secondary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.auto_graph,
                    size: 14,
                    color: isPlayer
                        ? AppColors.primary
                        : AppColors.secondaryFixedDim,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$elo ELO',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isPlayer
                          ? AppColors.primary
                          : AppColors.secondaryFixedDim,
                    ),
                  ),
                ],
              ),
            ),
            if (streak != null && streak > 0) ...[
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_fire_department,
                    size: 14,
                    color: AppColors.secondaryFixed,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '$streak racha',
                    style: GoogleFonts.workSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondaryFixed,
                    ),
                  ),
                ],
              ),
            ],
            // Label
            const SizedBox(height: 12),
            Text(
              isPlayer ? 'TÚ' : 'RIVAL',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.onSurfaceVariant.withOpacity(0.5),
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVsBadge() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final glow = 0.6 + (_pulseController.value * 0.4);
        return Container(
          width: 72,
          height: 72,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [
                AppColors.secondaryFixedDim,
                AppColors.onSecondaryContainer,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.stadiumGlowGold.withOpacity(glow),
                blurRadius: 20,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Center(
            child: Text(
              'VS',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.onSecondary,
                letterSpacing: -1,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStartButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _startGame,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 200,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.secondaryFixedDim.withOpacity(0.8 + (_pulseController.value * 0.2)),
                      AppColors.onSecondaryContainer.withOpacity(0.8 + (_pulseController.value * 0.2)),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.stadiumGlowGold.withOpacity(0.3 + (_pulseController.value * 0.2)),
                      blurRadius: 24,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'JUGAR',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSecondary,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.onSecondary,
                      size: 24,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'La partida comenzará automáticamente',
          style: GoogleFonts.workSans(
            fontSize: 12,
            color: AppColors.onSurfaceVariant.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _PitchTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    const spacing = 24.0;
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
