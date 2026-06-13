import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/user.dart';
import '../../providers/user_provider.dart';

/// Un logro derivado de los datos actuales del usuario (sin persistencia extra).
class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final int target;
  final int progress;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.target,
    required this.progress,
  });

  bool get unlocked => progress >= target;
  double get ratio =>
      target == 0 ? 1.0 : (progress / target).clamp(0.0, 1.0);
}

/// Calcula los logros a partir del estado del usuario.
List<Achievement> evaluateAchievements(User user) {
  final s = user.stats;
  return [
    Achievement(
        id: 'first_win',
        title: 'Debut goleador',
        description: 'Gana tu primera partida',
        icon: Icons.emoji_events,
        target: 1,
        progress: s.wins),
    Achievement(
        id: 'wins_10',
        title: 'Killer',
        description: 'Gana 10 partidas',
        icon: Icons.sports_soccer,
        target: 10,
        progress: s.wins),
    Achievement(
        id: 'wins_50',
        title: 'Crack',
        description: 'Gana 50 partidas',
        icon: Icons.military_tech,
        target: 50,
        progress: s.wins),
    Achievement(
        id: 'streak_3',
        title: 'En racha',
        description: 'Encadena 3 victorias seguidas',
        icon: Icons.local_fire_department,
        target: 3,
        progress: s.bestWinStreak),
    Achievement(
        id: 'streak_5',
        title: 'Imparable',
        description: 'Encadena 5 victorias seguidas',
        icon: Icons.whatshot,
        target: 5,
        progress: s.bestWinStreak),
    Achievement(
        id: 'correct_100',
        title: 'Sabelotodo',
        description: '100 respuestas correctas',
        icon: Icons.check_circle,
        target: 100,
        progress: s.totalCorrectAnswers),
    Achievement(
        id: 'correct_500',
        title: 'Enciclopedia',
        description: '500 respuestas correctas',
        icon: Icons.menu_book,
        target: 500,
        progress: s.totalCorrectAnswers),
    Achievement(
        id: 'games_50',
        title: 'Veterano',
        description: 'Juega 50 partidas',
        icon: Icons.stadium,
        target: 50,
        progress: s.totalGames),
    Achievement(
        id: 'league_3',
        title: 'A la RFEF',
        description: 'Asciende a Primera RFEF',
        icon: Icons.trending_up,
        target: 3,
        progress: user.leagueTier),
    Achievement(
        id: 'league_5',
        title: 'Élite',
        description: 'Llega a Primera División',
        icon: Icons.workspace_premium,
        target: 5,
        progress: user.leagueTier),
    Achievement(
        id: 'daily_7',
        title: 'Constante',
        description: 'Racha diaria de 7 días',
        icon: Icons.calendar_month,
        target: 7,
        progress: user.bestDailyStreak),
  ];
}

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider).valueOrNull;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.emerald950,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Logros',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : _buildList(evaluateAchievements(user)),
    );
  }

  Widget _buildList(List<Achievement> achievements) {
    final unlocked = achievements.where((a) => a.unlocked).length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Resumen
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer.withOpacity(0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Row(
            children: [
              const Icon(Icons.emoji_events,
                  size: 32, color: AppColors.yellow500),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$unlocked / ${achievements.length}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.onSurface,
                    ),
                  ),
                  Text(
                    'logros desbloqueados',
                    style: GoogleFonts.lexend(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ...achievements.map(_buildCard),
      ],
    );
  }

  Widget _buildCard(Achievement a) {
    final color = a.unlocked ? AppColors.yellow500 : AppColors.onSurfaceVariant;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: a.unlocked
              ? AppColors.yellow500.withOpacity(0.4)
              : Colors.white.withOpacity(0.06),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(a.unlocked ? 0.18 : 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(a.icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Opacity(
              opacity: a.unlocked ? 1.0 : 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          a.title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ),
                      if (a.unlocked)
                        const Icon(Icons.check_circle,
                            size: 18, color: AppColors.success),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    a.description,
                    style: GoogleFonts.lexend(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  if (!a.unlocked) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: a.ratio,
                        minHeight: 5,
                        backgroundColor: Colors.white.withOpacity(0.08),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${a.progress.clamp(0, a.target)}/${a.target}',
                      style: GoogleFonts.lexend(
                        fontSize: 10,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
