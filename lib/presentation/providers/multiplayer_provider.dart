import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/repositories/match_repository_impl.dart';
import '../../data/repositories/question_repository_impl.dart';
import '../../domain/entities/match.dart';
import '../../domain/entities/question.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/match_repository.dart';
import '../../domain/repositories/question_repository.dart';
import '../../domain/repositories/quiz_attempt_repository.dart';
import '../../data/repositories/quiz_attempt_repository_impl.dart';
import '../../data/models/quiz_attempt_model.dart';
import '../../core/constants/game_constants.dart';
import '../../core/utils/score_calculator.dart';
import '../../core/utils/fuzzy_matcher.dart';
import '../../core/utils/elo_calculator.dart';
import '../../core/utils/league_system.dart';
import '../../services/audio_service.dart';
import 'user_provider.dart';

/// Repository providers
final matchRepositoryProvider = Provider<MatchRepository>((ref) {
  return MatchRepositoryImpl();
});

final questionRepositoryMultiProvider = Provider<QuestionRepository>((ref) {
  return QuestionRepositoryImpl();
});

/// Quiz attempt repository provider for multiplayer
final quizAttemptRepositoryMultiProvider = Provider<QuizAttemptRepository>((ref) {
  return QuizAttemptRepositoryImpl();
});

/// Multiplayer game mode
enum MultiplayerMode { casual, ranked, friendChallenge }

/// Multiplayer state
enum MultiplayerStatus {
  idle,
  searching,
  found,
  playing,
  finished,
  error,
}

/// Multiplayer game state
class MultiplayerState {
  final MultiplayerStatus status;
  final MultiplayerMode mode;
  final GameMatch? currentMatch;
  final List<Question> questions;
  final int currentQuestionIndex;
  final int timeRemaining;
  final int playerScore;
  final int opponentScore;
  final List<Answer> playerAnswers;
  final int correctAnswers;
  final int streak;
  final String? errorMessage;
  final String? opponentName;
  final int? opponentElo;
  final int opponentCorrectAnswers;
  final List<Answer>? opponentAnswers;
  final int? eloChange;
  final int? newElo;
  final int? lpDelta;
  final bool promoted;
  final bool relegated;
  final int? newLeagueTier;
  final String? invitedFriendId;

  const MultiplayerState({
    this.status = MultiplayerStatus.idle,
    this.mode = MultiplayerMode.casual,
    this.currentMatch,
    this.questions = const [],
    this.currentQuestionIndex = 0,
    this.timeRemaining = 0,
    this.playerScore = 0,
    this.opponentScore = 0,
    this.playerAnswers = const [],
    this.correctAnswers = 0,
    this.streak = 0,
    this.errorMessage,
    this.opponentName,
    this.opponentElo,
    this.opponentCorrectAnswers = 0,
    this.opponentAnswers,
    this.eloChange,
    this.newElo,
    this.lpDelta,
    this.promoted = false,
    this.relegated = false,
    this.newLeagueTier,
    this.invitedFriendId,
  });

  double calculatePerformanceScore() {
    double totalPerformance = 0.0;
    for (final answer in playerAnswers) {
      if (answer.isCorrect) {
        totalPerformance += 1.0;
        if (answer.timeMs < 2000) {
          totalPerformance += 0.5;
        } else if (answer.timeMs < 5000) {
          totalPerformance += 0.2;
        }
      }
    }
    return totalPerformance;
  }

  double? get opponentPerformanceScore {
    if (opponentAnswers == null) return null;
    
    double totalPerformance = 0.0;
    for (final answer in opponentAnswers!) {
      if (answer.isCorrect) {
        totalPerformance += 1.0;
        if (answer.timeMs < 2000) totalPerformance += 0.5;
        else if (answer.timeMs < 5000) totalPerformance += 0.2;
      }
    }
    return totalPerformance;
  }

