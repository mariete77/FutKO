import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:futko/core/constants/firebase_constants.dart';
import 'package:futko/data/questions/football_data.dart';
import 'package:futko/domain/entities/question.dart';

class QuestionSeederService {
  final FirebaseFirestore _firestore;
  final Random _random = Random();
  int _questionCount = 0;

  QuestionSeederService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<int> seedQuestions({bool overwrite = false}) async {
    _questionCount = 0;

    final questions = _generateAllQuestions();
    questions.shuffle(_random);

    final batch = _firestore.batch();
    var operationCount = 0;

    for (final q in questions) {
      final docRef = _firestore
          .collection(FirebaseConstants.questions)
          .doc();

      if (overwrite) {
        batch.set(docRef, _toFirestoreMap(q));
      } else {
        batch.set(docRef, _toFirestoreMap(q));
      }
      operationCount++;
      _questionCount++;

      if (operationCount >= 500) {
        await batch.commit();
        operationCount = 0;
      }
    }

    if (operationCount > 0) {
      await batch.commit();
    }

    return _questionCount;
  }

  Map<String, dynamic> _toFirestoreMap(Question q) {
    return {
      FirebaseConstants.questionType: q.type.name,
      FirebaseConstants.difficulty: q.difficulty.name,
      FirebaseConstants.correctAnswer: q.correctAnswer,
      FirebaseConstants.options: q.options,
      if (q.imageUrl != null) FirebaseConstants.imageUrl: q.imageUrl,
      if (q.questionText != null) FirebaseConstants.questionText: q.questionText,
      if (q.extraData != null) FirebaseConstants.extraData: q.extraData,
    };
  }

  Question _q({
    required QuestionType type,
    required Difficulty difficulty,
    required String correctAnswer,
    String? questionText,
    List<String> options = const [],
    String? imageUrl,
    Map<String, dynamic>? extraData,
  }) {
    return Question(
      id: '',
      type: type,
      difficulty: difficulty,
      correctAnswer: correctAnswer,
      questionText: questionText,
      options: options,
      imageUrl: imageUrl,
      extraData: extraData,
    );
  }

  List<Question> _generateAllQuestions() {
    final questions = <Question>[
      ..._generateTeamQuestions(),
      ..._generatePlayerQuestions(),
      ..._generateCompetitionQuestions(),
      ..._generateStadiumQuestions(),
      ..._generateHistoryQuestions(),
      ..._generateRulesQuestions(),
      ..._generateStatisticQuestions(),
      ..._generateTransferQuestions(),
    ];
    return questions;
  }

  List<Question> _generateTeamQuestions() {
    final questions = <Question>[];
    final data = FootballData.teams;

    for (final team in data) {
      final type = _random.nextInt(4);
      switch (type) {
        case 0:
          questions.add(_q(
            type: QuestionType.team,
            difficulty: _randomDifficulty(),
            correctAnswer: team.name,
            questionText: '¿Qué club fue fundado en ${team.founded}?',
            options: [],
          ));
          break;
        case 1:
          questions.add(_q(
            type: QuestionType.team,
            difficulty: Difficulty.easy,
            correctAnswer: team.name,
            questionText: '¿En qué país juega el ${team.name}?',
            options: [],
          ));
          break;
        case 2:
          questions.add(_q(
            type: QuestionType.team,
            difficulty: Difficulty.medium,
            correctAnswer: team.name,
            questionText: '¿Qué equipo juega en ${team.stadium}?',
            options: [],
          ));
          break;
        case 3:
          questions.add(_q(
            type: QuestionType.team,
            difficulty: Difficulty.hard,
            correctAnswer: team.name,
            questionText: '¿Qué club juega en la ${team.league} y fue fundado en ${team.founded}?',
            options: [],
          ));
          break;
      }
    }

    return questions;
  }

  List<Question> _generatePlayerQuestions() {
    final questions = <Question>[];
    final data = FootballData.players;

    for (final player in data) {
      final type = _random.nextInt(4);
      switch (type) {
        case 0:
            questions.add(_q(
            type: QuestionType.player,
            difficulty: player.ballonDor > 0 ? Difficulty.hard : Difficulty.medium,
            correctAnswer: player.name,
            questionText: '¿Qué jugador es ${player.nationality} y juega como ${player.position}?',
            options: [],
          ));
          break;
        case 1:
            questions.add(_q(
            type: QuestionType.player,
            difficulty: Difficulty.easy,
            correctAnswer: player.name,
            questionText: '¿Qué futbolista es conocido por jugar en ${player.knownFor}?',
            options: [],
          ));
          break;
        case 2:
          if (player.ballonDor > 0) {
            questions.add(_q(
              type: QuestionType.player,
              difficulty: Difficulty.medium,
              correctAnswer: player.name,
              questionText: '¿Qué jugador ha ganado ${player.ballonDor} Balón(es) de Oro?',
              options: [],
            ));
          }
          break;
        case 3:
            questions.add(_q(
            type: QuestionType.player,
            difficulty: Difficulty.hard,
            correctAnswer: player.name,
            questionText: '¿De qué nacionalidad es ${player.name}?',
            options: [],
          ));
          break;
      }
    }

    return questions;
  }

