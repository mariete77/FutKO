import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:futko/domain/entities/league.dart';
import 'package:futko/domain/repositories/league_repository.dart';

/// Implementación de LeagueRepository usando Cloud Firestore.
class LeagueRepositoryImpl implements LeagueRepository {
  final FirebaseFirestore _firestore;

  LeagueRepositoryImpl(this._firestore);

  @override
  Future<List<League>> getActiveLeagues() async {
    final snapshot = await _firestore
        .collection('leagues')
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return League(
        id: doc.id,
        name: data['name'] ?? '',
        country: data['country'] ?? '',
        logoUrl: data['logoUrl'],
        isActive: data['isActive'] ?? true,
      );
    }).toList();
  }

  @override
  Future<League?> getLeagueById(String id) async {
    final doc = await _firestore.collection('leagues').doc(id).get();
    if (!doc.exists) return null;

    final data = doc.data()!;
    return League(
      id: doc.id,
      name: data['name'] ?? '',
      country: data['country'] ?? '',
      logoUrl: data['logoUrl'],
      isActive: data['isActive'] ?? true,
    );
  }
}
