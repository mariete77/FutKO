import 'dart:async';
import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/repositories/question_repository_impl.dart';
import '../../data/repositories/quiz_attempt_repository_impl.dart';
import '../../domain/entities/question.dart';
import '../../domain/entities/match.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/question_repository.dart';
import '../../domain/repositories/quiz_attempt_repository.dart';
import '../../data/models/quiz_attempt_model.dart';
import '../../core/constants/game_constants.dart';
import '../../core/utils/score_calculator.dart';
import '../../core/utils/fuzzy_matcher.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import '../../services/analytics_service.dart';
import '../../services/audio_service.dart';
import '../../services/haptics_service.dart';
import 'user_provider.dart';

part 'game_provider.freezed.dart';
part 'game_provider.g.dart';

/// Question repository provider
@riverpod
QuestionRepository questionRepository(QuestionRepositoryRef ref) {
  return QuestionRepositoryImpl();
}

/// Quiz attempt repository provider
@riverpod
QuizAttemptRepository quizAttemptRepository(QuizAttemptRepositoryRef ref) {
  return QuizAttemptRepositoryImpl();
}

/// Game state
@freezed
class GameState with _$GameState {
  const factory GameState.initial() = _Initial;
  const factory GameState.loading() = _Loading;
  const factory GameState.playing({
    required List<Question> questions,
    required int currentQuestionIndex,
    required int timeRemaining,
    required int score,
    required List<Answer> userAnswers,
    required int correctAnswers,
    required int streak,
    // 50/50 hint (once per match). [hintedOptions] holds the two surviving
    // options for the current question (correct + one wrong), or null.
    @Default(false) bool hintUsed,
    List<String>? hintedOptions,
  }) = _Playing;
  const factory GameState.answered({
    required bool isCorrect,
    required String correctAnswer,
    required String selectedAnswer,
    required int score,
  }) = _Answered;
  const factory GameState.finished({
    required int score,
    required int totalQuestions,
    required int correctAnswers,
    required List<Answer> userAnswers,
    required double averageTime,
  }) = _Finished;
  const factory GameState.error({
    required String message,
  }) = _Error;
}

/// Game provider
@riverpod
class GameNotifier extends _$GameNotifier {
  Timer? _timer;
  Timer? _answeredTimer;
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;

  // Once-per-match power-ups.
  bool _hintUsed = false;
  bool _timeUsed = false;
  bool _doubleUsed = false;
  bool _doubleActive = false; // next correct answer scores double
  bool get timeUsed => _timeUsed;
  bool get doubleUsed => _doubleUsed;

  // Pending state for manual "next question" flow
  int _pendingScore = 0;
  List<Answer> _pendingUserAnswers = [];
  int _pendingCorrectAnswers = 0;
  int _pendingStreak = 0;

  // Points earned on the most recent answer (for the floating "+X" animation).
  int _lastScoreDelta = 0;
  int get lastScoreDelta => _lastScoreDelta;

  /// Streak after the most recent answer (the answered state no longer carries
  /// the playing streak, so the feedback screen reads it from here).
  int get lastStreak => _pendingStreak;

  @override
  GameState build() {
    ref.onDispose(() {
      _timer?.cancel();
      _answeredTimer?.cancel();
    });
    return const GameState.initial();
  }

  /// Start a new game
  Future<void> startGame({
    required Difficulty difficulty,
  }) async {
    state = const GameState.loading();

    try {
      // Fetch all questions (no difficulty filter) to maximize pool and reduce repeats
      final questionsResult = await ref
          .read(questionRepositoryProvider)
          .getRandomQuestions(
            count: GameConstants.questionsPerMatch,
          );

      questionsResult.fold(
        (failure) {
          state = GameState.error(message: failure.message);
        },
        (questions) {
          if (questions.isEmpty) {
            state = const GameState.error(message: 'No hay preguntas disponibles');
            return;
          }

          // Convert some questions to type-answer mode (strip options)
          _questions = _convertToTypeAnswer(questions);
          _currentQuestionIndex = 0;
          _hintUsed = false;
          _timeUsed = false;
          _doubleUsed = false;
          _doubleActive = false;

          AnalyticsService.instance.logGameStarted(
            mode: 'practice',
            difficulty: difficulty.name,
          );

          // Auto-detect time based on first question type
          final secondsPerQuestion = _getTimeForQuestion(_questions.first);

          state = GameState.playing(
            questions: _questions,
            currentQuestionIndex: 0,
            timeRemaining: secondsPerQuestion,
            score: 0,
            userAnswers: [],
            correctAnswers: 0,
            streak: 0,
          );

          _startTimer();
        },
      );
    } catch (e) {
      state = GameState.error(message: 'Error al iniciar partida: $e');
    }
  }

