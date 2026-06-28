import 'package:flutter_test/flutter_test.dart';
import 'package:futko/core/utils/fuzzy_matcher.dart';

void main() {
  group('levenshteinDistance', () {
    test('identical strings return 0', () {
      expect(levenshteinDistance('hello', 'hello'), 0);
    });

    test('empty strings return length of other', () {
      expect(levenshteinDistance('', 'abc'), 3);
      expect(levenshteinDistance('abc', ''), 3);
    });

    test('both empty return 0', () {
      expect(levenshteinDistance('', ''), 0);
    });

    test('single character difference', () {
      expect(levenshteinDistance('cat', 'bat'), 1);
    });

    test('insertion', () {
      expect(levenshteinDistance('cat', 'cats'), 1);
    });

    test('deletion', () {
      expect(levenshteinDistance('cats', 'cat'), 1);
    });

    test('completely different', () {
      expect(levenshteinDistance('abc', 'xyz'), 3);
    });
  });

  group('answerSimilarity', () {
    test('perfect match returns 1.0', () {
      expect(answerSimilarity('Real Madrid', 'Real Madrid'), 1.0);
    });

    test('case insensitive', () {
      expect(answerSimilarity('real madrid', 'REAL MADRID'), 1.0);
    });

    test('trims whitespace', () {
      expect(answerSimilarity('  Messi  ', 'Messi'), 1.0);
    });

    test('empty user answer returns 0.0', () {
      expect(answerSimilarity('', 'Barcelona'), 0.0);
    });

    test('similar strings return high similarity', () {
      final sim = answerSimilarity('Barcelona', 'Barcelon');
      expect(sim, greaterThan(0.8));
    });

    test('very different strings return low similarity', () {
      final sim = answerSimilarity('abc', 'xyz');
      expect(sim, lessThan(0.5));
    });

    test('ignores accents', () {
      expect(answerSimilarity('Iniesta', 'Iniésta'), 1.0);
      expect(answerSimilarity('España', 'Espana'), 1.0);
    });

    test('Thier Henry is very close to Thierry Henry', () {
      final sim = answerSimilarity('Thier Henry', 'Thierry Henry');
      expect(sim, greaterThanOrEqualTo(0.8));
    });

    test('ignores punctuation and extra spaces', () {
      expect(answerSimilarity('Luka Modric!', 'Luka Modric'), 1.0);
      expect(answerSimilarity('Luka   Modric', 'Luka Modric'), 1.0);
    });
  });

  group('calculateTypedScore', () {
    test('similarity below 0.6 returns 0', () {
      final score = calculateTypedScore(
        similarity: 0.3,
        timeRemaining: 10,
        maxTime: 15,
        streak: 0,
      );
      expect(score, 0);
    });

    test('partial credit between 0.6 and 0.85', () {
      final partial = calculateTypedScore(
        similarity: 0.7,
        timeRemaining: 10,
        maxTime: 15,
        streak: 0,
      );
      final perfect = calculateTypedScore(
        similarity: 1.0,
        timeRemaining: 10,
        maxTime: 15,
        streak: 0,
      );
      expect(partial, greaterThan(0));
      expect(partial, lessThan(perfect));
    });

    test('partial credit between 0.85 and 1.0', () {
      final partial = calculateTypedScore(
        similarity: 0.9,
        timeRemaining: 10,
        maxTime: 15,
        streak: 0,
      );
      final perfect = calculateTypedScore(
        similarity: 1.0,
        timeRemaining: 10,
        maxTime: 15,
        streak: 0,
      );
      expect(partial, greaterThan(0));
      expect(partial, lessThan(perfect));
    });

    test('perfect match with full time gives max score', () {
      final score = calculateTypedScore(
        similarity: 1.0,
        timeRemaining: 15,
        maxTime: 15,
        streak: 0,
      );
      expect(score, greaterThan(100));
    });

    test('streak adds bonus', () {
      final noStreak = calculateTypedScore(
        similarity: 1.0,
        timeRemaining: 10,
        maxTime: 15,
        streak: 0,
      );
      final withStreak = calculateTypedScore(
        similarity: 1.0,
        timeRemaining: 10,
        maxTime: 15,
        streak: 3,
      );
      expect(withStreak, greaterThan(noStreak));
    });

    test('faster answer scores higher', () {
      final fast = calculateTypedScore(
        similarity: 1.0,
        timeRemaining: 14,
        maxTime: 15,
        streak: 0,
      );
      final slow = calculateTypedScore(
        similarity: 1.0,
        timeRemaining: 2,
        maxTime: 15,
        streak: 0,
      );
      expect(fast, greaterThan(slow));
    });
  });

  group('accuracyLabel', () {
    test('perfect returns PERFECTO', () {
      expect(accuracyLabel(1.0), '¡PERFECTO!');
    });

    test('0.85+ returns Casi', () {
      expect(accuracyLabel(0.9), '¡Casi!');
    });

    test('0.6+ returns Cerca', () {
      expect(accuracyLabel(0.75), 'Cerca');
    });

    test('below 0.6 returns Incorrecto', () {
      expect(accuracyLabel(0.3), 'Incorrecto');
    });
  });

  group('accuracyColor', () {
    test('perfect returns gold', () {
      expect(accuracyColor(1.0), 0xFFFFD700);
    });

    test('0.85+ returns green', () {
      expect(accuracyColor(0.9), 0xFF4CAF50);
    });

    test('0.6+ returns orange', () {
      expect(accuracyColor(0.75), 0xFFFF9800);
    });

    test('below 0.6 returns red', () {
      expect(accuracyColor(0.3), 0xFFF44336);
    });
  });
}
