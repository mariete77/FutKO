import 'package:equatable/equatable.dart';

/// Question types for football trivia
enum QuestionType {
  player,       // Questions about players (who scored, career, stats)
  team,         // Questions about teams (which club, founding, trophies)
  competition,  // Questions about competitions (Champions, World Cup, Leagues)
  history,      // Historical football questions (old World Cups, records)
  rules,        // Football rules and refereeing
  stadium,      // Stadium questions (capacity, location, name)
  badge,        // Identify team from badge/crest image
  playerImage,  // Identify player from photo
  statistic,    // Statistical records (top scorers, appearances)
  transfer,     // Transfer history questions
}

/// Question difficulty
enum Difficulty { easy, medium, hard }

/// Question entity
class Question extends Equatable {
  final String id;
  final QuestionType type;
  final Difficulty difficulty;
  final String correctAnswer;
  final List<String> options;
  final String? imageUrl;
  final String? questionText;
  final Map<String, dynamic>? extraData;

  const Question({
    required this.id,
    required this.type,
    required this.difficulty,
    required this.correctAnswer,
    required this.options,
    this.imageUrl,
    this.questionText,
    this.extraData,
  });

  @override
  List<Object?> get props => [
        id,
        type,
        difficulty,
        correctAnswer,
        options,
        imageUrl,
        questionText,
        extraData,
      ];

  /// Check if answer is correct
  bool isCorrect(String answer) {
    return answer.toLowerCase().trim() == correctAnswer.toLowerCase().trim();
  }
}