  MultiplayerState copyWith({
    MultiplayerStatus? status,
    MultiplayerMode? mode,
    GameMatch? currentMatch,
    List<Question>? questions,
    int? currentQuestionIndex,
    int? timeRemaining,
    int? playerScore,
    int? opponentScore,
    List<Answer>? playerAnswers,
    int? correctAnswers,
    int? streak,
    String? errorMessage,
    String? opponentName,
    int? opponentElo,
    int? opponentCorrectAnswers,
    List<Answer>? opponentAnswers,
    int? eloChange,
    int? newElo,
    int? lpDelta,
    bool? promoted,
    bool? relegated,
    int? newLeagueTier,
    String? invitedFriendId,
  }) {
    return MultiplayerState(
      status: status ?? this.status,
      mode: mode ?? this.mode,
      currentMatch: currentMatch ?? this.currentMatch,
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      playerScore: playerScore ?? this.playerScore,
      opponentScore: opponentScore ?? this.opponentScore,
      playerAnswers: playerAnswers ?? this.playerAnswers,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      streak: streak ?? this.streak,
      errorMessage: errorMessage ?? this.errorMessage,
      opponentName: opponentName ?? this.opponentName,
      opponentElo: opponentElo ?? this.opponentElo,
      opponentCorrectAnswers: opponentCorrectAnswers ?? this.opponentCorrectAnswers,
      opponentAnswers: opponentAnswers ?? this.opponentAnswers,
      eloChange: eloChange ?? this.eloChange,
      newElo: newElo ?? this.newElo,
      lpDelta: lpDelta ?? this.lpDelta,
      promoted: promoted ?? this.promoted,
      relegated: relegated ?? this.relegated,
      newLeagueTier: newLeagueTier ?? this.newLeagueTier,
      invitedFriendId: invitedFriendId ?? this.invitedFriendId,
    );
  }
}

/// Multiplayer game notifier
class MultiplayerNotifier extends StateNotifier<MultiplayerState> {
  final Ref _ref;
  Timer? _timer;
  Timer? _matchmakingTimer; // Overall timeout (60s)
  Timer? _searchTimer; // Periodic re-query timer (3s)
  StreamSubscription? _matchSubscription;
  List<Question> _questions = [];
  String? _pendingMatchId; // Track match ID for cancellation

  MultiplayerNotifier(this._ref) : super(const MultiplayerState()) {
    // Cleanup on dispose
    _ref.onDispose(() {
      _timer?.cancel();
      _matchmakingTimer?.cancel();
      _searchTimer?.cancel();
      _matchSubscription?.cancel();
    });
  }

  /// Get current user ID
  String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;

  /// Get current user ELO (defaults to 1000 if profile not loaded)
  int get _userElo => _ref.read(userNotifierProvider).valueOrNull?.elo ?? 1000;

  /// Whether the user can still play [mode] today given the freemium limits.
  bool _canPlay(User user, MultiplayerMode mode) {
    if (mode == MultiplayerMode.friendChallenge) return true; // no cuenta
    final isRanked = mode == MultiplayerMode.ranked;
    final daily = user.dailyGames;
    final played = daily.isToday
        ? (isRanked ? daily.rankedPlayed : daily.casualPlayed)
        : 0;
    final limit = isRanked
        ? (user.isPremium
            ? GameConstants.premiumRankedGamesPerDay
            : GameConstants.freeRankedGamesPerDay)
        : (user.isPremium ? 1 << 30 : GameConstants.freeCasualGamesPerDay);
    return played < limit;
  }

  /// Start searching for a match
  Future<void> startMatchmaking(MultiplayerMode mode) async {
    if (_currentUserId == null) {
      state = state.copyWith(
        status: MultiplayerStatus.error,
        errorMessage: 'No autenticado',
      );
      return;
    }

    final user = _ref.read(userNotifierProvider).valueOrNull;
    if (user != null && !_canPlay(user, mode)) {
      state = state.copyWith(
        status: MultiplayerStatus.error,
        errorMessage:
            'Has alcanzado tu límite diario de partidas. Hazte Premium para jugar sin límites.',
      );
      return;
    }

    state = state.copyWith(
      status: MultiplayerStatus.searching,
      mode: mode,
      errorMessage: null,
    );

    try {
      await _startPvPMatch(mode);
    } catch (e) {
      state = state.copyWith(
        status: MultiplayerStatus.error,
        errorMessage: 'Error al iniciar búsqueda: $e',
      );
    }
  }

