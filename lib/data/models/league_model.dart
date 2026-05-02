import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de datos para una Liga (Ej: La Liga, Premier League).
class LeagueModel {
  final String id;
  final String name;
  final String country;
  final String logoUrl;
  final int seasonYear;
  final bool isActive;

  LeagueModel({
    required this.id,
    required this.name,
    required this.country,
    required this.logoUrl,
    required this.seasonYear,
    this.isActive = true,
  });

  factory LeagueModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LeagueModel(
      id: doc.id,
      name: data['name'] ?? '',
      country: data['country'] ?? '',
      logoUrl: data['logoUrl'] ?? '',
      seasonYear: data['seasonYear'] ?? DateTime.now().year,
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'country': country,
      'logoUrl': logoUrl,
      'seasonYear': seasonYear,
      'isActive': isActive,
    };
  }
}
