import 'package:cloud_firestore/cloud_firestore.dart';

/// Representa una predicción de un usuario sobre un partido.
enum PredictionOutcome { homeWin, draw, awayWin }

class PredictionModel {
  final String id;
  final String matchId; // ID del partido (Fixture)
  final String userId; // Usuario que predice
  final PredictionOutcome prediction; // 1, X, 2
  final DateTime createdAt;
  bool? isCorrect; // Null hasta que el partido termine

  PredictionModel({
    required this.id,
    required this.matchId,
    required this.userId,
    required this.prediction,
    required this.createdAt,
    this.isCorrect,
  });

  factory PredictionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PredictionModel(
      id: doc.id,
      matchId: data['matchId'] ?? '',
      userId: data['userId'] ?? '',
      prediction: _outcomeFromString(data['prediction']),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isCorrect: data['isCorrect'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'matchId': matchId,
      'userId': userId,
      'prediction': _outcomeToString(prediction),
      'createdAt': Timestamp.fromDate(createdAt),
      'isCorrect': isCorrect,
    };
  }

  static PredictionOutcome _outcomeFromString(String? value) {
    switch (value) {
      case 'homeWin': return PredictionOutcome.homeWin;
      case 'awayWin': return PredictionOutcome.awayWin;
      case 'draw': return PredictionOutcome.draw;
      default: return PredictionOutcome.draw;
    }
  }

  static String _outcomeToString(PredictionOutcome outcome) {
    return outcome.toString().split('.').last;
  }
}
