---
name: Stadium Arena
colors:
  surface: '#121414'
  surface-dim: '#121414'
  surface-bright: '#38393a'
  surface-container-lowest: '#0c0f0f'
  surface-container-low: '#1a1c1c'
  surface-container: '#1e2020'
  surface-container-high: '#282a2b'
  surface-container-highest: '#333535'
  on-surface: '#e2e2e2'
  on-surface-variant: '#c2c8c0'
  inverse-surface: '#e2e2e2'
  inverse-on-surface: '#2f3131'
  outline: '#8c928b'
  outline-variant: '#424842'
  surface-tint: '#accfb3'
  primary: '#accfb3'
  on-primary: '#183623'
  primary-container: '#0f2e1b'
  on-primary-container: '#76977e'
  inverse-primary: '#46654f'
  secondary: '#fff9ef'
  on-secondary: '#3a3000'
  secondary-container: '#ffdb3c'
  on-secondary-container: '#725f00'
  tertiary: '#ffb779'
  on-tertiary: '#4c2700'
  tertiary-container: '#402000'
  on-tertiary-container: '#ca7d30'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#c8ebce'
  primary-fixed-dim: '#accfb3'
  on-primary-fixed: '#02210f'
  on-primary-fixed-variant: '#2f4d38'
  secondary-fixed: '#ffe16d'
  secondary-fixed-dim: '#e9c400'
  on-secondary-fixed: '#221b00'
  on-secondary-fixed-variant: '#544600'
  tertiary-fixed: '#ffdcc1'
  tertiary-fixed-dim: '#ffb779'
  on-tertiary-fixed: '#2e1500'
  on-tertiary-fixed-variant: '#6c3a00'
  background: '#121414'
  on-background: '#e2e2e2'
  surface-variant: '#333535'
typography:
  headline-xl:
    fontFamily: Plus Jakarta Sans
    fontSize: 48px
    fontWeight: '800'
    lineHeight: '1.1'
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '700'
    lineHeight: '1.2'
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: '1.2'
  body-lg:
    fontFamily: Lexend
    fontSize: 18px
    fontWeight: '400'
    lineHeight: '1.6'
  body-md:
    fontFamily: Lexend
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.5'
  label-bold:
    fontFamily: Lexend
    fontSize: 14px
    fontWeight: '600'
    lineHeight: '1.2'
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 40px
  container-max: 1200px
  gutter: 20px
---

## Brand & Style

The design system is engineered to capture the high-stakes adrenaline of a championship final. The brand personality is competitive, authoritative, and intensely energetic, targeting football enthusiasts who value both the history and the modern spectacle of the sport. 

The visual style is a fusion of **Tactile/Skeuomorphism** and **High-Contrast Bold**. It moves away from flat design by introducing physical textures—such as the woven synthetic of a match ball or the mown grass of a pitch—into digital containers. UI elements should feel like high-performance sports gear: durable, precision-engineered, and ready for action. The emotional response should be one of "Match Day" anticipation: focused, high-octane, and rewarding.

## Colors

The palette is anchored in a dark-mode experience that mimics a stadium at night.

*   **Primary (Pitch Deep):** A deep, dark green used for the main backgrounds to provide maximum contrast for gameplay elements.
*   **Secondary (Championship Gold):** Reserved for trophies, winning states, and premium highlights. It represents the ultimate goal.
*   **Tertiary (Bronze Medal):** Used for secondary achievements, rank progressions, and subtle interactive states.
*   **Neutral (Energetic White):** A crisp, high-visibility white used for typography and critical UI markers, ensuring legibility against the dark greens.
*   **Pitch Accents:** Use a slightly brighter green for "on-field" elements like progress bars or active selection states.

## Typography

This design system utilizes a high-impact typographic hierarchy. 

**Headlines** use **Plus Jakarta Sans** in heavy weights (Bold to ExtraBold). The tight letter spacing and aggressive scale mimic sports broadcasting graphics and stadium scoreboards. 

**Body text and Labels** use **Lexend**. Chosen for its athletic clarity and readability, it ensures that even during fast-paced trivia rounds, the user can digest information instantly. Labels should frequently use uppercase styling to maintain the competitive tone.

## Layout & Spacing

The layout follows a **Fixed Grid** model for desktop and a **Fluid Grid** for mobile, ensuring the high-energy visuals remain contained and impactful. 

A 12-column system is used for screens above 1024px. The rhythm is based on a 4px baseline, but spacing between major sections should be generous (XL) to allow the "Stadium Glow" effects to breathe. Components like trivia cards and player stats should be tightly packed (MD) to simulate the density of a crowded leaderboard or match lineup.

## Elevation & Depth

Hierarchy is established through **Tonal Layers** and **Stadium-Light Glows**. 

Instead of traditional drop shadows, this design system uses "Inner Glows" and "Backdrop Blurs" to simulate the lighting found in sports arenas. Backgrounds should feature a subtle grass texture at the lowest level. Cards and containers sit above this, using semi-transparent dark greens with 1px solid borders that mimic pitch lines (white, 20% opacity). 

Floating elements like "Correct Answer" popups should use a vibrant outer glow in Gold or Green, making them appear as if they are illuminated by floodlights.

## Shapes

The shape language is **Rounded (0.5rem)**, reflecting the aerodynamic curves of modern footballs and professional stadium architecture. 

Sharp corners are avoided to maintain a high-performance, ergonomic feel. Major containers like "Match Cards" use `rounded-lg` (1rem), while smaller interactive elements like chips or badges use `rounded-xl` (1.5rem) to appear more "pill-like" and approachable. The 1px borders mentioned in Elevation should follow these radii strictly to maintain the "pitch-line" aesthetic.

## Components

### Buttons
Buttons are the "gear" of this design system. They must feel tactile. Primary buttons feature a subtle vertical gradient (Trophy Gold to Bronze) and a 2px bottom "lip" to give a pressed-down, physical feedback.

### Cards (Pitch Containers)
Trivia questions are housed in cards with dark-green backgrounds. They feature "field-line" borders—thin, crisp white lines that may stop at the corners to mimic the markings of a penalty box or center circle.

### Iconography
Icons are dynamic and thick-stroked. Use sport-specific metaphors: a whistle for "Rules/Settings," a yellow card for "Report/Flag," and a trophy for "Rankings."

### Progress Bars (The Pitch)
Progress indicators (like time remaining) should look like a top-down view of a football pitch, with a small soccer ball icon acting as the scrubber/current position marker.

### Chips & Tags
Used for categories (e.g., "Premier League," "World Cup"). These should have a slight glassmorphism effect, allowing the background grass texture to peek through.