# FutKO — Visual Design System

## 1. Overview & Creative North Star

**FutKO** is a football trivia battle app. The visual identity channels the energy of a **premium sports broadcast overlay** — think Champions League graphics, gold-leaf trophies, and the lush green of a perfect pitch under floodlights.

The design language, **"Modern Football Pitch,"** balances:

- **Competitive intensity** — bold scores, dramatic timers, stadium-like depth cues.
- **Premium sophistication** — tonal layering, gold accents, no cheap borders.
- **Football authenticity** — the palette is drawn directly from the pitch, the ball, and the medal podium.

We reject the boxed-in, utility look of standard mobile apps. Instead we use **intentional asymmetry**, **tonal depth**, and **editorial typography** to create an experience that feels like holding a premium match-day programme.

---

## 2. Color Palette

### Core Colors

| Token | Hex | Usage |
|---|---|---|
| **Primary (Pitch Green)** | `#1B5E20` | CTAs, active states, nav selection |
| **Primary Dark** | `#0D3B12` | Pressed states, deep accents |
| **Primary Container** | `#2E7D32` | Gradient endpoint, lighter green fills |
| **On Primary** | `#FFFFFF` | Text/icons on primary |
| **Primary Fixed** | `#A5D6A7` | Unfilled progress segments |
| **Secondary (Gold)** | `#C6A54E` | Accent, medals, highlights, trophies |
| **Secondary Container** | `#D4BC6A` | Selected chips, subtle gold fills |
| **On Secondary** | `#1A1A1A` | Text on gold |
| **Tertiary (Deep Navy)** | `#1A237E` | Alternate accent, 3rd-place medal |
| **Tertiary Container** | `#283593` | Competitive action buttons |
| **Background** | `#F8FAF8` | Scaffold base — "fresh pitch" white-green |
| **Surface** | `#F8FAF8` | Cards, sheets |
| **On Surface** | `#1A1C1B` | Primary text |
| **Error** | `#BA1A1A` | Wrong answers, timer danger |
| **Success / Correct** | `#2E7D32` | Correct answer feedback |
| **Highlight** | `#D4A843` | Gold shimmer, premium highlights |

### Surface Hierarchy (Tonal Layering)

| Token | Hex | Depth |
|---|---|---|
| `surfaceContainerLowest` | `#FFFFFF` | Cards (topmost) |
| `surfaceContainerLow` | `#F2F4F2` | Sections |
| `surfaceContainer` | `#ECEEEC` | Nested containers |
| `surfaceContainerHigh` | `#E6E8E6` | Headers within cards |
| `surfaceContainerHighest` | `#E0E3E0` | Deepest background zones |

### Timer Semantic Colors

| State | Color | Token |
|---|---|---|
| Normal (> 10 s) | `#1B5E20` | `timerNormal` (primary) |
| Warning (5-10 s) | `#C6A54E` | `timerWarning` (secondary/gold) |
| Danger (< 5 s) | `#BA1A1A` | `timerDanger` (error) |

### Signature Gradient

```dart
LinearGradient(
  begin: Alignment(-0.6, -1.0),
  end: Alignment(0.6, 1.0),
  colors: [primary, primaryContainer], // #1B5E20 → #2E7D32
)
```

Used on primary CTAs for a "brushed silk" tactile quality.

---

## 3. The "No-Line" Rule

**Explicit rule:** No `1px solid` borders for sectioning or containment. Boundaries are defined solely through **background color shifts**.

- Use `surfaceContainerLow` to separate a section sitting on a `surface` background.
- If a border is absolutely required (accessibility), use the `outlineVariant` token at **15% opacity** — a "ghost border" that is felt, not seen.
- Divider spacing: use `8px` or `16px` vertical gaps instead of lines.

---

## 4. Typography

Two font families create a **dual-voice** system: one for competitive energy, one for clarity.

### Fonts (via `google_fonts`)

| Voice | Font | Role |
|---|---|---|
| **Competitive** | **Plus Jakarta Sans** | Display, headlines, scores, buttons, timer |
| **Educational / Body** | **Work Sans** | Body text, labels, captions, input text |

### Type Scale

