import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/active_players_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/elo_history_provider.dart';
import '../../providers/match_history_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/entities/match.dart';
import 'widgets/elo_sparkline.dart';
import 'widgets/subscription_modal.dart';
import '../../widgets/common/futko_page_transitions.dart';
import 'package:intl/intl.dart';

/// Home screen — "PantallaPrincipal" mockup.
/// Stadium atmosphere with top app bar, player stats, game modes, bottom nav.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final userState = ref.watch(userNotifierProvider);
    final dailyGames = ref.watch(dailyGamesStatusProvider);
    final eloHistory = ref.watch(eloHistoryProvider);
    final matchHistory = ref.watch(matchHistoryProvider);

    if (currentUser != null &&
        userState.valueOrNull == null &&
        !userState.isLoading &&
        !userState.hasError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(userNotifierProvider.notifier).getUserProfile(currentUser.userId);
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(presenceServiceProvider).startPresenceUpdates();
    });

    final displayUser = userState.valueOrNull ?? currentUser;

    if (displayUser == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.secondaryFixed),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Grass texture background
          Positioned.fill(
            child: CustomPaint(
              painter: _HomeGrassPainter(),
            ),
          ),

          // Main content
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // ── Top App Bar ─────────────────────
                _buildTopBar(context, ref, displayUser),

                // ── Scrollable Content ──────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Player Stats
                        _buildPlayerStats(context, displayUser, eloHistory),
                        const SizedBox(height: 24),

                        // Sections label
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 12),
                          child: Text(
                            'SECCIONES',
                            style: GoogleFonts.lexend(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurfaceVariant,
                              letterSpacing: 3,
                            ),
                          ),
                        ),

                        // Game Modes
                        _buildGameModes(context, ref, dailyGames),
                        const SizedBox(height: 20),

                        // Last Challenge
                        _buildLastChallenge(context, ref, matchHistory, displayUser.userId),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // ── Top App Bar ─────────────────────────────────────────
  Widget _buildTopBar(BuildContext context, WidgetRef ref, User user) {
    final activePlayersAsync = ref.watch(activePlayersProvider);
    final activeCount = activePlayersAsync.valueOrNull ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.emerald950.withOpacity(0.9),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              Icon(
                Icons.sports_soccer,
                size: 24,
                color: AppColors.yellow500,
              ),
              const SizedBox(width: 8),
              Text(
                'FutKO',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.yellow500,
                  fontStyle: FontStyle.italic,
                  shadows: [
                    Shadow(
                      color: AppColors.yellow500.withOpacity(0.4),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Right side
          Row(
            children: [
              if (activeCount > 0)
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.success,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.success.withOpacity(0.5),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$activeCount',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
              GestureDetector(
                onTap: () {
                  // TODO: Profile
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.yellow500,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundImage:
                        user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                    backgroundColor: AppColors.surfaceContainerHigh,
                    child: user.photoUrl == null
                        ? Text(
                            user.displayName.isNotEmpty
                                ? user.displayName[0].toUpperCase()
                                : '?',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Player Stats Section ────────────────────────────────
  Widget _buildPlayerStats(
      BuildContext context, User user, EloHistoryState eloHistory) {
    final winStreak = user.stats.currentWinStreak;
    final totalGames = user.stats.wins + user.stats.losses + user.stats.draws;
    final winRate = totalGames > 0
        ? ((user.stats.wins / totalGames) * 100).round()
        : 0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Decorative soccer ball
            Positioned(
              top: -30,
              right: -20,
              child: Opacity(
                opacity: 0.08,
                child: Transform.rotate(
                  angle: 0.2,
                  child: Icon(
                    Icons.sports_soccer,
                    size: 140,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Top row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.displayName,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryContainer,
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Text(
                              'Pro League'.toUpperCase(),
                              style: GoogleFonts.lexend(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSecondaryContainer,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'GLOBAL ELO',
                            style: GoogleFonts.lexend(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onPrimaryContainer.withOpacity(0.7),
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${user.elo}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: AppColors.yellow500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Stats grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatBox(
                          label: 'Win Streak',
                          value: '$winStreak',
                          icon: Icons.local_fire_department,
                          iconColor: AppColors.yellow500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatBox(
                          label: 'Win Rate',
                          value: '$winRate%',
                          icon: Icons.emoji_events,
                          iconColor: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
        ),
      ),
      child: Column(
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.lexend(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 6),
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Game Modes ──────────────────────────────────────────
  Widget _buildGameModes(
    BuildContext context,
    WidgetRef ref,
    DailyGamesStatus dailyGames,
  ) {
    return Column(
      children: [
        _buildModeCard(
          context,
          title: 'Partida Rápida',
          subtitle: 'Salta directo a la acción contra otros jugadores.',
          icon: Icons.bolt,
          iconBgColor: AppColors.yellow500,
          iconColor: AppColors.emerald950,
          cardColor: AppColors.emerald900,
          glowColor: AppColors.yellow500.withOpacity(0.1),
          onTap: dailyGames.canPlayCasual
              ? () => context.go('/game/easy')
              : null,
        ),
        const SizedBox(height: 12),
        _buildModeCard(
          context,
          title: 'Ranked',
          subtitle: 'Escala en la tabla y conviértete en leyenda.',
          icon: Icons.emoji_events,
          iconBgColor: AppColors.surfaceContainerHighest,
          iconColor: AppColors.yellow500,
          cardColor: AppColors.surfaceContainerHigh,
          borderColor: Colors.white.withOpacity(0.06),
          onTap: dailyGames.canPlayRanked
              ? () => context.go('/matchmaking/ranked')
              : null,
        ),
        const SizedBox(height: 12),
        _buildModeCard(
          context,
          title: 'Entrenamiento',
          subtitle: 'Perfecciona tus tiros y estrategias.',
          icon: Icons.fitness_center,
          iconBgColor: AppColors.surfaceContainerHighest,
          iconColor: AppColors.primary,
          cardColor: AppColors.surfaceContainerHigh,
          borderColor: Colors.white.withOpacity(0.06),
          onTap: () => context.go('/matchmaking/ghostRun'),
        ),
      ],
    );
  }

  Widget _buildModeCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required Color cardColor,
    Color? glowColor,
    Color? borderColor,
    VoidCallback? onTap,
  }) {
    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: borderColor != null
                ? Border.all(color: borderColor)
                : null,
            gradient: glowColor != null
                ? LinearGradient(
                    colors: [glowColor, Colors.transparent],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: glowColor != null
                        ? [
                            BoxShadow(
                              color: AppColors.yellow500.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    icon,
                    size: 28,
                    color: iconColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: glowColor != null
                              ? Colors.white
                              : AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.lexend(
                          fontSize: 13,
                          color: glowColor != null
                              ? Colors.white.withOpacity(0.6)
                              : AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: glowColor != null
                      ? Colors.white.withOpacity(0.3)
                      : AppColors.onSurfaceVariant.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Last Challenge ──────────────────────────────────────
  Widget _buildLastChallenge(
    BuildContext context,
    WidgetRef ref,
    MatchHistoryState matchHistory,
    String currentUserId,
  ) {
    final matches = matchHistory.matches;

    if (matches.isEmpty) {
      return const SizedBox.shrink();
    }

    final lastMatch = matches.first;
    final result = lastMatch.result;
    final isWin = result?.winnerId == currentUserId;
    final myScore = result?.scores[currentUserId] ?? 0;
    final opponentId = lastMatch.getOpponentId(currentUserId);
    final opponentScore = result?.scores[opponentId] ?? 0;
    final dateStr = lastMatch.finishedAt != null
        ? _formatRelativeDate(lastMatch.finishedAt!)
        : '';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Último Desafío'.toUpperCase(),
                  style: GoogleFonts.lexend(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    letterSpacing: 2,
                  ),
                ),
                if (dateStr.isNotEmpty)
                  Text(
                    dateStr,
                    style: GoogleFonts.lexend(
                      fontSize: 11,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$myScore - $opponentScore',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isWin ? AppColors.success : AppColors.error,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${isWin ? 'Victoria' : 'Derrota'} vs ${lastMatch.opponentName ?? 'Oponente'}',
                            style: GoogleFonts.lexend(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurfaceVariant,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.emerald950,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: Icon(
                    Icons.celebration,
                    color: AppColors.yellow500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'ahora';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'ayer';
    return DateFormat('dd MMM', 'es_ES').format(date);
  }

  // ── Bottom Navigation Bar ───────────────────────────────
  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.emerald950,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.08),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.sports_soccer,
                label: 'Play',
                isActive: true,
                onTap: () {},
              ),
              _buildNavItem(
                icon: Icons.emoji_events,
                label: 'Rankings',
                onTap: () => context.go('/leaderboard'),
              ),
              _buildNavItem(
                icon: Icons.fitness_center,
                label: 'Rules',
                onTap: () {},
              ),
              _buildNavItem(
                icon: Icons.person,
                label: 'Profile',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: isActive
            ? BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.yellow500.withOpacity(0.1),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ],
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? AppColors.yellow500 : AppColors.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isActive ? AppColors.yellow500 : AppColors.onSurfaceVariant.withOpacity(0.5),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Home Grass Painter ────────────────────────────────────
class _HomeGrassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.02);
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