  /// Start a PvP match: try to join an existing waiting match, otherwise create one
  Future<void> _startPvPMatch(MultiplayerMode mode) async {
    final matchType =
        mode == MultiplayerMode.ranked ? MatchType.ranked : MatchType.casual;
    final baseElo = _userElo;

    _matchmakingTimer?.cancel();

    final findResult = await _ref.read(matchRepositoryProvider).findWaitingMatch(
          mode: mode.name,
          playerElo: baseElo,
          userId: _currentUserId!,
        );

    final foundMatch = findResult.fold<GameMatch?>(
      (failure) => null,
      (match) => match,
    );

    if (foundMatch != null) {
      await _joinExistingMatch(foundMatch);
    } else {
      await _createAndWaitForOpponent(matchType, baseElo);
    }
  }

  /// Pre-generate random questions for a new match
  Future<List<Question>?> _generateQuestions() async {
    final result = await _ref
        .read(questionRepositoryMultiProvider)
        .getRandomQuestions(count: GameConstants.questionsPerMatch);

    return result.fold(
      (failure) => null,
      (questions) => questions.isEmpty ? null : questions,
    );
  }

  /// Load questions by IDs (so both players get the same set)
  Future<List<Question>?> _loadQuestionsByIds(List<String> questionIds) async {
    if (questionIds.isEmpty) return null;

    final result = await _ref
        .read(questionRepositoryMultiProvider)
        .getQuestionsByIds(questionIds);

    return result.fold(
      (failure) => null,
      (questions) => questions.isEmpty ? null : questions,
    );
  }

  /// Join an existing waiting match
  Future<void> _joinExistingMatch(GameMatch existingMatch) async {
    final joinResult = await _ref.read(matchRepositoryProvider).joinMatch(
          matchId: existingMatch.id,
          userId: _currentUserId!,
        );

    await joinResult.fold(
      (failure) async {
        // Join failed (someone else joined first) — create our own match
        await _createAndWaitForOpponent(existingMatch.type, _userElo);
      },
      (joinedMatch) async {
        final questions = await _loadQuestionsByIds(joinedMatch.questionIds);

        if (questions == null) {
          final fallbackQuestions = await _generateQuestions();
          if (fallbackQuestions == null) {
            state = state.copyWith(
              status: MultiplayerStatus.error,
              errorMessage: 'Error al cargar preguntas',
            );
            return;
          }
          _questions = fallbackQuestions;
        } else {
          _questions = questions;
        }

        final opponentId = _currentUserId != null
            ? joinedMatch.getOpponentId(_currentUserId!)
            : null;
        final opponentName = opponentId != null
            ? await _getOpponentDisplayName(opponentId)
            : 'Oponente';

        state = state.copyWith(
          status: MultiplayerStatus.found,
          currentMatch: joinedMatch,
          opponentName: opponentName,
        );
      },
    );
  }

