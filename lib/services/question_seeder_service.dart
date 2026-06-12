import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:futko/core/constants/firebase_constants.dart';
import 'package:futko/data/questions/football_data.dart';
import 'package:futko/data/questions/honours_data.dart';
import 'package:futko/data/questions/top_scorers_data.dart';
import 'package:futko/data/questions/awards_data.dart';
import 'package:futko/data/questions/extra_football_data.dart';
import 'package:futko/domain/entities/question.dart';

class QuestionSeederService {
  final FirebaseFirestore _firestore;
  final Random _random = Random();
  int _questionCount = 0;

  QuestionSeederService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<int> seedQuestions({bool overwrite = true}) async {
    _questionCount = 0;

    // When overwriting, wipe the existing collection first so re-seeding is
    // idempotent (otherwise every seed appends a duplicate of everything).
    if (overwrite) {
      await _deleteAllQuestions();
    }

    final questions = _generateAllQuestions();
    questions.shuffle(_random);

    // A WriteBatch cannot be reused after commit, so create a fresh one per
    // chunk of 500 operations (Firestore's batch limit).
    var batch = _firestore.batch();
    var operationCount = 0;

    for (final q in questions) {
      final docRef = _firestore.collection(FirebaseConstants.questions).doc();
      batch.set(docRef, _toFirestoreMap(q));
      operationCount++;
      _questionCount++;

      if (operationCount >= 500) {
        await batch.commit();
        batch = _firestore.batch();
        operationCount = 0;
      }
    }

    if (operationCount > 0) {
      await batch.commit();
    }

    return _questionCount;
  }

