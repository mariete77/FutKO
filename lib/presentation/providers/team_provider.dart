import 'package:futko/data/repositories/team_repository_impl.dart';
import 'package:futko/domain/repositories/team_repository.dart';
import 'package:riverpod/riverpod.dart';

/// Provider para el repositorio de Equipos.
final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  return TeamRepositoryImpl();
});
