// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_attempt_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuizAttemptModel _$QuizAttemptModelFromJson(Map<String, dynamic> json) {
  return _QuizAttemptModel.fromJson(json);
}

/// @nodoc
mixin _$QuizAttemptModel {
  String get questionId => throw _privateConstructorUsedError;
  String get questionType => throw _privateConstructorUsedError;
  String get correctAnswer => throw _privateConstructorUsedError;
  String get userAnswer => throw _privateConstructorUsedError;
  bool get isCorrect => throw _privateConstructorUsedError;
  bool get isTimeout => throw _privateConstructorUsedError;
  int get timeMs => throw _privateConstructorUsedError;
  String get matchId => throw _privateConstructorUsedError;
  String get matchMode => throw _privateConstructorUsedError;
  String get matchType => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  int? get userElo => throw _privateConstructorUsedError;
  String? get questionDifficulty => throw _privateConstructorUsedError;
  DateTime get answeredAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get questionData => throw _privateConstructorUsedError;

  /// Serializes this QuizAttemptModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizAttemptModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizAttemptModelCopyWith<QuizAttemptModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizAttemptModelCopyWith<$Res> {
  factory $QuizAttemptModelCopyWith(
          QuizAttemptModel value, $Res Function(QuizAttemptModel) then) =
      _$QuizAttemptModelCopyWithImpl<$Res, QuizAttemptModel>;
  @useResult
  $Res call(
      {String questionId,
      String questionType,
      String correctAnswer,
      String userAnswer,
      bool isCorrect,
      bool isTimeout,
      int timeMs,
      String matchId,
      String matchMode,
      String matchType,
      String? userId,
      int? userElo,
      String? questionDifficulty,
      DateTime answeredAt,
      Map<String, dynamic>? questionData});
}