  /// Get appropriate time limit based on question type
  int _getTimeForQuestion(Question question) {
    // Type-answer questions (no options) get more time
    if (question.options.isEmpty) {
      return GameConstants.secondsPerTypeQuestion;
    }
    return GameConstants.secondsPerQuestion;
  }

  /// Start timer for current question
  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        final currentState = state;
        if (currentState is! _Playing) {
          timer.cancel();
          return;
        }

        if (currentState.timeRemaining <= 1) {
          timer.cancel();
          AudioService().playRedCard();
          submitAnswer(
            selectedAnswer: '',
            isTimeout: true,
          );
        } else {
          // Countdown en últimos 3 segundos
          if (currentState.timeRemaining <= 3) {
            AudioService().playCountdown();
            HapticsService().countdownTick();
          }
          state = currentState.copyWith(
            timeRemaining: currentState.timeRemaining - 1,
          );
        }
      },
    );
  }

  /// Submit a typed answer for type-answer mode
  void submitTypedAnswer({
    required String typedAnswer,
  }) {
    final currentState = state;
    if (currentState is! _Playing) return;

    _timer?.cancel();

    final question = currentState.questions[currentState.currentQuestionIndex];
    final similarity = answerSimilarity(typedAnswer, question.correctAnswer);
    final isCorrect = similarity >= 0.6; // 60%+ counts as correct (partial credit)

    final maxTime = _getTimeForQuestion(question);

    final baseScore = calculateTypedScore(
      similarity: similarity,
      timeRemaining: currentState.timeRemaining,
      maxTime: maxTime,
      streak: currentState.streak,
    );
    final questionScore =
        (_doubleActive && isCorrect) ? baseScore * 2 : baseScore;
    if (_doubleActive && isCorrect) _doubleActive = false;

    final answer = Answer(
      questionIndex: currentState.currentQuestionIndex,
      selectedAnswer: typedAnswer,
      isCorrect: isCorrect,
      timeMs: (maxTime - currentState.timeRemaining) * 1000,
      answeredAt: DateTime.now(),
    );

    final updatedAnswers = [...currentState.userAnswers, answer];
    final newScore = currentState.score + questionScore;
    final newCorrectAnswers = isCorrect ? currentState.correctAnswers + 1 : currentState.correctAnswers;
    final newStreak = isCorrect ? currentState.streak + 1 : 0;

    _transitionToAnswered(
      isCorrect: isCorrect,
      isTimeout: false,
      question: question,
      selectedAnswer: typedAnswer,
      newScore: newScore,
      scoreDelta: questionScore,
      updatedAnswers: updatedAnswers,
      newCorrectAnswers: newCorrectAnswers,
      newStreak: newStreak,
    );
  }

  /// Submit answer for current question
  void submitAnswer({
    required String selectedAnswer,
    required bool isTimeout,
  }) {
    final currentState = state;
    if (currentState is! _Playing) return;

    _timer?.cancel();

    final question = currentState.questions[currentState.currentQuestionIndex];
    final isCorrect = !isTimeout && question.isCorrect(selectedAnswer);

    // Calculate score (x2 if the double-points power-up is active)
    final baseScore = calculateQuestionScore(
      isCorrect: isCorrect,
      timeRemaining: currentState.timeRemaining,
      streak: currentState.streak,
      isTimeout: isTimeout,
    );
    final questionScore =
        (_doubleActive && isCorrect) ? baseScore * 2 : baseScore;
    if (_doubleActive && isCorrect) _doubleActive = false;

    // Create answer record - use appropriate time for this question type
    final maxTime = _getTimeForQuestion(question);
    final answer = Answer(
      questionIndex: currentState.currentQuestionIndex,
      selectedAnswer: selectedAnswer,
      isCorrect: isCorrect,
      timeMs: (maxTime - currentState.timeRemaining) * 1000,
      answeredAt: DateTime.now(),
    );

    AnalyticsService.instance.logQuestionAnswered(
      type: question.type.name,
      correct: isCorrect,
    );

    // Track quiz attempt for analytics (fire and forget, don't block gameplay)
    _trackQuizAttempt(
      question: question,
      selectedAnswer: selectedAnswer,
      isCorrect: isCorrect,
      isTimeout: isTimeout,
      timeMs: answer.timeMs,
    );

    // Update user answers list
    final updatedAnswers = [...currentState.userAnswers, answer];

    // Calculate new state
    final newScore = currentState.score + questionScore;
    final newCorrectAnswers =
        isCorrect ? currentState.correctAnswers + 1 : currentState.correctAnswers;
    final newStreak = isCorrect ? currentState.streak + 1 : 0;

    // Transition to answered state with appropriate delay
    _transitionToAnswered(
      isCorrect: isCorrect,
      isTimeout: isTimeout,
      question: question,
      selectedAnswer: selectedAnswer,
      newScore: newScore,
      scoreDelta: questionScore,
      updatedAnswers: updatedAnswers,
      newCorrectAnswers: newCorrectAnswers,
      newStreak: newStreak,
    );
  }

  /// Track quiz attempt to Firestore for analytics
  /// This is a fire-and-forget operation that doesn't block gameplay
  void _trackQuizAttempt({
    required Question question,
    required String selectedAnswer,
    required bool isCorrect,
    required bool isTimeout,
    required int timeMs,
  }) {
    try {
      final attemptRepository = ref.read(quizAttemptRepositoryProvider);
      final auth = FirebaseAuth.instance;

      final attempt = QuizAttemptModel(
        questionId: question.id,
        questionType: question.type.name,
        questionDifficulty: question.difficulty.name,
        correctAnswer: question.correctAnswer,
        userAnswer: selectedAnswer,
        isCorrect: isCorrect,
        isTimeout: isTimeout,
        timeMs: timeMs,
        matchId: 'practice-${DateTime.now().millisecondsSinceEpoch}', // Practice mode
        matchMode: 'practice',
        matchType: 'casual',
        userId: auth.currentUser?.uid,
        userElo: null, // Practice mode doesn't track ELO
        answeredAt: DateTime.now(),
        questionData: question.extraData,
      );

      // Record attempt asynchronously, don't await to avoid blocking gameplay
      attemptRepository.recordAttempt(attempt).then((_) {
        // Success - optionally log for debugging
      }).catchError((error) {
        // Log error but don't crash the game
        print('Failed to track quiz attempt: $error');
      });
    } catch (e) {
      // Catch all errors to prevent affecting gameplay
      print('Error tracking quiz attempt: $e');
    }
  }

  /// Transition to answered state with appropriate delay
  void _transitionToAnswered({
    required bool isCorrect,
    required bool isTimeout,
    required Question question,
    required String selectedAnswer,
    required int newScore,
    required int scoreDelta,
    required List<Answer> updatedAnswers,
    required int newCorrectAnswers,
    required int newStreak,
  }) {
    final displayAnswer = isTimeout ? "¡Se acabó el tiempo!" : selectedAnswer;

    // Store pending values for manual next-question flow
    _pendingScore = newScore;
    _pendingUserAnswers = updatedAnswers;
    _pendingCorrectAnswers = newCorrectAnswers;
    _pendingStreak = newStreak;
    _lastScoreDelta = scoreDelta;

    state = GameState.answered(
      isCorrect: isCorrect,
      correctAnswer: question.correctAnswer,
      selectedAnswer: displayAnswer,
      score: newScore,
    );

    // Determine delay based on result
    final delayMs = isTimeout
        ? GameConstants.answeredDelayTimeoutMs
        : isCorrect
            ? GameConstants.answeredDelayCorrectMs
            : GameConstants.answeredDelayIncorrectMs;

    _answeredTimer?.cancel();
    _answeredTimer = Timer(Duration(milliseconds: delayMs), () {
      nextQuestion();
    });
  }

  /// Move to next question or finish game
  /// Can be called without args (uses stored pending values) for manual tap.
  void nextQuestion({
    int? score,
    List<Answer>? userAnswers,
    int? correctAnswers,
    int? streak,
  }) {
    _answeredTimer?.cancel();

    // Use provided values or fall back to stored pending values
    final s = score ?? _pendingScore;
    final ua = userAnswers ?? _pendingUserAnswers;
    final ca = correctAnswers ?? _pendingCorrectAnswers;
    final st = streak ?? _pendingStreak;

    // Use instance variables instead of state, since state is _Answered here
    final nextIndex = _currentQuestionIndex + 1;

    if (nextIndex >= _questions.length) {
      finishGame(
        score: s,
        userAnswers: ua,
        correctAnswers: ca,
      );
    } else {
      _currentQuestionIndex = nextIndex;

      // Auto-detect time based on next question type
      final nextQuestion = _questions[nextIndex];
      final secondsPerQuestion = _getTimeForQuestion(nextQuestion);

      state = GameState.playing(
        questions: _questions,
        currentQuestionIndex: nextIndex,
        timeRemaining: secondsPerQuestion,
        score: s,
        userAnswers: ua,
        correctAnswers: ca,
        streak: st,
        // Hint stays spent for the rest of the match; new question gets full
        // options again (hintedOptions left null).
        hintUsed: _hintUsed,
      );
      _startTimer();
    }
  }

  /// Finish game and show results
  void finishGame({
    required int score,
    required List<Answer> userAnswers,
    required int correctAnswers,
  }) {
    _timer?.cancel();

    final totalTimeMs = userAnswers.fold<int>(
      0,
      (sum, answer) => sum + answer.timeMs,
    );
    final averageTime = calculateAverageTime(totalTimeMs, userAnswers.length);

    state = GameState.finished(
      score: score,
      totalQuestions: GameConstants.questionsPerMatch,
      correctAnswers: correctAnswers,
      userAnswers: userAnswers,
      averageTime: averageTime,
    );

    AudioService().playMatchEnd();

    AnalyticsService.instance.logMatchFinished(
      score: score,
      correctAnswers: correctAnswers,
    );

    _updateUserStatsAfterCasual(correctAnswers);
  }

  /// Persiste el resultado de una partida casual en el perfil del usuario:
  /// incrementa partidas jugadas, aciertos totales y el contador de partidas
  /// casuales del día.
  Future<void> _updateUserStatsAfterCasual(int correctAnswers) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final notifier = ref.read(userNotifierProvider.notifier);
      User? user = ref.read(userNotifierProvider).valueOrNull;
      if (user == null) {
        await notifier.getUserProfile(currentUser.uid);
        user = ref.read(userNotifierProvider).valueOrNull;
        if (user == null) return;
      }

      final updatedStats = user.stats.copyWith(
        totalGames: user.stats.totalGames + 1,
        totalCorrectAnswers: user.stats.totalCorrectAnswers + correctAnswers,
      );

      await notifier.updateUserProfile(
        user.copyWith(stats: updatedStats),
      );
      await notifier.recordGamePlayed(user.userId, false);
    } catch (e) {
      // No bloquear la UI si falla la persistencia.
      print('Error updating casual game stats: $e');
    }
  }

  /// Cancel game
  void cancelGame() {
    _timer?.cancel();
    _answeredTimer?.cancel();
    state = const GameState.initial();
  }

  /// Reset game state (for navigating back home)
  void resetGame() {
    _timer?.cancel();
    _answeredTimer?.cancel();
    _questions = [];
    _currentQuestionIndex = 0;
    _hintUsed = false;
    _timeUsed = false;
    _doubleUsed = false;
    _doubleActive = false;
    _pendingScore = 0;
    _pendingUserAnswers = [];
    _pendingCorrectAnswers = 0;
    _pendingStreak = 0;
    state = const GameState.initial();
  }

  /// Convert some questions to type-answer mode by stripping options
  /// Roughly 30% of questions become type-answer
  /// Comparison/selection question types are excluded because they need options to make sense
  List<Question> _convertToTypeAnswer(List<Question> questions) {
    final random = Random();

    // Tipos que NUNCA deben convertirse a type-answer porque necesitan opciones
    // para tener sentido. Los tipos comparativos geográficos del fork se
    // eliminaron; añade aquí tipos de fútbol que requieran opciones si hace falta.
    const neverConvertTypes = <QuestionType>{};

    return questions.map((q) {
      // Skip conversion for comparison/selection types
      if (neverConvertTypes.contains(q.type)) {
        return q;
      }
      // Only convert prompts whose answer is unique & not given away. The
      // seeder marks these with extraData['taEligible']; ambiguous prompts
      // (e.g. "club fundado en 1905") stay multiple-choice.
      if (q.extraData?['taEligible'] != true) {
        return q;
      }
      // 30% chance to convert to type-answer
      if (random.nextDouble() < 0.3) {
        return Question(
          id: q.id,
          type: q.type,
          difficulty: q.difficulty,
          correctAnswer: q.correctAnswer,
          options: [], // Empty options = type-answer mode
          imageUrl: q.imageUrl,
          questionText: q.questionText,
          extraData: q.extraData,
        );
      }
      return q;
    }).toList();
  }

  /// Skip to next question (for testing/debug)
  void skipQuestion() {
    final currentState = state;
    if (currentState is! _Playing) return;

    submitAnswer(
      selectedAnswer: '',
      isTimeout: true,
    );
  }

  /// Use the once-per-match 50/50 hint: reduce the current multiple-choice
  /// question's options to two — the correct answer plus one random wrong one.
  /// No-op if already used or the question can't be reduced (type-answer / ≤2
  /// options).
  void useHint() {
    final currentState = state;
    if (currentState is! _Playing) return;
    if (_hintUsed) return;

    final question = currentState.questions[currentState.currentQuestionIndex];
    final options =
        question.options.where((o) => o.trim().isNotEmpty).toList();
    if (options.length <= 2) return;

    final correctOption = options.firstWhere(
      (o) => question.isCorrect(o),
      orElse: () => question.correctAnswer,
    );
    final wrongOptions = options.where((o) => !question.isCorrect(o)).toList()
      ..shuffle();
    final kept = <String>[correctOption, wrongOptions.first]..shuffle();

    _hintUsed = true;
    state = currentState.copyWith(hintUsed: true, hintedOptions: kept);
  }

  /// +Tiempo: añade 5 segundos al cronómetro (una vez por partida).
  void addTime() {
    final currentState = state;
    if (currentState is! _Playing) return;
    if (_timeUsed) return;
    _timeUsed = true;
    state = currentState.copyWith(
      timeRemaining: currentState.timeRemaining + 5,
    );
  }

  /// Doble puntos: la siguiente respuesta correcta vale el doble (una vez).
  /// El botón se deshabilita en el siguiente tick del cronómetro.
  void useDoublePoints() {
    final currentState = state;
    if (currentState is! _Playing) return;
    if (_doubleUsed) return;
    _doubleUsed = true;
    _doubleActive = true;
  }
}

