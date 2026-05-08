import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:futko/domain/entities/question.dart';
import '../../../../core/theme/app_colors.dart';

class QuestionCard extends StatelessWidget {
  final Question question;

  const QuestionCard({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: AppColors.outlineVariant.withOpacity(0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1C1B).withOpacity(0.04),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: _buildQuestionContent(),
    );
  }

  Widget _buildQuestionContent() {
    switch (question.type) {
      case QuestionType.player:
        return _buildPlayerQuestion();
      case QuestionType.team:
        return _buildTeamQuestion();
      case QuestionType.competition:
        return _buildCompetitionQuestion();
      case QuestionType.history:
        return _buildHistoryQuestion();
      case QuestionType.rules:
        return _buildRulesQuestion();
      case QuestionType.stadium:
        return _buildStadiumQuestion();
      case QuestionType.badge:
        return _buildBadgeQuestion();
      case QuestionType.playerImage:
        return _buildPlayerImageQuestion();
      case QuestionType.statistic:
        return _buildStatisticQuestion();
      case QuestionType.transfer:
        return _buildTransferQuestion();
    }
  }

  /// Helper to build an image container with proper full-border support.
  /// Uses a white background behind BoxFit.contain images so the border
  /// is visible on all sides, not just top/bottom.
  Widget _buildImageSection({
    required String imageUrl,
    required double height,
    BoxFit fit = BoxFit.contain,
    Widget? placeholder,
    Widget? errorWidget,
    bool isAsset = false,
    bool isNetwork = true,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.4)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(31)),
        child: isAsset
            ? Image.asset(
                imageUrl,
                height: height,
                width: double.infinity,
                fit: fit,
                errorBuilder: (context, error, stackTrace) =>
                    errorWidget ??
                    Container(
                      height: height,
                      color: AppColors.surfaceVariant.withOpacity(0.3),
                      child: const Center(
                          child: Icon(Icons.image_not_supported,
                              size: 60, color: AppColors.outline)),
                    ),
              )
            : CachedNetworkImage(
                imageUrl: imageUrl,
                height: height,
                width: double.infinity,
                fit: fit,
                placeholder: (context, url) =>
                    placeholder ??
                    Container(
                      color: AppColors.surfaceVariant.withOpacity(0.3),
                      child: const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.primary)),
                    ),
                errorWidget: (context, url, error) =>
                    errorWidget ??
                    Container(
                      color: AppColors.surfaceVariant.withOpacity(0.3),
                      child: const Center(
                          child: Icon(Icons.image_not_supported,
                              size: 60, color: AppColors.outline)),
                    ),
              ),
      ),
    );
  }


  // ── Football Question Builders ─────────────────────────────────────────

  Widget _buildPlayerQuestion() {
    return _buildGenericQuestion(
      icon: Icons.person,
      defaultQuestion: '¿Qué jugador es este?',
      iconColor: AppColors.primary,
    );
  }

  Widget _buildTeamQuestion() {
    return _buildGenericQuestion(
      icon: Icons.shield,
      defaultQuestion: '¿De qué equipo se trata?',
      iconColor: AppColors.primary,
    );
  }

  Widget _buildCompetitionQuestion() {
    return _buildGenericQuestion(
      icon: Icons.emoji_events,
      defaultQuestion: '¿Qué competición es esta?',
      iconColor: AppColors.secondary,
    );
  }

  Widget _buildHistoryQuestion() {
    return _buildGenericQuestion(
      icon: Icons.history,
      defaultQuestion: '¿Sabes la respuesta?',
      iconColor: AppColors.tertiary,
    );
  }

  Widget _buildRulesQuestion() {
    return _buildGenericQuestion(
      icon: Icons.gavel,
      defaultQuestion: '¿Qué dice el reglamento?',
      iconColor: AppColors.tertiary,
    );
  }

  Widget _buildStadiumQuestion() {
    return _buildGenericQuestion(
      icon: Icons.stadium,
      defaultQuestion: '¿Qué estadio es este?',
      iconColor: AppColors.primary,
      hasImage: true,
    );
  }

  Widget _buildBadgeQuestion() {
    return _buildGenericQuestion(
      icon: Icons.shield,
      defaultQuestion: '¿De qué equipo es este escudo?',
      iconColor: AppColors.primary,
      hasImage: true,
    );
  }

  Widget _buildPlayerImageQuestion() {
    return _buildGenericQuestion(
      icon: Icons.person,
      defaultQuestion: '¿Quién es este jugador?',
      iconColor: AppColors.primary,
      hasImage: true,
    );
  }

  Widget _buildStatisticQuestion() {
    return _buildGenericQuestion(
      icon: Icons.bar_chart,
      defaultQuestion: '¿Cuál es la respuesta correcta?',
      iconColor: AppColors.tertiary,
    );
  }

  Widget _buildTransferQuestion() {
    return _buildGenericQuestion(
      icon: Icons.swap_horiz,
      defaultQuestion: '¿A qué equipo fue transferido?',
      iconColor: AppColors.secondary,
    );
  }

  /// Difficulty badge widget
  Widget _buildDifficultyBadge() {
    final difficulty = question.difficulty;
    final (label, color) = switch (difficulty) {
      Difficulty.easy => ('FÁCIL', AppColors.success),
      Difficulty.medium => ('MEDIO', AppColors.secondaryFixed),
      Difficulty.hard => ('DIFÍCIL', AppColors.error),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.lexend(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 1,
        ),
      ),
    );
  }

  /// Generic question builder â€” handles both text-only and image questions.
  Widget _buildGenericQuestion({
    required IconData icon,
    required String defaultQuestion,
    required Color iconColor,
    bool hasImage = false,
  }) {
    final imageUrl = question.imageUrl;

    return Column(
      children: [
        if (hasImage && imageUrl != null)
          _buildImageSection(
            imageUrl: imageUrl,
            height: 200,
            fit: BoxFit.contain,
            errorWidget: Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant.withOpacity(0.3),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Center(child: Icon(icon, size: 60, color: AppColors.outline)),
            ),
          ),
        if (!hasImage || imageUrl == null)
          Container(
            height: hasImage ? 200 : 100,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant.withOpacity(0.3),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Center(
              child: Icon(icon, size: 56, color: iconColor.withOpacity(0.4)),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildDifficultyBadge(),
              const SizedBox(height: 16),
              Text(
                question.questionText ?? defaultQuestion,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.onSurface,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