/// @nodoc
class _$QuizAttemptModelCopyWithImpl<$Res, $Val extends QuizAttemptModel>
    implements $QuizAttemptModelCopyWith<$Res> {
  _$QuizAttemptModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizAttemptModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = null,
    Object? questionType = null,
    Object? correctAnswer = null,
    Object? userAnswer = null,
    Object? isCorrect = null,
    Object? isTimeout = null,
    Object? timeMs = null,
    Object? matchId = null,
    Object? matchMode = null,
    Object? matchType = null,
    Object? userId = freezed,
    Object? userElo = freezed,
    Object? questionDifficulty = freezed,
    Object? answeredAt = null,
    Object? questionData = freezed,
  }) {
    return _then(_value.copyWith(
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      questionType: null == questionType
          ? _value.questionType
          : questionType // ignore: cast_nullable_to_non_nullable
              as String,
      correctAnswer: null == correctAnswer
          ? _value.correctAnswer
          : correctAnswer // ignore: cast_nullable_to_non_nullable
              as String,
      userAnswer: null == userAnswer
          ? _value.userAnswer
          : userAnswer // ignore: cast_nullable_to_non_nullable
              as String,
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      isTimeout: null == isTimeout
          ? _value.isTimeout
          : isTimeout // ignore: cast_nullable_to_non_nullable
              as bool,
      timeMs: null == timeMs
          ? _value.timeMs
          : timeMs // ignore: cast_nullable_to_non_nullable
              as int,
      matchId: null == matchId
          ? _value.matchId
          : matchId // ignore: cast_nullable_to_non_nullable
              as String,
      matchMode: null == matchMode
          ? _value.matchMode
          : matchMode // ignore: cast_nullable_to_non_nullable
              as String,
      matchType: null == matchType
          ? _value.matchType
          : matchType // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      userElo: freezed == userElo
          ? _value.userElo
          : userElo // ignore: cast_nullable_to_non_nullable
              as int?,
      questionDifficulty: freezed == questionDifficulty
          ? _value.questionDifficulty
          : questionDifficulty // ignore: cast_nullable_to_non_nullable
              as String?,
      answeredAt: null == answeredAt
          ? _value.answeredAt
          : answeredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      questionData: freezed == questionData
          ? _value.questionData
          : questionData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuizAttemptModelImplCopyWith<$Res>
    implements $QuizAttemptModelCopyWith<$Res> {
  factory _$$QuizAttemptModelImplCopyWith(_$QuizAttemptModelImpl value,
          $Res Function(_$QuizAttemptModelImpl) then) =
      __$$QuizAttemptModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String questionId,
      String questionType,
      String correctAnswer,
      String userAnswer,
      bool isCorrect,
      bool isTimeout,
      int timeMs,
      String matchId,
      String matchMode,
      String matchType,
      String? userId,
      int? userElo,
      String? questionDifficulty,
      DateTime answeredAt,
      Map<String, dynamic>? questionData});
}

/// @nodoc
class __$$QuizAttemptModelImplCopyWithImpl<$Res>
    extends _$QuizAttemptModelCopyWithImpl<$Res, _$QuizAttemptModelImpl>
    implements _$$QuizAttemptModelImplCopyWith<$Res> {
  __$$QuizAttemptModelImplCopyWithImpl(_$QuizAttemptModelImpl _value,
      $Res Function(_$QuizAttemptModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuizAttemptModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = null,
    Object? questionType = null,
    Object? correctAnswer = null,
    Object? userAnswer = null,
    Object? isCorrect = null,
    Object? isTimeout = null,
    Object? timeMs = null,
    Object? matchId = null,
    Object? matchMode = null,
    Object? matchType = null,
    Object? userId = freezed,
    Object? userElo = freezed,
    Object? questionDifficulty = freezed,
    Object? answeredAt = null,
    Object? questionData = freezed,
  }) {
    return _then(_$QuizAttemptModelImpl(
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      questionType: null == questionType
          ? _value.questionType
          : questionType // ignore: cast_nullable_to_non_nullable
              as String,
      correctAnswer: null == correctAnswer
          ? _value.correctAnswer
          : correctAnswer // ignore: cast_nullable_to_non_nullable
              as String,
      userAnswer: null == userAnswer
          ? _value.userAnswer
          : userAnswer // ignore: cast_nullable_to_non_nullable
              as String,
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      isTimeout: null == isTimeout
          ? _value.isTimeout
          : isTimeout // ignore: cast_nullable_to_non_nullable
              as bool,
      timeMs: null == timeMs
          ? _value.timeMs
          : timeMs // ignore: cast_nullable_to_non_nullable
              as int,
      matchId: null == matchId
          ? _value.matchId
          : matchId // ignore: cast_nullable_to_non_nullable
              as String,
      matchMode: null == matchMode
          ? _value.matchMode
          : matchMode // ignore: cast_nullable_to_non_nullable
              as String,
      matchType: null == matchType
          ? _value.matchType
          : matchType // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      userElo: freezed == userElo
          ? _value.userElo
          : userElo // ignore: cast_nullable_to_non_nullable
              as int?,
      questionDifficulty: freezed == questionDifficulty
          ? _value.questionDifficulty
          : questionDifficulty // ignore: cast_nullable_to_non_nullable
              as String?,
      answeredAt: null == answeredAt
          ? _value.answeredAt
          : answeredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      questionData: freezed == questionData
          ? _value._questionData
          : questionData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizAttemptModelImpl extends _QuizAttemptModel {
  const _$QuizAttemptModelImpl(
      {required this.questionId,
      required this.questionType,
      required this.correctAnswer,
      required this.userAnswer,
      required this.isCorrect,
      required this.isTimeout,
      required this.timeMs,
      required this.matchId,
      required this.matchMode,
      required this.matchType,
      this.userId,
      this.userElo,
      this.questionDifficulty,
      required this.answeredAt,
      final Map<String, dynamic>? questionData})
      : _questionData = questionData,
        super._();

  factory _$QuizAttemptModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizAttemptModelImplFromJson(json);

  @override
  final String questionId;
  @override
  final String questionType;
  @override
  final String correctAnswer;
  @override
  final String userAnswer;
  @override
  final bool isCorrect;
  @override
  final bool isTimeout;
  @override
  final int timeMs;
  @override
  final String matchId;
  @override
  final String matchMode;
  @override
  final String matchType;
  @override
  final String? userId;
  @override
  final int? userElo;
  @override
  final String? questionDifficulty;
  @override
  final DateTime answeredAt;
  final Map<String, dynamic>? _questionData;
  @override
  Map<String, dynamic>? get questionData {
    final value = _questionData;
    if (value == null) return null;
    if (_questionData is EqualUnmodifiableMapView) return _questionData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'QuizAttemptModel(questionId: $questionId, questionType: $questionType, correctAnswer: $correctAnswer, userAnswer: $userAnswer, isCorrect: $isCorrect, isTimeout: $isTimeout, timeMs: $timeMs, matchId: $matchId, matchMode: $matchMode, matchType: $matchType, userId: $userId, userElo: $userElo, questionDifficulty: $questionDifficulty, answeredAt: $answeredAt, questionData: $questionData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizAttemptModelImpl &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.questionType, questionType) ||
                other.questionType == questionType) &&
            (identical(other.correctAnswer, correctAnswer) ||
                other.correctAnswer == correctAnswer) &&
            (identical(other.userAnswer, userAnswer) ||
                other.userAnswer == userAnswer) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.isTimeout, isTimeout) ||
                other.isTimeout == isTimeout) &&
            (identical(other.timeMs, timeMs) || other.timeMs == timeMs) &&
            (identical(other.matchId, matchId) || other.matchId == matchId) &&
            (identical(other.matchMode, matchMode) ||
                other.matchMode == matchMode) &&
            (identical(other.matchType, matchType) ||
                other.matchType == matchType) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userElo, userElo) || other.userElo == userElo) &&
            (identical(other.questionDifficulty, questionDifficulty) ||
                other.questionDifficulty == questionDifficulty) &&
            (identical(other.answeredAt, answeredAt) ||
                other.answeredAt == answeredAt) &&
            const DeepCollectionEquality()
                .equals(other._questionData, _questionData));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      questionId,
      questionType,
      correctAnswer,
      userAnswer,
      isCorrect,
      isTimeout,
      timeMs,
      matchId,
      matchMode,
      matchType,
      userId,
      userElo,
      questionDifficulty,
      answeredAt,
      const DeepCollectionEquality().hash(_questionData));

  /// Create a copy of QuizAttemptModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizAttemptModelImplCopyWith<_$QuizAttemptModelImpl> get copyWith =>
      __$$QuizAttemptModelImplCopyWithImpl<_$QuizAttemptModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizAttemptModelImplToJson(
      this,
    );
  }
}