/// Current question provider
@riverpod
Question? currentQuestion(CurrentQuestionRef ref) {
  final gameState = ref.watch(gameNotifierProvider);
  return gameState.maybeWhen(
    playing: (questions, currentQuestionIndex, timeRemaining, score, userAnswers, correctAnswers, streak, hintUsed, hintedOptions) {
      if (currentQuestionIndex < questions.length) {
        return questions[currentQuestionIndex];
      }
      return null;
    },
    orElse: () => null,
  );
}

/// Progress percentage provider
@riverpod
double progressPercentage(ProgressPercentageRef ref) {
  final gameState = ref.watch(gameNotifierProvider);
  return gameState.maybeWhen(
    playing: (questions, currentQuestionIndex, timeRemaining, score, userAnswers, correctAnswers, streak, hintUsed, hintedOptions) {
      if (questions.isEmpty) return 0.0;
      return (currentQuestionIndex + 1) / questions.length;
    },
    orElse: () => 0.0,
  );
}

/// Timer progress provider (0.0 to 1.0)
@riverpod
double timerProgress(TimerProgressRef ref) {
  final gameState = ref.watch(gameNotifierProvider);
  return gameState.maybeWhen(
    playing: (questions, currentQuestionIndex, timeRemaining, score, userAnswers, correctAnswers, streak, hintUsed, hintedOptions) {
      // Use the correct max time based on current question type
      final currentQuestion = currentQuestionIndex < questions.length
          ? questions[currentQuestionIndex]
          : null;
      final maxTime = currentQuestion != null && currentQuestion.options.isEmpty
          ? GameConstants.secondsPerTypeQuestion
          : GameConstants.secondsPerQuestion;
      return timeRemaining / maxTime;
    },
    orElse: () => 0.0,
  );
}
