import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/entities/question.dart';
import '../../providers/game_provider.dart';
import 'widgets/timer_widget.dart';
import 'widgets/question_card.dart';
import 'widgets/answer_options_widget.dart';
import 'widgets/answer_feedback_widget.dart';
import 'widgets/game_result_widget.dart';
import 'widgets/type_answer_widget.dart';
import '../../../core/constants/game_constants.dart';
import '../../../core/theme/app_colors.dart';

class GameScreen extends ConsumerWidget {
  final Difficulty difficulty;

  const GameScreen({super.key, required this.difficulty});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameNotifierProvider);
    final currentQuestion = ref.watch(currentQuestionProvider);
    final progress = ref.watch(progressPercentageProvider);
    final timerProgress = ref.watch(timerProgressProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Pitch gradient background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.3),
                  radius: 1.2,
                  colors: [
                    const Color(0xFF1a2e1d),
                    AppColors.background,
                  ],
                ),
              ),
            ),
          ),

          // Pitch markings
          Positioned.fill(
            child: CustomPaint(
              painter: _PitchMarkingsPainter(),
            ),
          ),

          // Main content
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // ── Top App Bar ─────────────────
                _buildTopBar(context, ref, gameState),

                // ── Game Content ────────────────
                Expanded(
                  child: gameState.when(
                    initial: () => _buildInitial(context, ref),
                    loading: () => _buildLoading(),
                    playing: (_, currentQuestionIndex, ___, score, _____, correctAnswers, ________) =>
                        _buildPlaying(context, ref, currentQuestion, currentQuestionIndex, progress, timerProgress, score, correctAnswers),
                    answered: (isCorrect, correctAnswer, selectedAnswer, score) =>
                        _buildAnswered(context, ref, isCorrect, correctAnswer, selectedAnswer, score, currentQuestion),
                    finished: (score, totalQuestions, correctAnswers, userAnswers, averageTime) =>
                        _buildFinished(context, ref, score, totalQuestions, correctAnswers, userAnswers, averageTime),
                    error: (message) => _buildError(context, message, ref),
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

  Widget _buildTopBar(BuildContext context, WidgetRef ref, AsyncValue<GameState> gameState) {
    final score = gameState.maybeWhen(
      playing: (_, __, ___, score, _____, ______, _______) => score,
      answered: (_, __, ___, score) => score,
      finished: (score, ___, _____, _______, ______) => score,
      orElse: () => 0,
    );

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

          // Score pill + avatar
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(
                    color: AppColors.outlineVariant.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.stars,
                      size: 16,
                      color: AppColors.yellow500,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$score pts',
                      style: GoogleFonts.lexend(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.yellow500,
                    width: 2,
                  ),
                  color: AppColors.primaryContainer,
                ),
                child: const Icon(
                  Icons.person,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInitial(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                ),
              ),
              child: Icon(
                Icons.play_circle_outline,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '¿Listo para jugar?',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Difficulty: ${difficulty.name.toUpperCase()}',
              style: GoogleFonts.lexend(
                fontSize: 16,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [AppColors.secondaryFixed, AppColors.onSecondaryContainer],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.onSecondaryFixedVariant.withOpacity(0.4),
                      blurRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => ref.read(gameNotifierProvider.notifier).startGame(difficulty: difficulty),
                    child: Center(
                      child: Text(
                        'INICIAR JUEGO',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSecondaryFixedVariant,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppColors.secondaryFixed,
            strokeWidth: 3,
          ),
          const SizedBox(height: 24),
          Text(
            'Cargando preguntas...',
            style: GoogleFonts.lexend(
              fontSize: 16,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaying(
    BuildContext context, WidgetRef ref, dynamic currentQuestion,
    int currentQuestionIndex, double progress, double timerProgress,
    int score, int correctAnswers,
  ) {
    if (currentQuestion == null) return _buildLoading();

    final timeRemaining = (timerProgress * GameConstants.secondsPerQuestion).ceil();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
      child: Column(
        children: [
          // ── Scoreboard ──────────────────────
          _buildScoreboard(context, currentQuestionIndex, timeRemaining, score),
          const SizedBox(height: 24),

          // ── Question ────────────────────────
          _buildQuestionArea(currentQuestion, currentQuestionIndex),
          const SizedBox(height: 28),

          // ── Answer Options ──────────────────
          if (currentQuestion.options.isEmpty)
            TypeAnswerWidget(
              question: currentQuestion,
              timeRemaining: timerProgress > 0
                  ? (timerProgress * GameConstants.secondsPerTypeQuestion).round()
                  : 0,
              onAnswerSubmitted: (answer) {
                ref.read(gameNotifierProvider.notifier).submitTypedAnswer(typedAnswer: answer);
              },
            )
          else
            AnswerOptionsWidget(
              question: currentQuestion,
              onAnswerSelected: (answer) {
                ref.read(gameNotifierProvider.notifier).submitAnswer(selectedAnswer: answer, isTimeout: false);
              },
            ),

          const SizedBox(height: 24),

          // ── Bottom Actions ──────────────────
          _buildBottomActions(context, ref),
        ],
      ),
    );
  }

  Widget _buildScoreboard(BuildContext context, int currentQuestionIndex, int timeRemaining, int score) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: const ColorFilter.matrix([
            1, 0, 0, 0, 0,
            0, 1, 0, 0, 0,
            0, 0, 1, 0, 0,
            0, 0, 0, 0.8, 0,
          ]),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Progress bar
                Container(
                  width: double.infinity,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.yellow500.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (currentQuestionIndex + 1) / 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.yellow500,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.yellow500.withOpacity(0.5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Rank
                    Column(
                      children: [
                        Text(
                          'Global Rank',
                          style: GoogleFonts.lexend(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '#42',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),

                    // Timer
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                            value: timeRemaining / GameConstants.secondsPerQuestion,
                            strokeWidth: 5,
                            backgroundColor: AppColors.surfaceContainerHighest,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              timeRemaining <= 5 ? AppColors.error : AppColors.yellow500,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              timeRemaining.toString().padLeft(2, '0'),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: AppColors.yellow500,
                                shadows: [
                                  Shadow(
                                    color: AppColors.yellow500.withOpacity(0.4),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Seconds',
                              style: GoogleFonts.lexend(
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                                color: AppColors.yellow500.withOpacity(0.5),
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Match Score
                    Column(
                      children: [
                        Text(
                          'Match Score',
                          style: GoogleFonts.lexend(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '$score',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '-',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${score > 0 ? score - 1 : 0}',
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionArea(dynamic currentQuestion, int currentQuestionIndex) {
    return Column(
      children: [
        // Chips
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                ),
              ),
              child: Text(
                'QUESTION ${currentQuestionIndex + 1}/10',
                style: GoogleFonts.lexend(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(
                  color: AppColors.outlineVariant,
                ),
              ),
              child: Text(
                'LIVE EVENT',
                style: GoogleFonts.lexend(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onTertiaryContainer,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Question text
        Text(
          currentQuestion.text,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBottomActions(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // Participants avatars (mock)
        Expanded(
          child: Row(
            children: [
              ...List.generate(3, (index) {
                return Container(
                  width: 36,
                  height: 36,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceContainerHighest,
                    border: Border.all(
                      color: AppColors.emerald950,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 16,
                    color: AppColors.onSurfaceVariant,
                  ),
                );
              }),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceContainerHighest,
                  border: Border.all(
                    color: AppColors.emerald950,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '+12k',
                    style: GoogleFonts.lexend(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Hint button
        Material(
          color: AppColors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.outlineVariant.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.help_outline,
                    size: 18,
                    color: AppColors.onSurface,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'HINT',
                    style: GoogleFonts.lexend(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnswered(BuildContext context, WidgetRef ref, bool isCorrect,
    String correctAnswer, String selectedAnswer, int score, dynamic currentQuestion,
  ) {
    return AnswerFeedbackWidget(
      isCorrect: isCorrect,
      correctAnswer: correctAnswer,
      selectedAnswer: selectedAnswer,
      score: score,
      question: currentQuestion,
      onNextQuestion: () => ref.read(gameNotifierProvider.notifier).nextQuestion(),
    );
  }

  Widget _buildFinished(BuildContext context, WidgetRef ref, int score,
    int totalQuestions, int correctAnswers, List<dynamic> userAnswers, double averageTime,
  ) {
    return GameResultWidget(
      score: score,
      totalQuestions: totalQuestions,
      correctAnswers: correctAnswers,
      averageTime: averageTime,
      userAnswers: userAnswers,
      onPlayAgain: () => ref.read(gameNotifierProvider.notifier).startGame(difficulty: difficulty),
      onGoHome: () {
        context.go('/home');
        Future.microtask(() => ref.read(gameNotifierProvider.notifier).resetGame());
      },
    );
  }

  Widget _buildError(BuildContext context, String message, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              message,
              style: GoogleFonts.lexend(fontSize: 16, color: AppColors.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
              ),
              child: const Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }

  void _showExitDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        title: Text(
          '¿Salir del juego?',
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Tu progreso se perderá. ¿Estás seguro?',
          style: GoogleFonts.lexend(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancelar',
              style: TextStyle(color: AppColors.onSurfaceVariant),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              ref.read(gameNotifierProvider.notifier).cancelGame();
              context.go('/home');
            },
            child: const Text(
              'Salir',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

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
              ),
              _buildNavItem(
                icon: Icons.emoji_events,
                label: 'Rankings',
              ),
              _buildNavItem(
                icon: Icons.fitness_center,
                label: 'Rules',
              ),
              _buildNavItem(
                icon: Icons.person,
                label: 'Profile',
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
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: isActive
          ? BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.yellow500.withOpacity(0.1),
                  blurRadius: 15,
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
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Pitch Markings Painter ────────────────────────────────
class _PitchMarkingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Center circle
    final center = Offset(size.width / 2, size.height * 0.4);
    canvas.drawCircle(center, 120, paint);

    // Center line
    canvas.drawLine(
      Offset(0, size.height * 0.4),
      Offset(size.width, size.height * 0.4),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
