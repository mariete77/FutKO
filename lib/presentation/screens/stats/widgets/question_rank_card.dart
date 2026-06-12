import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/repositories/quiz_attempt_repository.dart';

/// Card que muestra una pregunta con su tasa de acierto
class QuestionRankCard extends StatelessWidget {
  final QuestionStats stats;
  final int rank; // Posición: 1, 2, 3...
  final bool isTopTen; // true = top falladas (rojo), false = top acertadas (verde)

  const QuestionRankCard({
    super.key,
    required this.stats,
    required this.rank,
    required this.isTopTen,
  });

  @override
  Widget build(BuildContext context) {
    final successRatePercent = (stats.successRate * 100).toStringAsFixed(1);
    final backgroundColor = isTopTen
        ? AppColors.error.withOpacity(0.1)
        : AppColors.success.withOpacity(0.1);
    final accentColor = isTopTen ? AppColors.error : AppColors.success;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Rank number
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentColor.withOpacity(0.2),
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Question info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question type
                Text(
                  stats.questionType,
                  style: GoogleFonts.lexend(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                // Attempts
                Text(
                  '${stats.totalAttempts} intentos',
                  style: GoogleFonts.lexend(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Success rate
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$successRatePercent%',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                ),
              ),
              Text(
                isTopTen ? 'Fallos' : 'Aciertos',
                style: GoogleFonts.lexend(
                  fontSize: 10,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
