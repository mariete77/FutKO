import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:futko/domain/entities/question.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../services/haptics_service.dart';

/// Visual state of an option button once an answer has been chosen.
enum _OptionStatus { idle, correct, wrong, dimmed }

class AnswerOptionsWidget extends StatefulWidget {
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
  State<AnswerOptionsWidget> createState() => _AnswerOptionsWidgetState();
}

class _AnswerOptionsWidgetState extends State<AnswerOptionsWidget> {
  // The option the player tapped, or null while still answering.
  String? _selected;

  @override
  void didUpdateWidget(AnswerOptionsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The State is reused across questions (same position in the tree), so
    // reset the selection whenever a new question comes in.
    if (widget.question != oldWidget.question) {
      _selected = null;
    }
  }

  void _onTap(String option) {
    if (_selected != null) return; // lock further taps
    setState(() => _selected = option);
    HapticsService().tap();
    // Briefly reveal correct/incorrect before handing control back to the
    // game (which swaps in the full feedback screen).
    Future.delayed(const Duration(milliseconds: 280), () {
      if (mounted) widget.onAnswerSelected(option);
    });
  }

  _OptionStatus _statusFor(String option) {
    if (_selected == null) return _OptionStatus.idle;
    if (widget.question.isCorrect(option)) return _OptionStatus.correct;
    if (option == _selected) return _OptionStatus.wrong;
    return _OptionStatus.dimmed;
  }

  @override
  Widget build(BuildContext context) {
    final options = (widget.overrideOptions ?? widget.question.options)
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
            status: _statusFor(options[i]),
            onPressed: () => _onTap(options[i]),
          ),
        ],
      ],
    );
  }
}

class _AnswerOptionButton extends StatelessWidget {
  final String option;
  final int index;
  final _OptionStatus status;
  final VoidCallback onPressed;

  const _AnswerOptionButton({
    required this.option,
    required this.index,
    required this.status,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final letter = index < 4 ? ['A', 'B', 'C', 'D'][index] : '';

    late final Color borderColor;
    late final Color bgColor;
    double scale = 1.0;
    double opacity = 1.0;

    switch (status) {
      case _OptionStatus.idle:
        borderColor = Colors.white.withOpacity(0.08);
        bgColor = AppColors.surfaceContainerLow;
        break;
      case _OptionStatus.correct:
        borderColor = AppColors.success;
        bgColor = AppColors.success.withOpacity(0.18);
        break;
      case _OptionStatus.wrong:
        borderColor = AppColors.error;
        bgColor = AppColors.error.withOpacity(0.18);
        scale = 0.97;
        break;
      case _OptionStatus.dimmed:
        borderColor = Colors.white.withOpacity(0.06);
        bgColor = AppColors.surfaceContainerLow;
        opacity = 0.45;
        break;
    }

    final showsResultIcon =
        status == _OptionStatus.correct || status == _OptionStatus.wrong;

    return AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 140),
      child: AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 140),
        child: Material(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: status == _OptionStatus.idle ? onPressed : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: borderColor,
                  width: status == _OptionStatus.idle ? 1 : 2,
                ),
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
                      child: showsResultIcon
                          ? Icon(
                              status == _OptionStatus.correct
                                  ? Icons.check
                                  : Icons.close,
                              size: 20,
                              color: status == _OptionStatus.correct
                                  ? AppColors.success
                                  : AppColors.error,
                            )
                          : Text(
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
        ),
      ),
    );
  }
}
