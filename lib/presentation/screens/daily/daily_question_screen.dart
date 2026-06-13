import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/daily_question_provider.dart';
import '../../providers/user_provider.dart';
import '../../../domain/entities/question.dart';

class DailyQuestionScreen extends ConsumerStatefulWidget {
  const DailyQuestionScreen({super.key});

  @override
  ConsumerState<DailyQuestionScreen> createState() => _DailyQuestionScreenState();
}

class _DailyQuestionScreenState extends ConsumerState<DailyQuestionScreen> {
  bool _answered = false;
  String? _selectedAnswer;
  bool _isCorrect = false;

  @override
  Widget build(BuildContext context) {
    final questionAsync = ref.watch(dailyQuestionProvider);
    final dailyStreak =
        ref.watch(userNotifierProvider).valueOrNull?.dailyStreak ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Pregunta del Día',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (dailyStreak > 0)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.tertiary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(color: AppColors.tertiary.withOpacity(0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_fire_department,
                          size: 16, color: AppColors.tertiary),
                      const SizedBox(width: 4),
                      Text(
                        '$dailyStreak',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.tertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Responde hoy y gana puntos extra',
                        style: GoogleFonts.workSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              questionAsync.when(
                data: (question) {
                  if (question == null) {
                    return const Center(
                      child: Text('No hay preguntas disponibles'),
                    );
                  }
                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          question.questionText ?? 'Pregunta del día',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        ...question.options.map(
                          (option) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildOptionButton(option, question.correctAnswer),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                error: (error, stack) => Center(
                  child: Text('Error: $error'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(String option, String correctAnswer) {
    final isSelected = _selectedAnswer == option;
    final showCorrect = _answered && option == correctAnswer;

    Color bgColor = AppColors.surfaceContainerHigh;
    Color borderColor = AppColors.outlineVariant.withOpacity(0.3);
    Color textColor = AppColors.onSurface;
    List<BoxShadow> boxShadow = [];

    if (_answered) {
      if (showCorrect) {
        bgColor = AppColors.success.withOpacity(0.15);
        borderColor = AppColors.success;
        textColor = AppColors.success;
        boxShadow = [
          BoxShadow(
            color: AppColors.success.withOpacity(0.6),
            blurRadius: 16,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: AppColors.success.withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 4,
          ),
        ];
      } else if (isSelected && !_isCorrect) {
        bgColor = AppColors.error.withOpacity(0.15);
        borderColor = AppColors.error;
        textColor = AppColors.error;
        boxShadow = [
          BoxShadow(
            color: AppColors.error.withOpacity(0.6),
            blurRadius: 16,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: AppColors.error.withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 4,
          ),
        ];
      }
    } else if (isSelected) {
      bgColor = AppColors.primary.withOpacity(0.1);
      borderColor = AppColors.primary;
    }

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _answered ? null : () => _selectAnswer(option, correctAnswer),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 2),
            boxShadow: boxShadow.isNotEmpty ? boxShadow : null,
          ),
          child: Text(
            option,
            style: GoogleFonts.workSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  void _selectAnswer(String option, String correctAnswer) {
    setState(() {
      _selectedAnswer = option;
      _answered = true;
      _isCorrect = option == correctAnswer;
    });
    _saveDailyAnswer(option, correctAnswer);
    _updateDailyStreak();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) { Navigator.pop(context); }
    });
  }

  /// Incrementa la racha diaria si se responde en días consecutivos.
  Future<void> _updateDailyStreak() async {
    try {
      final user = ref.read(userNotifierProvider).valueOrNull;
      if (user == null) return;
      final now = DateTime.now();
      String key(DateTime d) =>
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      final today = key(now);
      final yesterday = key(now.subtract(const Duration(days: 1)));
      if (user.lastDailyDate == today) return; // ya contado hoy
      final newStreak =
          user.lastDailyDate == yesterday ? user.dailyStreak + 1 : 1;
      final best =
          newStreak > user.bestDailyStreak ? newStreak : user.bestDailyStreak;
      await ref.read(userNotifierProvider.notifier).updateUserProfile(
            user.copyWith(
              dailyStreak: newStreak,
              bestDailyStreak: best,
              lastDailyDate: today,
            ),
          );
    } catch (e, st) {
      FirebaseCrashlytics.instance.recordError(e, st);
    }
  }

  Future<void> _saveDailyAnswer(String selectedAnswer, String correctAnswer) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      final questionAsync = ref.read(dailyQuestionProvider);
      final question = questionAsync.valueOrNull;
      if (question == null) return;
      final now = DateTime.now();
      final todayKey = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      await FirebaseFirestore.instance
          .collection('users').doc(user.uid)
          .collection('dailyAnswers').doc(todayKey)
          .set({
        'questionId': question.id,
        'selectedAnswer': selectedAnswer,
        'correctAnswer': correctAnswer,
        'isCorrect': _isCorrect,
        'answeredAt': FieldValue.serverTimestamp(),
      });
    } catch (e, st) {
      FirebaseCrashlytics.instance.recordError(e, st);
    }
  }
}
