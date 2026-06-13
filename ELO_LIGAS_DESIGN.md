# Estudio: sistema de clasificación por Ligas (pirámide española) para FutKO

> Generado el 2026-06-13. Estudio de diseño + **v1 implementada**.
> Objetivo: elegir la mejor forma de clasificar jugadores con 5 ligas estilo
> pirámide española, puntos por liga y ascenso/descenso por partida multijugador.

> **Estado (v1, rama `feat/league-system`):** modelo híbrido implementado.
> Decidido: inicio en Segunda RFEF, 5 ligas planas, sin temporadas/recompensas
> aún. Hecho: `LeagueSystem` (+ tests), campos `leagueTier`/`leaguePoints` en
> `User`/`UserModel`, actualización de LP al cerrar partida multijugador, y
> Liga + barra de puntos en home y perfil. Pendiente: banner de ascenso/descenso
> en pantalla de resultado, gating casual vs ranked, temporadas y recompensas.

---

## 1. Objetivo y restricciones

**Lo que pides:** 5 ligas, de más a menos nivel —
**1ª División → 2ª División → 1ª RFEF → 2ª RFEF → 3ª RFEF**. Cada liga tiene X
puntos; al cruzar un umbral (~100) asciendes. Cada partida multijugador sube o
baja esos puntos. Quieres saber *cuál es la mejor manera* de hacerlo.

**Restricciones reales de FutKO (esto condiciona TODO):**
- **Todo es client-side.** No hay Cloud Functions (`functions/` está vacío); el
  ELO y el matchmaking se calculan en el cliente (`core/utils/elo_calculator.dart`).
  → Cualquiera puede manipular su puntuación si quisiera. El sistema debe ser
  simple y robusto, no asumir anti-cheat de servidor.
- **Base de jugadores pequeña.** Pocos rivales disponibles a la vez
  (matchmaking por cola en Realtime DB, rango ELO ±200).
- **Partidas cortas y con azar** (10 preguntas, banco limitado). El resultado
  tiene varianza → conviene un sistema que no castigue demasiado una mala racha.
- **Freemium**, móvil, en español, tema "Stadium Arena". La progresión es
  gancho de retención: tiene que *sentirse* y verse.

---

## 2. Estado actual (lo que ya hay en el código)

- `User.elo` (int), arranca en **1000** (`GameConstants.initialElo`), mín. 100.
- ELO Elo-clásico: K = **32** (< 30 partidas) / **16** (establecido),
  `expected = 1/(1+10^((oppElo−myElo)/400))` — `EloCalculator.calculateChange`.
- El "score" del jugador en la partida (0.0–1.0) sale de aciertos ponderados por
  velocidad (`multiplayer_provider`: 1 pt/acierto + 0.5 si <2 s + 0.2 si <5 s).
- **Rangos actuales (bandas fijas sobre ELO):** Bronze 0 / Silver 1200 / Gold
  1400 / Platinum 1600 / Diamond 1800 (`getRank`, `User.rank`).
  → Genéricos y poco temáticos. Es lo que vamos a sustituir.
- Se muestran en leaderboard (podio + lista) y en el badge de perfil/home.

**Conclusión:** ya tienes un ELO funcional y justo para emparejar. No hay que
tirarlo; hay que **construir la capa de Ligas encima**.

---

## 3. Los 4 modelos candidatos

### A. ELO puro con bandas (lo actual, solo recoloreado)
Mapear los rangos ELO a los 5 nombres de la pirámide y ya.
- ✅ Cero trabajo nuevo de lógica; matemáticamente justo.
- ❌ No hay "puntos por liga" ni sensación de ascenso/descenso por partida; el
  número ELO es abstracto y no engancha. **No cumple lo que pides.**

### B. Glicko-2 (ELO moderno con incertidumbre)
Añade *rating deviation* (RD) y volatilidad: sube/baja más rápido si juegas poco
o eres inconsistente.
- ✅ Más preciso con **pocas partidas** y jugadores intermitentes — encaja con tu
  base pequeña.
- ❌ Bastante más complejo de implementar y explicar; sigue siendo un número
  abstracto si no le pones una capa de ligas encima. Overkill como *display*.
- 👉 Útil como motor oculto a futuro, no como lo que ve el jugador.

