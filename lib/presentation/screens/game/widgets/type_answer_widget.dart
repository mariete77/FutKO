import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:futko/domain/entities/question.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/fuzzy_matcher.dart';

/// Widget for typing answers in type-answer game mode.
///
/// Provides immediate broadcast-style feedback on accuracy: even partially
/// correct answers (60-99%) are rewarded with a label and visual cue instead
/// of feeling like a total failure.
class TypeAnswerWidget extends StatefulWidget {
  final Question question;
  final int timeRemaining;
  final Function(String answer) onAnswerSubmitted;

  const TypeAnswerWidget({
    super.key,
    required this.question,
    required this.timeRemaining,
    required this.onAnswerSubmitted,
  });

  @override
  State<TypeAnswerWidget> createState() => _TypeAnswerWidgetState();
}

class _TypeAnswerWidgetState extends State<TypeAnswerWidget> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _submitted = false;
  double _similarity = 0.0;

  @override
  void initState() {
    super.initState();
    // Auto-focus the text field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    // Listen to text changes to update button state
    _textController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submitAnswer() {
    if (_submitted) return;
    final answer = _textController.text.trim();
    if (answer.isEmpty) return;

    final similarity = answerSimilarity(answer, widget.question.correctAnswer);

    setState(() {
      _submitted = true;
      _similarity = similarity;
    });
    _focusNode.unfocus();
    widget.onAnswerSubmitted(answer);
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = _submitted
        ? Color(accuracyColor(_similarity))
        : AppColors.primary.withValues(alpha: 0.5);

    return Column(
      children: [
        // Hint text based on question type
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.tertiary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.keyboard, color: AppColors.tertiary.withValues(alpha: 0.7), size: 20),
              const SizedBox(width: 8),
              Text(
                _getHintText(),
                style: GoogleFonts.workSans(
                  color: AppColors.tertiary.withValues(alpha: 0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Text input
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: 2,
            ),
            boxShadow: _submitted
                ? [
                    BoxShadow(
                      color: borderColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: TextField(
            controller: _textController,
            focusNode: _focusNode,
            enabled: !_submitted,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submitAnswer(),
            decoration: InputDecoration(
              hintText: 'Escribe tu respuesta...',
              hintStyle: GoogleFonts.workSans(
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                fontSize: 18,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              suffixIcon: !_submitted
                  ? IconButton(
                      icon: Icon(Icons.send, color: AppColors.primary),
                      onPressed: _submitAnswer,
                    )
                  : Icon(Icons.check, color: borderColor),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Submit button
        if (!_submitted)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _textController.text.trim().isEmpty ? null : _submitAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: AppColors.outlineVariant.withValues(alpha: 0.3),
              ),
              child: Text(
                'CONFIRMAR',
                style: GoogleFonts.workSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
          )
        else
          _buildFeedback(),
      ],
    );
  }

  Widget _buildFeedback() {
    final label = accuracyLabel(_similarity);
    final color = Color(accuracyColor(_similarity));

    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            if (_similarity >= 0.6 && _similarity < 1.0) ...[
              const SizedBox(height: 4),
              Text(
                'Respuesta parcialmente correcta',
                style: GoogleFonts.workSans(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
            if (_similarity < 0.6) ...[
              const SizedBox(height: 4),
              Text(
                'Respuesta incorrecta',
                style: GoogleFonts.workSans(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getHintText() {
    switch (widget.question.type) {
      case QuestionType.player:
        return 'Escribe el nombre del jugador';
      case QuestionType.team:
        return 'Escribe el nombre del equipo';
      case QuestionType.competition:
        return 'Escribe el nombre de la competición';
      case QuestionType.history:
        return 'Escribe tu respuesta';
      case QuestionType.rules:
        return 'Escribe tu respuesta';
      case QuestionType.stadium:
        return 'Escribe el nombre del estadio';
      case QuestionType.badge:
        return 'Escribe el nombre del equipo';
      case QuestionType.playerImage:
        return 'Escribe el nombre del jugador';
      case QuestionType.statistic:
        return 'Escribe tu respuesta';
      case QuestionType.transfer:
        return 'Escribe el nombre del equipo';
      case QuestionType.champion:
        return 'Escribe el ganador';
      case QuestionType.topScorer:
        return 'Escribe el nombre del goleador';
      default:
        return 'Escribe tu respuesta';
    }
  }
}
