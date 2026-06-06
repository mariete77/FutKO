import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/question_repository_impl.dart';
import '../../domain/entities/question.dart';

part 'daily_question_provider.g.dart';

@riverpod
class DailyQuestion extends _$DailyQuestion {
  @override
  Future<Question?> build() async {
    final repo = QuestionRepositoryImpl();
    final result = await repo.getRandomQuestions(count: 1, maxDifficulty: Difficulty.medium);
    return result.fold(
      (failure) => null,
      (questions) => questions.isNotEmpty ? questions.first : null,
    );
  }
}
