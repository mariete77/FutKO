import 'package:firebase_analytics/firebase_analytics.dart';

/// Wrapper tipado sobre Firebase Analytics para los eventos clave del juego.
/// Usa [observer] en `MaterialApp.router` para registrar vistas de pantalla.
class AnalyticsService {
  AnalyticsService._();
  static final AnalyticsService instance = AnalyticsService._();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> logGameStarted({
    required String mode,
    required String difficulty,
  }) =>
      _analytics.logEvent(
        name: 'game_started',
        parameters: {'mode': mode, 'difficulty': difficulty},
      );

  Future<void> logQuestionAnswered({
    required String type,
    required bool correct,
  }) =>
      _analytics.logEvent(
        name: 'question_answered',
        parameters: {'type': type, 'correct': correct.toString()},
      );

  Future<void> logMatchFinished({
    required int score,
    required int correctAnswers,
  }) =>
      _analytics.logEvent(
        name: 'match_finished',
        parameters: {'score': score, 'correct_answers': correctAnswers},
      );

  Future<void> logPurchaseInitiated({required String plan}) =>
      _analytics.logEvent(
        name: 'purchase_initiated',
        parameters: {'plan': plan},
      );
}
