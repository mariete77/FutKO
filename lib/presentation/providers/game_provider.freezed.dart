// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GameState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Question> questions,
            int currentQuestionIndex,
            int timeRemaining,
            int score,
            List<Answer> userAnswers,
            int correctAnswers,
            int streak)
        playing,
    required TResult Function(bool isCorrect, String correctAnswer,
            String selectedAnswer, int score)
        answered,
    required TResult Function(int score, int totalQuestions, int correctAnswers,
            List<Answer> userAnswers, double averageTime)
        finished,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Question> questions,
            int currentQuestionIndex,
            int timeRemaining,
            int score,
            List<Answer> userAnswers,
            int correctAnswers,
            int streak)?
        playing,
    TResult? Function(bool isCorrect, String correctAnswer,
            String selectedAnswer, int score)?
        answered,
    TResult? Function(int score, int totalQuestions, int correctAnswers,
            List<Answer> userAnswers, double averageTime)?
        finished,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Question> questions,
            int currentQuestionIndex,
            int timeRemaining,
            int score,
            List<Answer> userAnswers,
            int correctAnswers,
            int streak)?
        playing,
    TResult Function(bool isCorrect, String correctAnswer,
            String selectedAnswer, int score)?
        answered,
    TResult Function(int score, int totalQuestions, int correctAnswers,
            List<Answer> userAnswers, double averageTime)?
        finished,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Playing value) playing,
    required TResult Function(_Answered value) answered,
    required TResult Function(_Finished value) finished,
    required TResult Function(_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Playing value)? playing,
    TResult? Function(_Answered value)? answered,
    TResult? Function(_Finished value)? finished,
    TResult? Function(_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Playing value)? playing,
    TResult Function(_Answered value)? answered,
    TResult Function(_Finished value)? finished,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameStateCopyWith<$Res> {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) then) =
      _$GameStateCopyWithImpl<$Res, GameState>;
}

/// @nodoc
class _$GameStateCopyWithImpl<$Res, $Val extends GameState>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'GameState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Question> questions,
            int currentQuestionIndex,
            int timeRemaining,
            int score,
            List<Answer> userAnswers,
            int correctAnswers,
            int streak)
        playing,
    required TResult Function(bool isCorrect, String correctAnswer,
            String selectedAnswer, int score)
        answered,
    required TResult Function(int score, int totalQuestions, int correctAnswers,
            List<Answer> userAnswers, double averageTime)
        finished,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Question> questions,
            int currentQuestionIndex,
            int timeRemaining,
            int score,
            List<Answer> userAnswers,
            int correctAnswers,
            int streak)?
        playing,
    TResult? Function(bool isCorrect, String correctAnswer,
            String selectedAnswer, int score)?
        answered,
    TResult? Function(int score, int totalQuestions, int correctAnswers,
            List<Answer> userAnswers, double averageTime)?
        finished,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Question> questions,
            int currentQuestionIndex,
            int timeRemaining,
            int score,
            List<Answer> userAnswers,
            int correctAnswers,
            int streak)?
        playing,
    TResult Function(bool isCorrect, String correctAnswer,
            String selectedAnswer, int score)?
        answered,
    TResult Function(int score, int totalQuestions, int correctAnswers,
            List<Answer> userAnswers, double averageTime)?
        finished,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Playing value) playing,
    required TResult Function(_Answered value) answered,
    required TResult Function(_Finished value) finished,
    required TResult Function(_Error value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Playing value)? playing,
    TResult? Function(_Answered value)? answered,
    TResult? Function(_Finished value)? finished,
    TResult? Function(_Error value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Playing value)? playing,
    TResult Function(_Answered value)? answered,
    TResult Function(_Finished value)? finished,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements GameState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl value, $Res Function(_$LoadingImpl) then) =
      __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'GameState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Question> questions,
            int currentQuestionIndex,
            int timeRemaining,
            int score,
            List<Answer> userAnswers,
            int correctAnswers,
            int streak)
        playing,
    required TResult Function(bool isCorrect, String correctAnswer,
            String selectedAnswer, int score)
        answered,
    required TResult Function(int score, int totalQuestions, int correctAnswers,
            List<Answer> userAnswers, double averageTime)
        finished,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Question> questions,
            int currentQuestionIndex,
            int timeRemaining,
            int score,
            List<Answer> userAnswers,
            int correctAnswers,
            int streak)?
        playing,
    TResult? Function(bool isCorrect, String correctAnswer,
            String selectedAnswer, int score)?
        answered,
    TResult? Function(int score, int totalQuestions, int correctAnswers,
            List<Answer> userAnswers, double averageTime)?
        finished,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Question> questions,
            int currentQuestionIndex,
            int timeRemaining,
            int score,
            List<Answer> userAnswers,
            int correctAnswers,
            int streak)?
        playing,
    TResult Function(bool isCorrect, String correctAnswer,
            String selectedAnswer, int score)?
        answered,
    TResult Function(int score, int totalQuestions, int correctAnswers,
            List<Answer> userAnswers, double averageTime)?
        finished,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Playing value) playing,
    required TResult Function(_Answered value) answered,
    required TResult Function(_Finished value) finished,
    required TResult Function(_Error value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Playing value)? playing,
    TResult? Function(_Answered value)? answered,
    TResult? Function(_Finished value)? finished,
    TResult? Function(_Error value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Playing value)? playing,
    TResult Function(_Answered value)? answered,
    TResult Function(_Finished value)? finished,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements GameState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$PlayingImplCopyWith<$Res> {
  factory _$$PlayingImplCopyWith(
          _$PlayingImpl value, $Res Function(_$PlayingImpl) then) =
      __$$PlayingImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {List<Question> questions,
      int currentQuestionIndex,
      int timeRemaining,
      int score,
      List<Answer> userAnswers,
      int correctAnswers,
      int streak});
}

