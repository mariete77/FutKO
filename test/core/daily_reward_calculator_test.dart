import 'package:flutter_test/flutter_test.dart';
import 'package:futko/core/utils/daily_reward_calculator.dart';
import 'package:futko/domain/entities/user.dart';

User _user({
  int dailyStreak = 0,
  int bestDailyStreak = 0,
  int leaguePoints = 0,
  int leagueTier = 2,
}) {
  return User(
    userId: 'u1',
    displayName: 'Player',
    elo: 1000,
    dailyStreak: dailyStreak,
    bestDailyStreak: bestDailyStreak,
    leaguePoints: leaguePoints,
    leagueTier: leagueTier,
    stats: const UserStats(),
    subscription: const Subscription(),
    dailyGames: DailyGames.today(),
    createdAt: DateTime.now(),
  );
}

void main() {
  group('DailyRewardCalculator', () {
    test('base reward is 5 LP', () {
      expect(DailyRewardCalculator.lpForStreak(0), 5);
    });

    test('streak bonus scales up to 10', () {
      expect(DailyRewardCalculator.lpForStreak(1), 6);
      expect(DailyRewardCalculator.lpForStreak(5), 10);
      expect(DailyRewardCalculator.lpForStreak(10), 15);
      expect(DailyRewardCalculator.lpForStreak(20), 15);
    });

    test('apply adds LP to current league points', () {
      final user = _user(dailyStreak: 3, leaguePoints: 10);
      final result = DailyRewardCalculator.apply(user);

      expect(result.lpEarned, 8);
      expect(result.totalLp, 18);
      expect(result.tier, 2);
      expect(result.promoted, false);
    });

    test('apply promotes when crossing 100 LP', () {
      final user = _user(dailyStreak: 10, leaguePoints: 90, leagueTier: 2);
      final result = DailyRewardCalculator.apply(user);

      expect(result.lpEarned, 15);
      expect(result.tier, 3); // promoted to Primera RFEF
      expect(result.totalLp, 20); // LeagueSystem.lpPromoteStart
      expect(result.promoted, true);
    });

    test('applyToUser returns user with updated league fields', () {
      final user = _user(dailyStreak: 2, leaguePoints: 4, leagueTier: 1);
      final updated = DailyRewardCalculator.applyToUser(user);

      expect(updated.leaguePoints, 11);
      expect(updated.leagueTier, 1);
      expect(updated.dailyStreak, 2);
    });

    test('top tier caps LP instead of overflowing', () {
      final user = _user(dailyStreak: 10, leaguePoints: 99, leagueTier: 5);
      final result = DailyRewardCalculator.apply(user);

      expect(result.tier, 5);
      expect(result.totalLp, 99); // capped at lpToPromote - 1
      expect(result.promoted, false);
    });
  });
}
