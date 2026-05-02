import 'package:flutter/material.dart';

/// FutKO Design System — "Modern Football Pitch" palette.
///
/// Deep pitch green, white lines, gold accents. No 1px borders.
/// Boundaries defined solely through background color shifts.
class AppColors {
  AppColors._();

  // ── Primary (Pitch Green) ───────────────────────────────
  static const Color primary = Color(0xFF1B5E20);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF2E7D32);
  static const Color onPrimaryContainer = Color(0xFFF1F8E9);
  static const Color primaryFixed = Color(0xFFA5D6A7);
  static const Color primaryFixedDim = Color(0xFF81C784);
  static const Color onPrimaryFixed = Color(0xFF002109);
  static const Color onPrimaryFixedVariant = Color(0xFF1B5E20);

  // ── Secondary (Gold) ────────────────────────────────────
  static const Color secondary = Color(0xFFC6A54E);
  static const Color onSecondary = Color(0xFF1A1A1A);
  static const Color secondaryContainer = Color(0xFFD4BC6A);
  static const Color onSecondaryContainer = Color(0xFF3D3000);
  static const Color secondaryFixed = Color(0xFFF5E6A3);
  static const Color secondaryFixedDim = Color(0xFFE0CF7A);
  static const Color onSecondaryFixed = Color(0xFF1E1600);
  static const Color onSecondaryFixedVariant = Color(0xFF4A3D00);

  // ── Tertiary (Deep Navy) ────────────────────────────────
  static const Color tertiary = Color(0xFF1A237E);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF283593);
  static const Color onTertiaryContainer = Color(0xFFE8EAF6);
  static const Color tertiaryFixed = Color(0xFF9FA8DA);
  static const Color tertiaryFixedDim = Color(0xFF7986CB);
  static const Color onTertiaryFixed = Color(0xFF000050);
  static const Color onTertiaryFixedVariant = Color(0xFF1A237E);

  // ── Error ────────────────────────────────────────────────
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // ── Surfaces (Tonal Layering) ────────────────────────────
  static const Color background = Color(0xFFF8FAF8);
  static const Color onBackground = Color(0xFF1A1C1B);
  static const Color surface = Color(0xFFF8FAF8);
  static const Color onSurface = Color(0xFF1A1C1B);
  static const Color surfaceVariant = Color(0xFFE0E3E0);
  static const Color onSurfaceVariant = Color(0xFF424841);
  static const Color surfaceTint = Color(0xFF1B5E20);

  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F4F2);
  static const Color surfaceContainer = Color(0xFFECEEEC);
  static const Color surfaceContainerHigh = Color(0xFFE6E8E6);
  static const Color surfaceContainerHighest = Color(0xFFE0E3E0);

  static const Color surfaceDim = Color(0xFFD8DAD8);
  static const Color surfaceBright = Color(0xFFF8FAF8);

  // ── Inverse ──────────────────────────────────────────────
  static const Color inverseSurface = Color(0xFF2D312D);
  static const Color inverseOnSurface = Color(0xFFEFF1EF);
  static const Color inversePrimary = Color(0xFF81C784);

  // ── Outlines ─────────────────────────────────────────────
  static const Color outline = Color(0xFF727970);
  static const Color outlineVariant = Color(0xFFC2C8BF);

  // ── Signature Gradient Colors ────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment(-0.6, -1.0),
    end: Alignment(0.6, 1.0),
    colors: [primary, primaryContainer],
  );

  // ── Highlight / Gold ────────────────────────────────────
  static const Color highlight = Color(0xFFD4A843);

  // ── Shadows (tinted, never pure black) ──────────────────
  static Color ambientShadow({double opacity = 0.06}) =>
      const Color(0xFF1A1C1B).withOpacity(opacity);

  // ── Ghost Border ────────────────────────────────────────
  static Color get ghostBorder => outlineVariant.withOpacity(0.15);

  // ── Semantic / Game ─────────────────────────────────────
  static const Color success = Color(0xFF2E7D32);
  static const Color correct = primaryContainer;
  static const Color incorrect = errorContainer;
  static const Color timerNormal = primary;
  static const Color timerWarning = secondary;
  static const Color timerDanger = error;

  // ── Ranks ───────────────────────────────────────────────
  static const Color rankBronze = Color(0xFFCD7F32);
  static const Color rankSilver = Color(0xFFC0C0C0);
  static const Color rankGold = Color(0xFFFFD700);
  static const Color rankPlatinum = Color(0xFFE5E4E2);
  static const Color rankDiamond = Color(0xFFB9F2FF);

  // ── Shimmer ─────────────────────────────────────────────
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
}
