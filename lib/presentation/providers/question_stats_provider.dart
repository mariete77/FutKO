import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/quiz_attempt_repository_impl.dart';
import '../../domain/repositories/quiz_attempt_repository.dart';

/// Quiz attempt repository provider
final quizAttemptRepositoryProvider = Provider<QuizAttemptRepository>((ref) {
  return QuizAttemptRepositoryImpl();
});

/// Provider: Preguntas más falladas (top 10)
final mostFailedQuestionsProvider =
    FutureProvider<List<QuestionStats>>((ref) async {
  final repo = ref.watch(quizAttemptRepositoryProvider);
  final result = await repo.getMostFailedQuestions(limit: 10, minAttempts: 1);
  return result.fold((failure) => throw Exception(failure.message), (data) => data);
});

/// Provider: Preguntas más acertadas (top 10)
final easiestQuestionsProvider =
    FutureProvider<List<QuestionStats>>((ref) async {
  final repo = ref.watch(quizAttemptRepositoryProvider);
  final result = await repo.getEasiestQuestions(limit: 10, minAttempts: 1);
  return result.fold((failure) => throw Exception(failure.message), (data) => data);
});

/// Provider: Estadísticas por tipo de pregunta
final statsByTypeProvider =
    FutureProvider<Map<String, TypeStats>>((ref) async {
  final repo = ref.watch(quizAttemptRepositoryProvider);
  final result = await repo.getStatsByType();
  return result.fold((failure) => throw Exception(failure.message), (data) => data);
});

/// Provider para filtro de tipo de pregunta
final questionTypeFilterProvider = StateProvider<String?>((ref) {
  return null; // null = sin filtro, muestra todas
});
