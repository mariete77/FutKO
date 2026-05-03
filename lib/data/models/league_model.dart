import 'package:futko/domain/entities/league.dart';

/// Modelo para serializar/deserializar datos de Liga desde Firestore.
class LeagueModel {
  final String id;
  final String name;
  final String country;
  final String? logoUrl;
  final bool isActive;

  LeagueModel({
    required this.id,
    required this.name,
    required this.country,
    this.logoUrl,
    this.isActive = true,
  });

  /// Crea un modelo desde un Map (Firestore)
  factory LeagueModel.fromMap(Map<String, dynamic> map, String docId) {
    return LeagueModel(
      id: docId,
      name: map['name'] ?? '',
      country: map['country'] ?? '',
      logoUrl: map['logoUrl'],
      isActive: map['isActive'] ?? true,
    );
  }

  /// Convierte el modelo a una Entidad de dominio
  League toEntity() {
    return League(
      id: id,
      name: name,
      country: country,
      logoUrl: logoUrl,
      isActive: isActive,
    );
  }

  /// Convierte el modelo a un Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'country': country,
      'logoUrl': logoUrl,
      'isActive': isActive,
    };
  }
}
