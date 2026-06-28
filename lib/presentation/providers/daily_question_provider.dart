import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/question_repository_impl.dart';
import '../../domain/entities/question.dart';

part 'daily_question_provider.g.dart';

@riverpod
class DailyQuestion extends _$DailyQuestion {
  @override
  Future<Question?> build() async {
    // Semilla determinista por fecha local: todos los jugadores ven la misma
    // pregunta (y el mismo orden de opciones) el mismo día. El repo usa este
    // Random tanto para el shuffle como para generar las opciones, y Firestore
    // devuelve los docs ordenados por ID, así que la selección es estable.
    final now = DateTime.now();
    final daySeed = now.year * 10000 + now.month * 100 + now.day;
    final repo = QuestionRepositoryImpl(random: Random(daySeed));
    final result = await repo.getRandomQuestions(count: 1, maxDifficulty: Difficulty.medium);
    return result.fold(
      (failure) => null,
      (questions) => questions.isNotEmpty ? questions.first : null,
    );
  }
}
