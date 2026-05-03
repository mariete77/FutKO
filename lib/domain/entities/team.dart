import 'package:equatable/equatable.dart';

/// Entidad que representa un Equipo de fútbol.
/// Contiene datos básicos para preguntas tipo: "¿De qué equipo es este escudo?"
class Team extends Equatable {
  final String id;
  final String name;
  final String leagueId; // ID de la liga a la que pertenece
  final String city;
  final String? badgeUrl; // URL del escudo
  final String? primaryColor; // Color principal (hex)
  final String? secondaryColor; // Color secundario (hex)

  const Team({
    required this.id,
    required this.name,
    required this.leagueId,
    required this.city,
    this.badgeUrl,
    this.primaryColor,
    this.secondaryColor,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        leagueId,
        city,
        badgeUrl,
        primaryColor,
        secondaryColor,
      ];
}