/// @nodoc
class __$$PlayingImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$PlayingImpl>
    implements _$$PlayingImplCopyWith<$Res> {
  __$$PlayingImplCopyWithImpl(
      _$PlayingImpl _value, $Res Function(_$PlayingImpl) _then)
      : super(_value, _then);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questions = null,
    Object? currentQuestionIndex = null,
    Object? timeRemaining = null,
    Object? score = null,
    Object? userAnswers = null,
    Object? correctAnswers = null,
    Object? streak = null,
  }) {
    return _then(_$PlayingImpl(
      questions: null == questions
          ? _value._questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<Question>,
      currentQuestionIndex: null == currentQuestionIndex
          ? _value.currentQuestionIndex
          : currentQuestionIndex // ignore: cast_nullable_to_non_nullable
              as int,
      timeRemaining: null == timeRemaining
          ? _value.timeRemaining
          : timeRemaining // ignore: cast_nullable_to_non_nullable
              as int,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      userAnswers: null == userAnswers
          ? _value._userAnswers
          : userAnswers // ignore: cast_nullable_to_non_nullable
              as List<Answer>,
      correctAnswers: null == correctAnswers
          ? _value.correctAnswers
          : correctAnswers // ignore: cast_nullable_to_non_nullable
              as int,
      streak: null == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$PlayingImpl implements _Playing {
  const _$PlayingImpl(
      {required final List<Question> questions,
      required this.currentQuestionIndex,
      required this.timeRemaining,
      required this.score,
      required final List<Answer> userAnswers,
      required this.correctAnswers,
      required this.streak})
      : _questions = questions,
        _userAnswers = userAnswers;

  final List<Question> _questions;
  @override
  List<Question> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  @override
  final int currentQuestionIndex;
  @override
  final int timeRemaining;
  @override
  final int score;
  final List<Answer> _userAnswers;
  @override
  List<Answer> get userAnswers {
    if (_userAnswers is EqualUnmodifiableListView) return _userAnswers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userAnswers);
  }

  @override
  final int correctAnswers;
  @override
  final int streak;

  @override
  String toString() {
    return 'GameState.playing(questions: $questions, currentQuestionIndex: $currentQuestionIndex, timeRemaining: $timeRemaining, score: $score, userAnswers: $userAnswers, correctAnswers: $correctAnswers, streak: $streak)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayingImpl &&
            const DeepCollectionEquality()
                .equals(other._questions, _questions) &&
            (identical(other.currentQuestionIndex, currentQuestionIndex) ||
                other.currentQuestionIndex == currentQuestionIndex) &&
            (identical(other.timeRemaining, timeRemaining) ||
                other.timeRemaining == timeRemaining) &&
            (identical(other.score, score) || other.score == score) &&
            const DeepCollectionEquality()
                .equals(other._userAnswers, _userAnswers) &&
            (identical(other.correctAnswers, correctAnswers) ||
                other.correctAnswers == correctAnswers) &&
            (identical(other.streak, streak) || other.streak == streak));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_questions),
      currentQuestionIndex,
      timeRemaining,
      score,
      const DeepCollectionEquality().hash(_userAnswers),
      correctAnswers,
      streak);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayingImplCopyWith<_$PlayingImpl> get copyWith =>
      __$$PlayingImplCopyWithImpl<_$PlayingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Question> questions,
            int currentQuestionIndex,
            int timeRemaining,
            int score,
            List<Answer> userAnswers,
            int correctAnswers,
            int streak)
        playing,
    required TResult Function(bool isCorrect, String correctAnswer,
            String selectedAnswer, int score)
        answered,
    required TResult Function(int score, int totalQuestions, int correctAnswers,
            List<Answer> userAnswers, double averageTime)
        finished,
    required TResult Function(String message) error,
  }) {
    return playing(questions, currentQuestionIndex, timeRemaining, score,
        userAnswers, correctAnswers, streak);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Question> questions,
            int currentQuestionIndex,
            int timeRemaining,
            int score,
            List<Answer> userAnswers,
            int correctAnswers,
            int streak)?
        playing,
    TResult? Function(bool isCorrect, String correctAnswer,
            String selectedAnswer, int score)?
        answered,
    TResult? Function(int score, int totalQuestions, int correctAnswers,
            List<Answer> userAnswers, double averageTime)?
        finished,
    TResult? Function(String message)? error,
  }) {
    return playing?.call(questions, currentQuestionIndex, timeRemaining, score,
        userAnswers, correctAnswers, streak);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Question> questions,
            int currentQuestionIndex,
            int timeRemaining,
            int score,
            List<Answer> userAnswers,
            int correctAnswers,
            int streak)?
        playing,
    TResult Function(bool isCorrect, String correctAnswer,
            String selectedAnswer, int score)?
        answered,
    TResult Function(int score, int totalQuestions, int correctAnswers,
            List<Answer> userAnswers, double averageTime)?
        finished,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (playing != null) {
      return playing(questions, currentQuestionIndex, timeRemaining, score,
          userAnswers, correctAnswers, streak);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Playing value) playing,
    required TResult Function(_Answered value) answered,
    required TResult Function(_Finished value) finished,
    required TResult Function(_Error value) error,
  }) {
    return playing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Playing value)? playing,
    TResult? Function(_Answered value)? answered,
    TResult? Function(_Finished value)? finished,
    TResult? Function(_Error value)? error,
  }) {
    return playing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Playing value)? playing,
    TResult Function(_Answered value)? answered,
    TResult Function(_Finished value)? finished,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (playing != null) {
      return playing(this);
    }
    return orElse();
  }
}

