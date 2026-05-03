import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:futko/domain/entities/team.dart';
import 'package:futko/domain/repositories/team_repository.dart';

/// Implementación de TeamRepository usando Cloud Firestore.
class TeamRepositoryImpl implements TeamRepository {
  final FirebaseFirestore _firestore;

  TeamRepositoryImpl(this._firestore);

  @override
  Future<List<Team>> getTeamsByLeague(String leagueId) async {
    final snapshot = await _firestore
        .collection('teams')
        .where('leagueId', isEqualTo: leagueId)
        .get();

    return _mapSnapshotToTeams(snapshot);
  }

  @override
  Future<Team?> getTeamById(String id) async {
    final doc = await _firestore.collection('teams').doc(id).get();
    if (!doc.exists) return null;

    return _mapDocToTeam(doc);
  }

  @override
  Future<List<Team>> getRandomTeams({
    int limit = 4,
    String? excludeLeagueId,
  }) async {
    Query query = _firestore.collection('teams');

    // Nota: Firestore no soporta '!=' nativamente en todas las versiones.
    // La lógica de filtrado se hace en cliente o se asume que la colección es manejable.
    // Si se requiere eficiencia, se debe usar una consulta de array-contains o estructura distinta.
    final snapshot = await query.limit(limit * 2).get();
    
    List<Team> teams = _mapSnapshotToTeams(snapshot);
    
    if (excludeLeagueId != null) {
      teams = teams.where((team) => team.leagueId != excludeLeagueId).toList();
    }
    
    return teams.take(limit).toList();
  }

  // --- Helper Methods ---

  List<Team> _mapSnapshotToTeams(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => _mapDocToTeam(doc)).toList();
  }

  Team _mapDocToTeam(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Team(
      id: doc.id,
      name: data['name'] ?? '',
      leagueId: data['leagueId'] ?? '',
      city: data['city'] ?? '',
      badgeUrl: data['badgeUrl'],
      primaryColor: data['primaryColor'],
      secondaryColor: data['secondaryColor'],
    );
  }
}