| Style | Font | Size | Weight | Usage |
|---|---|---|---|---|
| `displayLg` | Plus Jakarta Sans | 57 | w900 | Victory screens |
| `displayMd` | Plus Jakarta Sans | 45 | w800 | Match results |
| `displaySm` | Plus Jakarta Sans | 36 | w800 | Big stats (current streak) |
| `h1` | Plus Jakarta Sans | 32 | w900 | Section titles |
| `h2` | Plus Jakarta Sans | 24 | w700 | Card headers |
| `h3` | Plus Jakarta Sans | 20 | w700 | Sub-headers |
| `bodyLarge` | Work Sans | 16 | w400 | Primary body |
| `bodyMedium` | Work Sans | 14 | w400 | Secondary body |
| `bodySmall` | Work Sans | 12 | w400 | Tertiary / muted |
| `button` | Plus Jakarta Sans | 16 | w700 | Primary buttons |
| `buttonSmall` | Plus Jakarta Sans | 14 | w600 | Secondary buttons |
| `timer` | Plus Jakarta Sans | 48 | w900 | Countdown display |
| `score` | Plus Jakarta Sans | 64 | w900 | Final score |
| `elo` | Plus Jakarta Sans | 36 | w800 | ELO rating |
| `label` | Work Sans | 14 | w600 | Form labels, tags |
| `labelSmall` | Work Sans | 10 | w600 | Micro-labels |
| `caption` | Work Sans | 12 | w400 | Timestamps, hints |

### Typography Principles

- **Extreme scale jumps** between headlines and body — editorial, not generic.
- Use `displaySm` for a single stat (e.g. "12 Win Streak") next to a small `labelSmall` descriptor.
- Letter spacing: tight on display (`-0.25` to `-1`), normal on body.

---

## 5. Icons

| Context | Icon | Notes |
|---|---|---|
| Primary app icon / nav | `sports_soccer` | The ball — FutKO's identity |
| Trophies / achievements | `emoji_events` | Cup / trophy |
| Leaderboard podium | `military_tech` | Medal |
| Rankings / position | `star`, `workspace_premium` | Rating badges |
| Timer / clock | `timer`, `schedule` | Match clock feel |
| Friends / social | `people`, `person_add` | Squad |
| History | `history`, `receipt_long` | Match history |
| Settings | `settings`, `tune` | Preferences |

### Icon Style

- **Weight:** Light / Regular (not bold/chunky) to match Work Sans sophistication.
- **Color:** Inherit from parent — `primary` for active, `onSurfaceVariant` for inactive.

---

## 6. Component Styles

### Buttons

| Type | Style |
|---|---|
| **Primary** | Pill shape (`BorderRadius.circular(9999)`), `primaryGradient` background, `onPrimary` white text, zero elevation. Pressed state → `primaryContainer`. |
| **Secondary** | No background. `title-sm` in `primary` color. Relies on whitespace. |
| **Tertiary** | `tertiaryContainer` (`#283593`) background for competitive actions ("Challenge Again"). |
| **Outlined** | Ghost border at 30% `outlineVariant`, pill shape, `primary` foreground. |
| **Text Button** | `primary` foreground, minimal padding. |

All buttons use `Plus Jakarta Sans w700` at 16px.

### Cards (Battle Cards / Match Cards)

- Zero elevation — depth via tonal layering only.
- `surfaceContainerLowest` body on a `surfaceContainerLow` section.
- Header zone: `surfaceContainerHigh`.
- Border radius: `24px`.
- Ghost border (`outlineVariant` at 15%) only if needed.
- **Tactile feedback:** On tap, scale to `0.98x` (press-in effect).

### Quiz Answer Chips

| State | Style |
|---|---|
| Default | `surfaceContainerHigh` background |
| Selected | `secondaryContainer` with `primary` label, font → Bold |
| Correct | `primaryContainer` (green) |
| Incorrect | `errorContainer` (red) |
| Shape | `RoundedRect(12px)`, no side border |

### Progress Bars (Battle Gauges)

- Segmented bar — each segment = one quiz milestone.
- Unfilled: `primaryFixed` (light green).
- Filled: `primary` (pitch green).

### Input Fields

- `surfaceVariant` at 50% opacity background.
- `RoundedRect(12px)` with ghost border.
- Focused: `primary` border at 1.5px.
- Floating label in `label-md` (Work Sans).

### Navigation Bar

- `BottomNavigationBar` with `background` color, zero elevation.
- Active item: `primary` (pitch green).
- Inactive: `onSurfaceVariant`.
- Fixed type — all items visible.

### Dialogs

- `surfaceContainerLowest` background.
- `RoundedRect(28px)` border radius.
- Match the tonal layering — no harsh shadows.

### Floating Action Button

- `primary` background, `onPrimary` foreground.
- Zero elevation, `CircleBorder()`.

---

## 7. Elevation & Depth

Shadows and borders are avoided in favor of **physics and light**:

- **Layering Principle:** A card doesn't "pop" with a shadow — it reveals itself as a lighter/darker cut-out.
- **Ambient Shadows:** If floating is required (modals, FABs), use blur ≥ `32px`, opacity ≤ `6%`, tinted with `onSurface` (never pure black).
- **Glassmorphism:** For floating overlays (countdown, map markers), use semi-transparent `surfaceVariant` with `backdrop-blur(20px)`.

