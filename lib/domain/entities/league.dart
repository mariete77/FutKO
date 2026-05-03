import 'package:equatable/equatable.dart';

/// Entidad que representa una Liga o Competición de fútbol.
/// Ej: La Liga, Premier League, Champions League.
class League extends Equatable {
  final String id;
  final String name;
  final String country;
  final String? logoUrl;
  final bool isActive;

  const League({
    required this.id,
    required this.name,
    required this.country,
    this.logoUrl,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [id, name, country, logoUrl, isActive];
}
