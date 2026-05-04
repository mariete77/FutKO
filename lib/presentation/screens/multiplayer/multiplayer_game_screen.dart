import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/multiplayer_provider.dart';
import '../../providers/friends_provider.dart';
import '../game/widgets/timer_widget.dart';
import '../game/widgets/question_card.dart';
import '../game/widgets/answer_options_widget.dart';
import '../game/widgets/type_answer_widget.dart';
import '../game/widgets/game_result_widget.dart';
import '../../../core/constants/game_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/match.dart';

/// Multiplayer game screen
class MultiplayerGameScreen extends ConsumerWidget {
  const MultiplayerGameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(multiplayerProvider);
    final isFinished = state.status == MultiplayerStatus.finished;

    return Scaffold(
      backgroundColor: isFinished ? AppColors.background : AppColors.surface,
      appBar: isFinished
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.close, color: AppColors.onSurface),
                onPressed: () => _showExitDialog(context, ref),
              ),
              actions: [
                _buildScoreBar(state),
              ],
            ),
      body: _buildBody(context, ref, state),
    );
  }

  Widget _buildScoreBar(MultiplayerState state) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${state.playerScore}',
            style: TextStyle(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'VS',
            style: TextStyle(
              color: AppColors.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${state.opponentScore}',
            style: TextStyle(
              color: AppColors.error,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, MultiplayerState state) {
    switch (state.status) {
      case MultiplayerStatus.playing:
        return _buildPlaying(context, ref, state);
      case MultiplayerStatus.finished:
        return _buildFinished(context, ref, state);
      case MultiplayerStatus.error:
        return _buildError(context, state.errorMessage ?? 'Unknown error');
      default:
        return _buildLoading();
    }
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.tertiary,
            strokeWidth: 3,
          ),
          const SizedBox(height: 24),
          Text(
            'Cargando...',
            style: TextStyle(color: AppColors.onSurface, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaying(BuildContext context, WidgetRef ref, MultiplayerState state) {
    final currentIndex = state.currentQuestionIndex;
    if (currentIndex >= state.questions.length) return _buildLoading();

    final question = state.questions[currentIndex];
    final totalQuestions = state.questions.length;
    final progress = (currentIndex + 1) / totalQuestions;

    // Calculate timer progress
    final maxTime = question.options.isEmpty
        ? GameConstants.secondsPerTypeQuestion
        : GameConstants.secondsPerQuestion;
    final timerProgress = state.timeRemaining / maxTime;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress bar with opponent indicator
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.onSurface.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.tertiary),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${currentIndex + 1}/$totalQuestions',
                style: TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Opponent info bar
          _buildOpponentBar(state),
          const SizedBox(height: 16),

          // Timer
          TimerWidget(progress: timerProgress),
          const SizedBox(height: 30),

          // Question card
          QuestionCard(question: question),
          const SizedBox(height: 30),

          // Answer options
          if (question.options.isEmpty)
            TypeAnswerWidget(
              question: question,
              timeRemaining: state.timeRemaining,
              onAnswerSubmitted: (answer) {
                ref.read(multiplayerProvider.notifier).submitTypedAnswer(
                      typedAnswer: answer,
                    );
              },
            )
          else
            AnswerOptionsWidget(
              question: question,
              onAnswerSelected: (answer) {
                ref.read(multiplayerProvider.notifier).submitAnswer(
                      selectedAnswer: answer,
                      isTimeout: false,
                    );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildOpponentBar(MultiplayerState state) {
    final isWinning = state.playerScore >= state.opponentScore;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isWinning
              ? AppColors.success.withOpacity(0.3)
              : AppColors.incorrect.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(Icons.person, color: AppColors.success, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Tú',
                  style: TextStyle(color: AppColors.success, fontSize: 14),
                ),
                const Spacer(),
                Text(
                  '${state.playerScore}',
                  style: TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 24,
            color: AppColors.outlineVariant,
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),
          Expanded(
            child: Row(
              children: [
                Text(
                  '${state.opponentScore}',
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                Text(
                  state.opponentName ?? 'Oponente',
                  style: TextStyle(color: AppColors.error, fontSize: 14),
                ),
                const SizedBox(width: 8),
                Icon(Icons.person_outline, color: AppColors.error, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinished(BuildContext context, WidgetRef ref, MultiplayerState state) {
    final won = state.playerScore > state.opponentScore;
    final totalQuestions = state.questions.length;
    
    // Safe calculation of average time with NaN/Infinity checks
    final avgTime = state.playerAnswers.isEmpty
        ? 0.0
        : (() {
            try {
              final totalMs = state.playerAnswers
                  .map((a) => a.timeMs)
                  .where((ms) => ms.isFinite && ms > 0)
                  .fold<double>(0.0, (sum, ms) => sum + ms);
              final count = state.playerAnswers
                  .where((a) => a.timeMs.isFinite && a.timeMs > 0)
                  .length;
              return count > 0 ? totalMs / count : 0.0;
            } catch (e) {
              return 0.0;
            }
          })();

    // Convert ghost answers to Answer for display in timeline
    List<Answer>? opponentAnswersForTimeline;
    if (state.ghostRun != null && state.opponentAnswers == null) {
      opponentAnswersForTimeline = state.ghostRun!.answers.map((ga) => Answer(
        questionIndex: ga.questionIndex,
        selectedAnswer: '',
        isCorrect: ga.isCorrect,
        timeMs: ga.timeMs,
        answeredAt: DateTime.now(),
      )).toList();
    } else if (state.opponentAnswers != null) {
      opponentAnswersForTimeline = state.opponentAnswers;
    }

    // Calculate opponent average time with safety checks
    final oppAvgTime = state.opponentAnswers != null && state.opponentAnswers!.isNotEmpty
        ? (() {
            try {
              final totalMs = state.opponentAnswers!
                  .map((a) => a.timeMs)
                  .where((ms) => ms.isFinite && ms > 0)
                  .fold<double>(0.0, (sum, ms) => sum + ms);
              final count = state.opponentAnswers!
                  .where((a) => a.timeMs.isFinite && a.timeMs > 0)
                  .length;
              return count > 0 ? totalMs / count : null;
            } catch (e) {
              return null;
            }
          })()
        : null;

    return GameResultWidget(
      score: state.playerScore,
      totalQuestions: totalQuestions,
      correctAnswers: state.correctAnswers,
      averageTime: avgTime,
      isVictory: won,
      opponentName: state.opponentName,
      eloChange: state.eloChange,
      userAnswers: state.playerAnswers,
      opponentAnswers: opponentAnswersForTimeline,
      opponentScore: state.opponentScore,
      opponentCorrectAnswers: state.opponentCorrectAnswers,
      opponentAverageTime: oppAvgTime,
      onAddFriend: state.currentMatch != null ? () {
        final currentUserId = FirebaseAuth.instance.currentUser?.uid;
        if (currentUserId != null) {
          final opponentId = state.currentMatch!.getOpponentId(currentUserId);
          if (opponentId != null && opponentId.isNotEmpty) {
            ref.read(friendsProvider.notifier).sendFriendRequest(opponentId);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Solicitud enviada a ${state.opponentName}')),
            );
          }
        }
      } : null,
      onPlayAgain: () {
        ref.read(multiplayerProvider.notifier).reset();
        context.go('/home');
      },
      onGoHome: () {
        ref.read(multiplayerProvider.notifier).reset();
        context.go('/home');
      },
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(color: AppColors.onSurface, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tertiary,
                foregroundColor: AppColors.onSurface,
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
        title: Text('¿Salir?', style: TextStyle(color: AppColors.onSurface)),
        content: Text(
          'Perderás tu progreso. ¿Estás seguro?',
          style: TextStyle(color: AppColors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('Cancelar', style: TextStyle(color: AppColors.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              ref.read(multiplayerProvider.notifier).reset();
              context.go('/home');
            },
            child: Text('Salir', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}