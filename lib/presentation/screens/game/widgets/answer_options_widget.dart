import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:futko/domain/entities/question.dart';
import '../../../../core/theme/app_colors.dart';

class AnswerOptionsWidget extends StatelessWidget {
  final Question question;
  final Function(String) onAnswerSelected;

  /// When set (e.g. after using the 50/50 hint), these options are shown
  /// instead of [question.options].
  final List<String>? overrideOptions;

  const AnswerOptionsWidget({
    super.key,
    required this.question,
    required this.onAnswerSelected,
    this.overrideOptions,
  });

  @override
  Widget build(BuildContext context) {
    final options = (overrideOptions ?? question.options)
        .where((o) => o.trim().isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < options.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          _AnswerOptionButton(
            option: options[i],
            index: i,
            onPressed: () => onAnswerSelected(options[i]),
          ),
        ],
      ],
    );
  }
}

class _AnswerOptionButton extends StatelessWidget {
  final String option;
  final int index;
  final VoidCallback onPressed;

  const _AnswerOptionButton({
    required this.option,
    required this.index,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final letter = index < 4 ? ['A', 'B', 'C', 'D'][index] : '';

    return Material(
      color: AppColors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    letter,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  option,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