### C. Puntos por liga / trofeos (tu idea literal, estilo Clash Royale)
El jugador tiene `(liga, puntos 0–100)`. Ganar = +puntos, perder = −puntos. Al
llegar a 100 asciende; al bajar de 0 desciende. Las partidas mueven una sola
moneda visible.
- ✅ **Exactamente tu modelo**, muy intuitivo y adictivo; cada partida "cuenta".
- ❌ Si los deltas son fijos (siempre ±30), ganar a un novato vale igual que a un
  crack → el emparejamiento deja de ser justo y un jugador fuerte arrasa.
  Necesita modular el delta por nivel del rival.

### D. **Híbrido: MMR oculto (ELO) + Liga/LP visible** ⭐ recomendado
Mantienes el **ELO como MMR oculto** (solo para emparejar justo y para calcular
cuántos puntos de liga ganas) y enseñas **Liga + Puntos de Liga (LP, 0–100)** como
progresión. Los LP que ganas/pierdes se **escalan con la expectativa del ELO**
(ganar al favorito da más; perder contra alguien mucho mejor quita poco).
- ✅ Lo mejor de C (sensación de ascenso, cada partida mueve LP) **y** de A
  (emparejamiento justo, no abusable por farmear novatos).
- ✅ Es el patrón que usan League of Legends, Valorant, etc. — probado.
- ✅ Reaprovecha tu `EloCalculator` casi tal cual.
- ❌ Hay que mantener dos números (uno oculto). Coste moderado.

**Recomendación: D.** Es "la mejor manera de clasificar" para FutKO porque
combina justicia (MMR) con la motivación de tu modelo de ligas (LP). Implementas
la capa visible *exactamente* como la describes (5 ligas, ~100 LP, asciende al
cruzar), pero los puntos se reparten de forma justa.

---

## 4. Especificación concreta del sistema recomendado (D)

### 4.1 Las 5 ligas (de menor a mayor)
| Liga (display) | Tier | MMR/ELO orientativo | Color sugerido |
|---|:---:|---|---|
| Tercera RFEF   | 1 | < 1000      | bronce `0xFFCD7F32` |
| Segunda RFEF   | 2 | 1000–1199   | gris   `0xFFB0B7C3` |
| Primera RFEF   | 3 | 1200–1399   | verde  `AppColors.primary` |
| Segunda División | 4 | 1400–1599 | plata  `0xFFE5E4E2` |
| Primera División | 5 | ≥ 1600    | oro    `AppColors.yellow500` |

> El MMR solo *orienta* la liga inicial y modula los LP. La liga "oficial" la
> determina el LP (ascensos/descensos), no el ELO directamente.

### 4.2 Puntos de Liga (LP)
- Cada liga: **0–100 LP**. Llegar a **100 → ascenso**; bajar de **0 → descenso**.
- **Inicio:** todos empiezan en **Segunda RFEF, 0 LP** (deja margen arriba y abajo;
  evita el placement complejo). Alternativa: 5 partidas de *placement* que siembran
  la liga según ELO — más preciso pero más trabajo. Recomiendo empezar simple.
- **Delta por partida (modulado por ELO):**
  ```
  expected = 1 / (1 + 10^((oppElo − myElo) / 400))   // ya existe en el código
  result   = 1.0 ganar | 0.5 empate | 0.0 perder
  base     = 24
  lpDelta  = round( base * (result − expected) )      // núcleo "justo"
           + (result == 1 ? +10 : result == 0 ? −10 : 0)   // suelo de victoria/derrota
           + perfBonus                                       // ±0..6 por margen de aciertos
  ```
  - Ganar al favorito (expected bajo) ⇒ +30 LP aprox.; ganar a un inferior ⇒ +10.
  - Perder contra alguien mucho mejor ⇒ −5..−8; perder contra un inferior ⇒ −28.
  - `perfBonus`: +hasta 6 si ganas por goleada de aciertos, para premiar dominar.
  - Acota el total a, p. ej., `clamp(−30, +34)` para que nada sea brutal.
- **Ascenso:** al cruzar 100 → liga +1, arrancas en **20 LP** con **escudo de
  descenso de 2 partidas** (no puedes descender inmediatamente tras subir).
- **Descenso:** al bajar de 0 → liga −1 en **75 LP** (caes "dentro", no al fondo).
- **Anti-frustración:** en **Tercera RFEF no se baja de 0** (suelo absoluto). Los
  primeros ~5 partidos de un jugador nuevo no descienden (placement suave).