abstract class _Playing implements GameState {
  const factory _Playing(
      {required final List<Question> questions,
      required final int currentQuestionIndex,
      required final int timeRemaining,
      required final int score,
      required final List<Answer> userAnswers,
      required final int correctAnswers,
      required final int streak}) = _$PlayingImpl;

  List<Question> get questions;
  int get currentQuestionIndex;
  int get timeRemaining;
  int get score;
  List<Answer> get userAnswers;
  int get correctAnswers;
  int get streak;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayingImplCopyWith<_$PlayingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AnsweredImplCopyWith<$Res> {
  factory _$$AnsweredImplCopyWith(
          _$AnsweredImpl value, $Res Function(_$AnsweredImpl) then) =
      __$$AnsweredImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {bool isCorrect, String correctAnswer, String selectedAnswer, int score});
}

/// @nodoc
class __$$AnsweredImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$AnsweredImpl>
    implements _$$AnsweredImplCopyWith<$Res> {
  __$$AnsweredImplCopyWithImpl(
      _$AnsweredImpl _value, $Res Function(_$AnsweredImpl) _then)
      : super(_value, _then);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCorrect = null,
    Object? correctAnswer = null,
    Object? selectedAnswer = null,
    Object? score = null,
  }) {
    return _then(_$AnsweredImpl(
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      correctAnswer: null == correctAnswer
          ? _value.correctAnswer
          : correctAnswer // ignore: cast_nullable_to_non_nullable
              as String,
      selectedAnswer: null == selectedAnswer
          ? _value.selectedAnswer
          : selectedAnswer // ignore: cast_nullable_to_non_nullable
              as String,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$AnsweredImpl implements _Answered {
  const _$AnsweredImpl(
      {required this.isCorrect,
      required this.correctAnswer,
      required this.selectedAnswer,
      required this.score});

  @override
  final bool isCorrect;
  @override
  final String correctAnswer;
  @override
  final String selectedAnswer;
  @override
  final int score;

  @override
  String toString() {
    return 'GameState.answered(isCorrect: $isCorrect, correctAnswer: $correctAnswer, selectedAnswer: $selectedAnswer, score: $score)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnsweredImpl &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.correctAnswer, correctAnswer) ||
                other.correctAnswer == correctAnswer) &&
            (identical(other.selectedAnswer, selectedAnswer) ||
                other.selectedAnswer == selectedAnswer) &&
            (identical(other.score, score) || other.score == score));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isCorrect, correctAnswer, selectedAnswer, score);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnsweredImplCopyWith<_$AnsweredImpl> get copyWith =>
      __$$AnsweredImplCopyWithImpl<_$AnsweredImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Question> questions,
            int currentQuestionIndex,
            int timeRemaining,
            int score,
            List<Answer> userAnswers,
            int correctAnswers,
            int streak)
        playing,
    required TResult Function(bool isCorrect, String correctAnswer,
            String selectedAnswer, int score)
        answered,
    required TResult Function(int score, int totalQuestions, int correctAnswers,
            List<Answer> userAnswers, double averageTime)
        finished,
    required TResult Function(String message) error,
  }) {
    return answered(isCorrect, correctAnswer, selectedAnswer, score);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Question> questions,
            int currentQuestionIndex,
            int timeRemaining,
            int score,
            List<Answer> userAnswers,
            int correctAnswers,
            int streak)?
        playing,
    TResult? Function(bool isCorrect, String correctAnswer,
            String selectedAnswer, int score)?
        answered,
    TResult? Function(int score, int totalQuestions, int correctAnswers,
            List<Answer> userAnswers, double averageTime)?
        finished,
    TResult? Function(String message)? error,
  }) {
    return answered?.call(isCorrect, correctAnswer, selectedAnswer, score);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Question> questions,
            int currentQuestionIndex,
            int timeRemaining,
            int score,
            List<Answer> userAnswers,
            int correctAnswers,
            int streak)?
        playing,
    TResult Function(bool isCorrect, String correctAnswer,
            String selectedAnswer, int score)?
        answered,
    TResult Function(int score, int totalQuestions, int correctAnswers,
            List<Answer> userAnswers, double averageTime)?
        finished,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (answered != null) {
      return answered(isCorrect, correctAnswer, selectedAnswer, score);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Playing value) playing,
    required TResult Function(_Answered value) answered,
    required TResult Function(_Finished value) finished,
    required TResult Function(_Error value) error,
  }) {
    return answered(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Playing value)? playing,
    TResult? Function(_Answered value)? answered,
    TResult? Function(_Finished value)? finished,
    TResult? Function(_Error value)? error,
  }) {
    return answered?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Playing value)? playing,
    TResult Function(_Answered value)? answered,
    TResult Function(_Finished value)? finished,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (answered != null) {
      return answered(this);
    }
    return orElse();
  }
}