  /// Delete every document in the questions collection, paging in batches of
  /// 500 (Firestore's batch limit) until the collection is empty.
  Future<void> _deleteAllQuestions() async {
    final collection = _firestore.collection(FirebaseConstants.questions);
    while (true) {
      final snapshot = await collection.limit(500).get();
      if (snapshot.docs.isEmpty) break;

      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }
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
      ..._generateBadgeQuestions(),
      ..._generatePlayerImageQuestions(),
      ..._generateChampionQuestions(),
      ..._generateTopScorerQuestions(),
      ..._generateAwardQuestions(),
      ..._generateCoachQuestions(),
      ..._generateDerbyQuestions(),
      ..._generateNicknameQuestions(),
      ..._generateNationalTeamQuestions(),
      ..._generateKitQuestions(),
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
      final slug = _slugify(stadium.name);
      final imgUrl = '/stadiums/$slug.jpg';
      final type = _random.nextInt(3);
      switch (type) {
        case 0:
          questions.add(_q(
            type: QuestionType.stadium,
            difficulty: Difficulty.easy,
            correctAnswer: stadium.name,
            questionText: '¿Qué estadio tiene capacidad para ${stadium.capacity} espectadores?',
            options: [],
            imageUrl: imgUrl,
          ));
          break;
        case 1:
          questions.add(_q(
            type: QuestionType.stadium,
            difficulty: Difficulty.medium,
            correctAnswer: stadium.name,
            questionText: '¿En qué estadio juega como local ${stadium.homeTeam}?',
            options: [],
            imageUrl: imgUrl,
          ));
          break;
        case 2:
          questions.add(_q(
            type: QuestionType.stadium,
            difficulty: Difficulty.hard,
            correctAnswer: stadium.name,
            questionText: '¿Qué estadio está ubicado en ${stadium.city}?',
            options: [],
            imageUrl: imgUrl,
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

  /// Generate badge/crest identification questions.
  /// imageUrl follows the Storage bucket structure: /badges/{teamId}.png
  List<Question> _generateBadgeQuestions() {
    final questions = <Question>[];
    final data = FootballData.teams;

    for (final team in data) {
      final slug = _slugify(team.name);
      questions.add(_q(
        type: QuestionType.badge,
        difficulty: Difficulty.easy,
        correctAnswer: team.name,
        questionText: '¿De qué equipo es este escudo?',
        options: [],
        imageUrl: '/badges/$slug.png',
      ));
    }

    return questions;
  }

  /// Generate player silhouette/image identification questions.
  /// imageUrl follows the Storage bucket structure: /silhouettes/{playerId}.png
  List<Question> _generatePlayerImageQuestions() {
    final questions = <Question>[];
    final data = FootballData.players;

    for (final player in data) {
      final slug = _slugify(player.name);
      questions.add(_q(
        type: QuestionType.playerImage,
        difficulty: _randomDifficulty(),
        correctAnswer: player.name,
        questionText: '¿Qué jugador es este?',
        options: [],
        imageUrl: '/silhouettes/$slug.png',
      ));
    }

    return questions;
  }

  /// Generate title-winner questions (World Cup, Euro, Champions/Europa
  /// League, domestic leagues). Options are built here from coherent pools
  /// (countries vs clubs) so distractors stay sensible.
  List<Question> _generateChampionQuestions() {
    final questions = <Question>[];

    // International — selections (countries).
    final selectionPool =
        HonoursData.internationalWins.map((e) => e.winner).toSet().toList();
    for (final w in HonoursData.internationalWins) {
      final comp = w.tournament == 'Mundial' ? 'el Mundial' : 'la Eurocopa';
      questions.add(_q(
        type: QuestionType.champion,
        difficulty: Difficulty.medium,
        correctAnswer: w.winner,
        questionText: '¿Qué selección ganó $comp de ${w.year}?',
        options: _pickOptions(w.winner, selectionPool, selectionPool),
      ));
    }

    // Pool of all club winners, used for club-cup distractors and as the
    // fallback pool for leagues with few distinct champions.
    final clubPool = <String>{
      ...HonoursData.clubTitles.map((e) => e.winner),
      ...HonoursData.leagueTitles.map((e) => e.winner),
    }.toList();

    // Club cups — Champions League / Europa League (UEFA Cup before 2010).
    for (final t in HonoursData.clubTitles) {
      final name = t.competition == 'Europa League' && t.year < 2010
          ? 'la Copa de la UEFA'
          : 'la ${t.competition}';
      questions.add(_q(
        type: QuestionType.champion,
        difficulty: Difficulty.medium,
        correctAnswer: t.winner,
        questionText: '¿Qué club ganó $name en ${t.year}?',
        options: _pickOptions(t.winner, clubPool, clubPool),
      ));
    }

    // Domestic leagues — distractors prefer other champions of the same league.
    for (final l in HonoursData.leagueTitles) {
      final sameLeaguePool = HonoursData.leagueTitles
          .where((e) => e.league == l.league)
          .map((e) => e.winner)
          .toSet()
          .toList();
      final season =
          '${l.year - 1}-${(l.year % 100).toString().padLeft(2, '0')}';
      questions.add(_q(
        type: QuestionType.champion,
        difficulty: Difficulty.medium,
        correctAnswer: l.winner,
        questionText:
            '¿Qué equipo ganó ${l.league} en la temporada $season?',
        options: _pickOptions(l.winner, sameLeaguePool, clubPool),
      ));
    }

    return questions;
  }

  /// Generate top-scorer-by-season questions for the four major European
  /// leagues. Distractors are other top scorers from the same league.
  List<Question> _generateTopScorerQuestions() {
    final questions = <Question>[];

    // All leagues and their data.
    final leagues = <_LeagueScorers>[
      _LeagueScorers('La Liga', TopScorersData.laLiga),
      _LeagueScorers('la Premier League', TopScorersData.premierLeague),
      _LeagueScorers('la Serie A', TopScorersData.serieA),
      _LeagueScorers('la Bundesliga', TopScorersData.bundesliga),
    ];

    // Global pool of all scorers across all leagues (fallback).
    final allScorers = leagues
        .expand((l) => l.scorers.map((s) => s.scorer))
        .toSet()
        .toList();

    for (final league in leagues) {
      // Preferred pool: other scorers from the same league.
      final sameLeaguePool =
          league.scorers.map((s) => s.scorer).toSet().toList();

      for (final entry in league.scorers) {
        final season =
            '${entry.year - 1}-${(entry.year % 100).toString().padLeft(2, '0')}';
        questions.add(_q(
          type: QuestionType.topScorer,
          difficulty: _randomDifficulty(),
          correctAnswer: entry.scorer,
          questionText:
              '¿Quién fue el máximo goleador de ${league.name} en la temporada $season?',
          options: _pickOptions(entry.scorer, sameLeaguePool, allScorers),
        ));
      }
    }

    return questions;
  }

  /// Build a 4-option list: the correct answer plus up to 3 distractors drawn
  /// first from [preferredPool], then from [fallbackPool] if needed.
  List<String> _pickOptions(
    String answer,
    List<String> preferredPool,
    List<String> fallbackPool,
  ) {
    final options = <String>[answer];

    void fillFrom(List<String> pool) {
      final candidates = pool.where((c) => c != answer).toList()
        ..shuffle(_random);
      for (final c in candidates) {
        if (options.length >= 4) break;
        if (!options.contains(c)) options.add(c);
      }
    }

    fillFrom(preferredPool);
    if (options.length < 4) fillFrom(fallbackPool);

    options.shuffle(_random);
    return options;
  }

  /// Convert a name to a filesystem-friendly slug.
  /// Convert a name to a filesystem-friendly slug.
  /// Strips accents for cross-platform compatibility.
  /// e.g. "Atlético Madrid" -> "atletico_madrid"
  /// Must match the slugify in scripts/download_images.dart
  static String _slugify(String name) {
    return name
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ñ', 'n')
        .replaceAll('ü', 'u')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }

  /// Generate award questions (Ballon d'Or, World Cup Golden Boot,
  /// European Golden Shoe).
  List<Question> _generateAwardQuestions() {
    final questions = <Question>[];

    // ── Ballon d'Or ──
    final ballonDorWinners =
        AwardsData.ballonDor.map((e) => e.winner).toSet().toList();
    for (final award in AwardsData.ballonDor) {
      final type = _random.nextInt(3);
      switch (type) {
        case 0:
          questions.add(_q(
            type: QuestionType.award,
            difficulty: Difficulty.medium,
            correctAnswer: award.winner,
            questionText: '¿Quién ganó el Balón de Oro en ${award.year}?',
            options: _pickOptions(award.winner, ballonDorWinners,
                ballonDorWinners),
          ));
          break;
        case 1:
          questions.add(_q(
            type: QuestionType.award,
            difficulty: Difficulty.hard,
            correctAnswer: award.winner,
            questionText:
                '¿Qué futbolista de ${award.nationality} ganó el Balón de Oro en ${award.year}?',
            options: _pickOptions(award.winner, ballonDorWinners,
                ballonDorWinners),
          ));
          break;
        case 2:
          questions.add(_q(
            type: QuestionType.award,
            difficulty: Difficulty.easy,
            correctAnswer: award.nationality,
            questionText:
                '¿De qué país es ${award.winner}, ganador del Balón de Oro ${award.year}?',
            options: _pickOptions(
                award.nationality,
                AwardsData.ballonDor.map((e) => e.nationality).toSet().toList(),
                AwardsData.ballonDor.map((e) => e.nationality).toSet().toList()),
          ));
          break;
      }
    }

    // ── World Cup Golden Boot ──
    final wcScorers =
        AwardsData.worldCupGoldenBoots.map((e) => e.winner).toSet().toList();
    for (final award in AwardsData.worldCupGoldenBoots) {
      final type = _random.nextInt(2);
      switch (type) {
        case 0:
          questions.add(_q(
            type: QuestionType.award,
            difficulty: Difficulty.medium,
            correctAnswer: award.winner,
            questionText:
                '¿Quién fue el máximo goleador del Mundial de ${award.year} con ${award.goals} goles?',
            options: _pickOptions(award.winner, wcScorers, ballonDorWinners),
          ));
          break;
        case 1:
          questions.add(_q(
            type: QuestionType.award,
            difficulty: Difficulty.hard,
            correctAnswer: award.winner,
            questionText:
                '¿Qué jugador ganó la Bota de Oro del Mundial de ${award.year}?',
            options: _pickOptions(award.winner, wcScorers, ballonDorWinners),
          ));
          break;
      }
    }

    // ── European Golden Shoe ──
    final shoeWinners =
        AwardsData.europeanGoldenShoes.map((e) => e.winner).toSet().toList();
    for (final award in AwardsData.europeanGoldenShoes) {
      questions.add(_q(
        type: QuestionType.award,
        difficulty: Difficulty.medium,
        correctAnswer: award.winner,
        questionText:
            '¿Quién ganó la Bota de Oro europea en la temporada ${award.year - 1}-${(award.year % 100).toString().padLeft(2, '0')} con ${award.goals} goles?',
        options:
            _pickOptions(award.winner, shoeWinners, ballonDorWinners),
      ));
    }

    return questions;
  }

  List<Question> _generateCoachQuestions() {
    final questions = <Question>[];
    final data = ExtraFootballData.coaches;
    final coachNames = data.map((c) => c.name).toList();
    final nationalities = data.map((c) => c.nationality).toSet().toList();

    for (final coach in data) {
      final type = _random.nextInt(3);
      switch (type) {
        case 0:
          final team = coach.teams[_random.nextInt(coach.teams.length)];
          questions.add(_q(
            type: QuestionType.coach,
            difficulty: Difficulty.medium,
            correctAnswer: coach.name,
            questionText: '¿Qué entrenador dirigió al $team?',
            options: _pickOptions(coach.name, coachNames, coachNames),
          ));
          break;
        case 1:
          questions.add(_q(
            type: QuestionType.coach,
            difficulty: Difficulty.easy,
            correctAnswer: coach.nationality,
            questionText: '¿De qué nacionalidad es ${coach.name}?',
            options: _pickOptions(coach.nationality, nationalities, nationalities),
          ));
          break;
        case 2:
          if (coach.championsLeagues > 0) {
            questions.add(_q(
              type: QuestionType.coach,
              difficulty: Difficulty.hard,
              correctAnswer: coach.name,
              questionText: '¿Qué entrenador ha ganado ${coach.championsLeagues} Champions League(s)?',
              options: _pickOptions(coach.name, coachNames, coachNames),
            ));
          }
          break;
      }
    }
    return questions;
  }

  List<Question> _generateDerbyQuestions() {
    final questions = <Question>[];
    final data = ExtraFootballData.derbies;
    final derbyNames = data.map((d) => d.name).toList();
    final allTeams = data.expand((d) => [d.teamA, d.teamB]).toSet().toList();

    for (final derby in data) {
      final type = _random.nextInt(2);
      switch (type) {
        case 0:
          questions.add(_q(
            type: QuestionType.derby,
            difficulty: Difficulty.medium,
            correctAnswer: derby.name,
            questionText: '¿Qué derbi enfrenta a ${derby.teamA} y ${derby.teamB}?',
            options: _pickOptions(derby.name, derbyNames, derbyNames),
          ));
          break;
        case 1:
          questions.add(_q(
            type: QuestionType.derby,
            difficulty: Difficulty.medium,
            correctAnswer: derby.teamB,
            questionText: 'En el ${derby.name}, ¿contra qué equipo juega ${derby.teamA}?',
            options: _pickOptions(derby.teamB, allTeams, allTeams),
          ));
          break;
      }
    }
    return questions;
  }

  List<Question> _generateNicknameQuestions() {
    final questions = <Question>[];
    final data = ExtraFootballData.nicknames;
    final teams = data.map((n) => n.team).toList();
    final nicknames = data.map((n) => n.nickname.split(' / ').first).toList();

    for (final entry in data) {
      final primary = entry.nickname.split(' / ').first;
      final type = _random.nextInt(2);
      switch (type) {
        case 0:
          questions.add(_q(
            type: QuestionType.nickname,
            difficulty: Difficulty.easy,
            correctAnswer: entry.team,
            questionText: '¿Qué equipo es conocido como "$primary"?',
            options: _pickOptions(entry.team, teams, teams),
          ));
          break;
        case 1:
          questions.add(_q(
            type: QuestionType.nickname,
            difficulty: Difficulty.medium,
            correctAnswer: primary,
            questionText: '¿Cuál es el apodo del ${entry.team}?',
            options: _pickOptions(primary, nicknames, nicknames),
          ));
          break;
      }
    }
    return questions;
  }

  List<Question> _generateNationalTeamQuestions() {
    final questions = <Question>[];
    final data = ExtraFootballData.nationalTeams;
    final teamNames = data.map((n) => n.name).toList();

    for (final team in data) {
      final type = _random.nextInt(3);
      switch (type) {
        case 0:
          questions.add(_q(
            type: QuestionType.nationalTeam,
            difficulty: Difficulty.easy,
            correctAnswer: team.name,
            questionText: '¿Qué selección es conocida como "${team.nickname}"?',
            options: _pickOptions(team.name, teamNames, teamNames),
          ));
          break;
        case 1:
          questions.add(_q(
            type: QuestionType.nationalTeam,
            difficulty: Difficulty.medium,
            correctAnswer: team.name,
            questionText: '¿Qué selección ha ganado ${team.worldCups} Mundial(es)?',
            options: _pickOptions(team.name, teamNames, teamNames),
          ));
          break;
        case 2:
          if (team.worldCups > 0) {
            questions.add(_q(
              type: QuestionType.nationalTeam,
              difficulty: Difficulty.hard,
              correctAnswer: team.name,
              questionText: '¿Qué combinado nacional tiene ${team.worldCups} estrellas en su escudo?',
              options: _pickOptions(team.name, teamNames, teamNames),
            ));
          }
          break;
      }
    }
    return questions;
  }

  List<Question> _generateKitQuestions() {
    final questions = <Question>[];
    final data = ExtraFootballData.kits;
    final teams = data.map((k) => k.team).toList();

    for (final kit in data) {
      final type = _random.nextInt(2);
      switch (type) {
        case 0:
          questions.add(_q(
            type: QuestionType.kit,
            difficulty: Difficulty.easy,
            correctAnswer: kit.team,
            questionText: '¿Qué equipo juega de ${kit.homeKit} como local?',
            options: _pickOptions(kit.team, teams, teams),
          ));
          break;
        case 1:
          questions.add(_q(
            type: QuestionType.kit,
            difficulty: Difficulty.medium,
            correctAnswer: kit.homeKit,
            questionText: '¿De qué color es la camiseta local del ${kit.team}?',
            options: [],
          ));
          break;
      }
    }
    return questions;
  }
}

class _TransferData {
  final String player;
  final String fromClub;
  final String toClub;
  final int fee;
  const _TransferData(this.player, this.fromClub, this.toClub, this.fee);
}

class _LeagueScorers {
  final String name; // display fragment for question text
  final List<TopScorerEntry> scorers;
  const _LeagueScorers(this.name, this.scorers);
}

