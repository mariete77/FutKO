# Assets de Audio para FutKO

## Archivos necesarios

Coloca los siguientes archivos `.mp3` en esta carpeta:

| Archivo | Descripción | Duración sugerida |
|---------|-------------|-------------------|
| `achievement_unlocked.mp3` | Sonido de desbloqueo de logro | 2-3 segundos |
| `correct_answer.mp3` | Respuesta correcta | 0.5-1 segundo |
| `wrong_answer.mp3` | Respuesta incorrecta | 0.5-1 segundo |
| `victory.mp3` | Victoria en partida | 3-5 segundos |
| `defeat.mp3` | Derrota en partida | 2-3 segundos |
| `streak_milestone.mp3` | Racha (3, 5, 10) | 1-2 segundos |
| `button_click.mp3` | Click en botones | 0.1-0.3 segundos |
| `timer_warning.mp3` | Últimos 5 segundos | 0.5 segundos |
| `level_up.mp3` | Subir de nivel/ELO | 2-3 segundos |

## Fuentes recomendadas

1. **Freesound.org** (gratuito)
   - https://freesound.org/
   - Buscar: "achievement", "success", "game"

2. **Zapsplat** (gratuito con registro)
   - https://www.zapsplat.com/
   - SFX de videojuegos

3. **Mixkit** (gratuito)
   - https://mixkit.co/free-sound-effects/

4. **Epidemic Sound** (pago)
   - Alta calidad para apps comerciales

## Formato

- **Formato:** MP3
- **Sample rate:** 44.1kHz
- **Bitrate:** 128-192 kbps
- **Canales:** Mono (para SFX)

## Implementación

El audio se maneja automáticamente en:
```dart
lib/core/services/audio_service.dart
```

Para reproducir:
```dart
audioService.playAchievementUnlocked();
```
