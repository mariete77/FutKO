import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

/// A reusable widget that displays a football substitution event.
///
/// This component is part of the FutKO match-events UI library.
/// It visualises the minute of the substitution, the player being replaced
/// (red arrow + red name) and the player entering the pitch (green arrow +
/// green name). A substitute icon sits between the two player names.
///
/// ## Example
/// ```dart
/// SubstitutionEventWidget(
///   minute: 65,
///   playerOut: 'Luka Modrić',
///   playerIn: 'Eduardo Camavinga',
/// )
/// ```
///
/// Design-system compliance:
/// * **No-Line Rule** – no 1 px borders; hierarchy comes from tonal layering.
/// * **350 px Rule** – automatically switches from a horizontal to a stacked
///   vertical layout on narrow screens.
/// * **Flexible Text** – player names are wrapped in `Flexible` and ellipsised.
class SubstitutionEventWidget extends StatelessWidget {
  const SubstitutionEventWidget({
    super.key,
    required this.minute,
    required this.playerOut,
    required this.playerIn,
    this.backgroundColor,
    this.onTap,
  });

  /// Minute when the substitution occurred (e.g. `65`).
  final int minute;

  /// Name of the player being substituted **out**.
  final String playerOut;

  /// Name of the player coming **in**.
  final String playerIn;

  /// Optional background colour for the card.
  /// Defaults to [AppColors.surfaceContainerLow].
  final Color? backgroundColor;

  /// Optional callback when the user taps the card.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 350;

        return GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: backgroundColor ?? AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: isNarrow ? _buildNarrowLayout() : _buildWideLayout(),
          ),
        );
      },
    );
  }

  /// Builds the circular minute badge (e.g. **65'**).
  Widget _buildMinuteBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        "$minute'",
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: AppColors.onSurface,
          height: 1.0,
        ),
      ),
    );
  }

  /// Horizontal layout for screens ≥ 350 px logical width.
  Widget _buildWideLayout() {
    return Row(
      children: [
        _buildMinuteBadge(),
        const SizedBox(width: 16),
        Expanded(
          child: Row(
            children: [
              // ── Player OUT ──
              Flexible(
                flex: 4,
                child: _buildPlayerRow(
                  icon: Icons.arrow_downward_rounded,
                  iconColor: AppColors.error,
                  name: playerOut,
                  textColor: AppColors.error,
                ),
              ),
              // ── Substitute icon ──
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(
                  Icons.sync_alt_rounded,
                  size: 20,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              // ── Player IN ──
              Flexible(
                flex: 4,
                child: _buildPlayerRow(
                  icon: Icons.arrow_upward_rounded,
                  iconColor: AppColors.success,
                  name: playerIn,
                  textColor: AppColors.success,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Stacked vertical layout for screens < 350 px logical width.
  Widget _buildNarrowLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMinuteBadge(),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPlayerRow(
                icon: Icons.arrow_downward_rounded,
                iconColor: AppColors.error,
                name: playerOut,
                textColor: AppColors.error,
              ),
              const SizedBox(height: 8),
              const Center(
                child: Icon(
                  Icons.sync_alt_rounded,
                  size: 20,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              _buildPlayerRow(
                icon: Icons.arrow_upward_rounded,
                iconColor: AppColors.success,
                name: playerIn,
                textColor: AppColors.success,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Single player row: `[icon] [name]`.
  Widget _buildPlayerRow({
    required IconData icon,
    required Color iconColor,
    required String name,
    required Color textColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 18,
          color: iconColor,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            name,
            style: GoogleFonts.workSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
              height: 1.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
