     1|import 'package:flutter/material.dart';
     2|import 'package:cached_network_image/cached_network_image.dart';
     3|import 'package:google_fonts/google_fonts.dart';
     4|import 'package:futko/domain/entities/question.dart';
     5|import '../../../../core/theme/app_colors.dart';
     6|
     7|class QuestionCard extends StatelessWidget {
     8|  final Question question;
     9|
    10|  const QuestionCard({super.key, required this.question});
    11|
    12|  @override
    13|  Widget build(BuildContext context) {
    14|    return Container(
    15|      decoration: BoxDecoration(
    16|        color: AppColors.surfaceContainerLowest,
    17|        borderRadius: BorderRadius.circular(32),
    18|        border: Border.all(
    19|          color: AppColors.outlineVariant.withOpacity(0.15),
    20|        ),
    21|        boxShadow: [
    22|          BoxShadow(
    23|            color: const Color(0xFF1A1C1B).withOpacity(0.04),
    24|            blurRadius: 32,
    25|            offset: const Offset(0, 8),
    26|          ),
    27|        ],
    28|      ),
    29|      child: _buildQuestionContent(),
    30|    );
    31|  }
    32|
    33|  Widget _buildQuestionContent() {
    34|    switch (question.type) {
    35|      case QuestionType.player:
    36|        return _buildPlayerQuestion();
    37|      case QuestionType.team:
    38|        return _buildTeamQuestion();
    39|      case QuestionType.competition:
    40|        return _buildCompetitionQuestion();
    41|      case QuestionType.history:
    42|        return _buildHistoryQuestion();
    43|      case QuestionType.rules:
    44|        return _buildRulesQuestion();
    45|      case QuestionType.stadium:
    46|        return _buildStadiumQuestion();
    47|      case QuestionType.badge:
    48|        return _buildBadgeQuestion();
    49|      case QuestionType.playerImage:
    50|        return _buildPlayerImageQuestion();
    51|      case QuestionType.statistic:
    52|        return _buildStatisticQuestion();
    53|      case QuestionType.transfer:
    54|        return _buildTransferQuestion();
    55|    }
    56|  }
    57|
    58|  /// Helper to build an image container with proper full-border support.
    59|  /// Uses a white background behind BoxFit.contain images so the border
    60|  /// is visible on all sides, not just top/bottom.
    61|  Widget _buildImageSection({
    62|    required String imageUrl,
    63|    required double height,
    64|    BoxFit fit = BoxFit.contain,
    65|    Widget? placeholder,
    66|    Widget? errorWidget,
    67|    bool isAsset = false,
    68|    bool isNetwork = true,
    69|  }) {
    70|    return Container(
    71|      height: height,
    72|      decoration: BoxDecoration(
    73|        color: Colors.white,
    74|        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
    75|        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.4)),
    76|      ),
    77|      child: ClipRRect(
    78|        borderRadius: const BorderRadius.vertical(top: Radius.circular(31)),
    79|        child: isAsset
    80|            ? Image.asset(
    81|                imageUrl,
    82|                height: height,
    83|                width: double.infinity,
    84|                fit: fit,
    85|                errorBuilder: (context, error, stackTrace) =>
    86|                    errorWidget ??
    87|                    Container(
    88|                      height: height,
    89|                      color: AppColors.surfaceVariant.withOpacity(0.3),
    90|                      child: const Center(
    91|                          child: Icon(Icons.image_not_supported,
    92|                              size: 60, color: AppColors.outline)),
    93|                    ),
    94|              )
    95|            : CachedNetworkImage(
    96|                imageUrl: imageUrl,
    97|                height: height,
    98|                width: double.infinity,
    99|                fit: fit,
   100|                placeholder: (context, url) =>
   101|                    placeholder ??
   102|                    Container(
   103|                      color: AppColors.surfaceVariant.withOpacity(0.3),
   104|                      child: const Center(
   105|                          child: CircularProgressIndicator(
   106|                              color: AppColors.primary)),
   107|                    ),
   108|                errorWidget: (context, url, error) =>
   109|                    errorWidget ??
   110|                    Container(
   111|                      color: AppColors.surfaceVariant.withOpacity(0.3),
   112|                      child: const Center(
   113|                          child: Icon(Icons.image_not_supported,
   114|                              size: 60, color: AppColors.outline)),
   115|                    ),
   116|              ),
   117|      ),
   118|    );
   119|  }
   120|

  // ── Football Question Builders ──────────────────────────

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

  /// Generic question builder — handles both text-only and image questions.
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
