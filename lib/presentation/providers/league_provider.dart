import 'package:futko/data/repositories/league_repository_impl.dart';
import 'package:futko/domain/repositories/league_repository.dart';
import 'package:riverpod/riverpod.dart';

/// Provider para el repositorio de Ligas.
final leagueRepositoryProvider = Provider<LeagueRepository>((ref) {
  return LeagueRepositoryImpl();
});