  List<Question> _generateCompetitionQuestions() {
    final questions = <Question>[];
    final data = FootballData.competitions;

    for (final comp in data) {
      final type = _random.nextInt(4);
      switch (type) {
        case 0:
          questions.add(_q(
            type: QuestionType.competition,
            difficulty: Difficulty.easy,
            correctAnswer: comp.name,
            questionText: '¿Qué competición de ${comp.type} se fundó en ${comp.firstEdition}?',
            options: [],
          ));
          break;
        case 1:
          questions.add(_q(
            type: QuestionType.competition,
            difficulty: Difficulty.medium,
            correctAnswer: comp.name,
            questionText: '¿Qué torneo se juega ${comp.frequency}?',
            options: [],
          ));
          break;
        case 2:
          questions.add(_q(
            type: QuestionType.competition,
            difficulty: Difficulty.hard,
            correctAnswer: comp.name,
            questionText: '¿Qué competición tiene un formato de grupos seguido de eliminación directa?',
            options: [],
          ));
          break;
        case 3:
          questions.add(_q(
            type: QuestionType.competition,
            difficulty: Difficulty.easy,
            correctAnswer: comp.name,
            questionText: '¿En qué liga juegan equipos como el Real Madrid, Barcelona y Atlético?',
            options: [],
          ));
          break;
      }
    }

    return questions;
  }

  List<Question> _generateStadiumQuestions() {
    final questions = <Question>[];
    final data = FootballData.stadiums;

    for (final stadium in data) {
      final type = _random.nextInt(3);
      switch (type) {
        case 0:
          questions.add(_q(
            type: QuestionType.stadium,
            difficulty: Difficulty.easy,
            correctAnswer: stadium.name,
            questionText: '¿Qué estadio tiene capacidad para ${stadium.capacity} espectadores?',
            options: [],
          ));
          break;
        case 1:
          questions.add(_q(
            type: QuestionType.stadium,
            difficulty: Difficulty.medium,
            correctAnswer: stadium.name,
            questionText: '¿En qué estadio juega como local ${stadium.homeTeam}?',
            options: [],
          ));
          break;
        case 2:
          questions.add(_q(
            type: QuestionType.stadium,
            difficulty: Difficulty.hard,
            correctAnswer: stadium.name,
            questionText: '¿Qué estadio está ubicado en ${stadium.city}?',
            options: [],
          ));
          break;
      }
    }

    return questions;
  }

  List<Question> _generateHistoryQuestions() {
    final questions = <Question>[];
    final data = FootballData.historyFacts;

    for (final fact in data) {
      questions.add(_q(
        type: QuestionType.history,
        difficulty: Difficulty.medium,
        correctAnswer: fact.subject,
        questionText: fact.fact,
        options: [],
      ));
    }

    return questions;
  }

  List<Question> _generateRulesQuestions() {
    final questions = <Question>[];
    final data = FootballData.rules;

    for (final rule in data) {
      questions.add(_q(
        type: QuestionType.rules,
        difficulty: Difficulty.medium,
        correctAnswer: rule.keyword,
        questionText: rule.rule,
        options: [],
      ));
    }

    return questions;
  }

  List<Question> _generateStatisticQuestions() {
    final questions = <Question>[];
    final data = FootballData.statistics;

    for (final stat in data) {
      questions.add(_q(
        type: QuestionType.statistic,
        difficulty: Difficulty.hard,
        correctAnswer: stat.subject,
        questionText: '¿Qué jugador tiene el récord de ${stat.record}?',
        options: [],
      ));
    }

    return questions;
  }

