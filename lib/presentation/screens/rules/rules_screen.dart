import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/game_constants.dart';
import '../../../core/theme/app_colors.dart';

/// Pantalla "Cómo jugar" — reglas básicas de FutKO.
class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Cómo jugar',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        children: [
          _rule(
            Icons.sports_soccer,
            'El partido',
            'Cada partida son ${GameConstants.questionsPerMatch} preguntas de fútbol. '
                'Tienes ${GameConstants.secondsPerQuestion}s por pregunta '
                '(${GameConstants.secondsPerTypeQuestion}s si hay que escribir la respuesta).',
          ),
          _rule(
            Icons.bolt,
            'Puntuación',
            'Ganas puntos por cada acierto, con bonus por responder rápido y por '
                'encadenar racha de aciertos.',
          ),
          _rule(
            Icons.emoji_events,
            'Ranking ELO',
            'Empiezas con ${GameConstants.initialElo} de ELO. Sube o baja según ganes '
                'o pierdas frente a tu rival, como en el ajedrez.',
          ),
          _rule(
            Icons.groups,
            'Modos de juego',
            'Partida Rápida (1v1 en directo), Clasificatoria (afecta a tu ELO) y la '
                'Pregunta del Día para puntos extra.',
          ),
          _rule(
            Icons.workspace_premium,
            'Gratis y Premium',
            'El plan gratis tiene un límite diario de partidas. Premium te da '
                'partidas ilimitadas y sin anuncios.',
          ),
        ],
      ),
    );
  }

  Widget _rule(IconData icon, String title, String body) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.yellow500, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: GoogleFonts.lexend(
                    fontSize: 13,
                    height: 1.4,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
