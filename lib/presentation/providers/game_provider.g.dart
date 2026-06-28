// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$questionRepositoryHash() =>
    r'6f15d44c48fbc2ac361117f8e21c34707b8e655d';

/// Question repository provider
///
/// Copied from [questionRepository].
@ProviderFor(questionRepository)
final questionRepositoryProvider =
    AutoDisposeProvider<QuestionRepository>.internal(
  questionRepository,
  name: r'questionRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$questionRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QuestionRepositoryRef = AutoDisposeProviderRef<QuestionRepository>;
String _$quizAttemptRepositoryHash() =>
    r'55592eab9bd5313ca8d8d81f58c1148c9374f4c5';

/// Quiz attempt repository provider
///
/// Copied from [quizAttemptRepository].
@ProviderFor(quizAttemptRepository)
final quizAttemptRepositoryProvider =
    AutoDisposeProvider<QuizAttemptRepository>.internal(
  quizAttemptRepository,
  name: r'quizAttemptRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$quizAttemptRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QuizAttemptRepositoryRef
    = AutoDisposeProviderRef<QuizAttemptRepository>;
String _$currentQuestionHash() => r'ef6004e0fd18ee6abca858f54a810d2b228dd3a8';

/// Current question provider
///
/// Copied from [currentQuestion].
@ProviderFor(currentQuestion)
final currentQuestionProvider = AutoDisposeProvider<Question?>.internal(
  currentQuestion,
  name: r'currentQuestionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentQuestionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentQuestionRef = AutoDisposeProviderRef<Question?>;
String _$progressPercentageHash() =>
    r'726ba492f23dcf7cd170ada0cafa4ac03d0f47b5';

/// Progress percentage provider
///
/// Copied from [progressPercentage].
@ProviderFor(progressPercentage)
final progressPercentageProvider = AutoDisposeProvider<double>.internal(
  progressPercentage,
  name: r'progressPercentageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$progressPercentageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProgressPercentageRef = AutoDisposeProviderRef<double>;
String _$timerProgressHash() => r'1844cb4296f85fb32fe0715866d668da83b0c4fb';

/// Timer progress provider (0.0 to 1.0)
///
/// Copied from [timerProgress].
@ProviderFor(timerProgress)
final timerProgressProvider = AutoDisposeProvider<double>.internal(
  timerProgress,
  name: r'timerProgressProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$timerProgressHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TimerProgressRef = AutoDisposeProviderRef<double>;
String _$gameNotifierHash() => r'fd463cf68e132576301addc066a12a86d5e91320';

/// Game provider
///
/// Copied from [GameNotifier].
@ProviderFor(GameNotifier)
final gameNotifierProvider =
    AutoDisposeNotifierProvider<GameNotifier, GameState>.internal(
  GameNotifier.new,
  name: r'gameNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$gameNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GameNotifier = AutoDisposeNotifier<GameState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
