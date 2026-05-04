import 'package:flutter/material.dart';

/// FutKO Design System — "Stadium Arena" dark palette.
///
/// Deep pitch green, championship gold, energetic white. Dark mode only.
/// Based on DESIGN.md — Stadium Arena design system.
class AppColors {
  AppColors._();

  // ── Primary (Pitch Green) ───────────────────────────────
  static const Color primary = Color(0xFFaccfb3);
  static const Color onPrimary = Color(0xFF183623);
  static const Color primaryContainer = Color(0xFF0f2e1b);
  static const Color onPrimaryContainer = Color(0xFF76977e);
  static const Color primaryFixed = Color(0xFFc8ebce);
  static const Color primaryFixedDim = Color(0xFFaccfb3);
  static const Color onPrimaryFixed = Color(0xFF02210f);
  static const Color onPrimaryFixedVariant = Color(0xFF2f4d38);

  // ── Secondary (Championship Gold) ───────────────────────
  static const Color secondary = Color(0xFFfff9ef);
  static const Color onSecondary = Color(0xFF3a3000);
  static const Color secondaryContainer = Color(0xFFffdb3c);
  static const Color onSecondaryContainer = Color(0xFF725f00);
  static const Color secondaryFixed = Color(0xFFffe16d);
  static const Color secondaryFixedDim = Color(0xFFe9c400);
  static const Color onSecondaryFixed = Color(0xFF221b00);
  static const Color onSecondaryFixedVariant = Color(0xFF544600);

  // ── Tertiary (Bronze Medal) ─────────────────────────────
  static const Color tertiary = Color(0xFFffb779);
  static const Color onTertiary = Color(0xFF4c2700);
  static const Color tertiaryContainer = Color(0xFF402000);
  static const Color onTertiaryContainer = Color(0xFFca7d30);
  static const Color tertiaryFixed = Color(0xFFffdcc1);
  static const Color tertiaryFixedDim = Color(0xFFffb779);
  static const Color onTertiaryFixed = Color(0xFF2e1500);
  static const Color onTertiaryFixedVariant = Color(0xFF6c3a00);

  // ── Error ────────────────────────────────────────────────
  static const Color error = Color(0xFFffb4ab);
  static const Color onError = Color(0xFF690005);
  static const Color errorContainer = Color(0xFF93000a);
  static const Color onErrorContainer = Color(0xFFffdad6);

  // ── Surfaces (Tonal Layering) ────────────────────────────
  static const Color background = Color(0xFF121414);
  static const Color onBackground = Color(0xFFe2e2e2);
  static const Color surface = Color(0xFF121414);
  static const Color onSurface = Color(0xFFe2e2e2);
  static const Color surfaceVariant = Color(0xFF333535);
  static const Color onSurfaceVariant = Color(0xFFc2c8c0);
  static const Color surfaceTint = Color(0xFFaccfb3);

  static const Color surfaceContainerLowest = Color(0xFF0c0f0f);
  static const Color surfaceContainerLow = Color(0xFF1a1c1c);
  static const Color surfaceContainer = Color(0xFF1e2020);
  static const Color surfaceContainerHigh = Color(0xFF282a2b);
  static const Color surfaceContainerHighest = Color(0xFF333535);

  static const Color surfaceDim = Color(0xFF121414);
  static const Color surfaceBright = Color(0xFF38393a);

  // ── Inverse ──────────────────────────────────────────────
  static const Color inverseSurface = Color(0xFFe2e2e2);
  static const Color inverseOnSurface = Color(0xFF2f3131);
  static const Color inversePrimary = Color(0xFF46654f);

  // ── Outlines ─────────────────────────────────────────────
  static const Color outline = Color(0xFF8c928b);
  static const Color outlineVariant = Color(0xFF424842);

  // ── Signature Gradient Colors ────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment(-0.6, -1.0),
    end: Alignment(0.6, 1.0),
    colors: [primary, primaryContainer],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [secondaryFixed, onSecondaryContainer],
  );

  // ── Highlight / Gold ────────────────────────────────────
  static const Color highlight = Color(0xFFffe16d);

  // ── Shadows (tinted, never pure black) ──────────────────
  static Color ambientShadow({double opacity = 0.06}) =>
      const Color(0xFF1A1C1B).withOpacity(opacity);

  // ── Ghost Border ────────────────────────────────────────
  static Color get ghostBorder => outlineVariant.withOpacity(0.15);

  // ── Semantic / Game ─────────────────────────────────────
  static const Color success = Color(0xFF4CAF50);
  static const Color correct = primaryContainer;
  static const Color incorrect = errorContainer;
  static const Color timerNormal = primary;
  static const Color timerWarning = secondaryFixed;
  static const Color timerDanger = error;

  // ── Ranks ───────────────────────────────────────────────
  static const Color rankBronze = Color(0xFFCD7F32);
  static const Color rankSilver = Color(0xFFC0C0C0);
  static const Color rankGold = Color(0xFFFFD700);
  static const Color rankPlatinum = Color(0xFFE5E4E2);
  static const Color rankDiamond = Color(0xFFB9F2FF);

  // ── Shimmer ─────────────────────────────────────────────
  static const Color shimmerBase = Color(0xFF1e2020);
  static const Color shimmerHighlight = Color(0xFF282a2b);

  // ── Stadium-specific ────────────────────────────────────
  static const Color emerald950 = Color(0xFF022c22);
  static const Color emerald900 = Color(0xFF064e3b);
  static const Color emerald800 = Color(0xFF065f46);
  static const Color emerald500 = Color(0xFF10b981);
  static const Color yellow500 = Color(0xFFeab308);
  static const Color stadiumGlowGold = Color(0x26eab308);
  static const Color stadiumGlowGreen = Color(0x2610b981);
}
