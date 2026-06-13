import 'dart:math';
import '../constants/game_constants.dart';

/// Resultado de aplicar una partida ranked al sistema de ligas.
class LeagueResult {
  final int tier;
  final int leaguePoints;
  final int lpDelta;
  final bool promoted;
  final bool relegated;

  const LeagueResult({
    required this.tier,
    required this.leaguePoints,
    required this.lpDelta,
    required this.promoted,
    required this.relegated,
  });
}

/// Sistema de clasificación por ligas (pirámide española) sobre un MMR/ELO
/// oculto. El jugador ve Liga + puntos (0–99); el ELO solo empareja y modula
/// cuántos puntos se ganan. Ver ELO_LIGAS_DESIGN.md.
class LeagueSystem {
  const LeagueSystem._();

  static const int minTier = 1;
  static const int maxTier = GameConstants.leagueCount; // 5

  /// Nombres de menor (tier 1) a mayor (tier 5).
  static const List<String> tierNames = [
    'Tercera RFEF',
    'Segunda RFEF',
    'Primera RFEF',
    'Segunda División',
    'Primera División',
  ];

  static String nameForTier(int tier) {
    final i = (tier - 1).clamp(0, tierNames.length - 1);
    return tierNames[i];
  }

  /// Color (ARGB) de cada liga.
  static int colorForTier(int tier) {
    switch (tier) {
      case 5:
        return 0xFFFFD700; // oro — Primera División
      case 4:
        return 0xFFE5E4E2; // plata — Segunda División
      case 3:
        return 0xFF4ADE80; // verde — Primera RFEF
      case 2:
        return 0xFFB0B7C3; // gris — Segunda RFEF
      default:
        return 0xFFCD7F32; // bronce — Tercera RFEF
    }
  }

  /// Liga inicial sembrada por ELO (para placement futuro).
  static int tierForElo(int elo) {
    if (elo >= 1600) return 5;
    if (elo >= 1400) return 4;
    if (elo >= 1200) return 3;
    if (elo >= 1000) return 2;
    return 1;
  }

  /// Puntos de liga a sumar/restar, modulados por la expectativa de ELO.
  /// [score]: 1.0 ganar, 0.5 empate, 0.0 perder. [correctMargin]: aciertos
  /// propios menos los del rival (bonus por dominar).
  static int lpDelta({
    required int playerElo,
    required int opponentElo,
    required double score,
    int correctMargin = 0,
  }) {
    final expected = 1.0 / (1.0 + pow(10, (opponentElo - playerElo) / 400.0));
    final core = (GameConstants.lpBaseDelta * (score - expected)).round();

    var floor = 0;
    var perf = 0;
    if (score == 1.0) {
      floor = GameConstants.lpWinFloor;
      perf = correctMargin.clamp(0, GameConstants.lpPerfBonusMax);
    } else if (score == 0.0) {
      floor = -GameConstants.lpLossFloor;
      perf = -((-correctMargin).clamp(0, GameConstants.lpPerfBonusMax));
    }

    final delta = core + floor + perf;
    return delta.clamp(GameConstants.lpClampMin, GameConstants.lpClampMax);
  }

  /// Aplica [lpDelta] a (tier, leaguePoints), resolviendo ascenso/descenso.
  /// [protectedFromRelegation]: escudo (placement o recién ascendido).
  static LeagueResult applyMatch({
    required int tier,
    required int leaguePoints,
    required int lpDelta,
    bool protectedFromRelegation = false,
  }) {
    var t = tier;
    var lp = leaguePoints + lpDelta;
    var promoted = false;
    var relegated = false;

    if (lp >= GameConstants.lpToPromote) {
      if (t < maxTier) {
        t += 1;
        lp = GameConstants.lpPromoteStart;
        promoted = true;
      } else {
        lp = GameConstants.lpToPromote - 1; // tope en Primera División
      }
    } else if (lp < 0) {
      if (protectedFromRelegation || t <= minTier) {
        lp = 0; // suelo
      } else {
        t -= 1;
        lp = GameConstants.lpRelegateStart;
        relegated = true;
      }
    }

    return LeagueResult(
      tier: t,
      leaguePoints: lp.clamp(0, GameConstants.lpToPromote - 1),
      lpDelta: lpDelta,
      promoted: promoted,
      relegated: relegated,
    );
  }
}
