import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:futko/data/repositories/question_repository_impl.dart';
import 'package:futko/domain/entities/question.dart';

Question _q({
  required String id,
  required QuestionType type,
  required String correctAnswer,
  List<String> options = const [],
  Map<String, dynamic>? extraData,
}) {
  return Question(
    id: id,
    type: type,
    difficulty: Difficulty.easy,
    correctAnswer: correctAnswer,
    options: options,
    extraData: extraData,
  );
}

void main() {
  late QuestionRepositoryImpl repo;

  setUp(() {
    repo = QuestionRepositoryImpl(random: Random(42));
  });

  group('hasPlaceholderOptions', () {
    test('detects spanish placeholders', () {
      expect(
        QuestionRepositoryImpl.hasPlaceholderOptions(
          ['Opción Incorrecta A', 'Opción Incorrecta B'],
        ),
        isTrue,
      );
    });

    test('detects english placeholders', () {
      expect(
        QuestionRepositoryImpl.hasPlaceholderOptions(
          ['Option A', 'Option B'],
        ),
        isTrue,
      );
    });

    test('returns false for real options', () {
      expect(
        QuestionRepositoryImpl.hasPlaceholderOptions(
          ['Real Madrid', 'Barcelona', 'Atlético', 'Sevilla'],
        ),
        isFalse,
      );
    });

    test('returns false for empty list', () {
      expect(QuestionRepositoryImpl.hasPlaceholderOptions([]), isFalse);
    });
  });

  group('enrichOptions', () {
    test('skips questions with 4+ valid options', () {
      final q = _q(
        id: '1',
        type: QuestionType.team,
        correctAnswer: 'Real Madrid',
        options: ['Real Madrid', 'Barcelona', 'Atlético', 'Sevilla'],
      );
      final result = repo.enrichOptions(q, [q]);
      expect(result.options, hasLength(4));
      expect(result.options, contains('Real Madrid'));
    });

    test('adds distractors from same type', () {
      final questions = [
        _q(id: '1', type: QuestionType.stadium, correctAnswer: 'Bernabéu', options: ['Bernabéu']),
        _q(id: '2', type: QuestionType.stadium, correctAnswer: 'Camp Nou'),
        _q(id: '3', type: QuestionType.stadium, correctAnswer: 'San Mamés'),
        _q(id: '4', type: QuestionType.stadium, correctAnswer: 'Mestalla'),
        _q(id: '5', type: QuestionType.stadium, correctAnswer: 'Wanda Metropolitano'),
      ];
      final result = repo.enrichOptions(questions[0], questions);
      expect(result.options, contains('Bernabéu'));
      expect(result.options.length, greaterThanOrEqualTo(4));
      for (final opt in result.options) {
        if (opt != 'Bernabéu') {
          expect(['Camp Nou', 'San Mamés', 'Mestalla', 'Wanda Metropolitano'], contains(opt));
        }
      }
    });

    test('falls back to any type when not enough same-type distractors', () {
      final questions = [
        _q(id: '1', type: QuestionType.stadium, correctAnswer: 'Bernabéu', options: ['Bernabéu']),
        _q(id: '2', type: QuestionType.stadium, correctAnswer: 'Camp Nou'),
        _q(id: '3', type: QuestionType.team, correctAnswer: 'Real Madrid'),
        _q(id: '4', type: QuestionType.team, correctAnswer: 'Barcelona'),
        _q(id: '5', type: QuestionType.player, correctAnswer: 'Messi'),
        _q(id: '6', type: QuestionType.player, correctAnswer: 'Ronaldo'),
      ];
      final result = repo.enrichOptions(questions[0], questions);
      expect(result.options, contains('Bernabéu'));
      expect(result.options.length, greaterThanOrEqualTo(4));
    });

    test('leaves type-answer questions without options unchanged', () {
      final q = _q(
        id: '1',
        type: QuestionType.history,
        correctAnswer: '1966',
        options: [],
      );
      final result = repo.enrichOptions(q, [q]);
      expect(result.options, isEmpty);
    });

    test('enriches badge type even with empty options', () {
      final questions = [
        _q(id: '1', type: QuestionType.badge, correctAnswer: 'Real Madrid', options: []),
        _q(id: '2', type: QuestionType.badge, correctAnswer: 'Barcelona'),
        _q(id: '3', type: QuestionType.badge, correctAnswer: 'Atlético'),
        _q(id: '4', type: QuestionType.badge, correctAnswer: 'Sevilla'),
        _q(id: '5', type: QuestionType.badge, correctAnswer: 'Valencia'),
      ];
      final result = repo.enrichOptions(questions[0], questions);
      expect(result.options, contains('Real Madrid'));
      expect(result.options.length, greaterThanOrEqualTo(4));
    });

    test('replaces placeholder options with real distractors', () {
      final questions = [
        _q(
          id: '1',
          type: QuestionType.team,
          correctAnswer: 'Real Madrid',
          options: ['Real Madrid', 'Opción Incorrecta A', 'Opción Incorrecta B', 'Opción Incorrecta C'],
        ),
        _q(id: '2', type: QuestionType.team, correctAnswer: 'Barcelona'),
        _q(id: '3', type: QuestionType.team, correctAnswer: 'Atlético'),
        _q(id: '4', type: QuestionType.team, correctAnswer: 'Sevilla'),
        _q(id: '5', type: QuestionType.team, correctAnswer: 'Valencia'),
      ];
      final result = repo.enrichOptions(questions[0], questions);
      expect(result.options, contains('Real Madrid'));
      expect(
        QuestionRepositoryImpl.hasPlaceholderOptions(result.options),
        isFalse,
      );
      expect(result.options.length, greaterThanOrEqualTo(4));
    });

    test('correct answer is always present in enriched options', () {
      final questions = [
        _q(id: '1', type: QuestionType.stadium, correctAnswer: 'Bernabéu', options: ['Bernabéu']),
        _q(id: '2', type: QuestionType.stadium, correctAnswer: 'Camp Nou'),
        _q(id: '3', type: QuestionType.stadium, correctAnswer: 'San Mamés'),
        _q(id: '4', type: QuestionType.stadium, correctAnswer: 'Mestalla'),
        _q(id: '5', type: QuestionType.stadium, correctAnswer: 'Wanda'),
      ];
      final result = repo.enrichOptions(questions[0], questions);
      expect(result.options, contains('Bernabéu'));
    });

    test('returns original question when fewer than 2 options available', () {
      final q = _q(
        id: '1',
        type: QuestionType.stadium,
        correctAnswer: 'Bernabéu',
        options: ['Bernabéu'],
      );
      final result = repo.enrichOptions(q, [q]);
      expect(result.options, equals(['Bernabéu']));
    });

    group('option count', () {
      test('never produces more than 4 options (5-options bug)', () {
        // Question with 0 options + 4+ available distractors must still cap at 4.
        final questions = [
          _q(id: '1', type: QuestionType.stadium, correctAnswer: 'Anoeta'),
          _q(id: '2', type: QuestionType.stadium, correctAnswer: 'Bernabéu'),
          _q(id: '3', type: QuestionType.stadium, correctAnswer: 'Camp Nou'),
          _q(id: '4', type: QuestionType.stadium, correctAnswer: 'Mestalla'),
          _q(id: '5', type: QuestionType.stadium, correctAnswer: 'San Mamés'),
          _q(id: '6', type: QuestionType.stadium, correctAnswer: 'Wanda'),
        ];
        final result = repo.enrichOptions(questions[0], questions);
        expect(result.options.length, lessThanOrEqualTo(4));
        expect(result.options, contains('Anoeta'));
      });
    });

    group('context-aware distractors', () {
      test('prefer same-country distractors over foreign ones', () {
        // A Spanish stadium should pull Spanish distractors, not English.
        final questions = [
          _q(id: 's1', type: QuestionType.stadium,
             correctAnswer: 'Anoeta', extraData: {'country': 'España'}),
          _q(id: 's2', type: QuestionType.stadium,
             correctAnswer: 'Bernabéu', extraData: {'country': 'España'}),
          _q(id: 's3', type: QuestionType.stadium,
             correctAnswer: 'Mestalla', extraData: {'country': 'España'}),
          _q(id: 's4', type: QuestionType.stadium,
             correctAnswer: 'San Mamés', extraData: {'country': 'España'}),
          _q(id: 's5', type: QuestionType.stadium,
             correctAnswer: 'Old Trafford', extraData: {'country': 'Inglaterra'}),
          _q(id: 's6', type: QuestionType.stadium,
             correctAnswer: 'Anfield', extraData: {'country': 'Inglaterra'}),
          _q(id: 's7', type: QuestionType.stadium,
             correctAnswer: 'Emirates', extraData: {'country': 'Inglaterra'}),
        ];
        final result = repo.enrichOptions(questions[0], questions);
        // With 3 same-country distractors available, none should be English.
        expect(result.options, contains('Anoeta'));
        expect(result.options, isNot(contains('Old Trafford')));
        expect(result.options, isNot(contains('Anfield')));
        expect(result.options, isNot(contains('Emirates')));
      });

      test('falls back to any same-type when context pool is too small', () {
        // Only 1 same-country distractor → must fill with other stadiums.
        final questions = [
          _q(id: 's1', type: QuestionType.stadium,
             correctAnswer: 'Anoeta', extraData: {'country': 'España'}),
          _q(id: 's2', type: QuestionType.stadium,
             correctAnswer: 'Bernabéu', extraData: {'country': 'España'}),
          _q(id: 's3', type: QuestionType.stadium,
             correctAnswer: 'Old Trafford', extraData: {'country': 'Inglaterra'}),
          _q(id: 's4', type: QuestionType.stadium,
             correctAnswer: 'Anfield', extraData: {'country': 'Inglaterra'}),
          _q(id: 's5', type: QuestionType.stadium,
             correctAnswer: 'Emirates', extraData: {'country': 'Inglaterra'}),
        ];
        final result = repo.enrichOptions(questions[0], questions);
        expect(result.options.length, greaterThanOrEqualTo(4));
        expect(result.options, contains('Anoeta'));
      });
    });
  });
}
