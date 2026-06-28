import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
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

  /// Test-only: expose the full generated set for coherence review.
  @visibleForTesting
  List<Question> generateAllQuestionsForReview() => _generateAllQuestions();

  List<Question> _rawQuestions() {
    return <Question>[
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
  }

  // Cached universe of every valid answer per prompt / per type / per
  // context key. Each item picks a random template variant per run, so one run
  // does not surface every answer a prompt can have; we accumulate many runs
  // ONCE so ambiguity is never under-detected, then reuse it across calls.
  Map<String, Set<String>>? _answersByKey;
  Map<QuestionType, Set<String>>? _answersByType;
  Map<String, Set<String>>? _answersByContext;

  static String _keyOf(Question q) =>
      '${q.type}|${(q.imageUrl ?? q.questionText ?? '').toLowerCase().trim()}';

  void _buildUniverse() {
    if (_answersByKey != null) return;
    final byKey = <String, Set<String>>{};
    final byType = <QuestionType, Set<String>>{};
    final byContext = <String, Set<String>>{};
    for (var i = 0; i < 300; i++) {
      for (final q in _rawQuestions()) {
        byKey.putIfAbsent(_keyOf(q), () => <String>{}).add(q.correctAnswer);
        byType.putIfAbsent(q.type, () => <String>{}).add(q.correctAnswer);
        for (final key in _contextKeys(q)) {
          byContext.putIfAbsent(key, () => <String>{}).add(q.correctAnswer);
        }
      }
    }
    _answersByKey = byKey;
    _answersByType = byType;
    _answersByContext = byContext;
  }

  /// Context keys used to keep distractors coherent with the question.
  /// Each key is prefixed with the question type so a player from England
  /// never becomes a distractor for a team from England.
  static List<String> _contextKeys(Question q) {
    final data = q.extraData;
    if (data == null) return const [];
    final prefix = q.type.name;
    final keys = <String>[];
    final country = data['country'];
    if (country is String && country.isNotEmpty) {
      keys.add('$prefix:country:$country');
    }
    final league = data['league'];
    if (league is String && league.isNotEmpty) {
      keys.add('$prefix:league:$league');
    }
    final position = data['position'];
    if (position is String && position.isNotEmpty) {
      keys.add('$prefix:position:$position');
    }
    final birthYear = data['birthYear'];
    if (birthYear is int) {
      final decade = (birthYear ~/ 10) * 10;
      keys.add('$prefix:birthDecade:$decade');
      final era = (decade ~/ 20) * 20;
      keys.add('$prefix:birthEra:$era');
    }
    final category = data['category'];
    if (category is String && category.isNotEmpty) {
      keys.add('$prefix:category:$category');
    }
    final transferYear = data['transferYear'];
    if (transferYear is int) {
      final halfDecade = (transferYear ~/ 5) * 5;
      keys.add('$prefix:transferHalfDecade:$halfDecade');
      final decade = (transferYear ~/ 10) * 10;
      keys.add('$prefix:transferDecade:$decade');
    }
    final year = data['year'];
    if (year is int) {
      final decade = (year ~/ 10) * 10;
      keys.add('$prefix:awardDecade:$decade');
    }
    final compType = data['type'];
    if (compType is String && compType.isNotEmpty) {
      keys.add('$prefix:compType:$compType');
    }
    return keys;
  }

  List<Question> _generateAllQuestions() {
    _buildUniverse();
    return _annotateCoherence(_rawQuestions());
  }

  /// Post-process every generated question so none is incoherent:
  ///
  /// - A question is only flagged `taEligible` (eligible to be shown as a
  ///   free-text "type the answer" question) when its prompt maps to a SINGLE
  ///   correct answer across the whole set and the answer is not already
  ///   spelled out in the prompt.
  /// - Any intrinsic type-answer question (no options) whose prompt is
  ///   ambiguous (several valid answers) or leaks the answer is upgraded to
  ///   multiple-choice, with distractors drawn from the same type but excluding
  ///   every other valid answer for that prompt (so no option is also correct).
  List<Question> _annotateCoherence(List<Question> questions) {
    final answersByKey = _answersByKey!;
    final answersByType = _answersByType!;

    bool leaks(Question q) {
      final t = q.questionText;
      if (t == null) return false;
      final a = q.correctAnswer.toLowerCase().trim();
      return a.length > 2 && t.toLowerCase().contains(a);
    }

    bool hasPlaceholderOptions(List<String> options) {
      const placeholders = {
        'opción incorrecta a',
        'opción incorrecta b',
        'opción incorrecta c',
        'option a',
        'option b',
        'option c',
        'opción 1',
        'opción 2',
        'opción 3',
        'option 1',
        'option 2',
        'option 3',
      };
      return options
          .any((o) => placeholders.contains(o.toLowerCase().trim()));
    }

    Question annotate(Question q, {List<String>? options, required bool ta}) {
      return Question(
        id: q.id,
        type: q.type,
        difficulty: q.difficulty,
        correctAnswer: q.correctAnswer,
        options: options ?? q.options,
        imageUrl: q.imageUrl,
        questionText: q.questionText,
        extraData: {...?q.extraData, 'taEligible': ta},
      );
    }

    return questions.map((q) {
      final key = _keyOf(q);
      final validAnswers = answersByKey[key] ?? {q.correctAnswer};
      final ambiguous = validAnswers.length > 1;
      final leaked = leaks(q);
      // Tipos semánticamente ambiguos como texto libre: nombrar a una PERSONA a
      // partir de una descripción (club/posición/palmarés) lo cumplen muchos,
      // aunque el enunciado sea único en la BD. Solo opción múltiple, nunca
      // escribir. (playerImage SÍ puede ser de escribir: la foto identifica.)
      const neverTypeAnswer = {QuestionType.player};
      final ta =
          !ambiguous && !leaked && !neverTypeAnswer.contains(q.type);

      // Type-answer questions whose prompt is unique & not leaked stay as-is.
      if (q.options.isEmpty && ta) {
        return annotate(q, ta: true);
      }

      // Keep already coherent 4-option sets untouched so generators that
      // produced consistent distractors are not overwritten by a generic pool.
      final optionsAreValid = q.options.length == 4 &&
          !hasPlaceholderOptions(q.options) &&
          q.options.toSet().length == 4 &&
          q.options.contains(q.correctAnswer) &&
          !q.options.any((o) => o != q.correctAnswer && validAnswers.contains(o));
      if (optionsAreValid) {
        return annotate(q, ta: ta);
      }

      // Distractors that are safe: collect them in priority order so a
      // position match is not diluted by a broad era match. For player
      // questions we intersect position with birth decade first, then relax.
      final contextKeys = _contextKeys(q);
      final prefix = q.type.name;
      String keyStarting(String dimension) => contextKeys
          .firstWhere((k) => k.startsWith('$prefix:$dimension:'), orElse: () => '');

      final safePool = <String>{};
      if (q.type == QuestionType.player) {
        final positionKey = keyStarting('position');
        final birthDecadeKey = keyStarting('birthDecade');
        final birthEraKey = keyStarting('birthEra');
        final countryKey = keyStarting('country');

        void addFrom(String? key) {
          if (key != null && key.isNotEmpty) {
            safePool.addAll(_answersByContext![key] ?? <String>{});
          }
        }

        // 1) same position + same birth decade
        if (positionKey.isNotEmpty && birthDecadeKey.isNotEmpty) {
          final byPosition = _answersByContext![positionKey] ?? <String>{};
          final byDecade = _answersByContext![birthDecadeKey] ?? <String>{};
          safePool.addAll(byPosition.where(byDecade.contains));
          safePool.removeWhere((a) => validAnswers.contains(a));
        }
        // 2) relax to same position + same era
        if (safePool.length < 3 &&
            positionKey.isNotEmpty &&
            birthEraKey.isNotEmpty) {
          final byPosition = _answersByContext![positionKey] ?? <String>{};
          final byEra = _answersByContext![birthEraKey] ?? <String>{};
          safePool.addAll(byPosition.where(byEra.contains));
          safePool.removeWhere((a) => validAnswers.contains(a));
        }
        // 3) relax to same position
        if (safePool.length < 3 && positionKey.isNotEmpty) {
          addFrom(positionKey);
          safePool.removeWhere((a) => validAnswers.contains(a));
        }
        // 4) same country + position
        if (safePool.length < 3 &&
            countryKey.isNotEmpty &&
            positionKey.isNotEmpty) {
          final byCountry = _answersByContext![countryKey] ?? <String>{};
          final byPosition = _answersByContext![positionKey] ?? <String>{};
          safePool.addAll(byCountry.where(byPosition.contains));
          safePool.removeWhere((a) => validAnswers.contains(a));
        }
        // 5) same country
        if (safePool.length < 3 && countryKey.isNotEmpty) {
          addFrom(countryKey);
          safePool.removeWhere((a) => validAnswers.contains(a));
        }
      } else {
        final priorityOrder = [
          '$prefix:position:',
          '$prefix:country:',
          '$prefix:league:',
          '$prefix:category:',
          '$prefix:compType:',
          '$prefix:birthDecade:',
          '$prefix:birthEra:',
          '$prefix:transferHalfDecade:',
          '$prefix:transferDecade:',
          '$prefix:awardDecade:',
        ];
        for (final priority in priorityOrder) {
          for (final key in contextKeys.where((k) => k.startsWith(priority))) {
            safePool.addAll(_answersByContext![key] ?? <String>{});
          }
          safePool.removeWhere((a) => validAnswers.contains(a));
          if (safePool.length >= 3) break;
        }
      }
      if (safePool.length < 3) {
        // Last-resort fallback: any answer of the same type. This can introduce
        // less coherent distractors, but guarantees a playable question.
        safePool.addAll(answersByType[q.type] ?? <String>{});
        safePool.removeWhere((a) => validAnswers.contains(a));
      }
      final shuffledSafe = safePool.toList()..shuffle(_random);

      // Everything else is multiple-choice: rebuild options keeping the correct
      // answer, dropping any option that is also a valid answer, topping up with
      // safe distractors.
      final used = <String>{q.correctAnswer.toLowerCase()};
      final opts = <String>[q.correctAnswer];
      for (final o in q.options) {
        if (opts.length >= 4) break;
        if (validAnswers.contains(o)) continue; // also-correct distractor
        if (used.add(o.toLowerCase())) opts.add(o);
      }
      for (final c in shuffledSafe) {
        if (opts.length >= 4) break;
        if (used.add(c.toLowerCase())) opts.add(c);
      }
      opts.shuffle(_random);
      return annotate(q, options: opts, ta: ta);
    }).toList();
  }

  List<Question> _generateTeamQuestions() {
    final questions = <Question>[];
    final data = FootballData.teams;

    // Pre-compute coherent pools for team distractors.
    final byCountry = <String, List<String>>{};
    final byLeague = <String, List<String>>{};
    for (final t in data) {
      byCountry.putIfAbsent(t.country, () => <String>[]).add(t.name);
      byLeague.putIfAbsent(t.league, () => <String>[]).add(t.name);
    }

    List<String> sameEra(int founded, {int window = 25}) => data
        .where((t) => (t.founded - founded).abs() <= window)
        .map((t) => t.name)
        .toList();

    for (final team in data) {
      // Only use country for context keys; league names like "Primera División"
      // are shared across countries and would mix distractors otherwise.
      final extra = {'country': team.country};
      final countryPool = byCountry[team.country] ?? [];
      final type = _random.nextInt(3);
      switch (type) {
        case 0:
          if (countryPool.length < 4) break;
          final preferred = sameEra(team.founded)
              .where((n) => countryPool.contains(n))
              .toList();
          questions.add(_q(
            type: QuestionType.team,
            difficulty: Difficulty.hard,
            correctAnswer: team.name,
            questionText:
                '¿Qué club de ${team.country} fue fundado en ${team.founded}?',
            options: _pickOptions(team.name, preferred, countryPool),
            extraData: extra,
          ));
          break;
        case 1:
          if (countryPool.length < 4) break;
          questions.add(_q(
            type: QuestionType.team,
            difficulty: Difficulty.medium,
            correctAnswer: team.name,
            questionText: '¿Qué equipo juega como local en ${team.stadium}?',
            options: _pickOptions(team.name, countryPool, countryPool),
            extraData: extra,
          ));
          break;
        case 2:
          // Stadium questions are unique, so reuse case 1 to avoid redundant
          // "which X plays in league Y" prompts where every local club is valid.
          if (countryPool.length < 4) break;
          questions.add(_q(
            type: QuestionType.team,
            difficulty: Difficulty.medium,
            correctAnswer: team.name,
            questionText: '¿Qué equipo juega como local en ${team.stadium}?',
            options: _pickOptions(team.name, countryPool, countryPool),
            extraData: extra,
          ));
          break;
      }
    }

    return questions;
  }

  List<Question> _generatePlayerQuestions() {
    final questions = <Question>[];
    final data = FootballData.players;

    // Pre-compute coherent pools for player distractors.
    final namesByPosition = <String, List<String>>{};
    final ballonDorWinners = data.where((p) => p.ballonDor > 0).toList();
    for (final p in data) {
      namesByPosition.putIfAbsent(p.position, () => <String>[]).add(p.name);
    }

    List<String> sameEra(int? birthYear, String name, {int window = 12}) {
      if (birthYear == null) return data.map((p) => p.name).toList();
      return data
          .where((p) =>
              p.name != name &&
              p.birthYear != null &&
              (p.birthYear! - birthYear).abs() <= window)
          .map((p) => p.name)
          .toList();
    }

    List<String> sameEraAndPosition(
      String position,
      int? birthYear,
      String name, {
      int window = 30,
    }) {
      final era = sameEra(birthYear, name, window: window);
      final samePosition = namesByPosition[position] ?? [];
      return samePosition.where((n) => era.contains(n) || n == name).toList();
    }

    for (final player in data) {
      final extra = {
        'country': player.nationality,
        'position': player.position,
        if (player.birthYear != null) 'birthYear': player.birthYear,
      };
      final type = _random.nextInt(3);
      switch (type) {
        case 0:
          final samePosition = namesByPosition[player.position] ??
              data.map((p) => p.name).toList();
          final era = sameEra(player.birthYear, player.name);
          final preferred =
              samePosition.where((n) => era.contains(n)).toList();
          final fallback =
              sameEraAndPosition(player.position, player.birthYear, player.name);
          questions.add(_q(
            type: QuestionType.player,
            difficulty: player.ballonDor > 0 ? Difficulty.hard : Difficulty.medium,
            correctAnswer: player.name,
            questionText: '¿Qué jugador es ${player.nationality} y juega como ${player.position}?',
            options: _pickOptions(player.name, preferred, fallback),
            extraData: extra,
          ));
          break;
        case 1:
          final era = sameEra(player.birthYear, player.name);
          final samePositionNames = namesByPosition[player.position] ??
              data.map((p) => p.name).toList();
          final preferred =
              samePositionNames.where((n) => era.contains(n)).toList();
          final fallback =
              sameEraAndPosition(player.position, player.birthYear, player.name);
          questions.add(_q(
            type: QuestionType.player,
            difficulty: Difficulty.easy,
            correctAnswer: player.name,
            questionText: '¿Qué futbolista es conocido por jugar en ${player.knownFor}?',
            options: _pickOptions(player.name, preferred, fallback),
            extraData: extra,
          ));
          break;
        case 2:
          if (player.ballonDor > 0) {
            final sameEraWinners = ballonDorWinners
                .where((p) => sameEra(player.birthYear, player.name, window: 15).contains(p.name))
                .map((p) => p.name)
                .toList();
            questions.add(_q(
              type: QuestionType.player,
              difficulty: Difficulty.hard,
              correctAnswer: player.name,
              questionText: '¿Qué jugador ha ganado ${player.ballonDor} Balón(es) de Oro?',
              options: _pickOptions(player.name, sameEraWinners,
                  ballonDorWinners.map((p) => p.name).toList()),
              extraData: extra,
            ));
          }
          break;
      }
    }

    return questions;
  }

  List<Question> _generateCompetitionQuestions() {
    final questions = <Question>[];
    final data = FootballData.competitions;

    // Pool competitions by type so a "club" question doesn't list national-team
    // tournaments as trivial distractors (and vice versa).
    final byType = <String, List<String>>{};
    for (final c in data) {
      byType.putIfAbsent(c.type, () => <String>[]).add(c.name);
    }

    for (final comp in data) {
      final extra = {'type': comp.type};
      final type = _random.nextInt(2);
      switch (type) {
        case 0:
          questions.add(_q(
            type: QuestionType.competition,
            difficulty: Difficulty.hard,
            correctAnswer: comp.name,
            questionText: '¿Qué competición de ${comp.type} se celebró por primera vez en ${comp.firstEdition}?',
            options: _pickOptions(comp.name, byType[comp.type] ?? [],
                data.map((c) => c.name).toList()),
            extraData: extra,
          ));
          break;
        case 1:
          questions.add(_q(
            type: QuestionType.competition,
            difficulty: Difficulty.medium,
            correctAnswer: comp.name,
            questionText: '¿Qué competición entrega ${comp.trophyCount} trofeos en cada edición?',
            options: _pickOptions(comp.name, byType[comp.type] ?? [],
                data.map((c) => c.name).toList()),
            extraData: extra,
          ));
          break;
      }
    }

    return questions;
  }

  List<Question> _generateStadiumQuestions() {
    final questions = <Question>[];
    final data = FootballData.stadiums;

    // Map home team → country (from the teams dataset) so stadium distractors
    // can be filtered by country (a Spanish stadium gets Spanish distractors,
    // not English ones). Falls back to null when the team isn't in the dataset.
    final teamCountry = {
      for (final t in FootballData.teams) t.name: t.country,
    };

    for (final stadium in data) {
      // Las "fotos" de estadio disponibles son logos con el nombre escrito
      // (revelan la respuesta), así que estas preguntas van sin imagen.
      final country = teamCountry[stadium.homeTeam];
      final extra = country == null ? null : {'country': country};
      final type = _random.nextInt(3);
      switch (type) {
        case 0:
          questions.add(_q(
            type: QuestionType.stadium,
            difficulty: Difficulty.easy,
            correctAnswer: stadium.name,
            questionText: '¿Qué estadio tiene capacidad para ${stadium.capacity} espectadores?',
            options: [],
            extraData: extra,
          ));
          break;
        case 1:
          questions.add(_q(
            type: QuestionType.stadium,
            difficulty: Difficulty.medium,
            correctAnswer: stadium.name,
            questionText: '¿En qué estadio juega como local ${stadium.homeTeam}?',
            options: [],
            extraData: extra,
          ));
          break;
        case 2:
          questions.add(_q(
            type: QuestionType.stadium,
            difficulty: Difficulty.hard,
            correctAnswer: stadium.name,
            questionText: '¿Qué estadio está ubicado en ${stadium.city}?',
            options: [],
            extraData: extra,
          ));
          break;
      }
    }

    return questions;
  }

  List<Question> _generateHistoryQuestions() {
    final questions = <Question>[];
    final data = FootballData.historyFacts;

    final allYears = data.map((f) => f.year).toList();

    for (final fact in data) {
      // Ocultar el año del enunciado para que la respuesta no aparezca en el texto.
      var clue = fact.fact
          .replaceAll(RegExp(r'\b\d{4}\b'), '___')
          .replaceAll(fact.year, '___')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      questions.add(_q(
        type: QuestionType.history,
        difficulty: Difficulty.medium,
        correctAnswer: fact.year,
        questionText:
            'Efeméride del fútbol: "$clue". ¿En qué año (o periodo) ocurrió?',
        options: _pickOptions(fact.year, allYears, allYears),
      ));
    }

    return questions;
  }

  List<Question> _generateRulesQuestions() {
    final questions = <Question>[];
    final data = FootballData.rules;

    final allKeywords = data.map((r) => r.keyword).toList();

    for (final rule in data) {
      // Enmascarar la palabra clave si aparece literalmente, para no filtrar la respuesta.
      final masked = rule.rule
          .replaceAll(RegExp(rule.keyword, caseSensitive: false), '___');
      questions.add(_q(
        type: QuestionType.rules,
        difficulty: Difficulty.medium,
        correctAnswer: rule.keyword,
        questionText: '¿Qué concepto del reglamento describe esto? "$masked"',
        options: _pickOptions(rule.keyword, allKeywords, allKeywords),
      ));
    }

    return questions;
  }

  List<Question> _generateStatisticQuestions() {
    final questions = <Question>[];
    final data = FootballData.statistics;

    // Pool statistic subjects by category so a player record doesn't list
    // teams/selecciones as obvious wrong answers.
    final byCategory = <String, List<String>>{};
    for (final s in data) {
      byCategory.putIfAbsent(s.category, () => <String>[]).add(s.subject);
    }

    for (final stat in data) {
      questions.add(_q(
        type: QuestionType.statistic,
        difficulty: Difficulty.hard,
        correctAnswer: stat.subject,
        questionText: stat.category == 'team'
            ? '¿Qué equipo tiene el récord de ${stat.record}?'
            : '¿Qué jugador tiene el récord de ${stat.record}?',
        options: _pickOptions(stat.subject, byCategory[stat.category] ?? [],
            byCategory[stat.category] ?? []),
        extraData: {'category': stat.category},
      ));
    }

    return questions;
  }

  List<Question> _generateTransferQuestions() {
    final transfers = FootballData.transfers;
    final questions = <Question>[];
    final playerPool = transfers.map((t) => t.player).toList();

    for (final t in transfers) {
      final sameEra = _transferOptionsByYear(t, transfers);
      final extra = {'transferYear': t.year};
      final type = _random.nextInt(2);
      switch (type) {
        case 0:
          questions.add(_q(
            type: QuestionType.transfer,
            difficulty: Difficulty.hard,
            correctAnswer: t.player,
            questionText: t.fee > 0
                ? '¿Qué jugador se transfirió de ${t.fromClub} a ${t.toClub} por unos ${(t.fee / 1000000).round()} millones?'
                : '¿Qué jugador fichó por ${t.toClub} procedente de ${t.fromClub}?',
            options: _pickOptions(t.player, sameEra, playerPool),
            extraData: extra,
          ));
          break;
        case 1:
          questions.add(_q(
            type: QuestionType.transfer,
            difficulty: Difficulty.medium,
            correctAnswer: t.player,
            questionText: '¿Qué futbolista dejó ${t.fromClub} para unirse a ${t.toClub}?',
            options: _pickOptions(t.player, sameEra, playerPool),
            extraData: extra,
          ));
          break;
      }
    }

    return questions;
  }

  /// Build a pool of transfer distractors centered on [target]'s year,
  /// widening the window gradually so a 2001 transfer doesn't list 2023 names.
  List<String> _transferOptionsByYear(TransferData target, List<TransferData> all) {
    final windows = [5, 10, 15];
    final options = <String>[];
    for (final window in windows) {
      final candidates = all
          .where((x) =>
              x.player != target.player &&
              (x.year - target.year).abs() <= window &&
              !options.contains(x.player))
          .map((x) => x.player);
      options.addAll(candidates);
      if (options.length >= 3) break;
    }
    return options;
  }

  Difficulty _randomDifficulty() {
    final weights = [0.4, 0.35, 0.25];
    final r = _random.nextDouble();
    if (r < weights[0]) return Difficulty.easy;
    if (r < weights[0] + weights[1]) return Difficulty.medium;
    return Difficulty.hard;
  }

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
        extraData: {'country': team.country, 'league': team.league},
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
        extraData: {
          'country': player.nationality,
          'position': player.position,
          if (player.birthYear != null) 'birthYear': player.birthYear,
        },
      ));
    }

    return questions;
  }

  /// Generate title-winner questions (World Cup, Euro, Champions/Europa
  /// League, domestic leagues). Options are built here from coherent pools
  /// (countries vs clubs) so distractors stay sensible.
  List<Question> _generateChampionQuestions() {
    final questions = <Question>[];

    // International — distractors are other winners of the SAME tournament from
    // nearby editions (e.g. World Cup 2006 -> France, Brazil, Spain), so an
    // expert can't dismiss them on era alone.
    for (final w in HonoursData.internationalWins) {
      final comp = w.tournament == 'Mundial' ? 'el Mundial' : 'la Eurocopa';
      final dated = HonoursData.internationalWins
          .where((e) => e.tournament == w.tournament)
          .map((e) => MapEntry(e.year, e.winner))
          .toList();
      questions.add(_q(
        type: QuestionType.champion,
        difficulty: Difficulty.medium,
        correctAnswer: w.winner,
        questionText: '¿Qué selección ganó $comp de ${w.year}?',
        options: _pickOptionsByYear(w.winner, w.year, dated, initialWindow: 16),
        extraData: {'year': w.year},
      ));
    }

    // Club cups — distractors are winners of the SAME competition from nearby
    // years (e.g. Champions League 2004 -> Milan, Liverpool, Barça of that era).
    for (final t in HonoursData.clubTitles) {
      final name = t.competition == 'Europa League' && t.year < 2010
          ? 'la Copa de la UEFA'
          : 'la ${t.competition}';
      final dated = HonoursData.clubTitles
          .where((e) => e.competition == t.competition)
          .map((e) => MapEntry(e.year, e.winner))
          .toList();
      questions.add(_q(
        type: QuestionType.champion,
        difficulty: Difficulty.medium,
        correctAnswer: t.winner,
        questionText: '¿Qué club ganó $name en ${t.year}?',
        options: _pickOptionsByYear(t.winner, t.year, dated, initialWindow: 8),
        extraData: {'year': t.year},
      ));
    }

    // Domestic leagues — distractors are champions of the SAME league from
    // nearby seasons (the era's real title rivals).
    for (final l in HonoursData.leagueTitles) {
      final dated = HonoursData.leagueTitles
          .where((e) => e.league == l.league)
          .map((e) => MapEntry(e.year, e.winner))
          .toList();
      final season =
          '${l.year - 1}-${(l.year % 100).toString().padLeft(2, '0')}';
      questions.add(_q(
        type: QuestionType.champion,
        difficulty: Difficulty.medium,
        correctAnswer: l.winner,
        questionText:
            '¿Qué equipo ganó ${l.league} en la temporada $season?',
        options: _pickOptionsByYear(l.winner, l.year, dated, initialWindow: 6),
        extraData: {'year': l.year},
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
      // Distractors: top scorers of the SAME league from nearby seasons (the
      // era's real Pichichi/Golden Boot rivals). Falls back to any scorer.
      final leagueDated =
          league.scorers.map((s) => MapEntry(s.year, s.scorer)).toList();

      for (final entry in league.scorers) {
        final season =
            '${entry.year - 1}-${(entry.year % 100).toString().padLeft(2, '0')}';
        var opts =
            _pickOptionsByYear(entry.scorer, entry.year, leagueDated, initialWindow: 6);
        if (opts.length < 4) {
          // top up from any scorer if a quiet era lacks distinct rivals
          for (final s in allScorers) {
            if (opts.length >= 4) break;
            if (!opts.contains(s)) opts = [...opts, s];
          }
        }
        questions.add(_q(
          type: QuestionType.topScorer,
          difficulty: _randomDifficulty(),
          correctAnswer: entry.scorer,
          questionText:
              '¿Quién fue el máximo goleador de ${league.name} en la temporada $season?',
          options: opts,
          extraData: {'year': entry.year},
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

  /// Like [_pickOptions] but era-aware: distractors are preferred from entries
  /// whose year is close to [targetYear], so a 2003 award doesn't list players
  /// from a completely different era. Starts with a tight window and widens
  /// gradually until 4 distinct options are available.
  List<String> _pickOptionsByYear(
    String answer,
    int targetYear,
    List<MapEntry<int, String>> dated, {
    int initialWindow = 3,
  }) {
    final options = <String>[answer];

    void fill(Iterable<String> pool) {
      final candidates = pool.where((c) => c != answer).toList()
        ..shuffle(_random);
      for (final c in candidates) {
        if (options.length >= 4) break;
        if (!options.contains(c)) options.add(c);
      }
    }

    final windows = [initialWindow, 5, 8, 12, 20];
    for (final window in windows) {
      fill(dated
          .where((e) => (e.key - targetYear).abs() <= window)
          .map((e) => e.value));
      if (options.length >= 4) break;
    }
    if (options.length < 4) fill(dated.map((e) => e.value));

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
    final ballonDorDated =
        AwardsData.ballonDor.map((e) => MapEntry(e.year, e.winner)).toList();
    for (final award in AwardsData.ballonDor) {
      final type = _random.nextInt(3);
      switch (type) {
        case 0:
          questions.add(_q(
            type: QuestionType.award,
            difficulty: Difficulty.medium,
            correctAnswer: award.winner,
            questionText: '¿Quién ganó el Balón de Oro en ${award.year}?',
            options:
                _pickOptionsByYear(award.winner, award.year, ballonDorDated),
            extraData: {'year': award.year},
          ));
          break;
        case 1:
          questions.add(_q(
            type: QuestionType.award,
            difficulty: Difficulty.hard,
            correctAnswer: award.winner,
            questionText:
                '¿Qué futbolista de ${award.nationality} ganó el Balón de Oro en ${award.year}?',
            options:
                _pickOptionsByYear(award.winner, award.year, ballonDorDated),
            extraData: {'year': award.year},
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
    final wcBootDated = AwardsData.worldCupGoldenBoots
        .map((e) => MapEntry(e.year, e.winner))
        .toList();
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
            options: _pickOptionsByYear(award.winner, award.year, wcBootDated,
                initialWindow: 12),
          ));
          break;
        case 1:
          questions.add(_q(
            type: QuestionType.award,
            difficulty: Difficulty.hard,
            correctAnswer: award.winner,
            questionText:
                '¿Qué jugador ganó la Bota de Oro del Mundial de ${award.year}?',
            options: _pickOptionsByYear(award.winner, award.year, wcBootDated,
                initialWindow: 12),
          ));
          break;
      }
    }

    // ── European Golden Shoe ──
    final shoeDated = AwardsData.europeanGoldenShoes
        .map((e) => MapEntry(e.year, e.winner))
        .toList();
    for (final award in AwardsData.europeanGoldenShoes) {
      questions.add(_q(
        type: QuestionType.award,
        difficulty: Difficulty.medium,
        correctAnswer: award.winner,
        questionText:
            '¿Quién ganó la Bota de Oro europea en la temporada ${award.year - 1}-${(award.year % 100).toString().padLeft(2, '0')} con ${award.goals} goles?',
        options: _pickOptionsByYear(award.winner, award.year, shoeDated),
      ));
    }

    return questions;
  }

  List<Question> _generateCoachQuestions() {
    final questions = <Question>[];
    final data = ExtraFootballData.coaches;
    final coachNames = data.map((c) => c.name).toList();
    final nationalities = data.map((c) => c.nationality).toSet().toList();

    // For "which coach managed X?" questions, only use teams that are unique
    // to a single coach in the dataset, otherwise multiple options could be
    // valid (e.g. Real Madrid has been managed by several coaches listed here).
    final teamCount = <String, int>{};
    for (final coach in data) {
      for (final team in coach.teams) {
        teamCount[team] = (teamCount[team] ?? 0) + 1;
      }
    }

    for (final coach in data) {
      final uniqueTeams = coach.teams.where((t) => teamCount[t] == 1).toList();
      final type = _random.nextInt(3);
      switch (type) {
        case 0:
          if (uniqueTeams.isEmpty) break;
          final team = uniqueTeams[_random.nextInt(uniqueTeams.length)];
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

    // Map kit team -> country/league from the main teams dataset so kit
    // distractors can be filtered by country/league when possible.
    final teamMeta = {
      for (final t in FootballData.teams) t.name: (country: t.country, league: t.league),
    };
    final byCountry = <String, List<String>>{};
    final byLeague = <String, List<String>>{};
    for (final kit in data) {
      final meta = teamMeta[kit.team];
      if (meta != null) {
        byCountry.putIfAbsent(meta.country, () => <String>[]).add(kit.team);
        byLeague.putIfAbsent(meta.league, () => <String>[]).add(kit.team);
      }
    }

    for (final kit in data) {
      final meta = teamMeta[kit.team];
      final extra = meta == null
          ? null
          : {'country': meta.country, 'league': meta.league};
      final type = _random.nextInt(2);
      switch (type) {
        case 0:
          final preferred = meta == null
              ? teams
              : byLeague[meta.league] ?? byCountry[meta.country] ?? teams;
          questions.add(_q(
            type: QuestionType.kit,
            difficulty: Difficulty.easy,
            correctAnswer: kit.team,
            questionText: '¿Qué equipo juega de ${kit.homeKit} como local?',
            options: _pickOptions(kit.team, preferred, teams),
            extraData: extra,
          ));
          break;
        case 1:
          questions.add(_q(
            type: QuestionType.kit,
            difficulty: Difficulty.medium,
            correctAnswer: kit.homeKit,
            questionText: '¿De qué color es la camiseta local del ${kit.team}?',
            options: [],
            extraData: extra,
          ));
          break;
      }
    }
    return questions;
  }
}

class _LeagueScorers {
  final String name; // display fragment for question text
  final List<TopScorerEntry> scorers;
  const _LeagueScorers(this.name, this.scorers);
}

