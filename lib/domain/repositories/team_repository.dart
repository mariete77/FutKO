import 'package:futko/domain/entities/team.dart';

/// Contrato para el repositorio de Equipos.
abstract class TeamRepository {
  /// Obtiene todos los equipos de una liga específica.
  Future<List<Team>> getTeamsByLeague(String leagueId);

  /// Obtiene un equipo por su ID.
  Future<Team?> getTeamById(String id);

  /// Obtiene equipos aleatorios (para preguntas de escudos).
  Future<List<Team>> getRandomTeams({int limit = 4, String? excludeLeagueId});
}
