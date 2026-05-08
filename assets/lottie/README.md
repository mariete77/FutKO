# Animaciones Lottie para FutKO

## Archivos necesarios

Descarga los siguientes archivos `.json` de [LottieFiles](https://lottiefiles.com/) y colócalos en esta carpeta:

| Archivo | Uso | Tipo de logro |
|---------|-----|---------------|
| `trophy.json` | 🏆 Trofeo | firstWin |
| `fire.json` | 🔥 Fuego | streak3, streak5, streak10 |
| `lightning.json` | ⚡ Rayo | speedDemon |
| `crown.json` | 👑 Corona | legendary |
| `diamond.json` | 💎 Diamante | perfectGame |
| `rocket.json` | 🚀 Cohete | comeback |
| `medal.json` | 🥇 Medalla | champion |
| `star.json` | ⭐ Estrella | Usos generales |
| `target.json` | 🎯 Diana | collector |

## Cómo descargar

1. Visita https://lottiefiles.com/
2. Busca el término (ej: "trophy", "fire", "crown")
3. Selecciona una animación que te guste
4. Click en "Download" → "Lottie JSON"
5. Renombra el archivo según la tabla de arriba

## Animaciones recomendadas

### trophy.json
- Buscar: "gold trophy" o "winner trophy"
- Ejemplo: https://lottiefiles.com/animations/gold-trophy

### fire.json
- Buscar: "fire flames" o "burning fire"
- Ejemplo: https://lottiefiles.com/animations/fire

### lightning.json
- Buscar: "lightning bolt" o "electric spark"
- Ejemplo: https://lottiefiles.com/animations/lightning

### crown.json
- Buscar: "gold crown" o "king crown"
- Ejemplo: https://lottiefiles.com/animations/crown

### diamond.json
- Buscar: "diamond gem" o "sparkle diamond"
- Ejemplo: https://lottiefiles.com/animations/diamond

### rocket.json
- Buscar: "rocket launch" o "space rocket"
- Ejemplo: https://lottiefiles.com/animations/rocket

### medal.json
- Buscar: "gold medal" o "winner medal"
- Ejemplo: https://lottiefiles.com/animations/medal

## Fallback

Si una animación Lottie no se carga, el sistema automáticamente muestra el emoji correspondiente. Ver:
```dart
lib/domain/entities/achievement.dart
```

## Optimización

- Tamaño recomendado: < 100KB por archivo
- Complejidad: Evita animaciones con más de 300 elementos
- FPS: 30fps es suficiente para la mayoría de casos