  List<Question> _generateTransferQuestions() {
    final transfers = <_TransferData>[
      _TransferData('Neymar Jr', 'FC Barcelona', 'PSG', 222000000),
      _TransferData('Kylian Mbappé', 'Monaco', 'PSG', 180000000),
      _TransferData('Philippe Coutinho', 'Liverpool', 'FC Barcelona', 135000000),
      _TransferData('João Félix', 'Benfica', 'Atlético Madrid', 126000000),
      _TransferData('Antoine Griezmann', 'Atlético Madrid', 'FC Barcelona', 120000000),
      _TransferData('Jack Grealish', 'Aston Villa', 'Manchester City', 117500000),
      _TransferData('Cristiano Ronaldo', 'Real Madrid', 'Juventus', 117000000),
      _TransferData('Eden Hazard', 'Chelsea', 'Real Madrid', 115000000),
      _TransferData('Jude Bellingham', 'Borussia Dortmund', 'Real Madrid', 103000000),
      _TransferData('Declan Rice', 'West Ham', 'Arsenal', 105000000),
      _TransferData('Moises Caicedo', 'Brighton', 'Chelsea', 115000000),
      _TransferData('Enzo Fernández', 'Benfica', 'Chelsea', 106800000),
      _TransferData('Gareth Bale', 'Tottenham', 'Real Madrid', 101000000),
      _TransferData('Cristiano Ronaldo', 'Juventus', 'Manchester United', 15000000),
      _TransferData('Luis Suárez', 'FC Barcelona', 'Atlético Madrid', 0),
      _TransferData('Lionel Messi', 'FC Barcelona', 'PSG', 0),
      _TransferData('Robert Lewandowski', 'Bayern Munich', 'FC Barcelona', 45000000),
      _TransferData('Erling Haaland', 'Borussia Dortmund', 'Manchester City', 60000000),
      _TransferData('Harry Kane', 'Tottenham', 'Bayern Munich', 100000000),
      _TransferData('Romelu Lukaku', 'Inter Milan', 'Chelsea', 115000000),
      _TransferData('Virgil van Dijk', 'Southampton', 'Liverpool', 84650000),
      _TransferData('Alisson Becker', 'AS Roma', 'Liverpool', 72500000),
      _TransferData('Kepa Arrizabalaga', 'Athletic Bilbao', 'Chelsea', 80000000),
      _TransferData('Paul Pogba', 'Juventus', 'Manchester United', 105000000),
      _TransferData('Ousmane Dembélé', 'Borussia Dortmund', 'FC Barcelona', 105000000),
      _TransferData('Kevin De Bruyne', 'Wolfsburg', 'Manchester City', 76000000),
      _TransferData('Luka Modrić', 'Tottenham', 'Real Madrid', 35000000),
      _TransferData('Vinícius Jr', 'Flamengo', 'Real Madrid', 45000000),
      _TransferData('Rodri', 'Atlético Madrid', 'Manchester City', 70000000),
      _TransferData('Aurelien Tchouaméni', 'Monaco', 'Real Madrid', 80000000),
      _TransferData('Ronaldo Nazário', 'FC Barcelona', 'Real Madrid', 0),
      _TransferData('Zinedine Zidane', 'Juventus', 'Real Madrid', 0),
      _TransferData('Luis Figo', 'FC Barcelona', 'Real Madrid', 0),
    ];

    final questions = <Question>[];
    for (final t in transfers) {
      final type = _random.nextInt(3);
      switch (type) {
        case 0:
          questions.add(_q(
            type: QuestionType.transfer,
            difficulty: Difficulty.easy,
            correctAnswer: t.player,
            questionText: '¿Qué jugador fichó por ${t.toClub} en ${_randomYear()}?',
            options: [],
          ));
          break;
        case 1:
          questions.add(_q(
            type: QuestionType.transfer,
            difficulty: Difficulty.hard,
            correctAnswer: t.player,
            questionText: t.fee > 0
                ? '¿Qué jugador se transfirió de ${t.fromClub} a ${t.toClub} por unos ${(t.fee / 1000000).round()} millones?'
                : '¿Qué jugador fichó por ${t.toClub} procedente de ${t.fromClub}?',
            options: [],
          ));
          break;
        case 2:
          questions.add(_q(
            type: QuestionType.transfer,
            difficulty: Difficulty.medium,
            correctAnswer: t.player,
            questionText: '¿Qué futbolista dejó ${t.fromClub} para unirse a ${t.toClub}?',
            options: [],
          ));
          break;
      }
    }

    return questions;
  }

  Difficulty _randomDifficulty() {
    final weights = [0.4, 0.35, 0.25];
    final r = _random.nextDouble();
    if (r < weights[0]) return Difficulty.easy;
    if (r < weights[0] + weights[1]) return Difficulty.medium;
    return Difficulty.hard;
  }

  int _randomYear() => 2010 + _random.nextInt(15);
}

class _TransferData {
  final String player;
  final String fromClub;
  final String toClub;
  final int fee;
  const _TransferData(this.player, this.fromClub, this.toClub, this.fee);
}
