// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_attempt_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuizAttemptModelImpl _$$QuizAttemptModelImplFromJson(
        Map<String, dynamic> json) =>
    _$QuizAttemptModelImpl(
      questionId: json['questionId'] as String,
      questionType: json['questionType'] as String,
      correctAnswer: json['correctAnswer'] as String,
      userAnswer: json['userAnswer'] as String,
      isCorrect: json['isCorrect'] as bool,
      isTimeout: json['isTimeout'] as bool,
      timeMs: (json['timeMs'] as num).toInt(),
      matchId: json['matchId'] as String,
      matchMode: json['matchMode'] as String,
      matchType: json['matchType'] as String,
      userId: json['userId'] as String?,
      userElo: (json['userElo'] as num?)?.toInt(),
      questionDifficulty: json['questionDifficulty'] as String?,
      answeredAt: DateTime.parse(json['answeredAt'] as String),
      questionData: json['questionData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$QuizAttemptModelImplToJson(
        _$QuizAttemptModelImpl instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'questionType': instance.questionType,
      'correctAnswer': instance.correctAnswer,
      'userAnswer': instance.userAnswer,
      'isCorrect': instance.isCorrect,
      'isTimeout': instance.isTimeout,
      'timeMs': instance.timeMs,
      'matchId': instance.matchId,
      'matchMode': instance.matchMode,
      'matchType': instance.matchType,
      'userId': instance.userId,
      'userElo': instance.userElo,
      'questionDifficulty': instance.questionDifficulty,
      'answeredAt': instance.answeredAt.toIso8601String(),
      'questionData': instance.questionData,
    };
