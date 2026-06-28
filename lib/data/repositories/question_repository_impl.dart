import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:meta/meta.dart';
import 'package:futko/core/errors/exceptions.dart';
import 'package:futko/core/errors/failures.dart';
import 'package:futko/core/constants/firebase_constants.dart';
import 'package:futko/domain/entities/question.dart';
import 'package:futko/domain/repositories/question_repository.dart';
import 'package:futko/data/models/question_model.dart';

/// Question repository implementation
class QuestionRepositoryImpl implements QuestionRepository {
  final FirebaseFirestore? _firestore;
  @visibleForTesting
  final Random random;

  QuestionRepositoryImpl({FirebaseFirestore? firestore, Random? random})
      : _firestore = firestore,
        random = random ?? Random();

  FirebaseFirestore get _db => _firestore ?? FirebaseFirestore.instance;

  @override
  Future<Either<Failure, List<Question>>> getRandomQuestions({
    int count = 10,
    List<QuestionType>? types,
    Difficulty? maxDifficulty,
  }) async {
    try {
      // Get all eligible questions
      Query query = _db.collection(FirebaseConstants.questions);

      if (types != null && types.isNotEmpty) {
        query = query.where(
          FirebaseConstants.questionType,
          whereIn: types.map((t) => t.name).toList(),
        );
      }

      if (maxDifficulty != null) {
        query = query.where(
          FirebaseConstants.difficulty,
          isLessThanOrEqualTo: maxDifficulty.name,
        );
      }

      final snapshot = await query.get();
      final allQuestions = snapshot.docs
          .map((doc) => QuestionModel.fromJson({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }).toDomain())
          .toList();

      if (allQuestions.isEmpty) {
        throw const NotFoundException('No questions found');
      }

      // Shuffle and select
      allQuestions.shuffle(random);

      // Ensure variety of types
      return Right(_selectBalancedQuestions(allQuestions, count));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Question>> getQuestionById(String id) async {
    try {
      final doc = await _db
          .collection(FirebaseConstants.questions)
          .doc(id)
          .get();

      if (!doc.exists) {
        throw const NotFoundException('Question not found');
      }

      final question =
          QuestionModel.fromJson({'id': doc.id, ...doc.data()!}).toDomain();
      return Right(question);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Question>>> getQuestionsByType(
    QuestionType type,
  ) async {
    try {
      final snapshot = await _db
          .collection(FirebaseConstants.questions)
          .where(FirebaseConstants.questionType, isEqualTo: type.name)
          .get();

      final questions = snapshot.docs
          .map((doc) => QuestionModel.fromJson({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }).toDomain())
          .toList();

      return Right(questions);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Question>>> getQuestionsByDifficulty(
    Difficulty difficulty,
  ) async {
    try {
      final snapshot = await _db
          .collection(FirebaseConstants.questions)
          .where(FirebaseConstants.difficulty, isEqualTo: difficulty.name)
          .get();

      final questions = snapshot.docs
          .map((doc) => QuestionModel.fromJson({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }).toDomain())
          .toList();

      return Right(questions);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Question>>> getQuestionsByIds(List<String> ids) async {
    try {
      if (ids.isEmpty) return const Right([]);

      final questions = <Question>[];
      // Firestore 'in' queries support max 30 items
      for (var i = 0; i < ids.length; i += 30) {
        final chunk = ids.sublist(i, i + 30 > ids.length ? ids.length : i + 30);
        final snapshot = await _db
            .collection(FirebaseConstants.questions)
            .where(FieldPath.documentId, whereIn: chunk)
            .get();

        for (final doc in snapshot.docs) {
          questions.add(QuestionModel.fromJson({
            'id': doc.id,
            ...doc.data() as Map<String, dynamic>,
          }).toDomain());
        }
      }

      // Preserve original order
      final questionMap = {for (final q in questions) q.id: q};
      final ordered = ids
          .map((id) => questionMap[id])
          .whereType<Question>()
          .toList();

      return Right(ordered);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  /// Select balanced questions (variety of types)
  List<Question> _selectBalancedQuestions(
    List<Question> questions,
    int count,
  ) {
    final selected = <Question>[];
    final usedTypes = <QuestionType>{};

    // First pass: one of each type
    for (final q in questions) {
      if (!usedTypes.contains(q.type) && selected.length < count) {
        selected.add(q);
        usedTypes.add(q.type);
      }
      if (selected.length >= 10) break; // 10 types max
    }

    // Second pass: fill up to count
    for (final q in questions) {
      if (!selected.contains(q) && selected.length < count) {
        selected.add(q);
      }
      if (selected.length >= count) break;
    }

    selected.shuffle(random);

    // Enrich questions with fewer than 4 options
    return selected.map((q) => enrichOptions(q, questions)).toList();
  }

  /// Enrich a question's options to have at least 4 choices.
  /// For questions with 0-3 options, adds random distractors from other questions.
  /// Silhouette and image-based types always get multiple choice with country distractors.
  @visibleForTesting
  Question enrichOptions(Question question, List<Question> allQuestions) {
    // Skip if already has enough valid options
    if (question.options.length >= 4 && !hasPlaceholderOptions(question.options)) {
      return question;
    }

    // El seeder crea TODAS las preguntas con options vacías y delega en este
    // método la generación de opciones. La conversión a type-answer la decide
    // luego _convertToTypeAnswer (30% aleatorio), así que aquí generamos
    // opciones para todos los tipos sembrados.
    final multipleChoiceTypes = {
      QuestionType.player,
      QuestionType.team,
      QuestionType.competition,
      QuestionType.history,
      QuestionType.rules,
      QuestionType.stadium,
      QuestionType.badge,
      QuestionType.playerImage,
      QuestionType.statistic,
      QuestionType.transfer,
      QuestionType.champion,
      QuestionType.topScorer,
    };

    // If it's not a multiple-choice type and has no options, leave as type-answer
    if (question.options.isEmpty && !multipleChoiceTypes.contains(question.type)) {
      return question;
    }

    // For types that should always have options but have placeholder data,
    // start with an empty list (correctAnswer will be added later)
    final enrichedOptions = hasPlaceholderOptions(question.options)
        ? <String>[]
        : List<String>.from(question.options);

    // Reserve a slot for the correct answer FIRST so the distractor loop can't
    // fill all 4 slots and then push a 5th when re-adding it below.
    if (!enrichedOptions.contains(question.correctAnswer)) {
      enrichedOptions.add(question.correctAnswer);
    }

    // Collect distractors only from questions of the SAME type to avoid
    // incoherent options (e.g. a player name in a stadium question).
    final sameTypeQuestions = allQuestions
        .where((q) => q.type == question.type)
        .toList();

    // Prefer distractors that share the question's context (country, league,
    // position, era, category, transfer period, competition type). Falls back
    // to any same-type answer, then to any type, if the context pool is small.
    List<String> poolFrom(List<Question> src) => src
        .map((q) => q.correctAnswer)
        .where((a) =>
            a.isNotEmpty &&
            a != question.correctAnswer &&
            !enrichedOptions.contains(a))
        .toSet()
        .toList();

    final contextKeys = _contextKeys(question);
    final sameTypeByContext = <String, List<String>>{};
    for (final key in contextKeys) {
      sameTypeByContext[key] = poolFrom(sameTypeQuestions
          .where((q) => _contextKeys(q).contains(key))
          .toList());
    }

    // Fill distractors in priority order: country > league > position > era
    // > category > transfer era > competition type. Keys are prefixed with
    // the question type to avoid mixing players, teams, competitions, etc.
    final typePrefix = question.type.name;
    final priorityPrefixes = [
      '$typePrefix:country:',
      '$typePrefix:league:',
      '$typePrefix:position:',
      '$typePrefix:birthDecade:',
      '$typePrefix:birthEra:',
      '$typePrefix:category:',
      '$typePrefix:transferHalfDecade:',
      '$typePrefix:transferDecade:',
      '$typePrefix:awardDecade:',
      '$typePrefix:compType:',
    ];
    var allAnswers = <String>[];
    for (final prefix in priorityPrefixes) {
      for (final key in contextKeys.where((k) => k.startsWith(prefix))) {
        final pool = sameTypeByContext[key] ?? [];
        allAnswers = [
          ...allAnswers,
          ...pool.where((a) => !allAnswers.contains(a)),
        ];
      }
      if (allAnswers.length >= 3) break;
    }

    // Fall back to any same-type answer, then to any type.
    if (allAnswers.length < 3) {
      final sameType = poolFrom(sameTypeQuestions);
      allAnswers = [...allAnswers, ...sameType.where((a) => !allAnswers.contains(a))];
    }
    if (allAnswers.length < 3) {
      final fallbackAnswers = allQuestions
          .map((q) => q.correctAnswer)
          .where((a) =>
              a.isNotEmpty &&
              a != question.correctAnswer &&
              !enrichedOptions.contains(a) &&
              !allAnswers.contains(a))
          .toSet()
          .toList();
      allAnswers = [...allAnswers, ...fallbackAnswers];
    }

    // Remove correct answer from distractor pool if present
    allAnswers.removeWhere((a) => enrichedOptions.contains(a));

    // Shuffle distractors for randomness
    allAnswers.shuffle(random);

    // Add distractors until we have 4 options (correct answer already in place)
    for (final distractor in allAnswers) {
      if (enrichedOptions.length >= 4) break;
      if (!enrichedOptions.contains(distractor)) {
        enrichedOptions.add(distractor);
      }
    }

    // If we still don't have 4, that's OK — return what we have
    if (enrichedOptions.length < 2) return question;

    // Shuffle final options
    enrichedOptions.shuffle(random);

    return Question(
      id: question.id,
      type: question.type,
      difficulty: question.difficulty,
      correctAnswer: question.correctAnswer,
      options: enrichedOptions,
      imageUrl: question.imageUrl,
      questionText: question.questionText,
      extraData: question.extraData,
    );
  }

  /// Context keys used to group questions whose distractors should be coherent
  /// with each other (same country, league, position, era, category, transfer
  /// period or competition type). Returns an empty list when no usable signal
  /// is stored in [extraData].
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

  /// Check if options contain placeholder text (e.g. "Opción Incorrecta A")
  @visibleForTesting
  static bool hasPlaceholderOptions(List<String> options) {
    const placeholders = {
      'opción incorrecta a', 'opción incorrecta b', 'opción incorrecta c',
      'option a', 'option b', 'option c',
      'opción 1', 'opción 2', 'opción 3',
      'option 1', 'option 2', 'option 3',
    };
    // If any option matches a placeholder, consider all options tainted
    return options.any((o) => placeholders.contains(o.toLowerCase().trim()));
  }
}