abstract class _QuizAttemptModel extends QuizAttemptModel {
  const factory _QuizAttemptModel(
      {required final String questionId,
      required final String questionType,
      required final String correctAnswer,
      required final String userAnswer,
      required final bool isCorrect,
      required final bool isTimeout,
      required final int timeMs,
      required final String matchId,
      required final String matchMode,
      required final String matchType,
      final String? userId,
      final int? userElo,
      final String? questionDifficulty,
      required final DateTime answeredAt,
      final Map<String, dynamic>? questionData}) = _$QuizAttemptModelImpl;
  const _QuizAttemptModel._() : super._();

  factory _QuizAttemptModel.fromJson(Map<String, dynamic> json) =
      _$QuizAttemptModelImpl.fromJson;

  @override
  String get questionId;
  @override
  String get questionType;
  @override
  String get correctAnswer;
  @override
  String get userAnswer;
  @override
  bool get isCorrect;
  @override
  bool get isTimeout;
  @override
  int get timeMs;
  @override
  String get matchId;
  @override
  String get matchMode;
  @override
  String get matchType;
  @override
  String? get userId;
  @override
  int? get userElo;
  @override
  String? get questionDifficulty;
  @override
  DateTime get answeredAt;
  @override
  Map<String, dynamic>? get questionData;

  /// Create a copy of QuizAttemptModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizAttemptModelImplCopyWith<_$QuizAttemptModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
