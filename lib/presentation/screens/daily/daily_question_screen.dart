import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/daily_question_provider.dart';

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
        bgColor = Colors.green.withOpacity(0.15);
        borderColor = Colors.greenAccent;
        textColor = Colors.greenAccent;
        boxShadow = [
          BoxShadow(
            color: Colors.greenAccent.withOpacity(0.6),
            blurRadius: 16,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 4,
          ),
        ];
      } else if (isSelected && !_isCorrect) {
        bgColor = Colors.red.withOpacity(0.15);
        borderColor = Colors.redAccent;
        textColor = Colors.redAccent;
        boxShadow = [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.6),
            blurRadius: 16,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
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

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }
}
