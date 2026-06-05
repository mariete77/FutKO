import 'package:flutter_test/flutter_test.dart';
import 'package:futko/core/utils/elo_calculator.dart';
import 'package:futko/core/constants/game_constants.dart';

void main() {
  late EloCalculator calc;

  setUp(() {
    calc = EloCalculator();
  });

  group('EloCalculator.calculateChange', () {
    test('winner gains ELO, loser loses ELO', () {
      final change = calc.calculateChange(
        playerElo: 1000,
        opponentElo: 1000,
        score: 1.0,
        gamesPlayed: 50,
      );
      expect(change, greaterThan(0));
    });

    test('loser loses ELO', () {
      final change = calc.calculateChange(
        playerElo: 1000,
        opponentElo: 1000,
        score: 0.0,
        gamesPlayed: 50,
      );
      expect(change, lessThan(0));
    });

    test('draw gives small change', () {
      final change = calc.calculateChange(
        playerElo: 1000,
        opponentElo: 1000,
        score: 0.5,
        gamesPlayed: 50,
      );
      expect(change.abs(), lessThanOrEqualTo(2));
    });

    test('new player has higher K-factor', () {
      final newPlayerChange = calc.calculateChange(
        playerElo: 1000,
        opponentElo: 1000,
        score: 1.0,
        gamesPlayed: 5,
      );
      final establishedChange = calc.calculateChange(
        playerElo: 1000,
        opponentElo: 1000,
        score: 1.0,
        gamesPlayed: 50,
      );
      expect(newPlayerChange, greaterThan(establishedChange));
    });

    test('beating higher rated opponent gives more ELO', () {
      final vsHigher = calc.calculateChange(
        playerElo: 1000,
        opponentElo: 1400,
        score: 1.0,
        gamesPlayed: 50,
      );
      final vsLower = calc.calculateChange(
        playerElo: 1000,
        opponentElo: 600,
        score: 1.0,
        gamesPlayed: 50,
      );
      expect(vsHigher, greaterThan(vsLower));
    });
  });

  group('EloCalculator.calculateNewElo', () {
    test('new ELO is clamped to minElo', () {
      final newElo = calc.calculateNewElo(
        playerElo: 105,
        opponentElo: 2000,
        score: 0.0,
        gamesPlayed: 50,
      );
      expect(newElo, greaterThanOrEqualTo(GameConstants.minElo));
    });

    test('new ELO never exceeds 9999', () {
      final newElo = calc.calculateNewElo(
        playerElo: 9990,
        opponentElo: 1000,
        score: 1.0,
        gamesPlayed: 5,
      );
      expect(newElo, lessThanOrEqualTo(9999));
    });
  });

  group('EloCalculator.determineWinner', () {
    test('player1 wins with more correct answers', () {
      final outcome = calc.determineWinner(
        player1Correct: 8,
        player2Correct: 5,
        player1TotalTime: 50000,
        player2TotalTime: 30000,
      );
      expect(outcome, MatchOutcome.player1Wins);
    });

    test('player2 wins with more correct answers', () {
      final outcome = calc.determineWinner(
        player1Correct: 3,
        player2Correct: 7,
        player1TotalTime: 30000,
        player2TotalTime: 50000,
      );
      expect(outcome, MatchOutcome.player2Wins);
    });

    test('tie broken by faster time', () {
      final outcome = calc.determineWinner(
        player1Correct: 5,
        player2Correct: 5,
        player1TotalTime: 40000,
        player2TotalTime: 60000,
      );
      expect(outcome, MatchOutcome.player1Wins);
    });

    test('exact tie is draw', () {
      final outcome = calc.determineWinner(
        player1Correct: 5,
        player2Correct: 5,
        player1TotalTime: 50000,
        player2TotalTime: 50000,
      );
      expect(outcome, MatchOutcome.draw);
    });
  });

  group('EloCalculator.getRank', () {
    test('Bronze for low ELO', () {
      expect(calc.getRank(800), 'Bronze');
    });

    test('Silver at 1200', () {
      expect(calc.getRank(1200), 'Silver');
    });

    test('Gold at 1400', () {
      expect(calc.getRank(1400), 'Gold');
    });

    test('Platinum at 1600', () {
      expect(calc.getRank(1600), 'Platinum');
    });

    test('Diamond at 1800', () {
      expect(calc.getRank(1800), 'Diamond');
    });
  });
}
