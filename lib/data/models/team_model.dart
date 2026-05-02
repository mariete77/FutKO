import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de datos para un Equipo de fútbol.
class TeamModel {
  final String id;
  final String name;
  final String shortName;
  final String logoUrl;
  final String leagueId; // ID de la liga a la que pertenece
  final int foundationYear;

  TeamModel({
    required this.id,
    required this.name,
    required this.shortName,
    required this.logoUrl,
    required this.leagueId,
    this.foundationYear = 0,
  });

  factory TeamModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TeamModel(
      id: doc.id,
      name: data['name'] ?? '',
      shortName: data['shortName'] ?? '',
      logoUrl: data['logoUrl'] ?? '',
      leagueId: data['leagueId'] ?? '',
      foundationYear: data['foundationYear'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'shortName': shortName,
      'logoUrl': logoUrl,
      'leagueId': leagueId,
      'foundationYear': foundationYear,
    };
  }
}
