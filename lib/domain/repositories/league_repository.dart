import 'package:futko/domain/entities/league.dart';

/// Contrato para el repositorio de Ligas.
abstract class LeagueRepository {
  /// Obtiene la lista de todas las ligas activas.
  Future<List<League>> getActiveLeagues();

  /// Obtiene una liga por su ID.
  Future<League?> getLeagueById(String id);
}
