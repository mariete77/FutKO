import '../../domain/entities/user.dart';
import 'league_system.dart';

/// Resultado de otorgar la recompensa diaria por acertar la pregunta del día.
class DailyRewardResult {
  const DailyRewardResult({
    required this.lpEarned,
    required this.totalLp,
    required this.tier,
    required this.promoted,
  });

  final int lpEarned;
  final int totalLp;
  final int tier;
  final bool promoted;
}

/// Calcula la recompensa de Liga/Puntos (LP) por acertar la pregunta diaria.
///
/// La recompensa escala levemente con la racha diaria para reforzar la
/// retención, pero está acotada para no desbalancear el sistema de ligas.
class DailyRewardCalculator {
  const DailyRewardCalculator._();

  /// LP base por acertar la pregunta del día.
  static const int _baseLp = 5;

  /// Bonus máximo adicional que aporta la racha diaria.
  static const int _maxStreakBonus = 10;

  /// LP que se ganan hoy dada la [streak] actual.
  static int lpForStreak(int streak) {
    final streakBonus = streak.clamp(0, _maxStreakBonus);
    return _baseLp + streakBonus;
  }

  /// Aplica la recompensa diaria al [user] si acierta hoy.
  ///
  /// Usa la racha **actual** del usuario (después de actualizarla) para
  /// calcular el bonus. Devuelve el [LeagueResult] resultante y los LP
  /// ganados específicamente por esta respuesta.
  static DailyRewardResult apply(User user) {
    final lpDelta = lpForStreak(user.dailyStreak);

    final leagueResult = LeagueSystem.applyMatch(
      tier: user.leagueTier,
      leaguePoints: user.leaguePoints,
      lpDelta: lpDelta,
      protectedFromRelegation: true,
    );

    return DailyRewardResult(
      lpEarned: lpDelta,
      totalLp: leagueResult.leaguePoints,
      tier: leagueResult.tier,
      promoted: leagueResult.promoted,
    );
  }

  /// Crea una copia del usuario con la recompensa aplicada.
  static User applyToUser(User user) {
    final result = apply(user);
    return user.copyWith(
      leagueTier: result.tier,
      leaguePoints: result.totalLp,
    );
  }
}
