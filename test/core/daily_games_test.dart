import 'package:flutter_test/flutter_test.dart';
import 'package:futko/domain/entities/user.dart';

void main() {
  group('DailyGames', () {
    test('today() creates with zero counts', () {
      final dg = DailyGames.today();
      expect(dg.casualPlayed, 0);
      expect(dg.rankedPlayed, 0);
    });

    test('isToday returns true for today', () {
      final dg = DailyGames.today();
      expect(dg.isToday, true);
    });

    test('isToday returns false for yesterday', () {
      final dg = DailyGames(
        casualPlayed: 0,
        rankedPlayed: 0,
        date: DateTime.now().subtract(const Duration(days: 1)),
      );
      expect(dg.isToday, false);
    });

    test('equality works', () {
      final now = DateTime(2026, 6, 5);
      final a = DailyGames(casualPlayed: 1, rankedPlayed: 0, date: now);
      final b = DailyGames(casualPlayed: 1, rankedPlayed: 0, date: now);
      expect(a, b);
    });
  });

  group('DailyGamesStatus logic', () {
    final today = DateTime.now();

    test('free user with 0 played can play both', () {
      final dg = DailyGames(casualPlayed: 0, rankedPlayed: 0, date: today);
      final casualRemaining = 1 - dg.casualPlayed;
      final rankedRemaining = 1 - dg.rankedPlayed;
      expect(casualRemaining, greaterThan(0));
      expect(rankedRemaining, greaterThan(0));
    });

    test('free user with 1 casual played cannot play casual', () {
      final dg = DailyGames(casualPlayed: 1, rankedPlayed: 0, date: today);
      final casualRemaining = (1 - dg.casualPlayed).clamp(0, 999);
      expect(casualRemaining, 0);
    });

    test('premium user has unlimited casual', () {
      const casualRemaining = 999;
      expect(casualRemaining, 999);
    });

    test('premium user ranked capped at 5', () {
      final dg = DailyGames(casualPlayed: 0, rankedPlayed: 3, date: today);
      final rankedRemaining = (5 - dg.rankedPlayed).clamp(0, 5);
      expect(rankedRemaining, 2);
    });
  });

  group('User.rank', () {
    // rank derives from leagueTier (Spanish pyramid), not from ELO anymore.
    User makeUser({int leagueTier = 2}) {
      return User(
        userId: 'test',
        displayName: 'Test',
        elo: 1000,
        leagueTier: leagueTier,
        stats: const UserStats(),
        subscription: const Subscription(),
        dailyGames: DailyGames.today(),
        createdAt: DateTime.now(),
      );
    }

    test('Tercera RFEF (tier 1)', () {
      expect(makeUser(leagueTier: 1).rank, 'Tercera RFEF');
    });

    test('Segunda RFEF (tier 2)', () {
      expect(makeUser(leagueTier: 2).rank, 'Segunda RFEF');
    });

    test('Primera RFEF (tier 3)', () {
      expect(makeUser(leagueTier: 3).rank, 'Primera RFEF');
    });

    test('Segunda División (tier 4)', () {
      expect(makeUser(leagueTier: 4).rank, 'Segunda División');
    });

    test('Primera División (tier 5)', () {
      expect(makeUser(leagueTier: 5).rank, 'Primera División');
    });
  });

  group('User.winRate', () {
    User makeUser({int totalGames = 0, int wins = 0}) {
      return User(
        userId: 'test',
        displayName: 'Test',
        elo: 1000,
        stats: UserStats(totalGames: totalGames, wins: wins),
        subscription: const Subscription(),
        dailyGames: DailyGames.today(),
        createdAt: DateTime.now(),
      );
    }

    test('0 games returns 0.0', () {
      expect(makeUser().winRate, 0.0);
    });

    test('5 wins out of 10 = 0.5', () {
      expect(makeUser(totalGames: 10, wins: 5).winRate, 0.5);
    });
  });
}
