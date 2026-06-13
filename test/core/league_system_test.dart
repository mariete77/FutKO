import 'package:flutter_test/flutter_test.dart';
import 'package:futko/core/utils/league_system.dart';

void main() {
  group('LeagueSystem.lpDelta', () {
    test('ganar a un rival igualado da una subida media positiva', () {
      final lp = LeagueSystem.lpDelta(
        playerElo: 1000,
        opponentElo: 1000,
        score: 1.0,
      );
      expect(lp, greaterThan(0));
      expect(lp, lessThanOrEqualTo(34));
    });

    test('ganar al favorito da más que ganar a un inferior', () {
      final vsStronger = LeagueSystem.lpDelta(
        playerElo: 1000,
        opponentElo: 1400,
        score: 1.0,
      );
      final vsWeaker = LeagueSystem.lpDelta(
        playerElo: 1400,
        opponentElo: 1000,
        score: 1.0,
      );
      expect(vsStronger, greaterThan(vsWeaker));
    });

    test('perder contra alguien muy superior quita menos que perder igualado', () {
      final vsStronger = LeagueSystem.lpDelta(
        playerElo: 1000,
        opponentElo: 1400,
        score: 0.0,
      );
      final vsEqual = LeagueSystem.lpDelta(
        playerElo: 1000,
        opponentElo: 1000,
        score: 0.0,
      );
      expect(vsStronger, greaterThan(vsEqual)); // menos negativo
    });
  });

  group('LeagueSystem.applyMatch', () {
    test('cruzar 100 asciende y reinicia los puntos', () {
      final r = LeagueSystem.applyMatch(tier: 2, leaguePoints: 90, lpDelta: 22);
      expect(r.promoted, isTrue);
      expect(r.tier, 3);
      expect(r.leaguePoints, 20);
    });

    test('bajar de 0 desciende a la liga anterior', () {
      final r = LeagueSystem.applyMatch(tier: 2, leaguePoints: 5, lpDelta: -22);
      expect(r.relegated, isTrue);
      expect(r.tier, 1);
      expect(r.leaguePoints, 75);
    });

    test('el escudo de placement evita el descenso', () {
      final r = LeagueSystem.applyMatch(
        tier: 2,
        leaguePoints: 5,
        lpDelta: -22,
        protectedFromRelegation: true,
      );
      expect(r.relegated, isFalse);
      expect(r.tier, 2);
      expect(r.leaguePoints, 0);
    });

    test('la liga más baja tiene suelo en 0 (no desciende)', () {
      final r = LeagueSystem.applyMatch(tier: 1, leaguePoints: 5, lpDelta: -22);
      expect(r.relegated, isFalse);
      expect(r.tier, 1);
      expect(r.leaguePoints, 0);
    });

    test('la liga más alta topa en 99 (no asciende más)', () {
      final r = LeagueSystem.applyMatch(tier: 5, leaguePoints: 90, lpDelta: 22);
      expect(r.promoted, isFalse);
      expect(r.tier, 5);
      expect(r.leaguePoints, 99);
    });
  });

  group('LeagueSystem nombres', () {
    test('los 5 tiers tienen nombre de la pirámide española', () {
      expect(LeagueSystem.nameForTier(1), 'Tercera RFEF');
      expect(LeagueSystem.nameForTier(2), 'Segunda RFEF');
      expect(LeagueSystem.nameForTier(5), 'Primera División');
    });
  });
}
