import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/active_players_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/background_video.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/game_constants.dart';
import '../../../core/utils/league_system.dart';
import '../../../domain/entities/user.dart';
import 'widgets/subscription_modal.dart';

/// Home screen — "PantallaPrincipal" mockup.
/// Stadium atmosphere with top app bar, compact player card, game-mode cards
/// and bottom nav.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _statsController;
  late final Animation<double> _lpAnimation;
  late final Animation<double> _statsFade;

  @override
  void initState() {
    super.initState();
    _statsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _lpAnimation = CurvedAnimation(
      parent: _statsController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
    );
    _statsFade = CurvedAnimation(
      parent: _statsController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    );
    _statsController.forward();
  }

  @override
  void dispose() {
    _statsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final userState = ref.watch(userNotifierProvider);
    final dailyGames = ref.watch(dailyGamesStatusProvider);

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
          // Background stadium video
          const BackgroundVideo(
            asset: 'assets/Fondo_loop_stadium.mp4',
            overlayOpacity: 0.6,
          ),

          // Main content
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // ── Top App Bar ─────────────────────
                _buildTopBar(context),

                // ── Scrollable Content ──────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Compact player card
                        _buildPlayerCard(context, displayUser),
                        const SizedBox(height: 20),

                        // Stats panel
                        _buildStatsPanel(displayUser),
                        const SizedBox(height: 28),

                        // Game-mode cards
                        _buildGameModeCards(context, displayUser, dailyGames),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(context, displayUser),
    );
  }

  // ── Top App Bar ─────────────────────────────────────────
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Center(
        child: Image.asset(
          'assets/images/futko_wordmark.png',
          height: 44,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  // ── Player Card with League Progress ────────────────────
  Widget _buildPlayerCard(BuildContext context, User user) {
    final leagueColor = Color(LeagueSystem.colorForTier(user.leagueTier));
    final leagueName = user.rank;
    final lpProgress = user.leaguePoints / GameConstants.lpToPromote;
    final lpRemaining = GameConstants.lpToPromote - user.leaguePoints;
    final displayName = user.displayName.isNotEmpty ? user.displayName : 'Jugador';
    final initials = displayName.split(' ').take(2).map((s) => s.isNotEmpty ? s[0].toUpperCase() : '').join();

    return AnimatedBuilder(
      animation: _lpAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _lpAnimation,
          child: Transform.translate(
            offset: Offset(0, -16 * (1 - _lpAnimation.value)),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              leagueColor.withOpacity(0.28),
              AppColors.primaryContainer.withOpacity(0.35),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: leagueColor.withOpacity(0.35)),
          boxShadow: [
            BoxShadow(
              color: leagueColor.withOpacity(0.15),
              blurRadius: 24,
              spreadRadius: -4,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.22),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: leagueColor, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: leagueColor.withOpacity(0.25),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 26,
                  backgroundImage:
                      user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                  backgroundColor: AppColors.surfaceContainerHigh,
                  child: user.photoUrl == null
                      ? Text(
                          initials.isNotEmpty ? initials : '?',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.onSurface,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: leagueColor.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: leagueColor.withOpacity(0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shield, size: 14, color: leagueColor),
                          const SizedBox(width: 6),
                          Text(
                            leagueName,
                            style: GoogleFonts.lexend(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: leagueColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // League tier number
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: leagueColor.withOpacity(0.18),
                  border: Border.all(color: leagueColor.withOpacity(0.5)),
                ),
                child: Center(
                  child: Text(
                    '${user.leagueTier}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: leagueColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PROGRESO DE LIGA',
                style: GoogleFonts.lexend(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                '${user.leaguePoints} / ${GameConstants.lpToPromote} LP',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Container(
                  height: 12,
                  color: Colors.white.withOpacity(0.08),
                ),
                AnimatedBuilder(
                  animation: _lpAnimation,
                  builder: (context, child) {
                    return FractionallySizedBox(
                      widthFactor: (lpProgress * _lpAnimation.value)
                          .clamp(0.0, 1.0),
                      child: Container(
                        height: 12,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              leagueColor,
                              leagueColor.withOpacity(0.75),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            user.leaguePoints >= GameConstants.lpToPromote - 1
                ? '¡Una victoria más y asciendes!'
                : '$lpRemaining LP para el ascenso',
            style: GoogleFonts.workSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    ),
  );
}

  // ── Stats Panel ─────────────────────────────────────────
  Widget _buildStatsPanel(User user) {
    final stats = user.stats;
    final totalQuestions = stats.totalGames * GameConstants.questionsPerMatch;
    final accuracy = totalQuestions > 0
        ? (stats.totalCorrectAnswers / totalQuestions) * 100
        : 0.0;
    final totalMultiplayer = stats.wins + stats.losses + stats.draws;

    return AnimatedBuilder(
      animation: _statsFade,
      builder: (context, child) {
        return FadeTransition(
          opacity: _statsFade,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _statsFade.value)),
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TU RENDIMIENTO',
            style: GoogleFonts.lexend(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.55,
            children: [
              _buildStatCard(
                icon: Icons.sports_soccer,
                label: 'Partidas jugadas',
                value: '${stats.totalGames}',
                sublabel: 'modo casual + ranked',
                color: AppColors.primary,
              ),
              _buildStatCard(
                icon: Icons.percent,
                label: 'Precisión global',
                value: '${accuracy.toStringAsFixed(0)}%',
                sublabel: '${stats.totalCorrectAnswers} aciertos',
                color: AppColors.secondaryFixed,
              ),
              _buildStatCard(
                icon: Icons.emoji_events,
                label: 'Victorias',
                value: '${stats.wins}',
                sublabel: totalMultiplayer > 0
                    ? '${(stats.wins / totalMultiplayer * 100).toStringAsFixed(0)}% ranked'
                    : 'en ranked',
                color: AppColors.yellow500,
              ),
              _buildStatCard(
                icon: Icons.local_fire_department,
                label: 'Mejor racha',
                value: '${stats.bestWinStreak}',
                sublabel: 'victorias seguidas',
                color: AppColors.tertiary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildMultiplayerRecord(stats),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required String sublabel,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 20, color: color),
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.workSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                sublabel,
                style: GoogleFonts.workSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMultiplayerRecord(UserStats stats) {
    final total = stats.wins + stats.losses + stats.draws;
    if (total == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BALANCE MULTIJUGADOR',
            style: GoogleFonts.lexend(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                _buildRecordBarSegment(
                  flex: stats.wins,
                  total: total,
                  color: AppColors.success,
                ),
                _buildRecordBarSegment(
                  flex: stats.draws,
                  total: total,
                  color: AppColors.onSurfaceVariant,
                ),
                _buildRecordBarSegment(
                  flex: stats.losses,
                  total: total,
                  color: AppColors.error,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildRecordLegend('Victorias', stats.wins, AppColors.success),
              _buildRecordLegend('Empates', stats.draws, AppColors.onSurfaceVariant),
              _buildRecordLegend('Derrotas', stats.losses, AppColors.error),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecordBarSegment({
    required int flex,
    required int total,
    required Color color,
  }) {
    if (total == 0 || flex <= 0) return const SizedBox.shrink();
    return Flexible(
      flex: flex,
      child: Container(
        height: 10,
        color: color,
      ),
    );
  }

  Widget _buildRecordLegend(String label, int value, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$label ',
          style: GoogleFonts.workSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        Text(
          '$value',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // ── Game-mode Cards ─────────────────────────────────────
  Widget _buildGameModeCards(
    BuildContext context,
    User user,
    DailyGamesStatus dailyGames,
  ) {
    final dailyAvailable = user.lastDailyDate != _todayKey();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildGameCard(
          context,
          icon: Icons.emoji_events,
          title: 'Clasificatorio',
          subtitle: dailyGames.canPlayRanked
              ? '${dailyGames.rankedRemaining} ${dailyGames.rankedRemaining == 1 ? 'partida' : 'partidas'} disponible${dailyGames.rankedRemaining == 1 ? '' : 's'}'
              : 'Límite diario alcanzado',
          accentColor: AppColors.yellow500,
          enabled: dailyGames.canPlayRanked,
          onTap: dailyGames.canPlayRanked
              ? () => context.go('/matchmaking/ranked')
              : null,
        ),
        const SizedBox(height: 14),
        _buildGameCard(
          context,
          icon: Icons.sports_soccer,
          title: 'Partido Casual',
          subtitle: dailyGames.canPlayCasual
              ? (dailyGames.casualRemaining >= 999
                  ? 'Partidas ilimitadas'
                  : '${dailyGames.casualRemaining} ${dailyGames.casualRemaining == 1 ? 'partida' : 'partidas'} disponible${dailyGames.casualRemaining == 1 ? '' : 's'}')
              : 'Límite diario alcanzado',
          accentColor: AppColors.primary,
          enabled: dailyGames.canPlayCasual,
          onTap: dailyGames.canPlayCasual
              ? () => context.go('/game/easy')
              : null,
        ),
        const SizedBox(height: 14),
        _buildGameCard(
          context,
          icon: Icons.event_available,
          title: 'Pregunta del Día',
          subtitle: dailyAvailable ? '¡Disponible ahora!' : 'Vuelve mañana',
          accentColor: dailyAvailable ? AppColors.primary : AppColors.error,
          enabled: true,
          onTap: () => context.push('/daily-question'),
        ),
      ],
    );
  }

  Widget _buildGameCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color accentColor,
    bool enabled = true,
    VoidCallback? onTap,
  }) {
    return Material(
      color: AppColors.surfaceContainerHigh.withOpacity(0.9),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: enabled
                  ? accentColor.withOpacity(0.35)
                  : Colors.white.withOpacity(0.08),
            ),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                accentColor.withOpacity(enabled ? 0.16 : 0.04),
                AppColors.surfaceContainerHigh.withOpacity(0.3),
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(enabled ? 0.2 : 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: accentColor.withOpacity(enabled ? 0.4 : 0.15),
                  ),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: enabled
                      ? accentColor
                      : AppColors.onSurfaceVariant.withOpacity(0.4),
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
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: enabled
                            ? Colors.white
                            : AppColors.onSurfaceVariant.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.lexend(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: enabled
                            ? accentColor
                            : AppColors.onSurfaceVariant.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: enabled
                    ? accentColor.withOpacity(0.6)
                    : AppColors.onSurfaceVariant.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  // ── Bottom Navigation Bar ───────────────────────────────
  Widget _buildBottomNavBar(BuildContext context, User user) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.emerald950,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.08)),
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
                icon: Icons.home,
                label: 'Inicio',
                isActive: true,
              ),
              _buildNavItem(
                icon: Icons.emoji_events,
                label: 'Ligas',
                onTap: () => context.go('/leaderboard'),
              ),
              _buildNavItem(
                icon: Icons.person,
                label: 'Perfil',
                onTap: () => context.push('/profile/${user.userId}'),
              ),
              _buildNavItem(
                icon: Icons.shopping_bag,
                label: 'Tienda',
                onTap: () => SubscriptionModal.show(context),
              ),
              _buildNavItem(
                icon: Icons.settings,
                label: 'Ajustes',
                onTap: () => context.push('/settings'),
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
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              color: isActive
                  ? AppColors.yellow500
                  : AppColors.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isActive
                    ? AppColors.yellow500
                    : AppColors.onSurfaceVariant.withOpacity(0.5),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