- El **MMR/ELO se sigue actualizando aparte** con tu `EloCalculator` actual (K
  32/16), para que el emparejamiento mejore con el tiempo.

### 4.3 Temporadas (opcional, recomendado a futuro)
- Cada ~6–8 semanas, **soft reset**: acerca a todos hacia la media
  (`nuevoLP/ liga` comprimidos), repartes recompensa por liga alcanzada (cosmético,
  título "Campeón de 2ª RFEF"). Da motivo para volver y evita estancamiento.
- Implementable client-side guardando `seasonId` + fecha en el doc de usuario.

### 4.4 Empates y casual
- **Casual:** NO toca ELO ni LP (verificar el bug actual de que casual calcula
  ELO). Solo *ranked* mueve liga.
- **Empate:** `result = 0.5` (LP ≈ `base*(0.5−expected)`, suele ser pequeño).

---

## 5. Mapeo al código (migración)

| Pieza | Cambio |
|---|---|
| `domain/entities/user.dart` | Añadir `int leaguePoints` (0–100), `int leagueTier` (1–5), opcional `int placementGames`. `User.rank` (String) pasa a derivar de `leagueTier`. |
| `core/constants/game_constants.dart` | Sustituir `rankBronze..rankDiamond` por umbrales de liga + constantes LP (`lpToPromote=100`, `lpBaseDelta=24`, `lpWinFloor=10`, etc.). |
| `core/utils/elo_calculator.dart` | Mantener `calculateChange` (MMR). Añadir `LeagueSystem` (o métodos): `lpDelta(...)`, `applyMatch(tier, lp, ...) -> (tier, lp)`, `leagueName(tier)`, `leagueColor(tier)`. `getRank` pasa a `leagueName`. |
| `presentation/providers/multiplayer_provider.dart` | Al cerrar partida *ranked*: actualizar ELO **y** LP; resolver ascenso/descenso; persistir. |
| `data/models/user_model.dart` + reglas Firestore | Serializar `leaguePoints`/`leagueTier` (+ `seasonId`). |
| `leaderboard_screen.dart` | Ordenar por (tier desc, lp desc) o por ELO; mostrar liga + barra de LP. |
| Perfil / home badge | Badge = nombre de liga + barra 0–100 de LP (sustituye `user.rank`). |

> Nota: hay `data/` con freezed/json — tocar `User`/`UserModel` implica
> `dart run build_runner build --delete-conflicting-outputs`.

---

## 6. Números recomendados (resumen para copiar)

```
Ligas (tier→nombre): 1 Tercera RFEF, 2 Segunda RFEF, 3 Primera RFEF,
                     4 Segunda División, 5 Primera División
Inicio:              tier 2 (Segunda RFEF), 0 LP, MMR 1000
LP por liga:         100  (ascenso al cruzar 100)
Delta base:          24   |  suelo victoria +10 / derrota −10  |  perfBonus ±0..6
Clamp delta:         [−30, +34]
Ascenso:             tier+1 @ 20 LP, escudo 2 partidas
Descenso:            tier−1 @ 75 LP  (suelo en Tercera RFEF)
Placement:           primeras 5 ranked sin descenso
MMR (oculto):        EloCalculator actual, K 32 (<30) / 16
Temporada:           soft reset cada 6–8 semanas (fase 2)
```

---

## 7. Decisiones abiertas (lo que necesito que decidas)
1. **¿Inicio en Segunda RFEF (simple) o con 5 partidas de placement (más preciso)?**
   Recomiendo Segunda RFEF para empezar.
2. **¿Sub-divisiones dentro de cada liga** (p. ej. Tercera RFEF I/II/III como LoL)
   o solo 5 ligas planas? Tu mensaje sugiere 5 planas → más simple, recomendado.
3. **¿Temporadas con reset desde ya o más adelante?** Recomiendo más adelante.
4. **¿Recompensas por ascenso** (cosméticos, título) en esta primera versión o
   después? Depende de si añadimos cosméticos (ver `BRAINSTORM.md`, idea 10).
5. **¿Mantengo el ELO visible en algún sitio** (p. ej. perfil avanzado) o lo
   ocultamos del todo y solo se ve la liga?

Cuando me confirmes esto, lo implemento en una rama aparte
(`feat/league-system`), con su migración de datos y el `build_runner`.
