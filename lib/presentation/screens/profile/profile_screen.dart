import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../../providers/friend_user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/user.dart';

/// Pantalla de perfil de un jugador (propio o de un amigo).
///
/// Si [userId] es `me` o está vacío, muestra el perfil del usuario actual.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final resolvedId =
        (userId.isEmpty || userId == 'me') ? currentUser?.userId : userId;
    final isOwnProfile =
        resolvedId != null && resolvedId == currentUser?.userId;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.emerald950,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/home'),
        ),
        title: Text(
          'Perfil',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        actions: [
          if (isOwnProfile)
            IconButton(
              icon: const Icon(Icons.settings_outlined,
                  color: AppColors.onSurfaceVariant),
              onPressed: () => context.push('/settings'),
            ),
        ],
      ),
      body: resolvedId == null
          ? _message('No hay sesión activa')
          : ref.watch(friendUserProvider(resolvedId)).when(
                loading: () => const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.secondaryFixed),
                ),
                error: (_, __) => _message('No se pudo cargar el perfil'),
                data: (user) => user == null
                    ? _message('Jugador no encontrado')
                    : _buildProfile(context, user),
              ),
    );
  }

  Widget _message(String text) => Center(
        child: Text(
          text,
          style: GoogleFonts.lexend(color: AppColors.onSurfaceVariant),
        ),
      );

  Widget _buildProfile(BuildContext context, User user) {
    final totalGames = user.stats.wins + user.stats.losses + user.stats.draws;
    final winRate =
        totalGames > 0 ? ((user.stats.wins / totalGames) * 100).round() : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
      child: Column(
        children: [
          // ── Avatar + nombre + rango ─────────────────────────
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.yellow500, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.yellow500.withOpacity(0.25),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundColor: AppColors.surfaceContainerHigh,
              backgroundImage:
                  user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
              child: user.photoUrl == null
                  ? Text(
                      user.displayName.isNotEmpty
                          ? user.displayName[0].toUpperCase()
                          : '?',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.displayName,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          _rankBadge(user.rank),
          const SizedBox(height: 10),
          // Progreso de puntos en la liga actual
          SizedBox(
            width: 180,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: (user.leaguePoints / 100).clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: AppColors.yellow500.withOpacity(0.15),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.yellow500,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${user.leaguePoints} / 100 pts',
                  style: GoogleFonts.lexend(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── ELO destacado ───────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Column(
              children: [
                Text(
                  'ELO GLOBAL',
                  style: GoogleFonts.lexend(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onPrimaryContainer.withOpacity(0.7),
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${user.elo}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: AppColors.yellow500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Grid de estadísticas ────────────────────────────
          Row(
            children: [
              Expanded(
                  child: _statBox(
                      'Partidas', '$totalGames', Icons.sports_soccer)),
              const SizedBox(width: 12),
              Expanded(
                  child: _statBox('% Victoria', '$winRate%',
                      Icons.emoji_events, AppColors.primary)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _statBox('Mejor Racha', '${user.stats.bestWinStreak}',
                      Icons.local_fire_department, AppColors.yellow500)),
              const SizedBox(width: 12),
              Expanded(
                  child: _statBox('Aciertos',
                      '${user.stats.totalCorrectAnswers}', Icons.check_circle,
                      AppColors.success)),
            ],
          ),
          const SizedBox(height: 16),

          // ── Récord V / D / E ────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _record('Victorias', user.stats.wins, AppColors.success),
                _record('Derrotas', user.stats.losses, AppColors.error),
                _record('Empates', user.stats.draws,
                    AppColors.onSurfaceVariant),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _rankBadge(String rank) {
    final color = switch (rank) {
      'Primera División' => const Color(0xFFFFD700),
      'Segunda División' => const Color(0xFFE5E4E2),
      'Primera RFEF' => const Color(0xFF4ADE80),
      'Segunda RFEF' => const Color(0xFFB0B7C3),
      'Tercera RFEF' => const Color(0xFFCD7F32),
      _ => AppColors.tertiary,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        rank.toUpperCase(),
        style: GoogleFonts.lexend(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _statBox(String label, String value, IconData icon,
      [Color iconColor = AppColors.yellow500]) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
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

  Widget _record(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          '$value',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.lexend(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurfaceVariant,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