abstract class _Answered implements GameState {
  const factory _Answered(
      {required final bool isCorrect,
      required final String correctAnswer,
      required final String selectedAnswer,
      required final int score}) = _$AnsweredImpl;

  bool get isCorrect;
  String get correctAnswer;
  String get selectedAnswer;
  int get score;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnsweredImplCopyWith<_$AnsweredImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FinishedImplCopyWith<$Res> {
  factory _$$FinishedImplCopyWith(
          _$FinishedImpl value, $Res Function(_$FinishedImpl) then) =
      __$$FinishedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {int score,
      int totalQuestions,
      int correctAnswers,
      List<Answer> userAnswers,
      double averageTime});
}

/// @nodoc
class __$$FinishedImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$FinishedImpl>
    implements _$$FinishedImplCopyWith<$Res> {
  __$$FinishedImplCopyWithImpl(
      _$FinishedImpl _value, $Res Function(_$FinishedImpl) _then)
      : super(_value, _then);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? score = null,
    Object? totalQuestions = null,
    Object? correctAnswers = null,
    Object? userAnswers = null,
    Object? averageTime = null,
  }) {
    return _then(_$FinishedImpl(
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      totalQuestions: null == totalQuestions
          ? _value.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      correctAnswers: null == correctAnswers
          ? _value.correctAnswers
          : correctAnswers // ignore: cast_nullable_to_non_nullable
              as int,
      userAnswers: null == userAnswers
          ? _value._userAnswers
          : userAnswers // ignore: cast_nullable_to_non_nullable
              as List<Answer>,
      averageTime: null == averageTime
          ? _value.averageTime
          : averageTime // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$FinishedImpl implements _Finished {
  const _$FinishedImpl(
      {required this.score,
      required this.totalQuestions,
      required this.correctAnswers,
      required final List<Answer> userAnswers,
      required this.averageTime})
      : _userAnswers = userAnswers;

  @override
  final int score;
  @override
  final int totalQuestions;
  @override
  final int correctAnswers;
  final List<Answer> _userAnswers;
  @override
  List<Answer> get userAnswers {
    if (_userAnswers is EqualUnmodifiableListView) return _userAnswers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userAnswers);
  }

  @override
  final double averageTime;

  @override
  String toString() {
    return 'GameState.finished(score: $score, totalQuestions: $totalQuestions, correctAnswers: $correctAnswers, userAnswers: $userAnswers, averageTime: $averageTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinishedImpl &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.totalQuestions, totalQuestions) ||
                other.totalQuestions == totalQuestions) &&
            (identical(other.correctAnswers, correctAnswers) ||
                other.correctAnswers == correctAnswers) &&
            const DeepCollectionEquality()
                .equals(other._userAnswers, _userAnswers) &&
            (identical(other.averageTime, averageTime) ||
                other.averageTime == averageTime));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      score,
      totalQuestions,
      correctAnswers,
      const DeepCollectionEquality().hash(_userAnswers),
      averageTime);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FinishedImplCopyWith<_$FinishedImpl> get copyWith =>
      __$$FinishedImplCopyWithImpl<_$FinishedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Question> questions,
            int currentQuestionIndex,
            int timeRemaining,
            int score,
            List<Answer> userAnswers,
            int correctAnswers,
            int streak)
        playing,
    required TResult Function(bool isCorrect, String correctAnswer,
            String selectedAnswer, int score)
        answered,
    required TResult Function(int score, int totalQuestions, int correctAnswers,
            List<Answer> userAnswers, double averageTime)
        finished,
    required TResult Function(String message) error,
  }) {
    return finished(
        score, totalQuestions, correctAnswers, userAnswers, averageTime);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Question> questions,
            int currentQuestionIndex,
            int timeRemaining,
            int score,
            List<Answer> userAnswers,
            int correctAnswers,
            int streak)?
        playing,
    TResult? Function(bool isCorrect, String correctAnswer,
            String selectedAnswer, int score)?
        answered,
    TResult? Function(int score, int totalQuestions, int correctAnswers,
            List<Answer> userAnswers, double averageTime)?
        finished,
    TResult? Function(String message)? error,
  }) {
    return finished?.call(
        score, totalQuestions, correctAnswers, userAnswers, averageTime);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Question> questions,
            int currentQuestionIndex,
            int timeRemaining,
            int score,
            List<Answer> userAnswers,
            int correctAnswers,
            int streak)?
        playing,
    TResult Function(bool isCorrect, String correctAnswer,
            String selectedAnswer, int score)?
        answered,
    TResult Function(int score, int totalQuestions, int correctAnswers,
            List<Answer> userAnswers, double averageTime)?
        finished,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (finished != null) {
      return finished(
          score, totalQuestions, correctAnswers, userAnswers, averageTime);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Playing value) playing,
    required TResult Function(_Answered value) answered,
    required TResult Function(_Finished value) finished,
    required TResult Function(_Error value) error,
  }) {
    return finished(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Playing value)? playing,
    TResult? Function(_Answered value)? answered,
    TResult? Function(_Finished value)? finished,
    TResult? Function(_Error value)? error,
  }) {
    return finished?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Playing value)? playing,
    TResult Function(_Answered value)? answered,
    TResult Function(_Finished value)? finished,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (finished != null) {
      return finished(this);
    }
    return orElse();
  }
}

