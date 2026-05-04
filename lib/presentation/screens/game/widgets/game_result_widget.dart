import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import 'answer_timeline_widget.dart';
import '../../../../domain/entities/match.dart';

class GameResultWidget extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final double averageTime;
  final VoidCallback onPlayAgain;
  final VoidCallback onGoHome;
  final String? opponentName;
  final int? eloChange;
  final bool isVictory;
  final List<dynamic>? userAnswers;
  final List<dynamic>? opponentAnswers;
  final int? opponentScore;
  final int? opponentCorrectAnswers;
  final double? opponentAverageTime;
  final VoidCallback? onAddFriend;

  const GameResultWidget({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.averageTime,
    required this.onPlayAgain,
    required this.onGoHome,
    this.opponentName,
    this.eloChange,
    this.isVictory = true,
    this.userAnswers,
    this.opponentAnswers,
    this.opponentScore,
    this.opponentCorrectAnswers,
    this.opponentAverageTime,
    this.onAddFriend,
  });

  @override
  State<GameResultWidget> createState() => _GameResultWidgetState();
}

class _GameResultWidgetState extends State<GameResultWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accuracy = widget.totalQuestions > 0
        ? (widget.correctAnswers / widget.totalQuestions) * 100
        : 0.0;

    return Container(
      color: AppColors.background,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: AnimatedBuilder(
          animation: _slideAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Main Result Card ────────────
                    _buildResultCard(accuracy),
                    const SizedBox(height: 24),

                    // ── Performance Message ─────────
                    _buildPerformanceMessage(accuracy),
                    const SizedBox(height: 24),

                    // ── Answer Timeline ─────────────
                    if (widget.userAnswers != null)
                      AnswerTimeline(
                        totalQuestions: widget.totalQuestions,
                        playerAnswers: widget.userAnswers!.cast<Answer>(),
                        opponentAnswers: widget.opponentAnswers?.cast<Answer>(),
                        playerName: 'Tú',
                        opponentName: widget.opponentName,
                      ),
                    if (widget.userAnswers != null) const SizedBox(height: 24),

                    // ── Action Buttons ──────────────
                    _buildActionButtons(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildResultCard(double accuracy) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: widget.isVictory
                ? AppColors.primary.withOpacity(0.1)
                : AppColors.error.withOpacity(0.1),
            blurRadius: 50,
            spreadRadius: -10,
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header ──────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              color: widget.isVictory
                  ? AppColors.primary.withOpacity(0.15)
                  : AppColors.error.withOpacity(0.15),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isVictory ? AppColors.primary : AppColors.error,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (widget.isVictory ? AppColors.primary : AppColors.error)
                            .withOpacity(0.3),
                        blurRadius: 30,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.isVictory ? Icons.emoji_events : Icons.rectangle,
                    size: 40,
                    color: widget.isVictory ? AppColors.onPrimary : AppColors.onError,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.isVictory ? '¡CAMPEÓN!' : 'FIN DEL PARTIDO',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: widget.isVictory ? AppColors.primary : AppColors.error,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 4),
                if (widget.opponentName != null)
                  Text(
                    'vs ${widget.opponentName}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),

          // ── Stats Grid ──────────────────
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        label: 'Puntos',
                        value: '${widget.score}',
                        icon: Icons.stars,
                        iconColor: AppColors.yellow500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        label: 'Aciertos',
                        value: '${widget.correctAnswers}/${widget.totalQuestions}',
                        icon: Icons.check_circle,
                        iconColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        label: 'Precisión',
                        value: '${accuracy.toStringAsFixed(0)}%',
                        icon: Icons.percent,
                        iconColor: AppColors.secondaryFixed,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        label: 'Tiempo Medio',
                        value: _formatTime(widget.averageTime),
                        icon: Icons.timer,
                        iconColor: AppColors.tertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── ELO Change ──────────────────
          if (widget.eloChange != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.eloChange! > 0 ? Icons.trending_up : Icons.trending_down,
                      color: widget.eloChange! > 0 ? AppColors.success : AppColors.error,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${widget.eloChange! > 0 ? '+' : ''}${widget.eloChange} ELO',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: widget.eloChange! > 0 ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.03),
        ),
      ),
      child: Column(
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.lexend(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
              letterSpacing: 2,
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
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMessage(double accuracy) {
    String message;
    if (accuracy >= 90) message = '🏆 ¡Eres una leyenda del fútbol!';
    else if (accuracy >= 80) message = '⚽ ¡Gran partido! ¡Sigue así!';
    else if (accuracy >= 70) message = '👟 ¡Bien jugado! ¡Cada vez mejor!';
    else if (accuracy >= 60) message = '💪 ¡Buen esfuerzo! ¡La práctica hace al maestro!';
    else message = '📚 ¡Sigue entrenando! ¡Cada partido cuenta!';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
      ),
      child: Text(
        message,
        style: GoogleFonts.lexend(
          color: AppColors.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Play Again
        SizedBox(
          width: double.infinity,
          height: 56,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [AppColors.secondaryContainer, AppColors.onSecondaryContainer],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.onSecondaryFixedVariant.withOpacity(0.3),
                  blurRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: widget.onPlayAgain,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.replay, color: Colors.black, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        widget.opponentName != null ? 'Revancha' : 'Jugar de Nuevo',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Go Home
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: widget.onGoHome,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.onSurface,
              side: BorderSide(
                color: AppColors.outlineVariant.withOpacity(0.3),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Volver al Inicio',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatTime(double ms) {
    if (!ms.isFinite || ms <= 0) return '0.0s';
    final seconds = ms / 1000;
    return '${seconds.toStringAsFixed(1)}s';
  }
}
