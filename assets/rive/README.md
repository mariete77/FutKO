# Mascota Rive para FutKO

## Archivo necesario

Descarga o crea un archivo `mascot.riv` y colócalo en esta carpeta.

## Especificaciones

### Estados requeridos (State Machine)
El archivo debe tener un **State Machine** llamado `"State Machine"` con los siguientes triggers:

| Trigger | Estado | Descripción |
|---------|--------|-------------|
| `idle` | idle | Animación por defecto (loop) |
| `happy` | happy | Feliz (cuando el usuario toca la mascota) |
| `excited` | excited | Emocionado (al iniciar partida) |
| `thinking` | thinking | Pensando (mientras responde) |
| `celebrating` | celebrating | Celebrando (victoria) |
| `sad` | sad | Triste (derrota) |

### Diseño sugerido

Un personaje futbolístico cute como:
- **Balón de fútbol con cara y brazos/piernas**
- **Un árbitro caricatura**
- **Una botella de agua deportiva animada**
- **Una pequeña copa/trofeo**

### Recursos para crear/descargar

1. **Rive Community** (Gratuito)
   - https://rive.app/community/
   - Busca "mascot", "character", "football"

2. **Crear propio**
   - https://rive.app/
   - Editor online gratuito
   - Exportar como `.riv`

### Ejemplo de estructura

```
Artboard: "Mascot"
  └── State Machine: "State Machine"
      ├── idle (default)
      ├── happy (trigger: happy)
      ├── excited (trigger: excited)
      ├── thinking (trigger: thinking)
      ├── celebrating (trigger: celebrating)
      └── sad (trigger: sad)
```

## Implementación

La mascota se muestra automáticamente en:
```dart
lib/presentation/widgets/common/mascot_widget.dart
```

Uso:
```dart
MascotWidget(
  state: MascotState.celebrating,
  size: 120,
  onTap: () => print('Mascota tocada!'),
)
```

## Fallback

Si no existe el archivo `mascot.riv`, se muestra un icono de balón de fútbol como fallback.