abstract class _Finished implements GameState {
  const factory _Finished(
      {required final int score,
      required final int totalQuestions,
      required final int correctAnswers,
      required final List<Answer> userAnswers,
      required final double averageTime}) = _$FinishedImpl;

  int get score;
  int get totalQuestions;
  int get correctAnswers;
  List<Answer> get userAnswers;
  double get averageTime;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FinishedImplCopyWith<_$FinishedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'GameState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Question> questions,
            int currentQuestionIndex,
            int timeRemaining,
            int score,
            List<Answer> userAnswers,
            int correctAnswers,
            int streak)
        playing,
    required TResult Function(bool isCorrect, String correctAnswer,
            String selectedAnswer, int score)
        answered,
    required TResult Function(int score, int totalQuestions, int correctAnswers,
            List<Answer> userAnswers, double averageTime)
        finished,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<Question> questions,
            int currentQuestionIndex,
            int timeRemaining,
            int score,
            List<Answer> userAnswers,
            int correctAnswers,
            int streak)?
        playing,
    TResult? Function(bool isCorrect, String correctAnswer,
            String selectedAnswer, int score)?
        answered,
    TResult? Function(int score, int totalQuestions, int correctAnswers,
            List<Answer> userAnswers, double averageTime)?
        finished,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<Question> questions,
            int currentQuestionIndex,
            int timeRemaining,
            int score,
            List<Answer> userAnswers,
            int correctAnswers,
            int streak)?
        playing,
    TResult Function(bool isCorrect, String correctAnswer,
            String selectedAnswer, int score)?
        answered,
    TResult Function(int score, int totalQuestions, int correctAnswers,
            List<Answer> userAnswers, double averageTime)?
        finished,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Playing value) playing,
    required TResult Function(_Answered value) answered,
    required TResult Function(_Finished value) finished,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Playing value)? playing,
    TResult? Function(_Answered value)? answered,
    TResult? Function(_Finished value)? finished,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Playing value)? playing,
    TResult Function(_Answered value)? answered,
    TResult Function(_Finished value)? finished,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements GameState {
  const factory _Error({required final String message}) = _$ErrorImpl;

  String get message;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
