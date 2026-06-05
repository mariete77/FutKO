import 'package:flutter_test/flutter_test.dart';
import 'package:futko/core/utils/score_calculator.dart';

void main() {
  group('calculateQuestionScore', () {
    test('timeout returns 0', () {
      final score = calculateQuestionScore(
        isCorrect: true,
        timeRemaining: 5,
        streak: 2,
        isTimeout: true,
      );
      expect(score, 0);
    });

    test('incorrect answer returns 0', () {
      final score = calculateQuestionScore(
        isCorrect: false,
        timeRemaining: 5,
        streak: 2,
        isTimeout: false,
      );
      expect(score, 0);
    });

    test('correct answer with time bonus', () {
      final score = calculateQuestionScore(
        isCorrect: true,
        timeRemaining: 8,
        streak: 0,
        isTimeout: false,
      );
      expect(score, 100 + 80);
    });

    test('correct answer with streak bonus', () {
      final score = calculateQuestionScore(
        isCorrect: true,
        timeRemaining: 5,
        streak: 3,
        isTimeout: false,
      );
      expect(score, 100 + 50 + 150);
    });

    test('max score with full time and high streak', () {
      final score = calculateQuestionScore(
        isCorrect: true,
        timeRemaining: 10,
        streak: 5,
        isTimeout: false,
      );
      expect(score, 100 + 100 + 250);
    });
  });

  group('calculateResultRank', () {
    test('LEGENDARY for 90%+ accuracy and 1500+ score', () {
      expect(calculateResultRank(0.9, 1500), 'LEGENDARY');
    });

    test('MASTER for 80%+ accuracy and 1200+ score', () {
      expect(calculateResultRank(0.8, 1200), 'MASTER');
    });

    test('EXPERT for 70%+ accuracy and 900+ score', () {
      expect(calculateResultRank(0.7, 900), 'EXPERT');
    });

    test('SKILLED for 60%+ accuracy and 600+ score', () {
      expect(calculateResultRank(0.6, 600), 'SKILLED');
    });

    test('BEGINNER for 50%+ accuracy', () {
      expect(calculateResultRank(0.5, 400), 'BEGINNER');
    });

    test('ROOKIE for below 50%', () {
      expect(calculateResultRank(0.3, 200), 'ROOKIE');
    });
  });

  group('calculateAccuracy', () {
    test('0 total returns 0.0', () {
      expect(calculateAccuracy(5, 0), 0.0);
    });

    test('perfect accuracy', () {
      expect(calculateAccuracy(10, 10), 1.0);
    });

    test('half accuracy', () {
      expect(calculateAccuracy(5, 10), 0.5);
    });
  });

  group('calculateAverageTime', () {
    test('0 answers returns 0.0', () {
      expect(calculateAverageTime(5000, 0), 0.0);
    });

    test('normal calculation', () {
      expect(calculateAverageTime(5000, 10), 500.0);
    });

    test('negative time returns 0.0', () {
      expect(calculateAverageTime(-100, 5), 0.0);
    });

    test('suspiciously large time returns 0.0', () {
      expect(calculateAverageTime(2000000, 5), 0.0);
    });
  });

  group('isValidDifficulty', () {
    test('easy is valid', () {
      expect(isValidDifficulty('easy'), true);
    });

    test('medium is valid', () {
      expect(isValidDifficulty('medium'), true);
    });

    test('hard is valid', () {
      expect(isValidDifficulty('hard'), true);
    });

    test('unknown is not valid', () {
      expect(isValidDifficulty('expert'), false);
    });
  });

  group('difficultyToWeight', () {
    test('easy = 1', () {
      expect(difficultyToWeight('easy'), 1);
    });

    test('medium = 2', () {
      expect(difficultyToWeight('medium'), 2);
    });

    test('hard = 3', () {
      expect(difficultyToWeight('hard'), 3);
    });

    test('unknown = 0', () {
      expect(difficultyToWeight('expert'), 0);
    });
  });
}
