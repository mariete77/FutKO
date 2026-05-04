import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:futko/domain/entities/question.dart';
import '../../../../core/theme/app_colors.dart';

class AnswerOptionsWidget extends StatelessWidget {
  final Question question;
  final Function(String) onAnswerSelected;

  const AnswerOptionsWidget({
    super.key,
    required this.question,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    final options = question.options;
    // Ensure we have exactly 4 options for 2x2 grid, pad if necessary
    final displayOptions = options.length >= 4 
        ? options.sublist(0, 4) 
        : [...options, ...List.filled(4 - options.length, '')];
    
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: displayOptions.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        if (option.isEmpty) return const SizedBox.shrink();
        return _AnswerOptionButton(
          option: option,
          index: index,
          onPressed: () => onAnswerSelected(option),
        );
      }).toList(),
    );
  }
}

class _AnswerOptionButton extends StatefulWidget {
  final String option;
  final int index;
  final VoidCallback onPressed;

  const _AnswerOptionButton({
    required this.option,
    required this.index,
    required this.onPressed,
  });

  @override
  State<_AnswerOptionButton> createState() => _AnswerOptionButtonState();
}

class _AnswerOptionButtonState extends State<_AnswerOptionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final letter = ['A', 'B', 'C', 'D'][widget.index];
    final isActive = _isPressed || _isHovered;

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.white.withOpacity(0.05)
                  : AppColors.surfaceContainerLow.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border(
                left: BorderSide(
                  color: isActive ? AppColors.yellow500 : Colors.transparent,
                  width: 4,
                ),
                top: BorderSide(
                  color: Colors.white.withOpacity(0.06),
                ),
                right: BorderSide(
                  color: Colors.white.withOpacity(0.06),
                ),
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),
            child: Row(
              children: [
                // Letter badge
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.yellow500
                        : AppColors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      letter,
                      style: GoogleFonts.plusJakartaSans(
                        color: isActive
                            ? AppColors.emerald950
                            : AppColors.onSurfaceVariant,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Answer text
                Expanded(
                  child: Text(
                    widget.option,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Bolt icon on hover
                if (isActive)
                  Icon(
                    Icons.bolt,
                    color: AppColors.yellow500,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
