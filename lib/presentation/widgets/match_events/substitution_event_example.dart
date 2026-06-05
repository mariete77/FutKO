import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'substitution_event_widget.dart';

/// Example screen demonstrating the [SubstitutionEventWidget] in action.
///
/// Run this screen to preview how substitutions look in both wide and narrow
/// layouts, and how they behave inside a scrollable list.
///
/// ```dart
/// Navigator.of(context).push(
///   MaterialPageRoute(
///     builder: (_) => const SubstitutionEventExample(),
///   ),
/// );
/// ```
class SubstitutionEventExample extends StatelessWidget {
  const SubstitutionEventExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLow,
        elevation: 0,
        title: Text(
          'Substitutions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w700,
              ),
        ),
        iconTheme: const IconThemeData(color: AppColors.onSurface),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Section: Wide layout (default) ──
            Text(
              'Wide layout (≥ 350 px)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            const SubstitutionEventWidget(
              minute: 65,
              playerOut: 'Luka Modrić',
              playerIn: 'Eduardo Camavinga',
            ),
            const SizedBox(height: 12),
            const SubstitutionEventWidget(
              minute: 72,
              playerOut: 'Karim Benzema',
              playerIn: 'Rodrygo Goes',
            ),
            const SizedBox(height: 32),

            // ── Section: Narrow layout ──
            Text(
              'Narrow layout (< 350 px)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            // Constrain width to force narrow layout
            const SizedBox(
              width: 280,
              child: SubstitutionEventWidget(
                minute: 58,
                playerOut: 'Toni Kroos',
                playerIn: 'Aurélien Tchouaméni',
              ),
            ),
            const SizedBox(height: 32),

            // ── Section: Interactive with tap ──
            Text(
              'Interactive (tap to show snackbar)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            SubstitutionEventWidget(
              minute: 88,
              playerOut: 'Vinícius Júnior',
              playerIn: 'Dani Ceballos',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Substitution tapped!'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