  /// Create a new match and wait for opponent
  Future<void> _createAndWaitForOpponent(MatchType matchType, int creatorElo) async {
    // Pre-generate questions so both players get the same set
    final questions = await _generateQuestions();
    if (questions == null) {
      state = state.copyWith(
        status: MultiplayerStatus.error,
          errorMessage: 'Error al generar preguntas',
      );
      return;
    }
    _questions = questions;

    // Create match with pre-generated question IDs
    final newMatch = GameMatch(
      id: '',
      players: [_currentUserId!],
      mode: MatchMode.async,
      type: matchType,
      status: MatchStatus.waiting,
      questionIds: questions.map((q) => q.id).toList(),
      answers: {},
      createdAt: DateTime.now(),
      creatorElo: creatorElo,
    );

    final result = await _ref.read(matchRepositoryProvider).createMatch(newMatch);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: MultiplayerStatus.error,
          errorMessage: 'Error al crear partida: ${failure.message}',
        );
      },
      (matchId) {
        _pendingMatchId = matchId;
        // Watch the match for opponent joining (via snapshot listener)
        _watchForOpponent(matchId);

        // Periodically re-query for OTHER waiting matches (fixes race condition)
        // When both players start at the same time, neither finds the other's match.
        // This timer re-searches every 3 seconds to discover newly created matches.
        _searchTimer = Timer.periodic(
          const Duration(seconds: 3),
          (timer) async {
            if (state.status != MultiplayerStatus.searching) {
              timer.cancel();
              return;
            }

            final findResult = await _ref.read(matchRepositoryProvider).findWaitingMatch(
                  mode: state.mode.name,
                  playerElo: _userElo,
                  userId: _currentUserId!,
                );

            findResult.fold(
              (_) {}, // ignore errors, keep waiting
              (match) {
                if (match != null && match.id != _pendingMatchId) {
                  // Found another player's match — cancel ours and join theirs
                  timer.cancel();
                  _cancelMatchmaking(_pendingMatchId!);
                  _joinExistingMatch(match);
                }
              },
            );
          },
        );

        // Overall timeout — show error after 60 seconds
        _matchmakingTimer = Timer(
          Duration(milliseconds: GameConstants.matchmakingTimeoutMs),
          () {
            if (state.status == MultiplayerStatus.searching) {
              _searchTimer?.cancel();
              _cancelMatchmaking(matchId);
              state = state.copyWith(
                status: MultiplayerStatus.error,
                errorMessage: 'No se encontró oponente. Inténtalo de nuevo.',
              );
            }
          },
        );
      },
    );
  }

  /// Watch match for opponent
  void _watchForOpponent(String matchId) {
    _matchSubscription?.cancel();
    _matchSubscription = _ref
        .read(matchRepositoryProvider)
        .watchMatch(matchId)
        .listen((gameMatch) {
      if (gameMatch.players.length >= 2 && state.status == MultiplayerStatus.searching) {
        _matchmakingTimer?.cancel();
        _onOpponentFound(gameMatch);
      }
    });
  }

  /// Called when opponent is found (creator side - questions already generated)
  Future<void> _onOpponentFound(GameMatch match) async {
    // Questions already set from _createAndWaitForOpponent
    // Just update match status to active
    final updatedMatch = GameMatch(
      id: match.id,
      players: match.players,
      mode: match.mode,
      type: match.type,
      status: MatchStatus.active,
      questionIds: match.questionIds.isNotEmpty
          ? match.questionIds
          : _questions.map((q) => q.id).toList(),
      answers: match.answers,
      createdAt: match.createdAt,
      startedAt: DateTime.now(),
    );

    await _ref.read(matchRepositoryProvider).updateMatch(match.id, updatedMatch);

    final opponentId = _currentUserId != null
        ? updatedMatch.getOpponentId(_currentUserId!)
        : null;
    final opponentName = opponentId != null
        ? await _getOpponentDisplayName(opponentId)
        : 'Oponente';

    state = state.copyWith(
      status: MultiplayerStatus.found,
      currentMatch: updatedMatch,
      opponentName: opponentName,
    );
  }

  /// Cancel matchmaking — only marks the match as cancelled if still 'waiting'
  /// Uses a transaction so it won't corrupt a match that just got an opponent
  Future<void> _cancelMatchmaking(String matchId) async {
    _matchSubscription?.cancel();
    _matchmakingTimer?.cancel();
    _searchTimer?.cancel();

    await _ref.read(matchRepositoryProvider).cancelIfWaiting(matchId);
  }

  /// Cancel matchmaking from UI
  Future<void> cancelSearch() async {
    if (_pendingMatchId != null) {
      await _cancelMatchmaking(_pendingMatchId!);
      _pendingMatchId = null;
    }
    _reset();
  }

  /// Challenge a specific friend to a match
  Future<void> challengeFriend(String friendId, {String? friendName, int? friendElo}) async {
    if (_currentUserId == null) {
      state = state.copyWith(status: MultiplayerStatus.error, errorMessage: 'Not authenticated');
      return;
    }
    if (friendId == _currentUserId) {
      state = state.copyWith(status: MultiplayerStatus.error, errorMessage: 'Cannot challenge yourself');
      return;
    }
    state = state.copyWith(status: MultiplayerStatus.searching, mode: MultiplayerMode.friendChallenge, errorMessage: null);
    try {
      String name = friendName ?? 'Amigo'; int elo = friendElo ?? 1000;
      if (friendName == null || friendElo == null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(friendId).get();
        if (doc.exists) { final d = doc.data()!; name = d['displayName'] ?? name; elo = d['elo'] ?? elo; }
      }
      final r = await _ref.read(questionRepositoryMultiProvider).getRandomQuestions(count: GameConstants.questionsPerMatch);
      r.fold(
        (failure) => state = state.copyWith(status: MultiplayerStatus.error, errorMessage: 'Failed to load questions'),
        (qs) { _questions = qs; state = state.copyWith(status: MultiplayerStatus.found, opponentName: name, opponentElo: elo, invitedFriendId: friendId); },
      );
    } catch (e) { state = state.copyWith(status: MultiplayerStatus.error, errorMessage: 'Error al crear reto: $e'); }
  }

  /// Public entry point for the VS screen to start the match
  void startPlaying() => _startPlaying();

  /// Start playing the match
  void _startPlaying() {
    if (_questions.isEmpty) {
      state = state.copyWith(
        status: MultiplayerStatus.error,
        errorMessage: 'No questions loaded',
      );
      return;
    }

    final secondsPerQuestion = _questions.first.options.isEmpty
        ? GameConstants.secondsPerTypeQuestion
        : GameConstants.secondsPerQuestion;

    state = state.copyWith(
      status: MultiplayerStatus.playing,
      questions: _questions,
      currentQuestionIndex: 0,
      timeRemaining: secondsPerQuestion,
      playerScore: 0,
      opponentScore: 0,
      playerAnswers: [],
      correctAnswers: 0,
      streak: 0,
    );

    _startTimer();
  }

  /// Start timer for current question
  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (state.status != MultiplayerStatus.playing) {
          timer.cancel();
          return;
        }

        if (state.timeRemaining <= 1) {
          timer.cancel();
          submitAnswer(selectedAnswer: '', isTimeout: true);
        } else {
          state = state.copyWith(timeRemaining: state.timeRemaining - 1);
        }
      },
    );
  }

  /// Submit answer for current question
  void submitAnswer({
    required String selectedAnswer,
    bool isTimeout = false,
  }) {
    if (state.status != MultiplayerStatus.playing) return;
    _timer?.cancel();

    final currentIndex = state.currentQuestionIndex;
    if (currentIndex >= _questions.length) return;

    final question = _questions[currentIndex];
    final isCorrect = !isTimeout && question.isCorrect(selectedAnswer);

    final questionScore = calculateQuestionScore(
      isCorrect: isCorrect,
      timeRemaining: state.timeRemaining,
      streak: state.streak,
      isTimeout: isTimeout,
    );

    final maxTime = question.options.isEmpty
        ? GameConstants.secondsPerTypeQuestion
        : GameConstants.secondsPerQuestion;

    final answer = Answer(
      questionIndex: currentIndex,
      selectedAnswer: selectedAnswer,
      isCorrect: isCorrect,
      timeMs: (maxTime - state.timeRemaining) * 1000,
      answeredAt: DateTime.now(),
    );

    // Track quiz attempt for analytics (fire and forget, don't block gameplay)
    _trackQuizAttempt(
      question: question,
      selectedAnswer: selectedAnswer,
      isCorrect: isCorrect,
      isTimeout: isTimeout,
      timeMs: answer.timeMs,
    );

    final updatedAnswers = [...state.playerAnswers, answer];
    final newScore = state.playerScore + questionScore;
    final newCorrect = isCorrect ? state.correctAnswers + 1 : state.correctAnswers;
    final newStreak = isCorrect ? state.streak + 1 : 0;

    int newOpponentScore = state.opponentScore;

    // Move to next question or finish
    final nextIndex = currentIndex + 1;

    // Update state with answer result then transition
    state = state.copyWith(
      playerScore: newScore,
      opponentScore: newOpponentScore,
      playerAnswers: updatedAnswers,
      correctAnswers: newCorrect,
      streak: newStreak,
    );

    // Transition after delay
    final delayMs = isTimeout
        ? GameConstants.answeredDelayTimeoutMs
        : isCorrect
            ? GameConstants.answeredDelayCorrectMs
            : GameConstants.answeredDelayIncorrectMs;

    Future.delayed(Duration(milliseconds: delayMs), () {
      if (nextIndex >= _questions.length) {
        _finishMatch();
      } else {
        final nextQuestion = _questions[nextIndex];
        final seconds = nextQuestion.options.isEmpty
            ? GameConstants.secondsPerTypeQuestion
            : GameConstants.secondsPerQuestion;

        state = state.copyWith(
          currentQuestionIndex: nextIndex,
          timeRemaining: seconds,
        );
        _startTimer();
      }
    });
  }

  /// Track quiz attempt to Firestore for analytics in multiplayer mode
  /// This is a fire-and-forget operation that doesn't block gameplay
  void _trackQuizAttempt({
    required Question question,
    required String selectedAnswer,
    required bool isCorrect,
    required bool isTimeout,
    required int timeMs,
  }) {
    try {
      final attemptRepository = _ref.read(quizAttemptRepositoryMultiProvider);
      final auth = FirebaseAuth.instance;

      final matchModeStr = state.mode == MultiplayerMode.ranked
          ? 'ranked'
          : state.mode == MultiplayerMode.friendChallenge
              ? 'friend_challenge'
              : 'casual';

      final attempt = QuizAttemptModel(
        questionId: question.id,
        questionType: question.type.name,
        questionDifficulty: question.difficulty.name,
        correctAnswer: question.correctAnswer,
        userAnswer: selectedAnswer,
        isCorrect: isCorrect,
        isTimeout: isTimeout,
        timeMs: timeMs,
        matchId: state.currentMatch?.id ?? 'unknown',
        matchMode: state.currentMatch?.mode == MatchMode.realtime ? 'realtime' : 'async',
        matchType: matchModeStr,
        userId: auth.currentUser?.uid,
        userElo: _userElo,
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

  /// Submit typed answer
  void submitTypedAnswer({required String typedAnswer}) {
    if (state.status != MultiplayerStatus.playing) return;
    _timer?.cancel();

    final currentIndex = state.currentQuestionIndex;
    if (currentIndex >= _questions.length) return;

    final question = _questions[currentIndex];
    final similarity = answerSimilarity(typedAnswer, question.correctAnswer);
    final isCorrect = similarity >= 0.6; // 60%+ counts as correct (partial credit)

    final maxTime = question.options.isEmpty
        ? GameConstants.secondsPerTypeQuestion
        : GameConstants.secondsPerQuestion;

    final questionScore = calculateTypedScore(
      similarity: similarity,
      timeRemaining: state.timeRemaining,
      maxTime: maxTime,
      streak: state.streak,
    );

    final answer = Answer(
      questionIndex: currentIndex,
      selectedAnswer: typedAnswer,
      isCorrect: isCorrect,
      timeMs: (maxTime - state.timeRemaining) * 1000,
      answeredAt: DateTime.now(),
    );

    final updatedAnswers = [...state.playerAnswers, answer];
    final newScore = state.playerScore + questionScore;
    final newCorrect = isCorrect ? state.correctAnswers + 1 : state.correctAnswers;
    final newStreak = isCorrect ? state.streak + 1 : 0;

    int newOpponentScore = state.opponentScore;

    state = state.copyWith(
      playerScore: newScore,
      opponentScore: newOpponentScore,
      playerAnswers: updatedAnswers,
      correctAnswers: newCorrect,
      streak: newStreak,
    );

    final nextIndex = currentIndex + 1;
    final delayMs = isCorrect
        ? GameConstants.answeredDelayCorrectMs
        : GameConstants.answeredDelayIncorrectMs;

    Future.delayed(Duration(milliseconds: delayMs), () {
      if (nextIndex >= _questions.length) {
        _finishMatch();
      } else {
        final nextQuestion = _questions[nextIndex];
        final seconds = nextQuestion.options.isEmpty
            ? GameConstants.secondsPerTypeQuestion
            : GameConstants.secondsPerQuestion;

        state = state.copyWith(
          currentQuestionIndex: nextIndex,
          timeRemaining: seconds,
        );
        _startTimer();
      }
    });
  }

  /// Finish the match
  Future<void> _finishMatch() async {
    try {
      _timer?.cancel();
      _matchSubscription?.cancel();

      final currentMatch = state.currentMatch;
      final currentUserId = _currentUserId;

      // ── 1. Submit local answers ────────────────
      if (currentUserId != null && state.playerAnswers.isNotEmpty) {
        // Submit each answer to Firestore match collection
        if (currentMatch != null) {
          for (final answer in state.playerAnswers) {
            await _ref.read(matchRepositoryProvider).submitAnswer(
                  currentMatch.id,
                  answer,
                );
          }
        }
      }

      // ── 2. Fetch opponent answers and calculate scores ────────
      List<Answer>? opponentAnswers;
      int calculatedOpponentScore = 0;
      int calculatedOpponentCorrect = 0;

      if (currentMatch != null && currentUserId != null) {
        final opponentId = currentMatch.getOpponentId(currentUserId);
        if (opponentId != null && opponentId.isNotEmpty) {
          final answersResult = await _ref.read(matchRepositoryProvider).getPlayerAnswers(
                matchId: currentMatch.id,
                userId: opponentId,
              );

          answersResult.fold(
            (failure) => null, // Continue with 0 points for opponent
            (answers) {
              opponentAnswers = answers;
              for (final ans in answers) {
                if (ans.isCorrect) {
                  calculatedOpponentCorrect++;
                  if (ans.questionIndex < _questions.length) {
                    final q = _questions[ans.questionIndex];
                    final maxTime = q.options.isEmpty
                        ? GameConstants.secondsPerTypeQuestion
                        : GameConstants.secondsPerQuestion;
                    calculatedOpponentScore += calculateQuestionScore(
                      isCorrect: true,
                      timeRemaining: maxTime - (ans.timeMs ~/ 1000),
                      streak: 0,
                      isTimeout: false,
                    );
                  }
                }
              }
            },
          );
        }
      }

      // Update state with opponent info BEFORE final ELO calculation
      state = state.copyWith(
        opponentScore: calculatedOpponentScore,
        opponentCorrectAnswers: calculatedOpponentCorrect,
        opponentAnswers: opponentAnswers,
      );

      // ── 3. ELO and Results calculation ────────────────────────
      final isRanked = state.mode == MultiplayerMode.ranked;
      int? eloChange;
      int? newElo;
      MatchResult? matchResult;
      int matchLpDelta = 0;
      bool matchPromoted = false;
      bool matchRelegated = false;
      int? matchNewTier;

      if (currentUserId != null) {
        final userState = _ref.read(userNotifierProvider);
        final currentUser = userState.valueOrNull;
        final playerElo = currentUser?.elo ?? GameConstants.initialElo;
        final gamesPlayed = currentUser?.stats.totalGames ?? 0;

        final opponentElo = state.opponentElo ?? GameConstants.initialElo;

        // Calculate performance score (score + speed)
        final playerPerf = state.calculatePerformanceScore();
        final oppPerf = state.opponentPerformanceScore ?? 0.0;

        double score;
        if (playerPerf > oppPerf) score = 1.0;
        else if (playerPerf < oppPerf) score = 0.0;
        else score = 0.5;

        final eloCalc = EloCalculator();
        eloChange = eloCalc.calculateChange(
          playerElo: playerElo,
          opponentElo: opponentElo,
          score: score,
          gamesPlayed: gamesPlayed,
        );
        newElo = eloCalc.calculateNewElo(
          playerElo: playerElo,
          opponentElo: opponentElo,
          score: score,
          gamesPlayed: gamesPlayed,
        );

        // League points earned this match (modulated by the ELO expectation).
        // Only ranked matches affect ELO and league points.
        final lpDelta = LeagueSystem.lpDelta(
          playerElo: playerElo,
          opponentElo: opponentElo,
          score: score,
        );

        if (!isRanked) {
          eloChange = 0;
          newElo = playerElo;
        }

        // Calculate opponent's ELO change
        final opponentScore = 1.0 - score;
        final oppEloChange = eloCalc.calculateChange(
          playerElo: opponentElo,
          opponentElo: playerElo,
          score: opponentScore,
          gamesPlayed: gamesPlayed, // Estimate using same games count
        );
        final oppNewElo = eloCalc.calculateNewElo(
          playerElo: opponentElo,
          opponentElo: playerElo,
          score: opponentScore,
          gamesPlayed: gamesPlayed,
        );

        // Prepare MatchResult
        final opponentId = currentMatch?.getOpponentId(currentUserId);
        if (currentMatch != null && opponentId != null && opponentId.isNotEmpty) {
          matchResult = MatchResult(
            winnerId: score == 1.0 ? currentUserId : (score == 0.0 ? opponentId : null),
            scores: {
              currentUserId: state.playerScore,
              opponentId: state.opponentScore,
            },
            eloChanges: {
              currentUserId: eloChange,
              opponentId: oppEloChange,
            },
            newElo: {
              currentUserId: newElo,
              opponentId: oppNewElo,
            },
          );

          // Save results to Firestore
          await _ref.read(matchRepositoryProvider).saveMatchResult(
                matchId: currentMatch.id,
                result: matchResult,
              ).catchError((e) => print('Error saving match result: $e'));

          // Mark the match finished so the onMatchFinished Cloud Function
          // resolves ELO + league authoritatively for BOTH players. Scores are
          // already written above, so the function has what it needs. Isolated
          // so a failure here still lets us update the local profile below.
          try {
            await _ref.read(matchRepositoryProvider).finishMatch(currentMatch.id);
          } catch (e) {
            print('Error finishing match: $e');
          }
        }

        // Update local user profile
        if (currentUser != null) {
          final isWin = score == 1.0;
          final isDraw = score == 0.5;
          final newStreak = isWin ? currentUser.stats.currentWinStreak + 1 : 0;
          final bestStreak = newStreak > currentUser.stats.bestWinStreak ? newStreak : currentUser.stats.bestWinStreak;

          // Resolve league promotion/relegation (ranked only). New players are
          // shielded from relegation during their placement games.
          final league = isRanked
              ? LeagueSystem.applyMatch(
                  tier: currentUser.leagueTier,
                  leaguePoints: currentUser.leaguePoints,
                  lpDelta: lpDelta,
                  protectedFromRelegation:
                      currentUser.stats.totalGames < GameConstants.placementGames,
                )
              : LeagueResult(
                  tier: currentUser.leagueTier,
                  leaguePoints: currentUser.leaguePoints,
                  lpDelta: 0,
                  promoted: false,
                  relegated: false,
                );
          matchLpDelta = league.lpDelta;
          matchPromoted = league.promoted;
          matchRelegated = league.relegated;
          matchNewTier = league.tier;

          // Count this match toward the daily freemium limit (skip friend
          // challenges). Resets the counters when the stored day is not today.
          final dg = currentUser.dailyGames;
          final dgToday = dg.isToday;
          final newDaily = state.mode == MultiplayerMode.friendChallenge
              ? dg
              : DailyGames(
                  date: DateTime.now(),
                  casualPlayed:
                      (dgToday ? dg.casualPlayed : 0) + (isRanked ? 0 : 1),
                  rankedPlayed:
                      (dgToday ? dg.rankedPlayed : 0) + (isRanked ? 1 : 0),
                );

          // Stats + dailyGames are client-owned (immediate, robust if the
          // function is delayed/undeployed). ELO and league are resolved
          // authoritatively by the Cloud Function; the optimistic values
          // computed above (newElo, league.*) feed only the result UI via state.
          final updatedUser = currentUser.copyWith(
            dailyGames: newDaily,
            stats: currentUser.stats.copyWith(
              totalGames: currentUser.stats.totalGames + 1,
              wins: currentUser.stats.wins + (isWin ? 1 : 0),
              losses: currentUser.stats.losses + (!isWin && !isDraw ? 1 : 0),
              draws: currentUser.stats.draws + (isDraw ? 1 : 0),
              totalCorrectAnswers: currentUser.stats.totalCorrectAnswers + state.correctAnswers,
              currentWinStreak: newStreak,
              bestWinStreak: bestStreak,
            ),
          );

          await _ref.read(userNotifierProvider.notifier).updateUserProfile(updatedUser)
              .catchError((e) => print('Error updating user profile: $e'));
        }

        // Final state transition
        state = state.copyWith(
          status: MultiplayerStatus.finished,
          eloChange: eloChange,
          newElo: newElo,
          lpDelta: matchLpDelta,
          promoted: matchPromoted,
          relegated: matchRelegated,
          newLeagueTier: matchNewTier,
          opponentElo: (matchResult != null && opponentId != null)
              ? matchResult.newElo[opponentId]
              : state.opponentElo,
        );
      } else {
        // Fallback if no user
        state = state.copyWith(status: MultiplayerStatus.finished);
      }

      AudioService().playMatchEnd();
    } catch (e, stack) {
      print('CRITICAL ERROR in _finishMatch: $e\n$stack');
      state = state.copyWith(
        status: MultiplayerStatus.error,
        errorMessage: 'Error al finalizar la partida: $e',
      );
    }
  }

  /// Fetch opponent display name from Firestore
  Future<String> _getOpponentDisplayName(String opponentId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(opponentId)
          .get();
      return doc.data()?['displayName'] as String? ?? 'Oponente';
    } catch (_) {
      return 'Oponente';
    }
  }

  /// Reset state
  void _reset() {
    _timer?.cancel();
    _matchmakingTimer?.cancel();
    _matchSubscription?.cancel();
    _questions = [];
    state = const MultiplayerState();
  }

  /// Reset from UI
  void reset() => _reset();
}

/// Multiplayer provider
final multiplayerProvider =
    StateNotifierProvider<MultiplayerNotifier, MultiplayerState>((ref) {
  return MultiplayerNotifier(ref);
});