---

## 8. Rank Tiers — Visual Identity

Football-themed ranks displayed with emoji and color:

| Rank | Emoji | ELO Range | Color Association |
|---|---|---|---|
| **Leyenda** | ⚽ | ≥ 1800 | Pitch Green (primary) — the GOAT tier |
| **Balón de Oro** | 🏆 | 1600–1799 | Gold (secondary) — Ballon d'Or |
| **Campeón** | 🥇 | 1400–1599 | Gold / warm tones — champion's medal |
| **Titular** | ⭐ | 1200–1399 | Navy / blue — starting XI quality |
| **Promesa** | 🌱 | < 1200 | Fresh green — rising talent |

### Medal Colors for Leaderboard Podium

| Position | Color |
|---|---|
| 1st | `rankGold` (`#FFD700`) — via `secondary` |
| 2nd | `rankSilver` (`#C0C0C0`) |
| 3rd | `tertiary` (`#1A237E`) — Deep Navy |

---

## 9. Animation & Motion

Football-themed transitions that feel like broadcast graphics:

| Context | Animation | Details |
|---|---|---|
| **Score reveal** | Scale + fade | Pop from `0.8x` → `1.0x` with `Curves.elasticOut`, 600ms |
| **Correct answer** | Green pulse | Flash `primaryContainer` + check icon scale-in |
| **Wrong answer** | Red shake | TranslateX oscillation ±4px, 300ms, 3 reps |
| **Timer countdown** | Color morph | Smooth transition `primary → secondary → error` at thresholds |
| **Card tap** | Press-in | Scale to `0.98x`, 100ms, `Curves.easeInOut` |
| **Page transitions** | Slide-up | Like a substitution board sliding up, 300ms `easeOut` |
| **Rank promotion** | Gold shimmer | `LinearGradient` sweep animation across rank badge |
| **Victory screen** | Confetti + scale | Full-screen celebration, trophy scale-in with elastic curve |
| **Matchmaking** | Pulsing ball | `sports_soccer` icon pulse at 1.2x, looping |

### Motion Principles

- **Fast and decisive** — football is fast-paced; animations ≤ 300ms for UI, ≤ 600ms for celebrations.
- **Broadcast feel** — inspired by TV match overlays: smooth slides, bold reveals.
- **No bouncy/childish** — premium sport, not cartoon.

---

## 10. Responsiveness & Layout Robustness

- **350px Rule:** Test all layouts on minimum 350px width. Use `LayoutBuilder` to switch `Row` → `Column`.
- **Flexible Text:** Always wrap `Text` in `Row` with `Flexible` or `Expanded`. Set `maxLines` + `TextOverflow.ellipsis`.
- **Adaptive Buttons:** Stack vertically on narrow screens.
- **Bento Grids:** Use `Wrap` or conditional layout for stat cards.
- **Scroll Safety:** Wrap dynamic vertical layouts in `SingleChildScrollView`.

---

## 11. Dark Mode

The dark theme inverts the tonal stack:

| Token | Light | Dark |
|---|---|---|
| Background | `#F8FAF8` | `#141615` |
| Surface | `#F8FAF8` | `#1A1C1B` |
| Primary | `#1B5E20` | `#81C784` (inverse primary — lighter green) |
| On Surface | `#1A1C1B` | `#EFF1EF` |
| Surface Container | `#ECEEEC` | `#262826` |

Dark mode maintains the same pitch-green identity but glows — like a stadium under floodlights.

---

## 12. Do's and Don'ts

### ✅ Do

- **Embrace negative space** — remove a container before shrinking text.
- **Asymmetric layouts** — headline left, score right, offset vertically.
- **Tinted overlays** — use gold (`secondary`) at 5% opacity on images for warmth.
- **Extreme typography scale** — let display and body contrast dramatically.
- **Tonal layering** — use the `surfaceContainer*` hierarchy for depth.

### ❌ Don't

- **No 1px dividers** — use spacing gaps instead.
- **No high-contrast shadows** — no "floating on a cloud." Layer materials instead.
- **No chunky/bold icons** — keep icons Light/Regular weight.
- **No default Material blue** — this is a pitch-green app.
- **No borders for containment** — ghost borders only, 15% opacity.

---

## 13. File Reference

| File | Purpose |
|---|---|
| `lib/core/theme/app_colors.dart` | Complete color token definitions |
| `lib/core/theme/app_text_styles.dart` | Typography scale with Google Fonts |
| `lib/core/theme/app_theme.dart` | Material 3 `ThemeData` (light + dark) |
| `lib/domain/entities/user.dart` | Rank tier definitions (Leyenda → Promesa) |
