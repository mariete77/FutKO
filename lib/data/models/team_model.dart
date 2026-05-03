import 'package:futko/domain/entities/team.dart';

/// Modelo para serializar/deserializar datos de Equipo desde Firestore.
class TeamModel {
  final String id;
  final String name;
  final String leagueId;
  final String city;
  final String? badgeUrl;
  final String? primaryColor;
  final String? secondaryColor;

  TeamModel({
    required this.id,
    required this.name,
    required this.leagueId,
    required this.city,
    this.badgeUrl,
    this.primaryColor,
    this.secondaryColor,
  });

  /// Crea un modelo desde un Map (Firestore)
  factory TeamModel.fromMap(Map<String, dynamic> map, String docId) {
    return TeamModel(
      id: docId,
      name: map['name'] ?? '',
      leagueId: map['leagueId'] ?? '',
      city: map['city'] ?? '',
      badgeUrl: map['badgeUrl'],
      primaryColor: map['primaryColor'],
      secondaryColor: map['secondaryColor'],
    );
  }

  /// Convierte el modelo a una Entidad de dominio
  Team toEntity() {
    return Team(
      id: id,
      name: name,
      leagueId: leagueId,
      city: city,
      badgeUrl: badgeUrl,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
    );
  }

  /// Convierte el modelo a un Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'leagueId': leagueId,
      'city': city,
      'badgeUrl': badgeUrl,
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
    };
  }
}
